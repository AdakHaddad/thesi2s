"use client";

import { useEffect, useMemo, useState } from "react";

type PhaseId =
  | "axi-write"
  | "cdc-stage1"
  | "cdc-stage2"
  | "frame-latch"
  | "left-delay"
  | "left-payload"
  | "right-delay"
  | "right-payload";

type Phase = {
  id: PhaseId;
  title: string;
  domain: string;
  bitCount: number;
  ws: 0 | 1;
  dataBit: 0 | 1;
  leftActive: boolean;
  rightActive: boolean;
  highlightKeys: string[];
  summary: string;
  detail: string;
  codeFocus: string;
  stageIndex: number;
};

const sampleWidth = 24;
const leftWord = 0xd4a5c3f0 >>> 0;
const rightWord = 0x6e35f0a5 >>> 0;

const rtlSnippet = [
  { key: "axi", line: "slv_reg0 <= S_AXI_WDATA;            // CPU writes left sample" },
  { key: "cdc1", line: "cdc_left_stage1_q <= slv_reg0;      // first sync flop" },
  { key: "cdc2", line: "cdc_left_stage2_q <= cdc_left_stage1_q; // second sync flop" },
  { key: "latch", line: "if (bclk_en_w && bit_count_q == 6'd0) sample_left_q <= cdc_left_stage2_q;" },
  { key: "ws", line: "i2s_ws_o <= bit_count_q[5];           // 0 for left slot, 1 for right slot" },
  { key: "delay", line: "if (bit_count_q == 6'd0 || bit_count_q == 6'd32) i2s_data_o <= 1'b0;" },
  { key: "left-msb", line: "else if (bit_count_q <= g_width) i2s_data_o <= sample_left_q[g_width - bit_count_q];" },
  { key: "right-msb", line: "else if (bit_count_q > 6'd32 && bit_count_q <= (6'd32 + g_width))" },
  { key: "right-data", line: "  i2s_data_o <= sample_right_q[g_width - (bit_count_q - 6'd32)];" },
  { key: "pad", line: "else i2s_data_o <= 1'b0;             // pad remaining slot bits with zero" },
];

function buildBits(word: number, width: number) {
  return Array.from({ length: width }, (_, index) => (word >>> (31 - index)) & 1);
}

const leftBits = buildBits(leftWord, sampleWidth);
const rightBits = buildBits(rightWord, sampleWidth);

