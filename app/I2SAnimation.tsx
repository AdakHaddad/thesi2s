"use client";

import { useEffect, useRef, useState } from "react";

export default function I2SAnimation() {
  const [fs, setFs] = useState(48000);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const requestRef = useRef<number>(null);

  // Simulation state
  const state = useRef({
    acc: 0,
    threshold: 100_000_000,
    bclk_state: 0,
    ws_state: 0,
    bit_count: 0,
    data_bits: [1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    history: [] as { bclk: number; ws: number; data: number }[],
    x: 0,
  });

  useEffect(() => {
    const animate = () => {
      const s = state.current;
      const bclk_toggle_rate = fs * 128; // 64 BCLKs * 2 for toggle

      // Update DDS
      s.acc += bclk_toggle_rate;
      if (s.acc >= s.threshold) {
        s.acc -= s.threshold;
        s.bclk_state = 1 - s.bclk_state;

        if (s.bclk_state === 0) { // Falling edge
          s.bit_count = (s.bit_count + 1) % 64;
          if (s.bit_count === 0) s.ws_state = 0;
          if (s.bit_count === 32) s.ws_state = 1;
        }

        // Add to history
        const data_bit = s.bit_count < s.data_bits.length ? s.data_bits[s.bit_count] : 0;
        s.history.push({ bclk: s.bclk_state, ws: s.ws_state, data: data_bit });
        if (s.history.length > 200) s.history.shift();
      }

      // Draw
      const canvas = canvasRef.current;
      if (canvas) {
        const ctx = canvas.getContext("2d");
        if (ctx) {
          ctx.clearRect(0, 0, canvas.width, canvas.height);

          // 1. Draw Accumulator (Clock Filling Up)
          const accWidth = (s.acc / s.threshold) * 400;
          ctx.fillStyle = "#222";
          ctx.beginPath();
          ctx.roundRect(50, 30, 400, 24, 12);
          ctx.fill();
          
          ctx.fillStyle = "#4fc3f7";
          ctx.beginPath();
          ctx.roundRect(50, 30, accWidth, 24, 12);
          ctx.fill();
          
          ctx.fillStyle = "#fff";
          ctx.font = "bold 14px sans-serif";
          ctx.fillText("🕒 Clock Bucket (Filling up to 100MHz)", 50, 20);
          ctx.font = "12px monospace";
          ctx.fillText(`${(s.acc / 1000000).toFixed(1)}M / 100M`, 460, 47);

          // 2. Draw Waveforms (The Signal Tracks)
          const drawWave = (y: number, key: "bclk" | "ws" | "data", label: string, color: string, icon: string) => {
            ctx.strokeStyle = color;
            ctx.setLineDash([]);
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(50, y);
            const step = 3;
            s.history.forEach((h, i) => {
              const val = h[key];
              const px = 50 + i * step;
              const py = y - (val ? 25 : 0);
              ctx.lineTo(px, py);
            });
            ctx.stroke();
            ctx.fillStyle = color;
            ctx.font = "bold 13px sans-serif";
            ctx.fillText(`${icon} ${label}`, 10, y - 5);
          };

          drawWave(120, "bclk", "BCLK (Heartbeat)", "#4fc3f7", "💓");
          drawWave(180, "ws", "WS (Left / Right)", "#81c784", "↔️");
          drawWave(240, "data", "DATA (Music Bits)", "#e57373", "🎵");

          // 3. Draw Data Moving (The Bit Factory)
          ctx.fillStyle = "#fff";
          ctx.font = "bold 14px sans-serif";
          ctx.fillText("🏭 The Bit Factory (Parallel Data)", 500, 100);
          
          // Show bits in parallel word as "containers"
          const wordBits = s.data_bits;
          wordBits.forEach((bit, i) => {
            const bx = 505 + i * 12;
            const by = 110;
            ctx.fillStyle = bit ? "#e57373" : "#333";
            ctx.beginPath();
            ctx.roundRect(bx, by, 8, 20, 2);
            ctx.fill();
            if (bit) {
              ctx.fillStyle = "#fff";
              ctx.font = "8px sans-serif";
              ctx.fillText("1", bx + 2, by + 13);
            }
          });

          // Show current bit being "pushed out"
          const currentIdx = s.bit_count % 32;
          if (currentIdx < wordBits.length) {
            ctx.strokeStyle = "#fff";
            ctx.setLineDash([2, 2]);
            ctx.lineWidth = 1;
            ctx.strokeRect(505 + currentIdx * 12 - 2, 110 - 2, 12, 24);
            
            // Draw a flying bit
            if (s.bclk_state === 1) {
                const progress = s.acc / s.threshold;
                const flyX = 505 + currentIdx * 12 - (progress * 400);
                const flyY = 110 + (progress * 130);
                
                ctx.fillStyle = wordBits[currentIdx] ? "#e57373" : "#555";
                ctx.beginPath();
                ctx.arc(flyX, flyY, 5, 0, Math.PI * 2);
                ctx.fill();
            }
          }

          // Labels for speakers
          ctx.fillStyle = s.ws_state === 0 ? "#81c784" : "#444";
          ctx.font = "bold 16px sans-serif";
          ctx.fillText("🔈 Left", 500, 180);
          ctx.fillStyle = s.ws_state === 1 ? "#81c784" : "#444";
          ctx.fillText("🔊 Right", 600, 180);
          
          ctx.fillStyle = "#aaa";
          ctx.font = "12px sans-serif";
          ctx.fillText(`Sending bit #${s.bit_count} of 64`, 500, 210);
        }
      }

      requestRef.current = requestAnimationFrame(animate);
    };

    requestRef.current = requestAnimationFrame(animate);
    return () => {
      if (requestRef.current) cancelAnimationFrame(requestRef.current);
    };
  }, [fs]);

  return (
    <div className="section-card frame-card" id="i2s-overall-animation">
      <div className="section-heading">
        <p className="eyebrow">Real-time Visualization</p>
        <h2>Overall I2S Flow & FS Divide</h2>
        <p>
          This live animation shows the internal DDS logic. The accumulator adds the frequency step every system clock.
          When it overflows, BCLK toggles. DATA bits are shifted out MSB-first based on the bit counter.
        </p>
      </div>

      <div className="bg-black/20 p-6 rounded-lg">
        <canvas 
          ref={canvasRef} 
          width={800} 
          height={250} 
          className="w-full h-auto bg-black/40 rounded border border-white/10"
        />
      </div>

      <div className="mt-6 flex items-center gap-6 p-4 bg-white/5 rounded-lg">
        <div className="flex-1">
          <label className="slider-label mb-2 block">
            <span>Target Sampling Frequency (Fs)</span>
            <strong>{fs.toLocaleString()} Hz</strong>
          </label>
          <input
            type="range"
            min={8000}
            max={192000}
            step={100}
            value={fs}
            onChange={(e) => setFs(Number(e.target.value))}
            className="range-input"
          />
        </div>
        <div className="text-right">
          <p className="text-sm text-gray-400">Step Value</p>
          <p className="text-xl font-mono text-[#4fc3f7]">{(fs * 128).toLocaleString()}</p>
        </div>
      </div>
    </div>
  );
}
