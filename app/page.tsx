"use client";

import { useEffect, useMemo, useState } from "react";
import FullFlow from "./FullFlow";
import I2SAnimation from "./I2SAnimation";

type FsFamily = 0 | 1;
type FsMode = 0 | 1;
type SampleWidth = 16 | 24 | 32;
type FieldKey = "enable" | "mute" | "family" | "mode" | "width" | "reservedLo" | "reservedHi";

type FrequencyFamily = {
  value: FsFamily;
  label: string;
  sourceName: string;
  sourceHz: number;
  familyFsHz: number;
  description: string;
};

type DividerMode = {
  value: FsMode;
  label: string;
  divider: 2 | 4;
  checkText: string;
};

type ControlField = {
  key: FieldKey;
  label: string;
  range: string;
  startBit: number;
  endBit: number;
  value: string;
  description: string;
  effect: string;
  accent: string;
};

type SummaryCell = {
  family: FsFamily;
  mode: FsMode;
  internalMclkHz: number;
  divider: 2 | 4;
  bclkEnableHz: number;
  bclkHz: number;
  wsHz: number;
  fsHz: number;
};

type SignalTimelineProps = {
  tick: number;
  sampleWidth: SampleWidth;
  enable: boolean;
  mute: boolean;
  leftBits: number[];
  rightBits: number[];
  title: string;
  description: string;
};

const outlineSections = [
  { id: "hero", label: "Overview" },
  { id: "real-time-flow", label: "Real-time Data Flow" },
  { id: "full-flow", label: "0. Full serialization flow" },
  { id: "clock-generation", label: "1. Clock generation" },
  { id: "clock-divider", label: "2. Divider and BCLK enable" },
  { id: "power-on-reset", label: "3. Power-on reset" },
  { id: "cdc-synchroniser", label: "4. CDC synchroniser" },
  { id: "control-register", label: "5. CONTROL bitfield" },
  { id: "i2s-frame", label: "6. Philips I2S frame" },
  { id: "ws-timing", label: "7. WS timing" },
  { id: "enable-mute", label: "8. ENABLE and MUTE" },
  { id: "formula-summary", label: "9. Full formula summary" },
];

const familyOptions: FrequencyFamily[] = [
  {
    value: 0,
    label: "FS_FAMILY = 0",
    sourceName: "audio_48_clk",
    sourceHz: 24_576_000,
    familyFsHz: 48_000,
    description: "48 kHz family: 24.576 MHz master clock, then divide by 2 for MCLK.",
  },
  {
    value: 1,
    label: "FS_FAMILY = 1",
    sourceName: "audio_44_clk",
    sourceHz: 22_579_200,
    familyFsHz: 44_100,
    description: "44.1 kHz family: 22.5792 MHz master clock, then divide by 2 for MCLK.",
  },
];

const modeOptions: DividerMode[] = [
  {
    value: 0,
    label: "FS_MODE = 0",
    divider: 4,
    checkText: "clock_div_q[1:0] == 2'b00",
  },
  {
    value: 1,
    label: "FS_MODE = 1",
    divider: 2,
    checkText: "clock_div_q[0] == 1'b0",
  },
];

const controlFields: ControlField[] = [
  {
    key: "reservedHi",
    label: "RESERVED",
    range: "bits 31:13",
    startBit: 13,
    endBit: 31,
    value: "0",
    description: "Reserved bits in the upper register region.",
    effect: "Must be written as 0 and ignored by the audio datapath.",
    accent: "field-reserved",
  },
  {
    key: "enable",
    label: "ENABLE",
    range: "bit 0",
    startBit: 0,
    endBit: 0,
    value: "1",
    description: "Turns the audio engine on or off.",
    effect: "When 0, BCLK, WS, and DATA are held low and the bit counter is reset.",
    accent: "field-enable",
  },
  {
    key: "mute",
    label: "MUTE",
    range: "bit 1",
    startBit: 1,
    endBit: 1,
    value: "0",
    description: "Silences the serial payload while leaving the clocks alive.",
    effect: "When 1, the stream keeps running but DATA is forced to 0.",
    accent: "field-mute",
  },
  {
    key: "family",
    label: "FS_FAMILY",
    range: "bit 2",
    startBit: 2,
    endBit: 2,
    value: "0",
    description: "Selects the 48 kHz or 44.1 kHz clock family.",
    effect: "Chooses audio_48_clk or audio_44_clk through the BUFGMUX.",
    accent: "field-family",
  },
  {
    key: "mode",
    label: "FS_MODE",
    range: "bit 3",
    startBit: 3,
    endBit: 3,
    value: "0",
    description: "Selects the divider used to derive the BCLK enable.",
    effect: "0 checks clock_div_q[1:0], 1 checks clock_div_q[0].",
    accent: "field-mode",
  },
  {
    key: "width",
    label: "SAMPLE_WIDTH",
    range: "bits 12:8",
    startBit: 8,
    endBit: 12,
    value: "24",
    description: "Sets the payload width in the I2S frame.",
    effect: "Controls how many serial cells are populated with sample bits before padding begins.",
    accent: "field-width",
  },
  {
    key: "reservedLo",
    label: "RESERVED",
    range: "bits 7:4",
    startBit: 4,
    endBit: 7,
    value: "0",
    description: "Reserved bits between FS_MODE and SAMPLE_WIDTH.",
    effect: "Must be written as 0 and do not change output behaviour.",
    accent: "field-reserved",
  },
];