const phases: Phase[] = [
  {
    id: "axi-write",
    title: "CPU writes DATA_LEFT",
    domain: "AXI clock domain",
    bitCount: 0,
    ws: 0,
    dataBit: 0,
    leftActive: false,
    rightActive: false,
    highlightKeys: ["axi"],
    summary: "The processor updates slv_reg0 immediately, but the serializer does not touch it yet.",
    detail: "This decouples software timing from the audio bitstream. A write can happen at any AXI cycle without corrupting an in-flight I2S word.",
    codeFocus: "AXI register write",
    stageIndex: 0,
  },
  {
    id: "cdc-stage1",
    title: "CDC stage 1 samples AXI value",
    domain: "audio clock domain",
    bitCount: 0,
    ws: 0,
    dataBit: 0,
    leftActive: false,
    rightActive: false,
    highlightKeys: ["cdc1"],
    summary: "The first synchronizer flip-flop captures the asynchronous AXI-domain sample.",
    detail: "This stage may see the transition at any safe audio edge; it is intentionally isolated before the value is used by the datapath.",
    codeFocus: "first CDC synchronizer flop",
    stageIndex: 1,
  },
  {
    id: "cdc-stage2",
    title: "CDC stage 2 cleans the value",
    domain: "audio clock domain",
    bitCount: 0,
    ws: 0,
    dataBit: 0,
    leftActive: false,
    rightActive: false,
    highlightKeys: ["cdc2"],
    summary: "The second synchronizer flop exports a cleaner version into the audio logic.",
    detail: "Only after this point should the sample be consumed by logic that controls timing-critical outputs such as WS and DATA.",
    codeFocus: "second CDC synchronizer flop",
    stageIndex: 2,
  },
  {
    id: "frame-latch",
    title: "Sample latch at frame start",
    domain: "audio clock domain",
    bitCount: 0,
    ws: 0,
    dataBit: 0,
    leftActive: true,
    rightActive: true,
    highlightKeys: ["latch", "ws", "delay"],
    summary: "At bit_count = 0, both stereo samples are latched together for the next full frame.",
    detail: "This is the critical anti-tearing mechanism: both channels are frozen at the same frame boundary before serialization begins.",
    codeFocus: "frame-boundary latching",
    stageIndex: 3,
  },
  {
    id: "left-delay",
    title: "WS changes, then one delay bit",
    domain: "audio clock domain",
    bitCount: 0,
    ws: 0,
    dataBit: 0,
    leftActive: true,
    rightActive: false,
    highlightKeys: ["ws", "delay"],
    summary: "Philips I2S requires a one-bit delay after the WS edge before the MSB appears.",
    detail: "That is why bit_count 0 is not payload. The data line is forced low for one BCLK so the receiver can align channel selection cleanly.",
    codeFocus: "WS edge and mandatory delay cell",
    stageIndex: 4,
  },
  {
    id: "left-payload",
    title: "Left channel MSB-first serialization",
    domain: "audio clock domain",
    bitCount: 1,
    ws: 0,
    dataBit: leftBits[0] as 0 | 1,
    leftActive: true,
    rightActive: false,
    highlightKeys: ["ws", "left-msb"],
    summary: "At bit_count = 1, the left-channel MSB is driven first, then the serializer walks downward bit by bit.",
    detail: `For a ${sampleWidth}-bit payload, bit_count 1..${sampleWidth} emit sample_left_q[23:0] MSB-first. The remainder of the 32-bit slot becomes zero padding.`,
    codeFocus: "left payload bit selection",
    stageIndex: 4,
  },
  {
    id: "right-delay",
    title: "Right-slot transition and delay bit",
    domain: "audio clock domain",
    bitCount: 32,
    ws: 1,
    dataBit: 0,
    leftActive: false,
    rightActive: true,
    highlightKeys: ["ws", "delay"],
    summary: "When bit_count crosses 32, WS rises and the serializer inserts the second mandatory delay bit.",
    detail: "The right channel follows the same rule as the left channel: WS changes first, then the first payload bit appears one BCLK later.",
    codeFocus: "right-slot WS transition",
    stageIndex: 4,
  },
  {
    id: "right-payload",
    title: "Right channel MSB-first serialization",
    domain: "audio clock domain",
    bitCount: 33,
    ws: 1,
    dataBit: rightBits[0] as 0 | 1,
    leftActive: false,
    rightActive: true,
    highlightKeys: ["ws", "right-msb", "right-data"],
    summary: "At bit_count = 33, the right-channel MSB starts shifting out, again MSB-first.",
    detail: `The index equation changes to sample_right_q[g_width - (bit_count_q - 32)], so bit_count 33 maps back to sample_right_q[23].`,
    codeFocus: "right payload bit selection",
    stageIndex: 4,
  },
];

function formatBinary(word: number) {
  return word.toString(2).padStart(32, "0");
}

function slotCells(side: "left" | "right", activePhase: Phase) {
  const bits = side === "left" ? leftBits : rightBits;
  const startCount = side === "left" ? 0 : 32;
  const ws = side === "left" ? 0 : 1;

  return Array.from({ length: 8 }, (_, index) => {
    const slotPosition = index * 4;
    const bitCount = startCount + slotPosition;
    const isDelay = slotPosition === 0;
    const payloadIndex = slotPosition - 1;
    const bit = isDelay ? 0 : payloadIndex < sampleWidth ? bits[payloadIndex] : 0;
    const isCurrent = activePhase.bitCount >= bitCount && activePhase.bitCount < bitCount + 4;

    return {
      label: `${bitCount}-${bitCount + 3}`,
      detail: isDelay ? "delay" : payloadIndex < sampleWidth ? `D${sampleWidth - 1 - payloadIndex}` : "pad",
      bit,
      ws,
      isCurrent,
    };
  });
}

