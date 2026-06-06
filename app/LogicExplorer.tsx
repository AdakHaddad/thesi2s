"use client";

import { useState } from "react";

type Snippet = {
  id: string;
  title: string;
  code: string;
  explanation: string;
  visualEffect: string;
};

const snippets: Snippet[] = [
  {
    id: "dds-calc",
    title: "DDS Increment Calculation",
    code: `// Section 13: Frequency words (increments per AXI clock cycle)
wire [31:0] bclk_toggle_rate_hz = {sample_rate_sync, 7'b0};   // Fs × 128
wire [31:0] mclk_toggle_rate_hz = {sample_rate_sync, 9'b0};   // Fs × 512`,
    explanation: "This code calculates how much to 'fill' the clock bucket every cycle. By shifting the sample rate (e.g., 48,000 Hz), we get a large number that represents the target frequency multiplied by a power of 2. Shifting left by 7 is equivalent to multiplying by 128.",
    visualEffect: "Shows the frequency slider value being shifted left (multiplied) to create the 'Step' value seen in the overall animation.",
  },
  {
    id: "dds-acc",
    title: "Phase Accumulator (The Bucket)",
    code: `// Section 13: Next-cycle accumulator values
wire [31:0] bclk_phase_sum = bclk_phase_acc_q + bclk_toggle_rate_hz;
wire bclk_phase_wrap = (bclk_phase_sum >= AXI_CLK_HZ);`,
    explanation: "This is the core of the clock generation. Every cycle, we add the step to the accumulator. When the sum exceeds the system clock (100MHz), 'bclk_phase_wrap' becomes 1, signaling that it's time to flip the BCLK pin.",
    visualEffect: "Highlights the 'Clock Bucket' filling up and resetting (overflowing) precisely when the wrap signal is high.",
  },
  {
    id: "serializer",
    title: "I2S Next-Bit Serializer",
    code: `// Section 16: Serializer Function
if (pos == 5'd0) begin
    // Slot 0 is the WS-transition gap bit — always 0
    i2s_next_serial_bit = 1'b0;
end else if (pos <= width) begin
    // Active payload bit — MSB first.
    i2s_next_serial_bit = in_left ? left_samp[width - pos] 
                                  : right_samp[width - (pos)];
end`,
    explanation: "This function decides which bit to send next. It looks at the current position in the frame. If it's the very first bit of a channel, it sends 0 (the I2S delay). Otherwise, it picks the correct bit from the 32-bit sample word based on the current bit count.",
    visualEffect: "Connects the 'bit_count' value to the specific line of code that selects either the 'Delay bit', 'Left Bit', or 'Right Bit'.",
  },
  {
    id: "latch",
    title: "Frame Boundary Latch",
    code: `// Section 14: Latched PCM samples
if (bclk_phase_wrap && !bclk_q && bit_count_q == 6'd0) begin
    sample_left_q  <= slv_reg0;
    sample_right_q <= slv_reg1;
    current_latch_status_q <= !current_latch_status_q;
end`,
    explanation: "To prevent audio glitches, we don't read the AXI registers mid-frame. Instead, we wait for the exact start of a new frame (bit_count == 0) and 'latch' both stereo samples into internal registers at once. The status bit also flips to tell the software 'I just took the data!'.",
    visualEffect: "Shows the 'Bit Factory' containers being refilled from the AXI registers only when the frame counter hits zero.",
  },
  {
    id: "divider-evolution",
    title: "Evolution: Integer vs DDS Divider",
    code: `// OLD DESIGN (Integer Divider):
// bclk_en_w = (clock_div_q == 2'd3); // Fixed divide by 4

// NEW DESIGN (DDS Divider):
wire bclk_phase_wrap = (bclk_phase_sum >= AXI_CLK_HZ);
// It wraps whenever we accumulate enough 'step' value!`,
    explanation: "In the first design, we used a simple counter that counted to 4 (Fixed Divider). It was like a clock that only ticked every 4 system cycles. In the new design, we use DDS. It's like a bucket that can be filled with any amount of 'water' (step value). This allows us to hit any frequency, not just 1/4 or 1/2 of the system clock.",
    visualEffect: "Explains why the new design is 'Arbitrary' (up to 20-bit FS) compared to the old one that only had 4 fixed choices.",
  }
];

