"use client";

export default function DividerComparison() {
  return (
    <div className="section-card frame-card" id="divider-comparison">
      <div className="section-heading">
        <p className="eyebrow">Architecture Evolution</p>
        <h2>Cycle Divider: Old vs. New Design</h2>
        <p>
          Compare how the clock was generated in the first version versus the latest DDS-optimized version.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {/* Old Design */}
        <div className="p-6 bg-red-600/5 border border-red-600/20 rounded-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 p-2 bg-red-600/20 text-red-800 text-[10px] font-bold uppercase tracking-widest">
            Legacy Design
          </div>
          <h3 className="text-xl font-bold text-red-700 mb-4 flex items-center gap-2">
            <span>⏱️</span> Fixed Integer Divider
          </h3>
          
          <div className="space-y-4">
            <div className="bg-black/40 p-4 rounded-lg font-mono text-sm border border-white/5">
              <p className="text-gray-400 mb-2">// Counts 0, 1, 2, 3... 0</p>
              <p className="text-red-400">bclk_en = (div_count == 4'd3);</p>
            </div>
            
            <div className="text-sm text-gray-800 leading-relaxed">
              <p className="mb-2"><strong>How it worked:</strong></p>
              <ul className="list-disc list-inside space-y-1 text-gray-700">
                <li>Used a simple counter (0, 1, 2, 3).</li>
                <li>Fired exactly every 4 system cycles.</li>
                <li>Result: <strong>Fixed frequencies</strong> (44.1k or 48k).</li>
                <li>Limited: Hard to get non-standard frequencies.</li>
              </ul>
            </div>
            
            <div className="mt-4 flex gap-1 h-8">
              {[0,1,2,3,0,1,2,3].map((v, i) => (
                <div key={i} className={`flex-1 flex items-center justify-center rounded text-[10px] ${v === 3 ? "bg-red-500 text-white" : "bg-white/5 text-gray-600"}`}>
                  {v === 3 ? "🔥" : v}
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* New Design */}
        <div className="p-6 bg-blue-600/5 border border-blue-600/20 rounded-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 p-2 bg-blue-600/20 text-blue-800 text-[10px] font-bold uppercase tracking-widest">
            Latest Design
          </div>
          <h3 className="text-xl font-bold text-blue-700 mb-4 flex items-center gap-2">
            <span>🌊</span> DDS Phase Accumulator
          </h3>
          
          <div className="space-y-4">
            <div className="bg-black/40 p-4 rounded-lg font-mono text-sm border border-white/5">
              <p className="text-gray-400 mb-2">// Accumulates water (step)</p>
              <p className="text-blue-400">bclk_en = (acc {">"}= 100MHz);</p>
            </div>
            
            <div className="text-sm text-gray-800 leading-relaxed">
              <p className="mb-2"><strong>How it works now:</strong></p>
              <ul className="list-disc list-inside space-y-1 text-gray-700">
                <li>Uses a 32-bit "Bucket" (Accumulator).</li>
                <li>Adds any "Step" value every cycle.</li>
                <li>Result: <strong>Arbitrary frequencies</strong> (1Hz to 1MHz).</li>
                <li>Flexible: Change Fs in real-time via software.</li>
              </ul>
            </div>

            <div className="mt-4 bg-white/5 h-8 rounded-full overflow-hidden flex">
              <div className="h-full bg-[#4fc3f7] transition-all duration-500" style={{ width: '75%' }} />
              <div className="h-full w-2 bg-white animate-pulse" />
            </div>
          </div>
        </div>
      </div>

      <div className="mt-8 p-4 bg-white/5 rounded-lg border border-white/10 text-center">
        <p className="text-sm text-gray-400">
          <strong>The Big Difference:</strong> The old design was like a gear that only fits specific teeth. 
          The new DDS design is like a liquid flow that can fill the bucket at any speed, giving us 
          <span className="text-[#4fc3f7] font-bold ml-1">Infinite Flexibility</span>.
        </p>
      </div>
    </div>
  );
}