const datapathStages = [
  { key: "axi", label: "AXI write", note: "CPU updates DATA_LEFT / DATA_RIGHT" },
  { key: "cdc1", label: "CDC stage 1", note: "first audio-domain sample" },
  { key: "cdc2", label: "CDC stage 2", note: "cleaned destination value" },
  { key: "latch", label: "Frame latch", note: "freeze both channels at bit_count = 0" },
  { key: "serializer", label: "Serializer", note: "delay bit, then MSB-first output" },
];

function frameSegments(activePhase: Phase) {
  return [
    {
      key: "left-delay",
      label: "L delay",
      range: "0",
      active: activePhase.id === "left-delay",
      complete: activePhase.bitCount > 0,
    },
    {
      key: "left-payload",
      label: "L payload",
      range: `1-${sampleWidth}`,
      active: activePhase.id === "left-payload",
      complete: activePhase.bitCount > sampleWidth,
    },
    {
      key: "left-pad",
      label: "L pad",
      range: `${sampleWidth + 1}-31`,
      active: activePhase.bitCount > sampleWidth && activePhase.bitCount < 32,
      complete: activePhase.bitCount >= 32,
    },
    {
      key: "right-delay",
      label: "R delay",
      range: "32",
      active: activePhase.id === "right-delay",
      complete: activePhase.bitCount > 32,
    },
    {
      key: "right-payload",
      label: "R payload",
      range: `33-${32 + sampleWidth}`,
      active: activePhase.id === "right-payload",
      complete: activePhase.bitCount > 32 + sampleWidth,
    },
    {
      key: "right-pad",
      label: "R pad",
      range: `${33 + sampleWidth}-63`,
      active: activePhase.bitCount > 32 + sampleWidth,
      complete: false,
    },
  ];
}

