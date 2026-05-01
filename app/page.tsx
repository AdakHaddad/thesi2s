"use client";

import { useEffect, useState } from "react";

const repositories = [
  {
    name: "ip_repo/",
    label: "Core RTL",
    description:
      "The custom AXI4-Lite I2S transmitter IP: top wrapper, slave interface, serializer, and the register-facing hardware surface.",
    accent: "var(--accent-amber)",
    bullets: [
      "Start here when explaining the IP boundary and signal generation.",
      "Maps naturally to register map, FIFO behavior, and serializer timing.",
    ],
  },
  {
    name: "i2sproject/",
    label: "Block Design",
    description:
      "The Vivado system integration layer: MicroBlaze V, AXI plumbing, clocks, wrappers, generated drivers, and bitstream outputs.",
    accent: "var(--accent-red)",
    bullets: [
      "Use this for the SoC story and addressable peripheral integration.",
      "Best place to talk about clocks, pinout, and hardware handoff.",
    ],
  },
  {
    name: "thesi2s/",
    label: "Thesis Narrative",
    description:
      "The full written argument: background, methodology, implementation, testing, and the research voice that connects everything.",
    accent: "var(--accent-blue)",
    bullets: [
      "Use this for chapter structure, results, and formal explanation.",
      "Acts as the backbone for captions, definitions, and validation notes.",
    ],
  },
];

const systemStages = [
  {
    id: "software",
    title: "Software intent",
    eyebrow: "MicroBlaze V / Vitis",
    summary:
      "Embedded C writes configuration and sample words through memory-mapped registers, then keeps the transmit side fed before underrun happens.",
  },
  {
    id: "fabric",
    title: "AXI4-Lite boundary",
    eyebrow: "Control surface",
    summary:
      "AXI transactions cross from processor space into the custom peripheral, exposing a clean register contract for mode selection and data movement.",
  },
  {
    id: "serializer",
    title: "I2S transmit engine",
    eyebrow: "Custom IP",
    summary:
      "Clock dividers, shifting logic, and framing rules transform 32-bit words into stereo serial audio with deterministic timing.",
  },
  {
    id: "output",
    title: "External DAC",
    eyebrow: "PCM5102A",
    summary:
      "The DAC reconstructs the stream as analog output once BCLK, WS, and DATA stay phase-aligned and stable.",
  },
];

const signalModes = {
  fs48: {
    label: "~48 kHz profile",
    lead:
      "A gentler transmit cadence that makes the handoff between processor, FIFO, and serializer easier to inspect.",
    lines: [
      { name: "MCLK", pattern: "||||||||||||||||||||||||||||||||", note: "Master reference clock stays continuous." },
      { name: "BCLK", pattern: "|||| |||| |||| |||| |||| |||| ||", note: "Bit clock advances each serial bit slot." },
      { name: "WS", pattern: "________--------________--------", note: "Word select flips once per stereo channel frame." },
      { name: "DATA", pattern: "..L23..L0....R23..R0....L23..L0.", note: "Left and right samples leave one bit lane at a time." },
    ],
  },
  fs96: {
    label: "~96 kHz profile",
    lead:
      "The same framing story, but with a tighter refill budget. This is where FIFO strategy becomes central to the thesis.",
    lines: [
      { name: "MCLK", pattern: "||||||||||||||||||||||||||||||||", note: "Reference clock remains continuous across modes." },
      { name: "BCLK", pattern: "|||||||| |||||||| |||||||| |||||", note: "Higher activity compresses the safe refill window." },
      { name: "WS", pattern: "____----____----____----____----", note: "Channel boundaries arrive more frequently." },
      { name: "DATA", pattern: ".L..L..L..R..R..R..L..L..L..R..R", note: "Serializer demand rises, so software slack drops." },
    ],
  },
} as const;

const chapters = [
  {
    title: "Why I2S on FPGA?",
    text:
      "Ground the reader in digital audio timing, why FPGA control matters, and why a soft-core plus custom IP is a meaningful design exercise.",
  },
  {
    title: "How the IP is shaped",
    text:
      "Explain the AXI4-Lite shell, the transmitter-only focus, supported formats, and the deliberate scoping choices around FIFO and sample modes.",
  },
  {
    title: "How the system comes alive",
    text:
      "Walk through Vivado block design, clock generation, driver access, and the path from register writes to audible playback on PCM5102A.",
  },
  {
    title: "How you proved it works",
    text:
      "Close with ILA captures, measurements, and the evidence chain that connects implementation details to thesis claims.",
  },
];

