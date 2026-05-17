"use client";

import { useMemo, useState, useEffect } from "react";

type Stage = "AXI" | "CDC" | "LATCH" | "SERIAL";

const stages: { id: Stage; label: string; description: string; domain: string }[] = [
  { id: "AXI", label: "AXI Register", description: "Sample is written by the CPU via AXI4-Lite bus.", domain: "S_AXI_ACLK (100MHz)" },
  { id: "CDC", label: "CDC Sync", description: "2-stage synchronizer transfers the sample to the audio clock.", domain: "internal_mclk (24MHz)" },
  { id: "LATCH", label: "Sample Latch", description: "Sample is captured at the start of a new I2S frame (bit_count=0).", domain: "internal_mclk (24MHz)" },
  { id: "SERIAL", label: "Serialization", description: "The MSB is shifted out to the DATA line bit-by-bit.", domain: "internal_mclk (24MHz)" },
];

export default function FullFlow() {
  const [activeStage, setActiveStage] = useState<number>(0);
  const [sampleValue] = useState<string>("0xD4A5C3F0");
  const [isPlaying, setIsPlaying] = useState<boolean>(true);

  useEffect(() => {
    if (!isPlaying) return;
    const timer = setInterval(() => {
      setActiveStage((prev) => (prev + 1) % stages.length);
    }, 2500);
    return () => clearInterval(timer);
  }, [isPlaying]);

  const currentStage = stages[activeStage];

  // Bit representation for serialization stage
  const bits = useMemo(() => {
    const val = parseInt(sampleValue, 16);
    return Array.from({ length: 32 }, (_, i) => (val >>> (31 - i)) & 1);
  }, [sampleValue]);

  return (
    <section className="section-card frame-card" id="full-flow">
      <div className="section-heading">
        <p className="eyebrow">The Complete Datapath</p>
        <h2>Life of a Sample</h2>
        <p>Follow a single 32-bit audio sample as it travels from the processor&apos;s AXI bus all the way to the serial I2S DATA pin.</p>
      </div>

      <div className="flex gap-4 mb-6">
        <button 
          className="action-btn" 
          onClick={() => setIsPlaying(!isPlaying)}
        >
          {isPlaying ? "Pause Animation" : "Resume Animation"}
        </button>
        <div className="status-pill">
            Current Domain: {currentStage.domain}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 relative">
        {stages.map((stage, index) => {
          const isActive = index === activeStage;
          const isPast = index < activeStage;
          
          return (
            <div key={stage.id} className="relative">
              <div 
                className={`p-6 rounded-2xl border transition-all duration-500 min-h-[180px] flex flex-col justify-between ${
                  isActive 
                    ? "bg-amber-50 border-amber-500 shadow-lg scale-105 z-10" 
                    : isPast
                    ? "bg-white border-green-200 opacity-80"
                    : "bg-white border-gray-100 opacity-60"
                }`}
              >
                <div>
                  <span className={`text-xs font-bold uppercase tracking-widest ${isActive ? "text-amber-600" : "text-gray-400"}`}>
                    Stage {index + 1}
                  </span>
                  <h3 className="text-xl font-bold mt-1">{stage.label}</h3>
                  <p className="text-sm text-gray-600 mt-2 leading-relaxed">{stage.description}</p>
                </div>
                
                <div className={`mt-4 font-mono text-sm p-2 rounded ${isActive ? "bg-amber-100 text-amber-900" : "bg-gray-50 text-gray-400"}`}>
                  {index === 0 && <code>slv_reg0 &lt;= WDATA</code>}
                  {index === 1 && <code>cdc_sync(slv_reg0)</code>}
                  {index === 2 && <code>sample_left_q &lt;= cdc_out</code>}
                  {index === 3 && <code>data_q &lt;= sample[bit]</code>}
                </div>
              </div>
              
              {index < stages.length - 1 && (
                <div className="hidden md:block absolute top-1/2 -right-4 transform -translate-y-1/2 z-20">
                  <span className={`text-2xl ${isActive ? "text-amber-500 animate-pulse" : "text-gray-300"}`}>→</span>
                </div>
              )}
            </div>
          );
        })}
      </div>

      <div className="mt-8 p-8 rounded-3xl bg-gray-900 text-white overflow-hidden relative">
        <div className="absolute top-0 left-0 w-full h-1 bg-gray-800">
            <div 
                className="h-full bg-amber-500 transition-all duration-[2500ms] ease-linear"
                style={{ width: `${((activeStage + 1) / stages.length) * 100}%` }}
            ></div>
        </div>

        <div className="flex flex-col items-center justify-center py-8">
            {activeStage === 0 && (
                <div className="animate-bounce flex flex-col items-center">
                    <div className="bg-amber-500 text-black px-6 py-3 rounded-lg font-bold text-lg shadow-xl">
                        {sampleValue}
                    </div>
                    <span className="text-amber-500 mt-2">Writing to AXI...</span>
                </div>
            )}

            {activeStage === 1 && (
                <div className="flex gap-8 items-center">
                    <div className="bg-gray-700 px-4 py-2 rounded border border-gray-600 opacity-50">AXI Domain</div>
                    <div className="flex gap-2">
                        <div className="w-8 h-12 bg-amber-500 rounded animate-pulse"></div>
                        <div className="w-8 h-12 bg-amber-700 rounded"></div>
                    </div>
                    <div className="bg-gray-700 px-4 py-2 rounded border border-gray-600">Audio Domain</div>
                </div>
            )}

            {activeStage === 2 && (
                <div className="flex flex-col items-center">
                    <div className="text-gray-400 mb-4 font-mono">Waiting for bit_count == 0...</div>
                    <div className="flex items-center gap-4">
                        <div className="text-2xl font-bold">bit_count: <span className="text-amber-500">0</span></div>
                        <div className="w-12 h-12 rounded-full border-4 border-amber-500 border-t-transparent animate-spin"></div>
                    </div>
                    <div className="mt-6 bg-green-600 px-6 py-3 rounded-lg font-bold shadow-xl">
                        SAMPLE LATCHED
                    </div>
                </div>
            )}

            {activeStage === 3 && (
                <div className="w-full">
                    <div className="flex justify-between items-center mb-6">
                        <span className="text-amber-500 font-bold uppercase tracking-widest text-sm">Serializing MSB First</span>
                        <div className="text-xl font-mono">DATA: <span className="text-amber-500">{bits[0]}</span></div>
                    </div>
                    <div className="flex gap-1 overflow-x-auto pb-4 no-scrollbar">
                        {bits.map((bit, i) => (
                            <div 
                                key={i} 
                                className={`flex-shrink-0 w-8 h-12 flex items-center justify-center rounded transition-all duration-300 ${
                                    i === 0 ? "bg-amber-500 text-black font-bold scale-110" : "bg-gray-800 text-gray-500"
                                }`}
                            >
                                {bit}
                            </div>
                        ))}
                    </div>
                    <div className="mt-4 text-center text-gray-400 text-sm">
                        One bit is shifted out every BCLK cycle (bit_idx = {32-1-0})
                    </div>
                </div>
            )}
        </div>
      </div>
      
      <div className="formula-steps mt-6">
        <div className="formula-step">
          <strong>The &quot;Wait&quot; at Latch</strong>
          <p>Even though AXI writes are instant, the sample doesn&apos;t enter the serializer until the next I2S frame starts. This prevents mid-word corruption.</p>
        </div>
        <div className="formula-step">
          <strong>MSB-Justified</strong>
          <p>The code uses <code>bit_idx = width - pos</code>. For a 24-bit sample in a 32-bit slot, it shifts out bit 23, then 22, and so on.</p>
        </div>
      </div>
    </section>
  );
}