export default function FullFlow() {
  const [phaseIndex, setPhaseIndex] = useState(0);
  const [playing, setPlaying] = useState(true);

  useEffect(() => {
    if (!playing) {
      return;
    }

    const timer = window.setInterval(() => {
      setPhaseIndex((current) => (current + 1) % phases.length);
    }, 2200);

    return () => window.clearInterval(timer);
  }, [playing]);

  const phase = phases[phaseIndex];
  const leftCells = useMemo(() => slotCells("left", phase), [phase]);
  const rightCells = useMemo(() => slotCells("right", phase), [phase]);
  const activeSegment = phase.bitCount < 32 ? "left" : "right";
  const currentWord = activeSegment === "left" ? leftWord : rightWord;
  const serializerProgress = phase.bitCount / 63;
  const segments = frameSegments(phase);
  const packetLeft = 8 + (phase.stageIndex / (datapathStages.length - 1)) * 84;

  return (
    <section className="section-card frame-card" id="full-flow">
      <div className="section-heading">
        <p className="eyebrow">Section 0</p>
        <h2>One-Viewport Serializer Walkthrough</h2>
        <p>
          This panel follows the real datapath in order: AXI write, CDC, frame latch, WS delay bit, left-slot serialization, WS transition,
          and right-slot serialization. The motion now tracks the sample itself so you can see when it is still a parallel word, when it
          is frozen for a frame, and when it finally becomes a single serial DATA bit.
        </p>
      </div>

      <div className="section-actions">
        <button className="action-btn" type="button" onClick={() => setPlaying((value) => !value)}>
          {playing ? "Pause walkthrough" : "Resume walkthrough"}
        </button>
        <button className="action-btn" type="button" onClick={() => setPhaseIndex((index) => (index + phases.length - 1) % phases.length)}>
          Previous step
        </button>
        <button className="action-btn" type="button" onClick={() => setPhaseIndex((index) => (index + 1) % phases.length)}>
          Next step
        </button>
        <div className="status-pill">
          Step {phaseIndex + 1}/{phases.length}: {phase.domain}
        </div>
      </div>

      <div className="fullflow-progress" aria-label="Full serializer walkthrough progress">
        {phases.map((item, index) => (
          <button
            key={item.id}
            type="button"
            className={index === phaseIndex ? "fullflow-step active" : index < phaseIndex ? "fullflow-step done" : "fullflow-step"}
            onClick={() => setPhaseIndex(index)}
          >
            <span>{index + 1}</span>
            <strong>{item.title}</strong>
          </button>
        ))}
      </div>

      <div className="fullflow-grid">
        <div className="fullflow-panel code-panel">
          <div className="fullflow-panel-head">
            <p className="eyebrow">RTL focus</p>
            <h3>{phase.codeFocus}</h3>
          </div>
          <div className="rtl-list" role="list" aria-label="RTL lines related to the serializer">
            {rtlSnippet.map((snippet, index) => (
              <div
                key={snippet.key}
                className={phase.highlightKeys.includes(snippet.key) ? "rtl-line active" : "rtl-line"}
                role="listitem"
              >
                <span>{String(index + 1).padStart(2, "0")}</span>
                <code>{snippet.line}</code>
              </div>
            ))}
          </div>
        </div>

        <div className="fullflow-panel viewport-panel">
          <div className="fullflow-panel-head">
            <p className="eyebrow">Sample journey</p>
            <h3>{phase.title}</h3>
          </div>

          <div className="signal-headline">
            <div className="signal-stat">
              <span>bit_count_q</span>
              <strong>{phase.bitCount}</strong>
            </div>
            <div className="signal-stat">
              <span>WS</span>
              <strong>{phase.ws}</strong>
            </div>
            <div className="signal-stat">
              <span>DATA</span>
              <strong>{phase.dataBit}</strong>
            </div>
            <div className="signal-stat">
              <span>sample width</span>
              <strong>{sampleWidth} bit</strong>
            </div>
          </div>

          <div className="journey-stage-strip" aria-label="Datapath stages">
            {datapathStages.map((stage, index) => (
              <div
                key={stage.key}
                className={
                  index === phase.stageIndex
                    ? "journey-stage-card active"
                    : index < phase.stageIndex
                      ? "journey-stage-card complete"
                      : "journey-stage-card"
                }
              >
                <span>{stage.label}</span>
                <small>{stage.note}</small>
              </div>
            ))}
          </div>

          <div className="journey-canvas frame-card subtle-card">
            <div className="journey-track" aria-hidden="true">
              <div
                className={`sample-packet ${activeSegment === "left" ? "left" : "right"}`}
                style={{ left: `${packetLeft}%` }}
              >
                <span>{activeSegment === "left" ? "L" : "R"}</span>
                <strong>{phase.dataBit}</strong>
              </div>
              <div className="journey-flowline" />
              <div className="journey-nodes">
                {datapathStages.map((stage, index) => (
                  <div key={stage.key} className={index === phase.stageIndex ? "journey-node active" : index < phase.stageIndex ? "journey-node complete" : "journey-node"}>
                    <strong>{index + 1}</strong>
                    <span>{stage.label}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="journey-hud">
              <div className="sample-word active">
                <span>Parallel word in motion</span>
                <strong>0x{currentWord.toString(16).toUpperCase()}</strong>
                <code>{formatBinary(currentWord).slice(0, sampleWidth)}...</code>
              </div>
              <div className="signal-stat">
                <span>What DATA pin sees now</span>
                <strong>{phase.dataBit}</strong>
              </div>
              <div className="signal-stat">
                <span>Current slot</span>
                <strong>{activeSegment === "left" ? "Left / WS=0" : "Right / WS=1"}</strong>
              </div>
            </div>
          </div>

          <div className="serializer-board">
            <div className="serializer-head">
              <div>
                <p className="eyebrow">Frame serializer</p>
                <h3>Where the parallel word turns into a serial I2S stream</h3>
              </div>
              <div className="serializer-status">
                <span>cursor</span>
                <strong>bit_count {phase.bitCount}</strong>
              </div>
            </div>

            <div className="serializer-segments" aria-label="I2S frame segments">
              {segments.map((segment) => (
                <div
                  key={segment.key}
                  className={segment.active ? "serializer-segment active" : segment.complete ? "serializer-segment complete" : "serializer-segment"}
                >
                  <span>{segment.label}</span>
                  <small>{segment.range}</small>
                </div>
              ))}
            </div>

            <div className="serializer-lane">
              <div className="serializer-lane-track" />
              <div className="serializer-lane-progress" style={{ width: `${serializerProgress * 100}%` }} />
              <div className="serializer-cursor" style={{ left: `calc(${serializerProgress * 100}% - 14px)` }}>
                <span>{phase.dataBit}</span>
              </div>
            </div>

            <div className="viewport-columns">
              <div className="slot-panel">
                <div className="slot-panel-head">
                  <strong>Left slot</strong>
                  <span>WS = 0, bit_count 0..31</span>
                </div>
                <div className="slot-grid">
                  {leftCells.map((cell) => (
                    <div key={`left-${cell.label}`} className={cell.isCurrent ? "slot-cell current left" : "slot-cell left"}>
                      <span>{cell.label}</span>
                      <strong>{cell.bit}</strong>
                      <small>{cell.detail}</small>
                    </div>
                  ))}
                </div>
              </div>

              <div className="slot-panel">
                <div className="slot-panel-head">
                  <strong>Right slot</strong>
                  <span>WS = 1, bit_count 32..63</span>
                </div>
                <div className="slot-grid">
                  {rightCells.map((cell) => (
                    <div key={`right-${cell.label}`} className={cell.isCurrent ? "slot-cell current right" : "slot-cell right"}>
                      <span>{cell.label}</span>
                      <strong>{cell.bit}</strong>
                      <small>{cell.detail}</small>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="fullflow-panel learn-panel">
          <div className="fullflow-panel-head">
            <p className="eyebrow">Why this step matters</p>
            <h3>{phase.summary}</h3>
          </div>

          <div className="formula-steps">
            <div className="formula-step">
              <strong>Current step</strong>
              <p>{phase.detail}</p>
            </div>
            <div className="formula-step">
              <strong>Hardware consequence</strong>
              <p>
                WS = {phase.ws}, DATA = {phase.dataBit}, and the active serializer position is bit_count {phase.bitCount}. That state is what a logic
                analyzer or ILA would observe on this exact cycle.
              </p>
            </div>
            <div className="formula-step">
              <strong>What to learn here</strong>
              <p>
                The serializer never streams directly from AXI registers. It waits for a clean CDC transfer and a frame boundary, then emits one delay
                bit plus MSB-first payload for each channel.
              </p>
            </div>
          </div>

          <div className="mini-wave-strip">
            <div className="wave-row">
              <span>BCLK</span>
              {Array.from({ length: 10 }, (_, index) => (
                <div key={`bclk-${index}`} className={index % 2 === 0 ? "wave-chip low" : "wave-chip high"}>
                  {index % 2}
                </div>
              ))}
            </div>
            <div className="wave-row">
              <span>WS</span>
              {Array.from({ length: 10 }, (_, index) => {
                const value = phase.ws === 0 ? (index < 5 ? 0 : 1) : 1;
                return (
                  <div key={`ws-${index}`} className={value === 0 ? "wave-chip low" : "wave-chip high"}>
                    {value}
                  </div>
                );
              })}
            </div>
            <div className="wave-row">
              <span>DATA</span>
              {Array.from({ length: 10 }, (_, index) => {
                const value = index === 5 ? phase.dataBit : index < 5 ? 0 : phase.dataBit;
                return (
                  <div key={`data-${index}`} className={value === 0 ? "wave-chip low" : "wave-chip high current"}>
                    {value}
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
