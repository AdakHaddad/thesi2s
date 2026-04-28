# I2S IP: beginner guide — what it does, how to use it, and how many registers you need

This guide is for someone new to **memory-mapped peripherals** on FPGA. It matches the **current** RTL in `hdl/i2s_slave_lite_v1_0_S00_AXI.v` and the Vitis example `workspace/hello_world/src/helloworld.c`.

---

## 1) The big picture (three pieces)

| Piece | Role |
|--------|------|
| **Your PC + Vitis** | You write **C code**. It runs on **MicroBlaze** inside the FPGA. |
| **I2S IP (AXI slave)** | Small hardware block with **registers** at fixed addresses. The CPU reads/writes them like variables in memory. |
| **PCM5102A DAC** | Chip that turns **digital I2S** (wires) into **analog sound**. It follows the **clocks** the FPGA sends (BCLK, WS/LRCK, DATA). |

**Important:** The UART speed (e.g. 115200) is only for **text printouts**. It is **not** the “audio baud rate.” Audio timing comes from the **I2S clocks** generated in FPGA hardware.

---

## 2) What this IP does **today** (in one sentence)

It takes a **32-bit stereo sample** from software (`Left` in high 16 bits, `Right` in low 16 bits), stores it in a register, and repeatedly sends it out on real **I2S wires** at the **sample rate fixed by hardware** (from `audio_clk` and the divider inside the Verilog).

So the IP is mainly a **“sample holding + I2S transmitter”** controlled over **AXI4-Lite**.

---

## 3) What is a “register” here?

A **register** is a 32-bit flip-flop inside the FPGA that:

- you **write** with `Xil_Out32(ADDRESS, value)`  
- you **read** with `value = Xil_In32(ADDRESS)`

The **address** is:

```text
BASE = XPAR_I2S_0_BASEADDR   // from xparameters.h after you export hardware to Vitis
```

Each register has an **offset** added to `BASE` (0, 4, 8, 12 bytes…).

---

## 4) Register table **today** (current IP — still **4** AXI words)

| Offset | Name (in docs) | What it does **today** |
|--------|------------------|-------------------------|
| `BASE + 0x00` | **SAMPLE / REG0** | **Stereo PCM input.** Packed: `[31:16] = Left`, `[15:0] = Right` (16-bit per channel). Latched into `sample_q` each stereo frame, then serialized to the DAC. |
| `BASE + 0x04` | **CTRL / REG1** | **Packed control** (`slv_reg1[7:0]` is double-flopped into `audio_clk`). **`[0]` PLAY**: `1` = output samples, `0` = digital silence on `i2s_data` (BCLK/WS keep running). **`[1]` MUTE**: `1` = force data bits to zero. **`[2]` FS_SLOW**: `1` = slower BCLK gating → about **half** the previous output sample rate (useful for a second “speed” without widening the address map). **`[31:8]`**: stored but ignored by I2S logic. **Power-up default** = `1` (`PLAY` only) so old software that never writes `0x04` still hears audio. |
| `BASE + 0x08` | **REG2** | **Scratch** — not used by I2S. |
| `BASE + 0x0C` | **REG3** | **Scratch** — not used by I2S. |

Hardware is still the **same 4-register AXI footprint**; **data** and **control** are split: `0x00` + packed `0x04`.

---

## 5) Beginner: how to **use** it from Vitis (minimal steps)

1. **Build FPGA design** in Vivado with the I2S IP connected to MicroBlaze AXI and `audio_clk`.
2. **Export hardware (XSA)** and **update / create platform** in Vitis.
3. In your C project, `#include "xparameters.h"`.
4. Use **`XPAR_I2S_0_BASEADDR`** as the base (name may vary if the block is renamed in Vivado).
5. **Self-test:** write a pattern to `0x00`, read it back — if it matches, AXI path is OK.
6. **Play audio:** in a loop, write many different packed samples to `0x00` at the rate that matches your **hardware** sample rate (see note below).

**Example pack (same idea as `helloworld.c`):**

```c
uint32_t pack_stereo(int16_t L, int16_t R) {
    return ((uint32_t)(uint16_t)L << 16) | (uint32_t)(uint16_t)R;
}
Xil_Out32(XPAR_I2S_0_BASEADDR + 0x00, pack_stereo(left, right));
```

**Note on “rate”:** Changing how **often** you call `Xil_Out32` changes how **fast you supply new samples**. The **DAC still runs at the hardware \(F_s\)** decided by BCLK/WS. If you write too slowly, the same sample is held longer → can sound like a **stuck** or **wrong** pitch. For smooth sine, your loop should target roughly one new frame per \(1/F_s\) seconds (plus margin), or you add a **FIFO** (planned v2) so small CPU jitter does not cause glitches.

---

## 6) “Do we only need a **second** register? (bit-packed so the IP is extraordinary)”

### Short answer

**No — not if you want a clear, maintainable, “extraordinary” peripheral.**

- **One register** (packed L/R) is a fine **minimum** for “prove I2S works.”
- A **second** register can hold a **CONTROL** bitfield (enable, mute, mode). **This repo now does that** at `BASE+0x04` (packed bits, no extra address width).
- But **volume, FIFO depth, IRQ flags, status, chip ID** etc. either need **more bits than fit comfortably** in one word **or** deserve their **own registers** so software stays simple and you avoid “magic packing” bugs.

### Why not cram everything into 1–2 mega-registers?

| Problem | Explanation |
|---------|--------------|
| **Hard to use** | Beginners must decode 32 masks; one wrong shift breaks audio *and* mode at once. |
| **Atomic updates** | Changing “volume + mode + data” in one word can glitch if hardware reads mid-update. |
| **Industry practice** | Real IPs use a **small register map**: `ID`, `CONTROL`, `STATUS`, `DATA`/`FIFO`, `IRQ`. |

### What *does* make an IP “extraordinary” (in a good way)

Not “fewest registers,” but:

- **Clear map** (each register has one job)
- **FIFO + watermark IRQ** (stable audio under real CPU load)
- **Documented** actual \(F_s\) from MMCM
- **Optional** `FS_MODE` for two sample rates
- **Optional** hardware volume or documented software gain

That is the direction of **`I2S_V2_IMPLEMENTATION_SPEC.md`** in the repo.

### If you still want “only two registers” as a student milestone

A **defensible minimal v1.5** could be:

| Register | Purpose |
|----------|---------|
| `0x00` | Packed **L:R sample** (same as now) |
| `0x04` | **CONTROL** bitfield only (e.g. enable, mute, `FS_MODE`) — **no audio samples here** |

You would **still** implement \(F_s\) switching in **RTL** (divider), not by “baud” in software. Volume could stay **software multiply** before writing `0x00` until you add a `VOLUME` register.

That is **two registers**, but not “two bit-packed everything registers” — it is **data + control**, which is the right split.

---

## 7) Where to read next

| Document | Content |
|----------|---------|
| `workspace/hello_world/I2S_VITIS_SOFTWARE_GUIDE.md` | Vitis ↔ addresses, flow diagram |
| `I2S_SLAVE_LITE_MASTER_GUIDE.md` (this folder) | RTL signal flow, clock math |
| `I2S_V2_IMPLEMENTATION_SPEC.md` (repo `sbml`) | Full multi-register + FIFO + IRQ plan |

---

## 8) One-line summary

**Today:** one register carries **stereo audio data**; everything else (real \(F_s\), BCLK) is **hardware**. **Tomorrow (v2):** add **separate** registers for **control / status / IRQ / FIFO**, and keep **data** in its own path — that is how you make the IP powerful **and** easy for beginners to use.