const defaultControlValue = 0x00001801;
const leftSampleWord = 0xd4a5c3f0 >>> 0;
const rightSampleWord = 0x6e35f0a5 >>> 0;
const audioPorStates = ["1111", "1110", "1100", "1000", "0000"] as const;

function useTicker(max: number, intervalMs: number) {
  const [tick, setTick] = useState(0);

  useEffect(() => {
    const timer = window.setInterval(() => {
      setTick((currentTick) => (currentTick + 1) % (max + 1));
    }, intervalMs);

    return () => window.clearInterval(timer);
  }, [intervalMs, max]);

  return [tick, setTick] as const;
}

function formatFrequency(hz: number) {
  if (hz >= 1_000_000) {
    return `${(hz / 1_000_000).toFixed(3)} MHz`;
  }

  if (hz >= 1_000) {
    return `${(hz / 1_000).toFixed(3)} kHz`;
  }

  return `${hz.toFixed(0)} Hz`;
}

function formatFrequencyForTable(hz: number) {
  if (hz >= 1_000_000) {
    return `${(hz / 1_000_000).toFixed(3)} MHz`;
  }

  if (hz >= 1_000) {
    return `${(hz / 1_000).toFixed(1)} kHz`;
  }

  return `${hz.toFixed(0)} Hz`;
}

function buildBits(word: number, width: SampleWidth) {
  return Array.from({ length: width }, (_, index) => (word >>> (31 - index)) & 1);
}

function frameBitAt(position: number, width: SampleWidth, leftBits: number[], rightBits: number[]) {
  if (position === 0 || position === 32) {
    return 0;
  }

  if (position < 32) {
    return position <= width ? leftBits[position - 1] ?? 0 : 0;
  }

  const rightPosition = position - 32;
  return rightPosition <= width ? rightBits[rightPosition - 1] ?? 0 : 0;
}

function signalValueAt(position: number, enable: boolean, mute: boolean, width: SampleWidth, leftBits: number[], rightBits: number[]) {
  if (!enable) {
    return { bclk: 0, ws: 0, data: 0 };
  }

  const bclk = position % 2;
  const ws = position < 32 ? 0 : 1;
  const data = mute ? 0 : frameBitAt(position, width, leftBits, rightBits);

  return { bclk, ws, data };
}

function SectionHeading({ eyebrow, title, lead }: { eyebrow: string; title: string; lead: string }) {
  return (
    <div className="section-heading">
      <p className="eyebrow">{eyebrow}</p>
      <h2>{title}</h2>
      <p>{lead}</p>
    </div>
  );
}

