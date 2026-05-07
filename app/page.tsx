"use client";

import { useEffect, useState } from "react";

type ClockLens = "mclk" | "counter" | "bclk";
type SerializerWidth = 16 | 24 | 32;
type AxiExample = "control" | "sample" | "strobes";
type ExplanationLens = "beginner" | "rtl" | "math" | "timing";

const outlineItems = [
  { id: "hero", label: "Overview" },
  { id: "architecture", label: "Signal flow" },
  { id: "clock-generation", label: "Clock generation" },
  { id: "axi-fundamentals", label: "AXI fundamentals" },
  { id: "cdc-fundamentals", label: "CDC fundamentals" },
  { id: "serializer", label: "Serializer" },
  { id: "explanations", label: "Four lenses" },
  { id: "full-story", label: "Full system story" },
];

const architectureBlocks = [
  {
    id: "cpu",
    title: "CPU / AXI side",
    text: "MicroBlaze writes control and sample words as if the core were ordinary memory.",
  },
  {
    id: "registers",
    title: "Register map",
    text: "Hardware state appears as named addresses: control bits, sample data, status, and mode selection.",
  },
  {
    id: "cdc",
    title: "Clock domain crossing",
    text: "A synchronizer moves intent from the CPU clocking world into the audio clock world safely.",
  },
  {
    id: "audio-clock",
    title: "Audio clock domain",
    text: "Internal dividers and enables build the cadence that drives frame timing and bit timing.",
  },
  {
    id: "serializer",
    title: "I2S serializer",
    text: "Parallel audio words are shifted out MSB-first one bit at a time.",
  },
  {
    id: "pins",
    title: "Output pins",
    text: "The final signals leave on MCLK, BCLK, WS, and DATA.",
  },
];

const architecturePlaceholders = [
  "[Placeholder: AXI-to-I2S Architecture Diagram]",
  "[Placeholder: CDC Synchronizer Visual]",
  "[Placeholder: I2S Frame Timing Figure]",
  "[Placeholder: BCLK Timing Animation]",
];