const interactionPrinciples = [
  {
    title: "Sticky companion visuals",
    text:
      "The illustration shouldn’t be a separate figure below the text. It should stay nearby while the prose changes what the reader is noticing.",
  },
  {
    title: "Tiny, meaningful controls",
    text:
      "A toggle, dial, or focus selector is enough when it changes the reader’s mental model. The interaction should clarify, not entertain.",
  },
  {
    title: "Annotated explanation",
    text:
      "Short callouts next to the visual keep the page feeling conversational, almost like a live whiteboard walkthrough.",
  },
];

const outlineItems = [
  { id: "hero", label: "Overview" },
  { id: "principles", label: "Interaction style" },
  { id: "repos", label: "Project layers" },
  { id: "grammar", label: "Interaction grammar" },
  { id: "architecture", label: "Architecture map" },
  { id: "signals", label: "Timing lab" },
  { id: "chapters", label: "Chapter pacing" },
  { id: "direction", label: "Recommended direction" },
];

export default function Home() {
  const [mode, setMode] = useState<keyof typeof signalModes>("fs48");
  const [focusRepo, setFocusRepo] = useState("ip_repo/");
  const [activeSection, setActiveSection] = useState(outlineItems[0].id);

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
    <main className="thesis-shell">
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
        </aside>

        <div className="page-content">
          <section className="hero-band" id="hero">
            <div className="hero-copy">
              <p className="eyebrow">Interactive thesis documentation</p>
              <h1>
                Building an explorable story for your
                <span> AXI I2S thesis</span>
              </h1>
              <p className="hero-lead">
                Inspired by the rhythm of Josh Comeau&apos;s SVG article, this version
                should treat the thesis as a guided technical experience: calm
                long-form prose, living side visuals, playful but disciplined
                controls, and just enough motion to make clocks, buses, and audio
                framing feel intuitive.
              </p>
            </div>

            <div className="hero-visual frame-panel">
              <div className="hero-grid">
                <div className="chip microblaze">MicroBlaze V</div>
                <div className="bus">AXI4-Lite</div>
                <div className="chip i2s">I2S TX IP</div>
                <div className="dac">PCM5102A</div>
              </div>
              <div className="hero-caption">
                <strong>Core arc:</strong> software intent becomes timed serial
                audio.
              </div>
            </div>
          </section>

          <section className="principles-band" id="principles">
            <div className="section-copy narrow">
              <p className="eyebrow">What the style really means</p>
              <h2>It&apos;s less about SVG as a format, more about explorable teaching</h2>
              <p>
                The recognizable Josh Comeau feeling comes from article design:
                generous whitespace, playful control surfaces, sticky visual aids,
                annotated diagrams, and an interaction model that helps the reader
                ask “what happens if this changes?” without getting lost.
              </p>
            </div>

            <div className="principle-grid">
              {interactionPrinciples.map((item) => (
                <article key={item.title} className="principle-card frame-panel">
                  <h3>{item.title}</h3>
                  <p>{item.text}</p>
                </article>
              ))}
            </div>
          </section>

          <section className="repo-overview" id="repos">
            <div className="section-copy">
              <p className="eyebrow">Source of truth</p>
              <h2>Three repositories, one thesis storyline</h2>
              <p>
                The cleanest structure is to present the project as three layers of
                the same system: IP design, SoC integration, and research writing.
                That gives the documentation a natural pacing and keeps each section
                anchored to real files.
              </p>
            </div>

            <div className="repo-selector frame-panel">
              <div className="toggle-row" role="tablist" aria-label="Repository focus">
                {repositories.map((repo) => (
                  <button
                    key={repo.name}
                    className={focusRepo === repo.name ? "toggle active" : "toggle"}
                    onClick={() => setFocusRepo(repo.name)}
                    type="button"
                  >
                    {repo.name}
                  </button>
                ))}
              </div>
              <p className="mode-lead">
                Focus mode changes the storytelling emphasis. Right now the article
                is centered on <strong>{focusRepo}</strong>, so the surrounding copy
                and visuals should privilege that layer of the system.
              </p>
            </div>

            <div className="repo-grid">
              {repositories.map((repo) => (
                <article
                  key={repo.name}
                  className={focusRepo === repo.name ? "repo-card frame-panel selected" : "repo-card frame-panel"}
                  style={{ ["--card-accent" as string]: repo.accent }}
                >
                  <p className="repo-name">{repo.name}</p>
                  <h3>{repo.label}</h3>
                  <p>{repo.description}</p>
                  <ul>
                    {repo.bullets.map((bullet) => (
                      <li key={bullet}>{bullet}</li>
                    ))}
                  </ul>
                </article>
              ))}
            </div>
          </section>

          <section className="article-lab" id="grammar">
            <div className="section-copy">
              <p className="eyebrow">Interaction grammar</p>
              <h2>Build the documentation like a technical playground, not a PDF mirror</h2>
              <p>
                The thesis content can still be rigorous, but the interface should
                feel browsable. Think sticky sidecars, controllable examples,
                highlighted system focus, and short explanation blocks that react to
                the reader’s choices.
              </p>
            </div>

            <div className="lab-editorial">
              <article className="essay-card">
                <p className="eyebrow">Narrative rail</p>
                <h3>Each section gets one main idea</h3>
                <p>
                  Instead of reproducing a whole chapter, give each screenful a
                  thesis of its own: why FIFO matters, what AXI actually buys you,
                  how word select divides channels, or why 96 kHz increases refill
                  pressure.
                </p>
                <p>
                  That keeps the interaction honest. The visual changes because the
                  idea changed, not because the page needed decoration.
                </p>
              </article>

              <aside className="playground-card frame-panel">
                <div className="playground-header">
                  <p className="eyebrow">Mini playground</p>
                  <h3>Reader-controlled focus</h3>
                </div>

                <div className="focus-stack">
                  <div className={focusRepo === "ip_repo/" ? "focus-pill active amber" : "focus-pill amber"}>
                    Register contract
                  </div>
                  <div className={focusRepo === "i2sproject/" ? "focus-pill active red" : "focus-pill red"}>
                    Block design wiring
                  </div>
                  <div className={focusRepo === "thesi2s/" ? "focus-pill active blue" : "focus-pill blue"}>
                    Thesis explanation
                  </div>
                </div>

                <div className="annotation-card">
                  <p className="annotation-label">What should change on screen?</p>
                  <p>
                    When the focus switches, the right panel, captions, and active
                    callouts should all retune. That&apos;s the interaction style to aim
                    for: same article, different lens.
                  </p>
                </div>
              </aside>
            </div>
          </section>

          <section className="scrollytelling-zone" id="architecture">
            <div className="section-copy narrow">
              <p className="eyebrow">Architecture map</p>
              <h2>Explain the thesis as a moving signal path</h2>
              <p>
                Instead of leading with blocks of text, the documentation should
                keep a sticky visual nearby while each section focuses on one
                boundary: processor intent, AXI register exchange, serializer
                timing, and DAC output.
              </p>
            </div>

            <div className="story-grid">
              <div className="story-steps">
                {systemStages.map((stage, index) => (
                  <article className="story-card" key={stage.id}>
                    <p className="story-index">0{index + 1}</p>
                    <p className="eyebrow">{stage.eyebrow}</p>
                    <h3>{stage.title}</h3>
                    <p>{stage.summary}</p>
                  </article>
                ))}
              </div>

              <aside className="sticky-visual frame-panel">
                <svg
                  viewBox="0 0 640 560"
                  role="img"
                  aria-label="System architecture diagram for the I2S thesis"
                  className="system-svg"
                >
                  <defs>
                    <linearGradient id="path-glow" x1="0%" y1="0%" x2="100%" y2="0%">
                      <stop offset="0%" stopColor="#f97316" />
                      <stop offset="50%" stopColor="#f43f5e" />
                      <stop offset="100%" stopColor="#2563eb" />
                    </linearGradient>
                  </defs>

                  <rect x="42" y="62" width="180" height="116" rx="28" className="svg-box soft" />
                  <text x="72" y="108" className="svg-label">MicroBlaze V</text>
                  <text x="72" y="138" className="svg-note">Vitis app writes control + samples</text>

                  <rect x="248" y="80" width="144" height="80" rx="40" className="svg-pill" />
                  <text x="289" y="126" className="svg-label small">AXI4-Lite</text>

                  <rect x="418" y="46" width="182" height="148" rx="30" className="svg-box hot" />
                  <text x="450" y="92" className="svg-label">I2S TX IP</text>
                  <text x="450" y="122" className="svg-note">registers + FIFO + serializer</text>
                  <text x="450" y="150" className="svg-note">MCLK / BCLK / WS / DATA</text>

                  <path d="M222 120 C244 120 242 120 248 120" className="svg-path" />
                  <path d="M392 120 C410 120 402 120 418 120" className="svg-path" />

                  <rect x="88" y="274" width="220" height="138" rx="28" className="svg-box calm" />
                  <text x="120" y="318" className="svg-label">Clocking + Control</text>
                  <text x="120" y="348" className="svg-note">sample mode selection</text>
                  <text x="120" y="376" className="svg-note">watermark / refill strategy</text>

                  <rect x="374" y="280" width="204" height="132" rx="28" className="svg-box frost" />
                  <text x="412" y="324" className="svg-label">PCM5102A</text>
                  <text x="412" y="354" className="svg-note">serial audio becomes analog output</text>

                  <path d="M505 194 C505 230 505 236 476 280" className="svg-path vertical" />
                  <path d="M308 344 C350 344 340 344 374 344" className="svg-path" />
                  <circle cx="505" cy="120" r="10" className="svg-node" />
                  <circle cx="505" cy="280" r="10" className="svg-node" />
                </svg>
                <div className="sticky-notes">
                  <div className="sticky-note">
                    <strong>Annotation A</strong>
                    The processor side is about intent and refill timing, not audio
                    waveform generation itself.
                  </div>
                  <div className="sticky-note">
                    <strong>Annotation B</strong>
                    The IP block is the dramatic center of the story, because this is
                    where software semantics become serial timing.
                  </div>
                </div>
              </aside>
            </div>
          </section>

          <section className="signal-lab" id="signals">
            <div className="section-copy">
              <p className="eyebrow">Explorable timing</p>
              <h2>Make the clocks feel tangible</h2>
              <p>
                One of the strongest upgrades over a static thesis PDF is giving the
                reader a mode switch that changes how the signal story feels. This
                doesn&apos;t need to be a full waveform simulator to be useful.
              </p>
            </div>

            <div className="lab-grid">
              <div className="mode-switch frame-panel">
                <div className="toggle-row" role="tablist" aria-label="Sampling modes">
                  {Object.entries(signalModes).map(([key, value]) => (
                    <button
                      key={key}
                      className={mode === key ? "toggle active" : "toggle"}
                      onClick={() => setMode(key as keyof typeof signalModes)}
                      type="button"
                    >
                      {value.label}
                    </button>
                  ))}
                </div>
                <p className="mode-lead">{signalModes[mode].lead}</p>
                <div className="signal-stack">
                  {signalModes[mode].lines.map((line) => (
                    <div key={line.name} className="signal-row">
                      <div>
                        <p className="signal-name">{line.name}</p>
                        <p className="signal-note">{line.note}</p>
                      </div>
                      <pre aria-hidden="true">{line.pattern}</pre>
                    </div>
                  ))}
                </div>
              </div>

              <div className="frame-panel insight-card">
                <p className="eyebrow">Why this matters</p>
                <h3>Interactive docs should reduce cognitive distance</h3>
                <p>
                  A reader shouldn&apos;t have to mentally translate paragraphs into
                  timing. If the documentation lets them toggle mode, inspect signal
                  roles, and connect that to FIFO refill pressure, your thesis becomes
                  easier to teach, defend, and demo.
                </p>
              </div>
            </div>
          </section>

          <section className="chapter-strip" id="chapters">
            <div className="section-copy narrow">
              <p className="eyebrow">Narrative pacing</p>
              <h2>Shape the article like an explorable chapter walk</h2>
            </div>

            <div className="chapter-grid">
              {chapters.map((chapter, index) => (
                <article key={chapter.title} className="chapter-card frame-panel">
                  <p className="story-index">0{index + 1}</p>
                  <h3>{chapter.title}</h3>
                  <p>{chapter.text}</p>
                </article>
              ))}
            </div>
          </section>

          <section className="closing-band frame-panel" id="direction">
            <p className="eyebrow">Recommended direction</p>
            <h2>Use `docpage/` as the interactive front door to the whole project</h2>
            <p>
              The first version should stay intentionally editorial: one long page,
              strong SVG-led explanations, and sections that point back to the real
              implementation in `ip_repo/`, `i2sproject/`, and `thesi2s/`. Once this
              shell feels right, we can add chapter routes, embedded figures, and
              extracted register details from your actual thesis files.
            </p>
          </section>
        </div>
      </div>
    </main>
  );
}