function SignalTimeline({ tick, sampleWidth, enable, mute, leftBits, rightBits, title, description }: SignalTimelineProps) {
  const start = (tick + 64 - 8) % 64;
  const cells = Array.from({ length: 16 }, (_, index) => (start + index) % 64);
  const current = enable ? tick : 0;

  return (
    <div className="timeline-shell frame-card">
      <div className="timeline-shell-head">
        <div>
          <p className="eyebrow">{title}</p>
          <h3>Live waveform preview</h3>
          <p>{description}</p>
        </div>
        <div className="timeline-metric">
          <span>Current bit_count_q</span>
          <strong>{current}</strong>
        </div>
      </div>

      <div className="timeline-grid" role="img" aria-label="Waveform preview for bit count, BCLK, WS, and DATA">
        <div className="timeline-row timeline-row-labels">
          <div className="timeline-label">bit_count</div>
          {cells.map((position) => (
            <div key={`count-${position}`} className={position === current ? "timeline-cell timeline-cell-count active" : "timeline-cell timeline-cell-count"}>
              {position}
            </div>
          ))}
        </div>

        <div className="timeline-row">
          <div className="timeline-label">BCLK</div>
          {cells.map((position) => {
            const values = signalValueAt(position, enable, mute, sampleWidth, leftBits, rightBits);

            return (
              <div key={`bclk-${position}`} className={position === current ? `timeline-cell signal-${values.bclk} active` : `timeline-cell signal-${values.bclk}`}>
                {values.bclk}
              </div>
            );
          })}
        </div>

        <div className="timeline-row">
          <div className="timeline-label">WS</div>
          {cells.map((position) => {
            const values = signalValueAt(position, enable, mute, sampleWidth, leftBits, rightBits);

            return (
              <div key={`ws-${position}`} className={position === current ? `timeline-cell signal-${values.ws} active` : `timeline-cell signal-${values.ws}`}>
                {values.ws}
              </div>
            );
          })}
        </div>

        <div className="timeline-row">
          <div className="timeline-label">DATA</div>
          {cells.map((position) => {
            const values = signalValueAt(position, enable, mute, sampleWidth, leftBits, rightBits);

            return (
              <div key={`data-${position}`} className={position === current ? `timeline-cell signal-${values.data} active` : `timeline-cell signal-${values.data}`}>
                {values.data}
              </div>
            );
          })}
        </div>
      </div>

      <div className="timeline-footer">
        <div>
          <strong>What this shows</strong>
          <p>{enable ? (mute ? "Clocks keep running while DATA is forced low." : "Normal I2S activity with BCLK, WS, and DATA all alive.") : "ENABLE = 0 holds the outputs low and resets the bit counter."}</p>
        </div>
        <div>
          <strong>How to read it</strong>
          <p>When the row is high, the signal is 1 for that slot. When it is low, the signal is 0. The current slot is highlighted so you can follow the moving bit position.</p>
        </div>
      </div>
    </div>
  );
}