export default function LogicExplorer() {
  const [selectedId, setSelectedId] = useState(snippets[0].id);
  const activeSnippet = snippets.find(s => s.id === selectedId)!;

  return (
    <div className="section-card frame-card" id="logic-explorer">
      <div className="section-heading">
        <p className="eyebrow">Verilog Logic Deep Dive</p>
        <h2>Code Logic Explorer</h2>
        <p>
          Understand how the Verilog code translates into hardware behavior. 
          Select a code block below to see its specific role in the I2S IP core.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Navigation */}
        <div className="lg:col-span-4 flex flex-col gap-2">
          {snippets.map(s => (
            <button
              key={s.id}
              onClick={() => setSelectedId(s.id)}
              className={`text-left p-4 rounded-lg border transition-all ${
                selectedId === s.id 
                ? "bg-[#4fc3f7]/10 border-[#4fc3f7] text-[#4fc3f7]" 
                : "bg-white/5 border-white/10 hover:bg-white/10 text-gray-400"
              }`}
            >
              <div className="font-bold">{s.title}</div>
              <div className="text-xs opacity-70 mt-1">Section {snippets.indexOf(s) + 13} of RTL</div>
            </button>
          ))}
          
          <div className="mt-4 p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-lg">
            <p className="text-xs text-yellow-200/70 italic">
              "Logic in Verilog is like a factory blueprint. Every line defines a wire or a flip-flop that works in parallel."
            </p>
          </div>
        </div>

        {/* Code & Visualization */}
        <div className="lg:col-span-8 flex flex-col gap-6">
          <div className="bg-[#1e1e1e] rounded-xl overflow-hidden border border-white/10 shadow-2xl">
            <div className="bg-black/40 px-4 py-2 flex items-center justify-between border-b border-white/10">
              <span className="text-xs font-mono text-gray-500">i2s_dds_slave_lite.v</span>
              <div className="flex gap-1.5">
                <div className="w-2.5 h-2.5 rounded-full bg-red-500/20" />
                <div className="w-2.5 h-2.5 rounded-full bg-yellow-500/20" />
                <div className="w-2.5 h-2.5 rounded-full bg-green-500/20" />
              </div>
            </div>
            <pre className="p-6 font-mono text-sm overflow-x-auto">
              <code className="text-[#9cdcfe]">
                {activeSnippet.code.split('\n').map((line, i) => (
                  <div key={i} className="hover:bg-white/5 px-2 -mx-2 rounded">
                    <span className="text-gray-600 mr-4 select-none inline-block w-4">{i + 1}</span>
                    <span className={line.startsWith('//') ? "text-green-600" : ""}>{line}</span>
                  </div>
                ))}
              </code>
            </pre>
          </div>

          <div className="bg-[#4fc3f7]/5 border border-[#4fc3f7]/20 rounded-xl p-6">
            <h4 className="text-[#4fc3f7] font-bold mb-2 flex items-center gap-2">
              <span>🔍</span> What this does in the hardware
            </h4>
            <p className="text-gray-300 leading-relaxed mb-4">
              {activeSnippet.explanation}
            </p>
            
            {/* Dynamic Visualization Area */}
            <div className="mt-6 mb-6 p-4 bg-black/40 rounded-lg border border-white/10 min-h-[120px] flex flex-col items-center justify-center">
              {selectedId === "dds-calc" && (
                <div className="flex flex-col items-center gap-4 w-full">
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-gray-500">Fs (Hz)</span>
                    <div className="bg-[#4fc3f7]/20 px-3 py-1 rounded font-mono text-[#4fc3f7]">48,000</div>
                    <span className="text-xl">➡️</span>
                    <span className="text-xs text-gray-500">Shift Left 7</span>
                    <div className="bg-[#4fc3f7]/40 px-3 py-1 rounded font-mono text-[#4fc3f7] animate-pulse">6,144,000</div>
                  </div>
                  <div className="flex gap-1">
                    {Array.from({length: 20}).map((_, i) => (
                      <div key={i} className={`w-3 h-6 rounded-sm ${i < 13 ? "bg-[#4fc3f7]" : "bg-white/10"}`} />
                    ))}
                    <div className="flex gap-1 ml-2 animate-bounce">
                      {[1,2,3,4,5,6,7].map(i => <div key={i} className="w-3 h-6 bg-yellow-500/40 rounded-sm border border-yellow-500/60" />)}
                    </div>
                  </div>
                  <p className="text-[10px] text-gray-500 uppercase tracking-widest">Multiplication by shifting wires</p>
                </div>
              )}

              {selectedId === "dds-acc" && (
                <div className="flex items-center gap-8">
                  <div className="relative w-16 h-16">
                    <div className="absolute inset-0 border-2 border-dashed border-[#4fc3f7]/30 rounded-full animate-spin-slow" />
                    <div className="absolute inset-2 border-4 border-[#4fc3f7] rounded-full border-t-transparent animate-spin" />
                    <div className="absolute inset-0 flex items-center justify-center text-[10px] font-bold">WRAP!</div>
                  </div>
                  <div className="flex flex-col gap-1">
                    <div className="h-2 w-48 bg-white/10 rounded-full overflow-hidden">
                      <div className="h-full bg-[#4fc3f7] animate-progress" style={{width: '100%'}} />
                    </div>
                    <div className="flex justify-between text-[10px] text-gray-500 font-mono">
                      <span>0</span>
                      <span>100,000,000</span>
                    </div>
                  </div>
                </div>
              )}

              {selectedId === "serializer" && (
                <div className="flex items-center gap-4">
                  <div className="flex flex-col gap-1">
                    {[1,0,1,1].map((b, i) => (
                      <div key={i} className="w-8 h-4 bg-white/5 border border-white/10 rounded flex items-center justify-center text-[8px]">{b}</div>
                    ))}
                  </div>
                  <div className="text-2xl text-gray-600">➡️</div>
                  <div className="w-16 h-16 border-2 border-[#e57373] rounded-full flex items-center justify-center relative overflow-hidden">
                    <div className="absolute inset-0 bg-[#e57373]/20 animate-pulse" />
                    <span className="text-xl font-bold text-[#e57373] animate-bounce">1</span>
                  </div>
                  <div className="text-2xl text-gray-600">➡️</div>
                  <div className="text-xs font-mono text-[#e57373]">i2s_data_o</div>
                </div>
              )}

              {selectedId === "latch" && (
                <div className="flex flex-col items-center gap-2">
                  <div className="flex gap-4">
                    <div className="text-center">
                      <p className="text-[8px] text-gray-500 mb-1">AXI Register</p>
                      <div className="w-20 h-10 bg-white/5 border border-white/20 rounded flex items-center justify-center text-xs">0xABCD</div>
                    </div>
                    <div className="flex items-center text-[#81c784] animate-ping-slow">
                      <span className="text-xl">📸</span>
                    </div>
                    <div className="text-center">
                      <p className="text-[8px] text-[#81c784] mb-1">Internal Latch</p>
                      <div className="w-20 h-10 bg-[#81c784]/20 border border-[#81c784] rounded flex items-center justify-center text-xs font-bold">0xABCD</div>
                    </div>
                  </div>
                  <p className="text-[10px] text-gray-500 italic">"Freezing data at Frame Start"</p>
                </div>
              )}

              {selectedId === "divider-evolution" && (
                <div className="flex items-center gap-12">
                  <div className="text-center">
                    <p className="text-[10px] text-red-400 mb-2">Old: 1/4 Gear</p>
                    <div className="w-12 h-12 border-4 border-red-500/30 rounded-full flex items-center justify-center relative">
                      <div className="w-1 h-6 bg-red-500 absolute top-0 origin-bottom" style={{transform: 'rotate(90deg)'}} />
                      <div className="w-1 h-6 bg-red-500 absolute top-0 origin-bottom" style={{transform: 'rotate(180deg)'}} />
                      <div className="w-1 h-6 bg-red-500 absolute top-0 origin-bottom" style={{transform: 'rotate(270deg)'}} />
                      <div className="w-1 h-6 bg-red-500 absolute top-0 origin-bottom" style={{transform: 'rotate(0deg)'}} />
                    </div>
                  </div>
                  <div className="text-center">
                    <p className="text-[10px] text-[#4fc3f7] mb-2">New: Infinite Flow</p>
                    <div className="w-12 h-12 border-4 border-[#4fc3f7] rounded-full flex items-center justify-center overflow-hidden">
                      <div className="w-full bg-[#4fc3f7]/40 animate-wave-slow h-full mt-4" />
                    </div>
                  </div>
                </div>
              )}
            </div>

            <div className="flex items-start gap-3 p-3 bg-black/30 rounded-lg border border-white/5">
              <span className="text-xl">✨</span>
              <div>
                <p className="text-sm font-bold text-white">Visual Effect</p>
                <p className="text-sm text-gray-400">{activeSnippet.visualEffect}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