const clockViews: Record<ClockLens, { title: string; lead: string; focus: string; rows: Array<{ cycle: number; bits: string; q0: string; q1: string; q2: string; bclkEnable: string; wsSelect: string }> }> = {
  mclk: {
    title: "internal_mclk as the local rhythm",
    lead:
      "internal_mclk is the clock that exists inside the core before the rest of the logic starts dividing and gating it. When a flip-flop toggles on every active edge, the output needs two input cycles to complete one full waveform.",
    focus: "A toggling flip-flop divides frequency by 2 because one output period now spans two input periods.",
    rows: [
      { cycle: 0, bits: "000", q0: "0", q1: "0", q2: "0", bclkEnable: "yes", wsSelect: "left" },
      { cycle: 1, bits: "001", q0: "1", q1: "0", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 2, bits: "010", q0: "0", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 3, bits: "011", q0: "1", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 4, bits: "100", q0: "0", q1: "0", q2: "1", bclkEnable: "yes", wsSelect: "right" },
      { cycle: 5, bits: "101", q0: "1", q1: "0", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 6, bits: "110", q0: "0", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 7, bits: "111", q0: "1", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
    ],
  },
  counter: {
    title: "clock_div_q as a binary counter",
    lead:
      "Because the divider is binary, every bit has a natural power-of-two rhythm. Bit 0 flips every 2 cycles, bit 1 flips every 4 cycles, and bit 2 flips every 8 cycles.",
    focus: "Binary counters turn simple toggles into predictable timing surfaces.",
    rows: [
      { cycle: 0, bits: "000", q0: "0", q1: "0", q2: "0", bclkEnable: "yes", wsSelect: "left" },
      { cycle: 1, bits: "001", q0: "1", q1: "0", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 2, bits: "010", q0: "0", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 3, bits: "011", q0: "1", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 4, bits: "100", q0: "0", q1: "0", q2: "1", bclkEnable: "yes", wsSelect: "right" },
      { cycle: 5, bits: "101", q0: "1", q1: "0", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 6, bits: "110", q0: "0", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 7, bits: "111", q0: "1", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
    ],
  },
  bclk: {
    title: "BCLK enable derived from low bits",
    lead:
      "The condition clock_div_q[1:0] == 2'b00 goes true every four counts, so it creates a periodic enable that is slower than bit 0 but faster than bit 2.",
    focus: "This is how divider logic becomes a bit-clock cadence.",
    rows: [
      { cycle: 0, bits: "000", q0: "0", q1: "0", q2: "0", bclkEnable: "yes", wsSelect: "left" },
      { cycle: 1, bits: "001", q0: "1", q1: "0", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 2, bits: "010", q0: "0", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 3, bits: "011", q0: "1", q1: "1", q2: "0", bclkEnable: "no", wsSelect: "left" },
      { cycle: 4, bits: "100", q0: "0", q1: "0", q2: "1", bclkEnable: "yes", wsSelect: "right" },
      { cycle: 5, bits: "101", q0: "1", q1: "0", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 6, bits: "110", q0: "0", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
      { cycle: 7, bits: "111", q0: "1", q1: "1", q2: "1", bclkEnable: "no", wsSelect: "right" },
    ],
  },
};

const binaryPatterns = [
  { label: "clock_div_q[0]", pattern: "0 1 0 1 0 1 0 1", note: "toggles every 2 cycles" },
  { label: "clock_div_q[1]", pattern: "0 0 1 1 0 0 1 1", note: "toggles every 4 cycles" },
  { label: "clock_div_q[2]", pattern: "0 0 0 0 1 1 1 1", note: "toggles every 8 cycles" },
];

const axiExamples: Record<AxiExample, { title: string; address: string; wstrb: string; lead: string; steps: string[]; bytes: string[] }> = {
  control: {
    title: "Control register write",
    address: "0x00",
    wstrb: "1111",
    lead:
      "A control write shows the simplest AXI contract: the address lands, the write data lands, and the slave returns a response once both sides have handshaken.",
    steps: ["AWVALID + AWREADY", "WVALID + WREADY", "BVALID + BREADY"],
    bytes: ["byte 3", "byte 2", "byte 1", "byte 0"],
  },
  sample: {
    title: "Sample data write",
    address: "0x04",
    wstrb: "1111",
    lead:
      "This is the path that turns a CPU register write into an audio payload. The peripheral can accept the word only when the address, data, and response channels all complete their handshake.",
    steps: ["sample word staged", "sample latched", "ready for serializer"],
    bytes: ["audio byte 3", "audio byte 2", "audio byte 1", "audio byte 0"],
  },
  strobes: {
    title: "Byte-lane write using WSTRB",
    address: "0x08",
    wstrb: "1100",
    lead:
      "WSTRB is the byte-enable mask. Only the active byte lanes update, so partial register writes can preserve the untouched bytes in the same 32-bit location.",
    steps: ["upper half enabled", "lower half held", "register preserves untouched bytes"],
    bytes: ["active", "active", "masked", "masked"],
  },
};

const serializerWidths: SerializerWidth[] = [16, 24, 32];

const explanationTabs: Record<ExplanationLens, { title: string; summary: string; points: string[] }> = {
  beginner: {
    title: "Beginner explanation",
    summary:
      "Think of the core as a conveyor belt. The CPU loads the belt with audio words, the clocking logic decides when the belt moves, and the serializer turns each parallel sample into one bit at a time.",
    points: [
      "AXI registers are hardware exposed as memory.",
      "A counter is fundamentally frequency division.",
      "Serialization is time-multiplexing of parallel data.",
    ],
  },
  rtl: {
    title: "RTL explanation",
    summary:
      "The RTL separates concerns: address decoding and register writes on the AXI side, clock-domain synchronization in the middle, and a shift engine that emits the I2S framing signals on the output side.",
    points: [
      "The register map is the software-visible contract.",
      "CDC logic isolates the asynchronous boundary.",
      "Bit counters and shift registers implement the serializer.",
    ],
  },
  math: {
    title: "Mathematical explanation",
    summary:
      "Binary counters naturally produce powers of two. That is why divider bits land on clean ratios and why a condition like clock_div_q[1:0] == 2'b00 repeats every four cycles.",
    points: [
      "f_out = f_in / 2 for a toggle flip-flop.",
      "2^5 = 32 explains the WS split in a 64-slot stereo frame.",
      "bit_idx = width - pos counts down from MSB to LSB.",
    ],
  },
  timing: {
    title: "Timing explanation",
    summary:
      "The critical story is who changes when. AXI writes can happen in bursts, CDC captures those values safely, and the audio side advances only when the derived enables say the next bit slot is ready.",
    points: [
      "Metastability appears when a signal changes near a clock edge.",
      "Two flip-flops give the first stage time to settle.",
      "BCLK and WS only move in the audio clock domain.",
    ],
  },
};

const cdcBlocks = [
  {
    title: "Why different clock domains are dangerous",
    text:
      "If a signal changes close to a destination clock edge, the receiving flip-flop can briefly enter metastability. The output is not a guaranteed 0 or 1 yet, so the next logic stage may see an unstable intermediate value.",
  },
  {
    title: "Why two flip-flops are used",
    text:
      "The first flop catches the crossing signal. The second flop gives that value another clock period to settle before the rest of the audio logic consumes it.",
  },
  {
    title: "What the synchronizer buys you",
    text:
      "You do not eliminate metastability mathematically, but you reduce the probability that it propagates into the functional part of the design.",
  },
];

const fullStorySteps = [
  {
    title: "CPU write",
    text: "Software writes an audio sample or configuration word through the AXI4-Lite interface.",
  },
  {
    title: "AXI register",
    text: "The address decoder selects the correct register and WSTRB decides which byte lanes update.",
  },
  {
    title: "CDC capture",
    text: "A two-flop synchronizer carries the control intent into the audio clock domain.",
  },
  {
    title: "Sample latch",
    text: "The sample is held steady so the serializer sees a complete word, not a moving target.",
  },
  {
    title: "Serializer",
    text: "Bit counters and shift logic emit the sample MSB-first across the DATA pin.",
  },
  {
    title: "I2S output pins",
    text: "MCLK, BCLK, WS, and DATA now describe a frame that the DAC can reconstruct as analog audio.",
  },
];

const placeholderCards = [
  {
    title: "Architecture sketch",
    text: "[Placeholder: AXI-to-I2S Architecture Diagram]",
  },
  {
    title: "Clock timing",
    text: "[Placeholder: BCLK Timing Animation]",
  },
  {
    title: "CDC view",
    text: "[Placeholder: CDC Synchronizer Visual]",
  },
  {
    title: "Frame figure",
    text: "[Placeholder: I2S Frame Timing Figure]",
  },
];

export default function Home() {
  const [activeSection, setActiveSection] = useState(outlineItems[0].id);
  const [clockLens, setClockLens] = useState<ClockLens>("mclk");
  const [serializerWidth, setSerializerWidth] = useState<SerializerWidth>(32);
  const [axiExample, setAxiExample] = useState<AxiExample>("sample");
  const [explanationLens, setExplanationLens] = useState<ExplanationLens>("beginner");

  useEffect(() => {
    const sections = outlineItems
      .map((item) => document.getElementById(item.id))
      .filter((node): node is HTMLElement => node !== null);

    const observer = new IntersectionObserver(
      (entries) => {
        const visibleEntries = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio);

        if (visibleEntries.length > 0) {
          setActiveSection(visibleEntries[0].target.id);
        }
      },
      {
        rootMargin: "-20% 0px -55% 0px",
        threshold: [0.2, 0.4, 0.6],
      },
    );

    sections.forEach((section) => observer.observe(section));

    return () => observer.disconnect();
  }, []);

  return (
    <main className="thesis-shell doc-shell">
      <div className="page-grid">
        <aside className="outline-rail">
          <div className="outline-card frame-panel">
            <p className="eyebrow">Outline</p>
            <nav aria-label="Page outline">
              {outlineItems.map((item) => (
                <a
                  key={item.id}
                  href={`#${item.id}`}
                  className={activeSection === item.id ? "outline-link active" : "outline-link"}
                >
                  {item.label}
                </a>
              ))}
            </nav>
          </div>
          <div className="outline-card frame-panel outline-note-card">
            <p className="eyebrow">Fundamental Insight</p>
            <p className="outline-note-text">
              AXI registers are hardware exposed as memory. That single idea is the bridge from software intent to physical timing.
            </p>
          </div>
        </aside>

        <div className="page-content">
          <section className="hero-band" id="hero">
            <div className="hero-copy">
              <p className="eyebrow">Interactive FPGA learning platform</p>
              <h1>
                Understand the AXI4-Lite I2S core from
                <span> first principles</span>
              </h1>
              <p className="hero-lead">
                This page is designed to build intuition before it explains RTL. It starts with the complete signal flow, then opens each block with timing, math, and register-level reasoning so the reader can feel how software becomes serial audio.
              </p>
              <div className="hero-chip-row">
                <span className="hero-chip">CPU / AXI side</span>
                <span className="hero-chip">CDC</span>
                <span className="hero-chip">Audio clock domain</span>
                <span className="hero-chip">MCLK / BCLK / WS / DATA</span>
              </div>
            </div>

            <div className="hero-visual frame-panel">
              <div className="architecture-strip">
                {architectureBlocks.map((block, index) => (
                  <div key={block.id} className="architecture-chip">
                    <div className="architecture-index">0{index + 1}</div>
                    <strong>{block.title}</strong>
                    <span>{block.text}</span>
                  </div>
                ))}
              </div>
              <div className="hero-flow-label">CPU → AXI registers → CDC → audio clocking → serializer → output pins</div>
            </div>
          </section>

          <section className="architecture-band" id="architecture">
            <div className="section-copy narrow">
              <p className="eyebrow">High-level architecture</p>
              <h2>Keep the whole path visible before zooming into any one block</h2>
              <p>
                The best mental model is a pipeline of responsibility. The CPU writes intent, the register map stores state, CDC moves that state safely, the audio clock domain times the frame, the serializer emits bits, and the pins turn that state into a DAC-ready stream.
              </p>
            </div>

            <div className="architecture-grid">
              {architectureBlocks.map((block) => (
                <article key={block.id} className="architecture-card frame-panel">
                  <p className="story-index">{block.id}</p>
                  <h3>{block.title}</h3>
                  <p>{block.text}</p>
                </article>
              ))}
            </div>

            <div className="placeholder-grid">
              {placeholderCards.map((placeholder) => (
                <article key={placeholder.title} className="placeholder-card frame-panel">
                  <p className="eyebrow">Visual placeholder</p>
                  <h3>{placeholder.title}</h3>
                  <p>{placeholder.text}</p>
                </article>
              ))}
            </div>
          </section>

          <section className="clock-band" id="clock-generation">
            <div className="section-copy">
              <p className="eyebrow">Clock generation</p>
              <h2>Why counters divide clocks and why powers of two appear everywhere</h2>
              <p>
                internal_mclk is the local clock that the core uses as a base rhythm. When a flip-flop toggles on each input edge, the output only completes one full cycle after two input cycles. That is why a toggling flip-flop divides frequency by 2 and why the formula is simply f_out = f_in / 2.
              </p>
            </div>

            <div className="clock-tabs frame-panel">
              <div className="toggle-row" role="tablist" aria-label="Clock explanation modes">
                {Object.entries(clockViews).map(([key, value]) => (
                  <button
                    key={key}
                    className={clockLens === key ? "toggle active" : "toggle"}
                    onClick={() => setClockLens(key as ClockLens)}
                    type="button"
                  >
                    {value.title}
                  </button>
                ))}
              </div>

              <div className="fundamental-callout">
                <strong>Fundamental Insight</strong>
                <p>{clockViews[clockLens].focus}</p>
              </div>

              <div className="clock-lens-grid">
                <article className="clock-note-card">
                  <h3>{clockViews[clockLens].title}</h3>
                  <p>{clockViews[clockLens].lead}</p>
                </article>

                <article className="clock-note-card">
                  <h3>Binary counter rhythms</h3>
                  <div className="pattern-stack">
                    {binaryPatterns.map((pattern) => (
                      <div key={pattern.label} className="pattern-row">
                        <div>
                          <strong>{pattern.label}</strong>
                          <p>{pattern.note}</p>
                        </div>
                        <pre aria-hidden="true">{pattern.pattern}</pre>
                      </div>
                    ))}
                  </div>
                </article>
              </div>

              <div className="counter-table-wrap">
                <div className="table-lead">
                  <p>
                    clock_div_q behaves like a 3-bit binary counter. That means every bit has a power-of-two rhythm: q[0] changes every 2 cycles, q[1] every 4 cycles, and q[2] every 8 cycles.
                  </p>
                </div>
                <table className="counter-table">
                  <thead>
                    <tr>
                      <th>cycle</th>
                      <th>clock_div_q</th>
                      <th>q[0]</th>
                      <th>q[1]</th>
                      <th>q[2]</th>
                      <th>clock_div_q[1:0] == 2'b00</th>
                      <th>ws_q</th>
                    </tr>
                  </thead>
                  <tbody>
                    {clockViews[clockLens].rows.map((row) => (
                      <tr key={row.cycle}>
                        <td>{row.cycle}</td>
                        <td>{row.bits}</td>
                        <td>{row.q0}</td>
                        <td>{row.q1}</td>
                        <td>{row.q2}</td>
                        <td>{row.bclkEnable}</td>
                        <td>{row.wsSelect}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div className="clock-note-strip">
                <article className="clock-note-card compact">
                  <h3>Why clock_div_q[1:0] == 2'b00 matters</h3>
                  <p>
                    The lower two bits are zero only at counts 0 and 4. That creates an enable every 4 cycles, which is slower than q[0] but still faster than the next stage. This is the exact relationship between the divider logic and the generated BCLK frequency.
                  </p>
                </article>
                <article className="clock-note-card compact">
                  <h3>Why ws_q &lt;= bit_count_q[5]</h3>
                  <p>
                    2^5 = 32, so bit 5 flips after 32 counts. In a 64-slot stereo frame, that gives a clean left/right split: the first 32 serial slots belong to one channel, and the next 32 belong to the other.
                  </p>
                </article>
              </div>

              <div className="placeholder-banner frame-panel">
                <strong>[Placeholder: BCLK Timing Animation]</strong>
                <span>[Placeholder: I2S Frame Timing Figure]</span>
              </div>
            </div>

            <div className="math-strip">
              <article className="math-card frame-panel">
                <p className="eyebrow">Mathematical intuition</p>
                <h3>Binary counters make division feel inevitable</h3>
                <p>
                  A binary counter advances through states that are already aligned to powers of two. That is why divide-by-2, divide-by-4, and divide-by-8 signals fall out of the same register instead of requiring separate counters.
                </p>
              </article>
            </div>
          </section>

          <section className="axi-band" id="axi-fundamentals">
            <div className="section-copy">
              <p className="eyebrow">AXI fundamentals</p>
              <h2>Make the memory map feel like hardware, not an abstraction</h2>
              <p>
                VALID/READY handshakes mean that a transfer only happens when both sides agree. Address decoding chooses which register responds, WSTRB selects which byte lanes update, and the address space advances in 4-byte steps because each register word is 32 bits wide.
              </p>
            </div>

            <div className="toggle-row axi-toggle-row" role="tablist" aria-label="AXI walkthrough examples">
              {Object.entries(axiExamples).map(([key, value]) => (
                <button
                  key={key}
                  className={axiExample === key ? "toggle active" : "toggle"}
                  onClick={() => setAxiExample(key as AxiExample)}
                  type="button"
                >
                  {value.title}
                </button>
              ))}
            </div>

            <div className="axi-grid">
              <article className="axi-card frame-panel">
                <p className="eyebrow">Transaction walkthrough</p>
                <h3>{axiExamples[axiExample].title}</h3>
                <p>{axiExamples[axiExample].lead}</p>
                <div className="axi-step-list">
                  {axiExamples[axiExample].steps.map((step) => (
                    <div key={step} className="axi-step">
                      {step}
                    </div>
                  ))}
                </div>
              </article>

              <article className="axi-card frame-panel">
                <p className="eyebrow">Register details</p>
                <div className="axi-register-block">
                  <div>
                    <strong>Address</strong>
                    <p>{axiExamples[axiExample].address}</p>
                  </div>
                  <div>
                    <strong>WSTRB</strong>
                    <p>{axiExamples[axiExample].wstrb}</p>
                  </div>
                </div>

                <div className="byte-lane-grid" aria-label="Byte lane mask">
                  {axiExamples[axiExample].bytes.map((byte, index) => (
                    <div key={byte} className={axiExample === "strobes" && index > 1 ? "byte-lane masked" : "byte-lane"}>
                      {byte}
                    </div>
                  ))}
                </div>

                <div className="fundamental-callout subtle">
                  <strong>Fundamental Insight</strong>
                  <p>
                    A register file is just a memory map with hardware behind it.
                  </p>
                </div>
              </article>
            </div>

            <div className="placeholder-banner frame-panel">
              <strong>[Placeholder: AXI handshake timing figure]</strong>
              <span>VALID, READY, WSTRB, and address decode should all be visible in the eventual illustration.</span>
            </div>
          </section>

          <section className="cdc-band" id="cdc-fundamentals">
            <div className="section-copy">
              <p className="eyebrow">CDC fundamentals</p>
              <h2>Be careful when a signal moves between clock domains</h2>
              <p>
                Different clock domains are dangerous because the receiving flop may sample while the source is changing. Metastability is the unstable middle state that can appear when the setup and hold window is violated.
              </p>
            </div>

            <div className="cdc-grid">
              <article className="cdc-panel frame-panel">
                <h3>Why a two-flop synchronizer exists</h3>
                <p>
                  The first flip-flop captures the asynchronous edge. The second flip-flop gives that captured value another cycle to settle so the rest of the audio logic sees a clean signal.
                </p>
                <div className="cdc-flow">
                  <div className="cdc-node">source domain</div>
                  <div className="cdc-arrow">→</div>
                  <div className="cdc-node">flop 1</div>
                  <div className="cdc-arrow">→</div>
                  <div className="cdc-node">flop 2</div>
                  <div className="cdc-arrow">→</div>
                  <div className="cdc-node">audio domain</div>
                </div>
              </article>

              <article className="cdc-panel frame-panel">
                <p className="eyebrow">Visual placeholders</p>
                <div className="placeholder-stack">
                  <div className="placeholder-card compact frame-panel">
                    <strong>[Placeholder: Simplified metastability illustration]</strong>
                    <p>Show the input edge landing too close to the clock edge.</p>
                  </div>
                  <div className="placeholder-card compact frame-panel">
                    <strong>[Placeholder: CDC Synchronizer Visual]</strong>
                    <p>Show two flip-flops buffering the crossing signal.</p>
                  </div>
                </div>
              </article>
            </div>

            <div className="cdc-notes-grid">
              {cdcBlocks.map((block) => (
                <article key={block.title} className="cdc-note frame-panel">
                  <h3>{block.title}</h3>
                  <p>{block.text}</p>
                </article>
              ))}
            </div>
          </section>

          <section className="serializer-band" id="serializer">
            <div className="section-copy">
              <p className="eyebrow">Serializer</p>
              <h2>Parallel audio becomes serial timing, one bit slot at a time</h2>
              <p>
                The serializer reads a full sample word and shifts it onto DATA MSB-first. The indexing rule bit_idx = width - pos gives the position of the next bit to send, where pos counts the serial slot and width is the word length.
              </p>
            </div>

            <div className="toggle-row" role="tablist" aria-label="Sample width examples">
              {serializerWidths.map((width) => (
                <button
                  key={width}
                  className={serializerWidth === width ? "toggle active" : "toggle"}
                  onClick={() => setSerializerWidth(width)}
                  type="button"
                >
                  {width}-bit sample
                </button>
              ))}
            </div>

            <div className="serializer-grid">
              <article className="serializer-card frame-panel">
                <p className="eyebrow">Bit-level example</p>
                <h3>MSB-first transmission for a {serializerWidth}-bit sample</h3>
                <p>
                  The first bit that leaves the core is sample[{serializerWidth - 1}]. The last bit is sample[0]. Every serial tick moves the read pointer one step lower.
                </p>
                <div className="bit-lane">
                  <span>sample[{serializerWidth - 1}]</span>
                  <span>sample[{serializerWidth - 2}]</span>
                  <span>sample[{serializerWidth - 3}]</span>
                  <span className="bit-lane-dots">...</span>
                  <span>sample[2]</span>
                  <span>sample[1]</span>
                  <span>sample[0]</span>
                </div>
                <div className="bit-index-card">
                  <strong>bit_idx = width - pos</strong>
                  <p>pos = 1 maps to the MSB, pos = width maps to the LSB.</p>
                </div>
              </article>

              <article className="serializer-card frame-panel">
                <p className="eyebrow">Frame timing</p>
                <h3>How the serializer places bits in time</h3>
                <div className="serializer-timing-grid">
                  <div className="timing-legend">
                    <div><strong>16-bit</strong><span>shorter payload, same framing logic</span></div>
                    <div><strong>24-bit</strong><span>common audio word length</span></div>
                    <div><strong>32-bit</strong><span>full word alignment and padding are easiest to reason about</span></div>
                  </div>
                  <div className="placeholder-card frame-panel compact">
                    <strong>[Placeholder: I2S Frame Timing Figure]</strong>
                    <p>Show one stereo frame with left and right slots, MSB-first bits, and WS boundaries.</p>
                  </div>
                </div>
                <div className="fundamental-callout subtle">
                  <strong>Fundamental Insight</strong>
                  <p>Serialization is time-multiplexing of parallel data.</p>
                </div>
              </article>
            </div>

            <div className="serializer-table-wrap">
              <table className="counter-table">
                <thead>
                  <tr>
                    <th>Sample width</th>
                    <th>First bit</th>
                    <th>Last bit</th>
                    <th>Why it matters</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>16-bit</td>
                    <td>sample[15]</td>
                    <td>sample[0]</td>
                    <td>Fast to inspect, compact frame example.</td>
                  </tr>
                  <tr>
                    <td>24-bit</td>
                    <td>sample[23]</td>
                    <td>sample[0]</td>
                    <td>Matches a common PCM audio depth.</td>
                  </tr>
                  <tr>
                    <td>32-bit</td>
                    <td>sample[31]</td>
                    <td>sample[0]</td>
                    <td>Best for exact word alignment and a simple shift story.</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <section className="explanation-band" id="explanations">
            <div className="section-copy narrow">
              <p className="eyebrow">Expandable teaching lenses</p>
              <h2>Switch between beginner, RTL, math, and timing explanations</h2>
              <p>
                These tabs are the page’s main teaching control. Each one keeps the same core idea in view, but changes the lens so the reader can match their current understanding level.
              </p>
            </div>

            <div className="toggle-row" role="tablist" aria-label="Explanation lenses">
              {(Object.keys(explanationTabs) as ExplanationLens[]).map((lens) => (
                <button
                  key={lens}
                  className={explanationLens === lens ? "toggle active" : "toggle"}
                  onClick={() => setExplanationLens(lens)}
                  type="button"
                >
                  {explanationTabs[lens].title}
                </button>
              ))}
            </div>

            <div className="explanation-panel frame-panel">
              <h3>{explanationTabs[explanationLens].title}</h3>
              <p>{explanationTabs[explanationLens].summary}</p>
              <div className="explanation-points">
                {explanationTabs[explanationLens].points.map((point) => (
                  <div key={point} className="explanation-point">
                    {point}
                  </div>
                ))}
              </div>
              <div className="fundamental-callout">
                <strong>Fundamental Insight</strong>
                <p>
                  Every good hardware explanation should connect the register map, the timing, and the physical pins in one story.
                </p>
              </div>
            </div>
          </section>

          <section className="story-band" id="full-story">
            <div className="section-copy">
              <p className="eyebrow">Full system story</p>
              <h2>Walk one sample all the way through the core</h2>
              <p>
                This is the final pass: CPU write to AXI register to CDC to sample latch to serializer to I2S output. If the reader can narrate this chain, they understand the design at the right level.
              </p>
            </div>

            <div className="story-flow-grid">
              {fullStorySteps.map((step, index) => (
                <article key={step.title} className="story-flow-card frame-panel">
                  <p className="story-index">0{index + 1}</p>
                  <h3>{step.title}</h3>
                  <p>{step.text}</p>
                </article>
              ))}
            </div>

            <section className="closing-band frame-panel">
              <p className="eyebrow">Final takeaway</p>
              <h2>Use docpage/ as the visual front door to the whole I2S thesis</h2>
              <p>
                The page should feel like an interactive FPGA notebook: diagrams first, intuition second, RTL third, and only then the surrounding implementation details. That structure makes the core easier to teach, defend, and extend.
              </p>
            </section>
          </section>

          <section className="placeholder-summary">
            <div className="placeholder-card frame-panel">
              <strong>[Placeholder: AXI-to-I2S Architecture Diagram]</strong>
              <p>Keep this near the top so the reader can anchor every later section to the same visual map.</p>
            </div>
            <div className="placeholder-card frame-panel">
              <strong>[Placeholder: CDC Synchronizer Visual]</strong>
              <p>Use this when the page explains metastability and the two-flop synchronizer.</p>
            </div>
            <div className="placeholder-card frame-panel">
              <strong>[Placeholder: BCLK Timing Animation]</strong>
              <p>Use this when the divider logic and enable cadence are being explained.</p>
            </div>
          </section>
        </div>
      </div>
    </main>
  );
}