export default function Home() {
  const [activeSection, setActiveSection] = useState(outlineSections[0].id);
  const [fsFamily, setFsFamily] = useState<FsFamily>(0);
  const [fsMode, setFsMode] = useState<FsMode>(0);
  const [sampleWidth, setSampleWidth] = useState<SampleWidth>(24);
  const [selectedField, setSelectedField] = useState<FieldKey>("enable");
  const [enable, setEnable] = useState(true);
  const [mute, setMute] = useState(false);
  const [clockTick] = useTicker(7, 900);
  const [porTick, setPorTick] = useTicker(4, 1000);
  const [cdcTick, setCdcTick] = useTicker(3, 1100);
  const [frameTick] = useTicker(63, 120);

  const selectedFamily = familyOptions[fsFamily];
  const selectedMode = modeOptions[fsMode];
  const internalMclkHz = selectedFamily.sourceHz;
  const mclkHz = internalMclkHz / 2;
  const bclkEnableHz = internalMclkHz / selectedMode.divider;
  const bclkHz = bclkEnableHz / 2;
  const wsHz = bclkHz / 64;
  const fsHz = wsHz;
  const mclkPhase = clockTick % 2;
  const leftBits = useMemo(() => buildBits(leftSampleWord, sampleWidth), [sampleWidth]);
  const rightBits = useMemo(() => buildBits(rightSampleWord, sampleWidth), [sampleWidth]);

  const summaryCells: SummaryCell[] = useMemo(
    () =>
      familyOptions.flatMap((family) =>
        modeOptions.map((mode) => ({
          family: family.value,
          mode: mode.value,
          internalMclkHz: family.sourceHz,
          divider: mode.divider,
          bclkEnableHz: family.sourceHz / mode.divider,
          bclkHz: family.sourceHz / mode.divider / 2,
          wsHz: family.sourceHz / mode.divider / 2 / 64,
          fsHz: family.sourceHz / mode.divider / 2 / 64,
        })),
      ),
    [],
  );

  const selectedFieldInfo = controlFields.find((field) => field.key === selectedField) ?? controlFields[0];
  const reservedFieldFallback = controlFields.find((field) => field.key === "reservedLo") ?? controlFields[0];

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((entry) => entry.isIntersecting)
          .sort((left, right) => right.intersectionRatio - left.intersectionRatio);

        if (visible.length > 0) {
          setActiveSection(visible[0].target.id);
        }
      },
      {
        rootMargin: "-22% 0px -58% 0px",
        threshold: [0.15, 0.35, 0.55],
      },
    );

    outlineSections.forEach((section) => {
      const node = document.getElementById(section.id);
      if (node) {
        observer.observe(node);
      }
    });

    return () => observer.disconnect();
  }, []);

  const registerBits = Array.from({ length: 32 }, (_, bitIndex) => (defaultControlValue >>> bitIndex) & 1);

  const fieldByBit = (bitIndex: number) => {
    const field = controlFields.find((entry) => bitIndex >= entry.startBit && bitIndex <= entry.endBit);
    return field ?? reservedFieldFallback;
  };

  const porState = audioPorStates[porTick];
  const cdcStages = [
    { title: "AXI domain src_in", value: cdcTick === 0 ? 0 : 1, note: "Value is generated in the AXI/register world." },
    { title: "stage1_q", value: cdcTick >= 2 ? 1 : cdcTick >= 1 ? 0 : 0, note: "First flop captures the asynchronous transition." },
    { title: "stage2_q = dest_out", value: cdcTick >= 3 ? 1 : 0, note: "Second flop exports a cleaner version into the destination domain." },
  ];

  const familyModeMatrix = [
    {
      family: familyOptions[0],
      cells: [summaryCells[0], summaryCells[1]],
    },
    {
      family: familyOptions[1],
      cells: [summaryCells[2], summaryCells[3]],
    },
  ];

  return (
    <main className="doc-shell">
      <div className="layout-grid">
        <aside className="sidebar" aria-label="Page outline">
          <div className="outline-card frame-card">
            <p className="eyebrow">Outline</p>
            <nav className="outline-nav">
              {outlineSections.map((section) => (
                <a
                  key={section.id}
                  href={`#${section.id}`}
                  className={activeSection === section.id ? "outline-link active" : "outline-link"}
                >
                  {section.label}
                </a>
              ))}
            </nav>
          </div>

          <div className="outline-card frame-card">
            <p className="eyebrow">Reader map</p>
            <p className="outline-note">
              This page starts with clocks, then divides them, resets them, synchronises them, latches stereo words at the frame boundary, and finally serializes them bit by bit with Philips I2S timing.
            </p>
          </div>
        </aside>

        <div className="content-column">
          <section className="hero-section" id="hero">
            <div className="hero-copy">
              <p className="eyebrow">Interactive documentation</p>
              <h1>I2S AXI4-Lite IP, explained visually from clock source to serial data</h1>
              <p className="hero-lead">
                Use the controls to change the clock family, divider mode, sample width, and runtime behaviour. Every derived value updates live so the register map, timing math, and I2S waveform stay connected.
              </p>
              <div className="chip-row">
                <span className="chip">single viewport walkthrough</span>
                <span className="chip">live derivations</span>
                <span className="chip">code-synchronised animation</span>
                <span className="chip">waveform preview</span>
                <span className="chip">hardware ready</span>
              </div>
              <div className="mt-8">
                <a href="#real-time-flow" className="action-btn inline-block">
                  View Real-time Animation →
                </a>
              </div>
            </div>

            <div className="hero-panel frame-card">
              <p className="eyebrow">What the core does</p>
              <div className="hero-flow">
                <span>FS_FAMILY</span>
                <span>BUFGMUX</span>
                <span>internal_mclk</span>
                <span>divider</span>
                <span>CDC</span>
                <span>serializer</span>
                <span>DATA</span>
              </div>
              <p className="hero-note">
                The software-visible CONTROL register chooses the family, mode, sample width, and run state. The audio side uses that selection to create MCLK, BCLK, WS, and the serial payload.
              </p>
            </div>
          </section>

          <section id="real-time-flow">
            <I2SAnimation />
          </section>

          <FullFlow />

          <section className="section-card frame-card" id="clock-generation">
            <SectionHeading
              eyebrow="Section 1"
              title="Clock generation"
              lead="FS_FAMILY chooses the clock source before anything else happens. That source then feeds a toggle flop so the final MCLK is always exactly half of internal_mclk."
            />

            <div className="control-panel">
              <div className="control-stack">
                <label className="slider-label" htmlFor="family-slider">
                  <span>FS_FAMILY</span>
                  <strong>{selectedFamily.label}</strong>
                </label>
                <input
                  id="family-slider"
                  className="range-input"
                  type="range"
                  min={0}
                  max={1}
                  step={1}
                  value={fsFamily}
                  aria-valuemin={0}
                  aria-valuemax={1}
                  aria-valuenow={fsFamily}
                  aria-valuetext={selectedFamily.label}
                  onChange={(event) => setFsFamily(Number(event.target.value) as FsFamily)}
                />
                <div className="slider-endpoints">
                  <span>48 kHz family</span>
                  <span>44.1 kHz family</span>
                </div>
              </div>

              <div className="formula-steps">
                <div className="formula-step">
                  <strong>Step 1</strong>
                  <p>FS_FAMILY = {fsFamily} selects {selectedFamily.sourceName} from the BUFGMUX.</p>
                </div>
                <div className="formula-step">
                  <strong>Step 2</strong>
                  <p>internal_mclk = {formatFrequency(internalMclkHz)}.</p>
                </div>
                <div className="formula-step">
                  <strong>Step 3</strong>
                  <p>mclk_q toggles every cycle, so MCLK = internal_mclk ÷ 2 = {formatFrequency(mclkHz)}.</p>
                </div>
              </div>
            </div>

            <div className="clock-visual-grid">
              <div className="metric-card">
                <span>Selected source</span>
                <strong>{selectedFamily.sourceName}</strong>
                <p>{selectedFamily.description}</p>
              </div>
              <div className="metric-card">
                <span>internal_mclk</span>
                <strong>{formatFrequency(internalMclkHz)}</strong>
                <p>That is the clock before the toggle flop divides it down.</p>
              </div>
              <div className="metric-card phase-card">
                <span>mclk_q phase</span>
                <div className={mclkPhase === 0 ? "phase-pill low" : "phase-pill high"}>{mclkPhase === 0 ? "0" : "1"}</div>
                <p>The flip-flop changes state on each edge, so the output period spans two input cycles.</p>
              </div>
              <div className="metric-card">
                <span>MCLK</span>
                <strong>{formatFrequency(mclkHz)}</strong>
                <p>Exactly half of internal_mclk.</p>
              </div>
            </div>

            <div className="mini-pulse-strip" aria-label="MCLK toggle animation">
              <div className={mclkPhase === 0 ? "pulse-step active" : "pulse-step"}>mclk_q = 0</div>
              <div className={mclkPhase === 1 ? "pulse-step active" : "pulse-step"}>mclk_q = 1</div>
              <div className={mclkPhase === 0 ? "pulse-step active" : "pulse-step"}>MCLK low half</div>
              <div className={mclkPhase === 1 ? "pulse-step active" : "pulse-step"}>MCLK high half</div>
            </div>
          </section>

          <section className="section-card frame-card" id="clock-divider">
            <SectionHeading
              eyebrow="Section 2"
              title="Clock divider and BCLK enable"
              lead="FS_MODE changes which low bits are inspected. That changes how often bclk_en_w fires, and the divider math then produces BCLK, WS, and Fs."
            />

            <div className="toggle-row">
              {modeOptions.map((mode) => (
                <button
                  key={mode.value}
                  className={fsMode === mode.value ? "toggle-btn active" : "toggle-btn"}
                  type="button"
                  onClick={() => setFsMode(mode.value)}
                >
                  <span>{mode.label}</span>
                  <small>{mode.checkText}</small>
                </button>
              ))}
            </div>

            <div className="formula-steps">
              <div className="formula-step">
                <strong>Step 1</strong>
                <p>FS_MODE = {fsMode} uses {selectedMode.checkText}, so the enable fires every {selectedMode.divider} cycles.</p>
              </div>
              <div className="formula-step">
                <strong>Step 2</strong>
                <p>bclk_en period = internal_mclk ÷ divider = {formatFrequency(bclkEnableHz)}.</p>
              </div>
              <div className="formula-step">
                <strong>Step 3</strong>
                <p>BCLK = bclk_en_rate ÷ 2 = {formatFrequency(bclkHz)} because one full clock needs both a rising and falling edge.</p>
              </div>
              <div className="formula-step">
                <strong>Step 4</strong>
                <p>WS = BCLK ÷ 64 = {formatFrequency(wsHz)} and Fs = WS = {formatFrequency(fsHz)}.</p>
              </div>
            </div>

            <div className="counter-strip">
              {Array.from({ length: 8 }, (_, cycle) => {
                const fire = cycle % selectedMode.divider === 0;
                const active = cycle === clockTick;

                return (
                  <div key={cycle} className={active ? "counter-cell active" : fire ? "counter-cell fire" : "counter-cell"}>
                    <span>q = {cycle.toString(2).padStart(3, "0")}</span>
                    <strong>{cycle}</strong>
                    <small>{fire ? "bclk_en_w fires" : "no fire"}</small>
                  </div>
                );
              })}
            </div>

            <div className="result-table-wrap">
              <table className="result-table">
                <thead>
                  <tr>
                    <th>FS_FAMILY</th>
                    <th>FS_MODE</th>
                    <th>internal_mclk</th>
                    <th>divider</th>
                    <th>bclk_en rate</th>
                    <th>BCLK</th>
                    <th>WS</th>
                    <th>Fs</th>
                  </tr>
                </thead>
                <tbody>
                  {summaryCells.map((row) => {
                    const isSelected = row.family === fsFamily && row.mode === fsMode;

                    return (
                      <tr key={`${row.family}-${row.mode}`} className={isSelected ? "selected-row" : undefined}>
                        <td>{row.family}</td>
                        <td>{row.mode}</td>
                        <td>{formatFrequencyForTable(row.internalMclkHz)}</td>
                        <td>{row.divider}</td>
                        <td>{formatFrequencyForTable(row.bclkEnableHz)}</td>
                        <td>{formatFrequencyForTable(row.bclkHz)}</td>
                        <td>{formatFrequencyForTable(row.wsHz)}</td>
                        <td>{formatFrequencyForTable(row.fsHz)}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </section>

          <section className="section-card frame-card" id="power-on-reset">
            <SectionHeading
              eyebrow="Section 3"
              title="Power-on reset"
              lead="audio_por_q starts at 1111 and shifts a 0 in from the right each cycle. That makes audio_rst stay high for four cycles and then drop low cleanly in the audio clock domain."
            />

            <div className="section-actions">
              <button className="action-btn" type="button" onClick={() => setPorTick(0)}>
                Replay POR
              </button>
              <div className="status-pill">
                audio_rst = {porState[0]}
              </div>
            </div>

            <div className="shift-register frame-card subtle-card">
              {porState.split("").map((bit, index) => (
                <div key={`${bit}-${index}`} className={bit === "1" ? "shift-cell high" : "shift-cell low"}>
                  <span>audio_por_q[{3 - index}]</span>
                  <strong>{bit}</strong>
                </div>
              ))}
            </div>

            <div className="formula-steps">
              <div className="formula-step">
                <strong>Why this works</strong>
                <p>The reset must be generated inside the audio clock domain, not copied directly from S_AXI_ARESETN, because the AXI reset belongs to a different clock domain.</p>
              </div>
              <div className="formula-step">
                <strong>Cycle count</strong>
                <p>At cycle 0 the register is 1111. By cycle 4 it becomes 0000 and audio_rst drops to 0.</p>
              </div>
            </div>
          </section>

          <section className="section-card frame-card" id="cdc-synchroniser">
            <SectionHeading
              eyebrow="Section 4"
              title="CDC synchroniser"
              lead="A two-stage synchroniser carries a value from the AXI domain into the destination domain. The first flop samples it, the second flop exports it one more cycle later, which improves MTBF and reduces the chance of metastability escaping into the core."
            />

            <div className="section-actions">
              <button className="action-btn" type="button" onClick={() => setCdcTick(0)}>
                Replay CDC
              </button>
              <div className="status-pill">2-cycle propagation</div>
            </div>

            <div className="cdc-grid">
              {cdcStages.map((stage, index) => (
                <div key={stage.title} className="cdc-stage frame-card subtle-card">
                  <span>{index === 0 ? "AXI domain" : index === 1 ? "stage1_q" : "stage2_q / dest_out"}</span>
                  <strong>{stage.value}</strong>
                  <p>{stage.note}</p>
                </div>
              ))}
            </div>

            <div className="cdc-arrow-row" aria-hidden="true">
              <span>src_in</span>
              <span>→</span>
              <span>stage1_q</span>
              <span>→</span>
              <span>stage2_q</span>
            </div>

            <div className="formula-steps">
              <div className="formula-step">
                <strong>Step 1</strong>
                <p>The source value is launched in the AXI domain.</p>
              </div>
              <div className="formula-step">
                <strong>Step 2</strong>
                <p>stage1_q captures the transition first, then stage2_q follows one cycle later.</p>
              </div>
              <div className="formula-step">
                <strong>Why ASYNC_REG matters</strong>
                <p>Marking both flip-flops with ASYNC_REG=TRUE tells the tool to keep them adjacent so the routing is short and the synchroniser is more reliable.</p>
              </div>
            </div>
          </section>

          <section className="section-card frame-card" id="control-register">
            <SectionHeading
              eyebrow="Section 5"
              title="CONTROL register bitfield"
              lead="The register is the software contract. Each field is clickable, and the default value 0x00001801 is annotated so you can see exactly which settings are active at reset, including reserved bits that must stay 0."
            />

            <div className="register-summary frame-card subtle-card">
              <div>
                <span>Default value</span>
                <strong>0x00001801</strong>
              </div>
              <div>
                <span>Decoded default</span>
                <strong>ENABLE = 1, SAMPLE_WIDTH = 24, RESERVED = 0</strong>
              </div>
              <div>
                <span>Current selection</span>
                <strong>{selectedFieldInfo.label}</strong>
              </div>
            </div>

            <div className="field-bar" role="tablist" aria-label="CONTROL register fields">
              {controlFields.map((field) => {
                const span = field.endBit - field.startBit + 1;
                const gridColumnStart = 32 - field.endBit;

                return (
                  <button
                    key={field.key}
                    type="button"
                    className={selectedField === field.key ? `field-chip ${field.accent} active` : `field-chip ${field.accent}`}
                    style={{ gridColumn: `${gridColumnStart} / span ${span}` }}
                    onClick={() => setSelectedField(field.key)}
                  >
                    <span>{field.label}</span>
                    <small>{field.range}</small>
                  </button>
                );
              })}
            </div>

            <div className="bit-map frame-card subtle-card">
              {Array.from({ length: 32 }, (_, index) => {
                const bitIndex = 31 - index;
                const field = fieldByBit(bitIndex);
                const value = registerBits[bitIndex];
                const isSelected = field.key === selectedField;

                return (
                  <button
                    key={bitIndex}
                    type="button"
                    className={isSelected ? `bit-cell ${field.accent} active` : `bit-cell ${field.accent}`}
                    onClick={() => setSelectedField(field.key)}
                    title={`${field.label} bit ${bitIndex}`}
                  >
                    <span>{bitIndex}</span>
                    <strong>{value}</strong>
                  </button>
                );
              })}
            </div>

            <div className="detail-card frame-card subtle-card">
              <div>
                <p className="eyebrow">Selected field</p>
                <h3>{selectedFieldInfo.label}</h3>
                <p>{selectedFieldInfo.description}</p>
              </div>
              <div>
                <p className="eyebrow">Effect on the audio path</p>
                <p>{selectedFieldInfo.effect}</p>
              </div>
              <div>
                <p className="eyebrow">Range and value</p>
                <p>{selectedFieldInfo.range} · default {selectedFieldInfo.value}</p>
              </div>
            </div>
          </section>

          <section className="section-card frame-card" id="i2s-frame">
            <SectionHeading
              eyebrow="Section 6"
              title="Philips I2S frame structure"
              lead="This is one full 64-bit stereo frame. The left channel occupies cells 0–31, the right channel occupies cells 32–63, and the sample width slider changes where payload ends and padding begins."
            />

            <div className="control-panel compact">
              <div className="control-stack">
                <label className="slider-label" htmlFor="width-slider">
                  <span>SAMPLE_WIDTH</span>
                  <strong>{sampleWidth}-bit</strong>
                </label>
                <input
                  id="width-slider"
                  className="range-input"
                  type="range"
                  min={16}
                  max={32}
                  step={8}
                  value={sampleWidth}
                  aria-valuemin={16}
                  aria-valuemax={32}
                  aria-valuenow={sampleWidth}
                  aria-valuetext={`${sampleWidth}-bit`}
                  onChange={(event) => setSampleWidth(Number(event.target.value) as SampleWidth)}
                />
                <div className="slider-endpoints">
                  <span>16</span>
                  <span>24</span>
                  <span>32</span>
                </div>
              </div>

              <div className="formula-steps">
                <div className="formula-step">
                  <strong>Cell rules</strong>
                  <p>pos 0 and pos 32 are the always-zero delay cells. pos 1 is sample[width-1]. pos 2..width count down through the remaining payload bits. Everything after width is padding.</p>
                </div>
              </div>
            </div>

            <div className="frame-legend">
              <span className="legend-item legend-left">Left slot</span>
              <span className="legend-item legend-right">Right slot</span>
              <span className="legend-item legend-delay">Delay bit</span>
              <span className="legend-item legend-payload">Payload</span>
              <span className="legend-item legend-padding">Padding</span>
            </div>

            <div className="frame-grid frame-card subtle-card" aria-label="64-cell I2S frame grid">
              {Array.from({ length: 64 }, (_, position) => {
                const isLeft = position < 32;
                const isDelay = position === 0 || position === 32;
                const localPosition = isLeft ? position : position - 32;
                const bitValue = frameBitAt(position, sampleWidth, leftBits, rightBits);
                const cellClass = isDelay
                  ? "frame-cell delay"
                  : localPosition <= sampleWidth
                    ? isLeft
                      ? "frame-cell payload left"
                      : "frame-cell payload right"
                    : isLeft
                      ? "frame-cell padding left"
                      : "frame-cell padding right";

                return (
                  <div key={position} className={cellClass}>
                    <span>{position}</span>
                    <strong>{bitValue}</strong>
                  </div>
                );
              })}
            </div>

            <div className="formula-steps">
              <div className="formula-step">
                <strong>pos 0</strong>
                <p>Always 0, creating the 1 BCLK delay after the WS edge required by Philips I2S.</p>
              </div>
              <div className="formula-step">
                <strong>pos 1</strong>
                <p>sample[width-1], the MSB of the selected sample word.</p>
              </div>
              <div className="formula-step">
                <strong>pos 2..width</strong>
                <p>sample[width-pos], continuing MSB-first until the payload is exhausted.</p>
              </div>
              <div className="formula-step">
                <strong>pos &gt; width</strong>
                <p>0, which is the padding region.</p>
              </div>
            </div>

            <div className="placeholder-box frame-card subtle-card">
              <p className="eyebrow">Placeholder</p>
              <strong>[PHOTO: ILA capture showing BCLK, WS, DATA for one full 64-bit stereo frame at 48 kHz]</strong>
              <p>Use this slot for a real capture when you want to prove the frame on hardware with the same timing shown above.</p>
            </div>
          </section>

          <section className="section-card frame-card" id="ws-timing">
            <SectionHeading
              eyebrow="Section 7"
              title="WS timing"
              lead="bit_count_q[5] is the clean left/right split. It is 0 for bit_count 0..31 and 1 for bit_count 32..63, so WS changes once per half-frame while DATA changes on the falling BCLK edge."
            />

            <SignalTimeline
              tick={frameTick}
              sampleWidth={sampleWidth}
              enable={enable}
              mute={mute}
              leftBits={leftBits}
              rightBits={rightBits}
              title="WS timing"
              description="This preview tracks the 64-bit stereo frame and highlights the current bit_count_q slot."
            />

            <div className="formula-steps">
              <div className="formula-step">
                <strong>Left channel</strong>
                <p>bit_count 0..31 means bit[5] = 0, so WS = LOW.</p>
              </div>
              <div className="formula-step">
                <strong>Right channel</strong>
                <p>bit_count 32..63 means bit[5] = 1, so WS = HIGH.</p>
              </div>
            </div>
          </section>

          <section className="section-card frame-card" id="enable-mute">
            <SectionHeading
              eyebrow="Section 8"
              title="ENABLE and MUTE behaviour"
              lead="These toggles show what the output pins do in real time. ENABLE stops the whole audio engine, while MUTE keeps the clocks alive and only forces DATA low."
            />

            <div className="toggle-row runtime-toggle-row">
              <button className={enable ? "toggle-btn active" : "toggle-btn"} type="button" onClick={() => setEnable((value) => !value)}>
                <span>ENABLE</span>
                <small>{enable ? "1" : "0"}</small>
              </button>
              <button className={mute ? "toggle-btn active" : "toggle-btn"} type="button" onClick={() => setMute((value) => !value)}>
                <span>MUTE</span>
                <small>{mute ? "1" : "0"}</small>
              </button>
            </div>

            <div className="state-grid">
              <div className="state-card frame-card subtle-card">
                <strong>ENABLE = 0</strong>
                <p>BCLK, WS, and DATA all stay low and bit_count resets to 0.</p>
              </div>
              <div className="state-card frame-card subtle-card">
                <strong>MUTE = 1</strong>
                <p>BCLK and WS continue normally, but DATA is forced to 0.</p>
              </div>
              <div className="state-card frame-card subtle-card">
                <strong>Both normal</strong>
                <p>ENABLE = 1 and MUTE = 0 produce the full I2S stream.</p>
              </div>
            </div>

            <SignalTimeline
              tick={frameTick}
              sampleWidth={sampleWidth}
              enable={enable}
              mute={mute}
              leftBits={leftBits}
              rightBits={rightBits}
              title="Output behaviour"
              description="Watch the same frame preview respond instantly to ENABLE and MUTE."
            />
          </section>

          <section className="section-card frame-card" id="formula-summary">
            <SectionHeading
              eyebrow="Section 9"
              title="Full formula summary"
              lead="This card ties the whole chain together. Pick a family and mode anywhere on the page, then read the selected path all the way down to Fs."
            />

            <div className="summary-flow frame-card subtle-card">
              <span>FS_FAMILY</span>
              <span>→ internal_mclk</span>
              <span>→ MCLK = internal_mclk ÷ 2</span>
              <span>→ FS_MODE</span>
              <span>→ divider</span>
              <span>→ BCLK = internal_mclk ÷ divider ÷ 2</span>
              <span>→ WS = BCLK ÷ 64</span>
              <span>→ Fs = WS</span>
            </div>

            <div className="summary-matrix">
              {familyModeMatrix.map((row) => (
                <div key={row.family.value} className="summary-row">
                  <div className="summary-family-label">
                    <strong>{row.family.label}</strong>
                    <span>{row.family.description}</span>
                  </div>
                  {row.cells.map((cell) => {
                    const selected = cell.family === fsFamily && cell.mode === fsMode;

                    return (
                      <div key={`${cell.family}-${cell.mode}`} className={selected ? "summary-cell active" : "summary-cell"}>
                        <strong>{modeOptions[cell.mode].label}</strong>
                        <p>Fs = {formatFrequencyForTable(cell.fsHz)}</p>
                        <span>divider {cell.divider} · BCLK {formatFrequencyForTable(cell.bclkHz)}</span>
                      </div>
                    );
                  })}
                </div>
              ))}
            </div>

            <div className="placeholder-box frame-card subtle-card">
              <p className="eyebrow">Placeholder</p>
              <strong>[PHOTO: Oscilloscope capture showing MCLK, BCLK, WS, and DATA aligned for one complete stereo frame]</strong>
              <p>Use a hardware image here when you want the visual summary to match a real board capture.</p>
            </div>
          </section>
        </div>
      </div>
    </main>
  );
}
