# Implementation Plan — I2S-Only Peripheral (AXI4-Lite, FPGA Basys3)

> **Scope**: This document is a complete, copyable end-to-end implementation plan for the I2S TX peripheral project targeting the Basys3 (Artix-7) FPGA board with a PCM5102A audio DAC, using Vivado IP Integrator + Vitis bare-metal software. It also describes where every section, figure, and table maps to the DTETI UGM LaTeX thesis template (`thesisdtetiugm.cls`).

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Clocking Strategy — audio_clk & BCLK Divider Modes](#2-clocking-strategy)
3. [Register Map Specification (AXI4-Lite Slave)](#3-register-map-specification)
4. [I2S TX Serializer Architecture](#4-i2s-tx-serializer-architecture)
5. [TX FIFO Buffering Design](#5-tx-fifo-buffering-design)
6. [Watermark IRQ Subsystem](#6-watermark-irq-subsystem)
7. [Vivado AXI4-Lite IP Customization — Step-by-Step](#7-vivado-axi4-lite-ip-customization)
8. [Vitis Bare-Metal Test Application Architecture](#8-vitis-bare-metal-test-application)
9. [Verification Strategy](#9-verification-strategy)
10. [Thesis Documentation Integration (DTETI UGM Template)](#10-thesis-documentation-integration)
11. [Diagram Placeholder Index](#11-diagram-placeholder-index)

---

## 1. System Overview

```
                ┌──────────────────────────────────────────────────────────┐
                │                 Basys3 FPGA (Artix-7 XC7A35T)            │
                │                                                            │
                │  ┌───────────────┐        ┌──────────────────────────┐   │
                │  │  MicroBlaze V │        │   I2S TX Peripheral IP   │   │
                │  │  (soft CPU)   │        │  ┌──────┐ ┌────┐ ┌─────┐│   │
                │  │               │        │  │ FIFO │→│ SR │→│BCLK ││   │
                │  │   Vitis C/C++ │        │  │ 64w  │ │ 24 │ │ GEN ││   │
                │  └──────┬────────┘        │  └──────┘ └────┘ └──┬──┘│   │
                │         │ AXI4-Lite        │   Reg Map / IRQ      │   │   │
                │         └─────────────────►  (Slave, 0x44A00000) │   │   │
                │                           └──────────────────────┼───┘   │
                │  ┌───────────────┐                               │        │
                │  │ Clocking Wiz. │→ audio_clk (24.56897 MHz) ───┘        │
                │  │ (MMCM)        │                                         │
                │  └───────────────┘                                         │
                └───────────────────────────────────────┬────────────────────┘
                                                        │ I2S signals
                                                        ▼
                                              ┌──────────────────┐
                                              │  PCM5102A DAC    │
                                              │  BCLK / WS / DIN │
                                              │  (no I2C ctrl)   │
                                              └──────────────────┘
```

**Key design decisions:**
- I2S TX only (no RX)
- 24-bit audio samples packed in 32-bit frames (8 LSBs zero-padded), stereo
- Two sample-rate modes selected via a single register bit (FS_MODE)
- Software-driven FIFO refill triggered by watermark IRQ
- No external MCLK required for PCM5102A (module auto-syncs to BCLK)

---

## 2. Clocking Strategy

### 2.1 MMCM Configuration

The on-board 100 MHz oscillator is fed into a Clocking Wizard (MMCM) to produce `audio_clk`. Due to MMCM fractional constraints on the Artix-7, the closest achievable output is:

| Parameter      | Requested   | Actual (MMCM) |
|----------------|-------------|---------------|
| Input (sys_clk)| 100.000 MHz | 100.000 MHz   |
| audio_clk      | 24.576 MHz  | **24.56897 MHz** |
| axi_clk        | 100 MHz     | 100.000 MHz   |

> **Note**: The 24.56897 MHz actual value is derived from MMCM output divider settings. Capture the "Requested vs Actual" screenshot from the Clocking Wizard GUI for Bab IV Figure 4.1.

### 2.2 BCLK Divider and Sampling Rate Modes

The I2S TX IP exposes a **BCLK_DIV** register field (or a 1-bit FS_MODE) that selects the clock divider applied to `audio_clk` before it becomes BCLK.

The frame structure uses **64 BCLK cycles per stereo frame** (2 channels × 32 bits):

```
Fs = audio_clk / (BCLK_DIV × 64)
```

| FS_MODE | BCLK_DIV | BCLK (MHz)                 | Fs (kHz)                        | Standard |
|---------|----------|----------------------------|---------------------------------|----------|
| 0 (48k) | 8        | 24.56897 / 8 = **3.07112** | 3.07112 / 0.064 = **47.986**    | ~48 kHz  |
| 1 (96k) | 4        | 24.56897 / 4 = **6.14224** | 6.14224 / 0.064 = **95.973**    | ~96 kHz  |

**Error analysis** (relative to ideal):

| Mode | Ideal Fs (kHz) | Actual Fs (kHz) | Error (ppm) |
|------|----------------|-----------------|-------------|
| 48k  | 48.000         | 47.986          | −288 ppm    |
| 96k  | 96.000         | 95.973          | −281 ppm    |

Both errors are well within the ±1000 ppm tolerance of the PCM5102A.

### 2.3 Verilog Clock Divider Snippet

```verilog
// BCLK generation from audio_clk
// bclk_div: 4 (96k mode) or 8 (48k mode)
reg [3:0] bclk_cnt;
reg bclk_reg;

always @(posedge audio_clk or negedge rst_n) begin
  if (!rst_n) begin
    bclk_cnt <= 4'd0;
    bclk_reg <= 1'b0;
  end else begin
    if (bclk_cnt == (bclk_div - 1)) begin
      bclk_cnt <= 4'd0;
      bclk_reg <= ~bclk_reg;
    end else
      bclk_cnt <= bclk_cnt + 1;
  end
end
assign i2s_bclk = bclk_reg;
```

---

## 3. Register Map Specification

**AXI4-Lite base address** (assign in Vivado address editor): `0x44A0_0000`  
**Address space**: 64 bytes (0x00–0x3F)

### 3.1 Full Register Table

| Offset | Name         | Access | Reset      | Description |
|--------|--------------|--------|------------|-------------|
| 0x00   | ID_VER       | RO     | 0x00010001 | [31:16] IP ID = 0x0001; [15:0] Version = 0x0001 |
| 0x04   | CONTROL      | RW     | 0x00000000 | See bit map below |
| 0x08   | STATUS       | RO     | 0x00000001 | See bit map below |
| 0x0C   | WATERMARK    | RW     | 0x00000010 | [5:0] FIFO level threshold for IRQ (default = 16) |
| 0x10   | IRQ_EN       | RW     | 0x00000000 | [0] WATERMARK_IRQ_EN |
| 0x14   | IRQ_STATUS   | RO/W1C | 0x00000000 | [0] WATERMARK_PENDING (W1C to clear) |
| 0x18   | VOLUME       | RW     | 0x00000064 | [6:0] Attenuation in steps (0=0 dB, 127=max mute) — optional |
| 0x1C   | TX_LEFT      | WO     | —          | [23:0] Left channel sample (24-bit, write triggers no push) |
| 0x20   | TX_RIGHT     | WO     | —          | [23:0] Right channel sample (24-bit, write pushes stereo frame to FIFO) |

> **FIFO push rule**: Writing `TX_LEFT` latches the left sample. Writing `TX_RIGHT` latches the right sample **and atomically pushes one stereo frame** (left + right) into the TX FIFO. Always write `TX_LEFT` before `TX_RIGHT`.

### 3.2 CONTROL Register (0x04) Bit Map

```
Bit  31..7  |  6     |  5      |  4        |  3      |  2       |  1    |  0
             Reserved  FS_MODE   FIFO_RST   CLR_UNR   MUTE      RSVD    ENABLE
```

| Bit | Field     | Description |
|-----|-----------|-------------|
| 0   | ENABLE    | 1 = enable I2S serializer; 0 = hold (BCLK/WS frozen) |
| 2   | MUTE      | 1 = force SD output to 0 (no data) |
| 3   | CLR_UNR   | Write 1 to clear underrun latch in STATUS |
| 4   | FIFO_RST  | Write 1 to reset and empty TX FIFO (self-clearing) |
| 5   | FS_MODE   | 0 = ~48 kHz (BCLK_DIV=8); 1 = ~96 kHz (BCLK_DIV=4) |

### 3.3 STATUS Register (0x08) Bit Map

```
Bit  31..14  |  13..8      |  7      |  6        |  5      |  4       |  3     |  2     |  1      |  0
              FIFO_LEVEL    Reserved   UNDERRUN   Reserved   FIFO_FULL  RSVD    RSVD    FIFO_EMPTY  ENABLE
```

| Bits  | Field      | Description |
|-------|------------|-------------|
| 0     | ENABLE     | Mirrors CONTROL[0] |
| 1     | FIFO_EMPTY | 1 = FIFO has 0 frames |
| 4     | FIFO_FULL  | 1 = FIFO has 64 frames |
| 7     | UNDERRUN   | 1 = serializer popped from empty FIFO (latched) |
| 13:8  | FIFO_LEVEL | Current number of stereo frames in FIFO (0–64) |

---

## 4. I2S TX Serializer Architecture

### 4.1 Signal Timing (Philips I2S Standard)

```
          ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐
BCLK  ────┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └────

           ←──────────── 32 BCLK (LEFT) ──────────────►←─ RIGHT...
WS    ─────────────────────────────────────────────────┐
      LOW = left channel                               │  HIGH = right channel
      └──────────────────────────────────────────────────────────────────────

           ← 1-bit delay →
SD         ×  B23 B22 B21 ... B1  B0  ×  ×  ×  ×  ×  ×  B23 ...
                (MSB)         (LSB)       (8 zero-pad bits)
```

### 4.2 Frame Format: 24-bit sample in 32-bit slot

```
Bit position in 32-bit slot:  31  30  29 ... 9   8   7   6 ... 0
Content:                       B23 B22 B21 ... B1  B0  0   0 ... 0
                               (MSB of audio)   (LSB)  (zero pad)
```

The I2S standard places the MSB in bit-slot position 0 (first bit after WS edge), offset by 1 cycle. The remaining 8 bits (bits 7:0 of the 32-bit slot) are transmitted as zeros.

### 4.3 Serializer State Machine

```
States: IDLE → WAIT_WS_FALL → SHIFT_LEFT[0..31] → SHIFT_RIGHT[0..31] → WAIT_WS_FALL
```

```verilog
// Core shift register logic (simplified)
reg [31:0] shift_reg;
reg [5:0]  bit_cnt;   // 0..63

always @(negedge i2s_bclk or negedge rst_n) begin
  if (!rst_n) begin
    shift_reg <= 32'd0;
    bit_cnt   <= 6'd0;
  end else if (enable) begin
    if (bit_cnt == 6'd0) begin
      // Load left sample on WS falling edge
      shift_reg <= {left_sample[23:0], 8'b0};  // 24-bit MSB-aligned in 32 bits
    end else if (bit_cnt == 6'd32) begin
      // Load right sample on WS rising edge
      shift_reg <= {right_sample[23:0], 8'b0};
    end else begin
      shift_reg <= {shift_reg[30:0], 1'b0};    // Shift out MSB first
    end
    bit_cnt <= (bit_cnt == 6'd63) ? 6'd0 : bit_cnt + 1;
  end
end

assign i2s_data = shift_reg[31];  // MSB always
```

---

## 5. TX FIFO Buffering Design

### 5.1 FIFO Parameters

| Parameter     | Value     | Notes |
|---------------|-----------|-------|
| Width         | 48 bits   | 24-bit left + 24-bit right packed per entry |
| Depth         | 64 entries | ~1.33 ms at 48 kHz, ~0.67 ms at 96 kHz |
| Implementation| BRAM (1× 18K BRAM) | Inferred by Vivado synthesis |
| Read port     | Sync to BCLK domain | Pop one entry per stereo frame |
| Write port    | Sync to AXI clock   | Push on TX_RIGHT write |

### 5.2 Clock-Domain Crossing

`audio_clk` (24.57 MHz) and `axi_clk` (100 MHz) are asynchronous. Use a **Gray-code dual-clock FIFO** (or Xilinx FIFO Generator IP with "Independent Clocks" mode) to safely cross domains.

```
  [AXI Write Port]──►[Write ptr, axi_clk domain]──Gray encode──►[CDC sync]──►[Read ptr comparison, bclk domain]
  [BRAM data]                                                                 ▲
  [BRAM data]◄──[Read ptr, bclk domain]──Gray encode──►[CDC sync]────────────┘
```

### 5.3 Underrun Behavior

When the serializer requests the next frame and the FIFO is empty:
1. The serializer transmits an **all-zeros frame** (silence)
2. The `UNDERRUN` latch in STATUS[7] is set
3. If IRQ is enabled, the underrun event can optionally trigger an interrupt (extend IRQ_EN[1])

### 5.4 FIFO Level Monitoring

The AXI read path exposes the write-side fill count (after CDC synchronization) in STATUS[13:8]. Software reads this to decide how many frames to push in polling mode.

---

## 6. Watermark IRQ Subsystem

### 6.1 Interrupt Generation Logic

```
FIFO_LEVEL < WATERMARK  AND  IRQ_EN[0] = 1
              │
              ▼
      irq_pending (level)
              │
              ▼
   XPS IRQ port → MicroBlaze interrupt input
```

The interrupt is **level-sensitive** and remains asserted until the software refills the FIFO above the watermark threshold (or clears IRQ_STATUS[0] via W1C if using edge-mode variant).

### 6.2 Recommended Watermark Value

Set `WATERMARK = 16` (default). This fires the IRQ when 16 or fewer frames remain, giving software ~0.33 ms (at 48 kHz) to push more frames before underrun.

```
Warning margin = WATERMARK / Fs = 16 / 47986 ≈ 0.33 ms
```

For 96 kHz mode, 16 frames gives ~0.17 ms — still sufficient for a bare-metal ISR.

### 6.3 ISR Software Protocol

```
1. On IRQ entry:
   a. Read STATUS → check FIFO_LEVEL
   b. Calculate frames_needed = FIFO_DEPTH - FIFO_LEVEL  (e.g., 64 - 14 = 50)
   c. Loop: push frames_needed stereo frames (write TX_LEFT then TX_RIGHT)
   d. Write IRQ_STATUS = 0x1 (W1C, clears pending flag if edge-mode)
   e. Return from ISR
```

---

## 7. Vivado AXI4-Lite IP Customization

### 7.1 Create Custom IP (Vivado IP Packager)

```
Step 1: Tools → Create and Package New IP
        → Create a new AXI4 peripheral
        → Interface: AXI4-Lite Slave
        → Data width: 32-bit
        → Number of registers: 9 (covers offsets 0x00–0x20)
        → IP name: i2s_tx_v1_0
        → IP location: <project>/ip_repo/i2s_tx_v1_0/

Step 2: Vivado generates skeleton:
        i2s_tx_v1_0.v           (top wrapper)
        i2s_tx_v1_0_S00_AXI.v   (AXI4-Lite slave logic + register file)

Step 3: Edit i2s_tx_v1_0_S00_AXI.v:
        - Replace slv_reg0..slv_reg8 with named registers per §3 above
        - Add i2s_bclk, i2s_ws, i2s_data output ports
        - Instantiate FIFO and serializer sub-modules
        - Wire IRQ output to AXI interrupt port

Step 4: Package IP:
        → Review and Package → Package IP
```

### 7.2 Add IP to Block Design

```
Step 5: In Vivado Block Design:
        a. Add repository: Settings → IP → Repository → Add <project>/ip_repo/
        b. Add IP: "I2S TX v1.0"
        c. Add Clocking Wizard IP:
           - Input: 100 MHz (sys_clk)
           - Output clk_out1: Request 24.576 MHz → Note actual = 24.56897 MHz
           - Output clk_out2: 100 MHz (for AXI if needed)
        d. Connect audio_clk (clk_out1) → i2s_tx/audio_clk_in
        e. Add MicroBlaze + local memory + AXI Interconnect
        f. Connect MicroBlaze M_AXI_DP → AXI Interconnect → i2s_tx S00_AXI
        g. Connect i2s_tx/interrupt → MicroBlaze INTERRUPT port
        h. Make external ports: i2s_bclk, i2s_ws, i2s_data

Step 6: Validate Design (F6) — fix DRC errors if any

Step 7: Address Editor:
        - i2s_tx S00_AXI: Assign offset 0x44A0_0000, range 64K
```

### 7.3 Constraints File (XDC) — Basys3 Pin Assignment

```xdc
# I2S output pins (Basys3 JA PMOD)
set_property PACKAGE_PIN J1  [get_ports i2s_bclk]
set_property PACKAGE_PIN L2  [get_ports i2s_ws]
set_property PACKAGE_PIN J2  [get_ports i2s_data]
set_property IOSTANDARD LVCMOS33 [get_ports {i2s_bclk i2s_ws i2s_data}]

# PCM5102A FLT/DEMP/XSMT control pins (tie static)
set_property PACKAGE_PIN G2  [get_ports pcm_flt]     ;# FLT=0: normal roll-off
set_property PACKAGE_PIN H2  [get_ports pcm_demp]    ;# DEMP=0: no de-emphasis
set_property PACKAGE_PIN K2  [get_ports pcm_xsmt]    ;# XSMT=1: unmute DAC
set_property IOSTANDARD LVCMOS33 [get_ports {pcm_flt pcm_demp pcm_xsmt}]
```

### 7.4 Generate Bitstream

```
Step 8: Generate HDL Wrapper → Run Synthesis → Run Implementation → Generate Bitstream
        (Estimated runtime: ~10 min on Basys3-sized design)

Step 9: Export Hardware (include bitstream) → File → Export → Export Hardware
        Vitis workspace: File → Launch Vitis IDE → link to exported XSA
```

---

## 8. Vitis Bare-Metal Test Application

### 8.1 Project Structure

```
vitis_workspace/
  i2s_test_app/
    src/
      main.cpp          ← entry point, sine table init, enable IP
      i2s_driver.h      ← register offset macros, inline helpers
      i2s_driver.cpp    ← init, push_frame, isr functions
      sine_table.h      ← 256-entry, 24-bit fixed-point sine LUT
    lscript.ld          ← linker script (generated by Vitis)
```

### 8.2 Register Offset Macros (`i2s_driver.h`)

```cpp
// i2s_driver.h
#pragma once
#include <cstdint>

#define I2S_BASE          0x44A00000UL

#define I2S_ID_VER        (I2S_BASE + 0x00)
#define I2S_CONTROL       (I2S_BASE + 0x04)
#define I2S_STATUS        (I2S_BASE + 0x08)
#define I2S_WATERMARK     (I2S_BASE + 0x0C)
#define I2S_IRQ_EN        (I2S_BASE + 0x10)
#define I2S_IRQ_STATUS    (I2S_BASE + 0x14)
#define I2S_VOLUME        (I2S_BASE + 0x18)
#define I2S_TX_LEFT       (I2S_BASE + 0x1C)
#define I2S_TX_RIGHT      (I2S_BASE + 0x20)

// CONTROL bit positions
#define CTRL_ENABLE       (1U << 0)
#define CTRL_MUTE         (1U << 2)
#define CTRL_CLR_UNR      (1U << 3)
#define CTRL_FIFO_RST     (1U << 4)
#define CTRL_FS_96K       (1U << 5)   // 0=48k, 1=96k

// STATUS bit positions
#define STS_ENABLE        (1U << 0)
#define STS_FIFO_EMPTY    (1U << 1)
#define STS_FIFO_FULL     (1U << 4)
#define STS_UNDERRUN      (1U << 7)
#define STS_FIFO_LEVEL(s) (((s) >> 8) & 0x3F)

inline void i2s_write(uint32_t addr, uint32_t val) {
    *reinterpret_cast<volatile uint32_t*>(addr) = val;
}
inline uint32_t i2s_read(uint32_t addr) {
    return *reinterpret_cast<volatile uint32_t*>(addr);
}
inline void i2s_push_frame(int32_t left, int32_t right) {
    i2s_write(I2S_TX_LEFT,  (uint32_t)(left  & 0xFFFFFF));
    i2s_write(I2S_TX_RIGHT, (uint32_t)(right & 0xFFFFFF));
}
```

### 8.3 Sine Table Generator (`sine_table.h`)

```cpp
// sine_table.h — 256-entry, one full period, 24-bit signed amplitude
#pragma once
#include <cstdint>

// Generated with: round(sin(2*pi*i/256) * (2^23 - 1)) for i in 0..255
// Peak amplitude: ±8388607 (full scale 24-bit)
extern const int32_t SINE_TABLE_256[256];

// Usage: index wraps modulo 256 for continuous playback
// For stereo, left and right can be the same table with phase offset
```

```cpp
// sine_table.cpp — first few entries shown; generate full table offline
#include "sine_table.h"
const int32_t SINE_TABLE_256[256] = {
    0, 205271, 410237, 614600, 817755, 1019400, 1219238, 1416975,
    1612320, 1804985, 1994688, 2181150, 2364095, 2543252, 2718356, 2889152,
    // ... (fill remaining 240 entries)
    // Python: [int(round(math.sin(2*math.pi*i/256)*(2**23-1))) for i in range(256)]
};
```

### 8.4 `main.cpp` Architecture

```cpp
// main.cpp — I2S TX bare-metal test
#include "xil_printf.h"
#include "xil_exception.h"
#include "xintc.h"
#include "i2s_driver.h"
#include "sine_table.h"

// ---- Global state ----
static volatile uint32_t sine_idx = 0;    // Current sine table index (left ch)
static uint32_t phase_step = 1;           // Samples per sine table step (freq control)
                                          // freq = Fs / (256 / phase_step)
                                          // phase_step=1 → ~187 Hz @48k
                                          // phase_step=4 → ~750 Hz @48k
                                          // phase_step=11 → ~1031 Hz @48k (≈1 kHz)

static XIntc intc;

// ---- ISR: refill FIFO when watermark hit ----
void i2s_irq_handler(void* callback_ref) {
    uint32_t status = i2s_read(I2S_STATUS);
    uint32_t level  = STS_FIFO_LEVEL(status);
    uint32_t needed = 64 - level;          // frames to fill up to FIFO_DEPTH

    for (uint32_t i = 0; i < needed; i++) {
        int32_t left  = SINE_TABLE_256[sine_idx & 0xFF];
        int32_t right = SINE_TABLE_256[sine_idx & 0xFF];  // mono-to-stereo
        i2s_push_frame(left, right);
        sine_idx += phase_step;
    }

    // W1C clear IRQ pending
    i2s_write(I2S_IRQ_STATUS, 0x1);
}

// ---- Initialization ----
void i2s_init(bool mode_96k) {
    // 1. Reset FIFO and clear any underrun
    i2s_write(I2S_CONTROL, CTRL_FIFO_RST | CTRL_CLR_UNR);
    // (self-clearing, but write 0 to be safe)
    i2s_write(I2S_CONTROL, 0);

    // 2. Set watermark = 16 frames
    i2s_write(I2S_WATERMARK, 16);

    // 3. Select sample rate
    uint32_t ctrl = mode_96k ? CTRL_FS_96K : 0;

    // 4. Pre-fill FIFO before enabling
    for (int i = 0; i < 64; i++) {
        int32_t s = SINE_TABLE_256[(sine_idx++) & 0xFF];
        i2s_push_frame(s, s);
    }

    // 5. Enable IRQ
    i2s_write(I2S_IRQ_EN, 0x1);

    // 6. Enable serializer
    i2s_write(I2S_CONTROL, ctrl | CTRL_ENABLE);
}

// ---- Main ----
int main() {
    xil_printf("I2S TX Test — start\r\n");

    // Initialize interrupt controller
    XIntc_Initialize(&intc, XPAR_INTC_0_DEVICE_ID);
    XIntc_Connect(&intc, XPAR_I2S_TX_0_INTERRUPT_INTR,
                  i2s_irq_handler, nullptr);
    XIntc_Enable(&intc, XPAR_I2S_TX_0_INTERRUPT_INTR);
    XIntc_Start(&intc, XIN_REAL_MODE);
    Xil_ExceptionEnable();

    // Start ~48 kHz mode (change to true for 96 kHz)
    i2s_init(false);

    xil_printf("ID/VER = 0x%08X\r\n", i2s_read(I2S_ID_VER));
    xil_printf("STATUS = 0x%08X\r\n", i2s_read(I2S_STATUS));

    // Idle loop — audio runs via ISR
    while (true) {
        // Poll STATUS for diagnostics
        uint32_t sts = i2s_read(I2S_STATUS);
        if (sts & STS_UNDERRUN) {
            xil_printf("[WARN] Underrun detected! STATUS=0x%08X\r\n", sts);
            i2s_write(I2S_CONTROL,
                      i2s_read(I2S_CONTROL) | CTRL_CLR_UNR);
        }
        // Optional: UART command to switch mode, change phase_step (frequency), etc.
    }

    return 0;
}
```

### 8.5 Frequency Selection Reference

```
Test tone frequency = Fs / (256 / phase_step)

phase_step | Freq @ 48 kHz | Freq @ 96 kHz
-----------+---------------+--------------
     1     |  ~187.5 Hz    |  ~375 Hz
     4     |  ~750 Hz      |  ~1500 Hz
    11     |  ~2062 Hz     |  ~4125 Hz
     5     |  ~937.5 Hz    |  ~1875 Hz
     (use 11 for ~1 kHz @ 48k; use 6 for ~1.125 kHz @ 48k)
```

---

## 9. Verification Strategy

### 9.1 Phase 1 — RTL Simulation (Vivado Simulator / ModelSim)

**Testbench checklist:**

```
[ ] Instantiate DUT: i2s_tx_v1_0 (top-level wrapper)
[ ] Apply AXI4-Lite reset sequence (ARESETn low for ≥16 clocks)
[ ] Write CONTROL = FIFO_RST, then ENABLE
[ ] Write TX_LEFT = 0x7FFFFF (full-scale positive)
[ ] Write TX_RIGHT = 0x800001 (near full-scale negative)
[ ] Monitor i2s_bclk, i2s_ws, i2s_data
[ ] Verify:
    - WS toggles every 32 BCLK cycles
    - DATA MSB appears 1 BCLK after WS edge (1-bit delay per Philips spec)
    - Bit 31 of left slot = 0x7FFFFF[23] = 1
    - Bits 7:0 of slot are 0 (zero pad)
[ ] Simulate underrun: do not write any frames; verify STATUS[7] asserts
[ ] Simulate watermark IRQ: write 10 frames, verify irq_out asserts (WATERMARK=16)
```

**Save simulation waveform screenshot** → `docs/figures/sim-waveform-i2s.png` (for Bab IV Figure 4.3)

### 9.2 Phase 2 — Hardware-in-Loop with ILA

**ILA probe configuration:**

```
Probe 0: i2s_bclk         (1-bit)
Probe 1: i2s_ws            (1-bit)
Probe 2: i2s_data          (1-bit)
Probe 3: fifo_level[5:0]   (6-bit)
Probe 4: underrun           (1-bit)
Probe 5: irq_out            (1-bit)
Probe 6: axi_wdata[23:0]   (24-bit, optional — AXI write data monitor)

Sample depth: 4096 samples
Clock: audio_clk (for BCLK-domain probes)
Trigger: WS falling edge (for aligned frame capture)
```

**Expected ILA observations:**

```
48 kHz mode:
  - BCLK period ≈ 325.5 ns → freq ≈ 3.071 MHz
  - WS period ≈ 20.836 µs → Fs ≈ 47.99 kHz
  - 32 BCLK pulses per WS half-period

96 kHz mode:
  - BCLK period ≈ 162.7 ns → freq ≈ 6.142 MHz
  - WS period ≈ 10.418 µs → Fs ≈ 95.97 kHz
```

**ILA capture screenshots** → `docs/figures/ila-bclk-ws-data-48k.png` and `docs/figures/ila-bclk-ws-data-96k.png`

### 9.3 Phase 3 — PCM5102A Audio Verification

```
Hardware setup:
  Basys3 JA PMOD ──► PCM5102A module
    JA[0] → BCLK  (PCM5102A pin: BCK)
    JA[1] → WS    (PCM5102A pin: LRCK)
    JA[2] → DIN   (PCM5102A pin: DIN)
    3.3 V  → VCC
    GND    → GND
  PCM5102A FLT  = 0 (normal roll-off)
  PCM5102A DEMP = 0 (no de-emphasis)
  PCM5102A XSMT = 1 (unmute)

Analog output:
  PCM5102A OUTL/OUTR → oscilloscope probes
  Expected: sine wave at selected frequency (e.g., ~1 kHz)
  Expected amplitude: ~2 Vpp (PCM5102A full scale ≈ 2.1 Vrms)

Audio proof options:
  Option A: Oscilloscope photo showing sine wave → figures/scope-pcm5102a-sine.png
  Option B: 3.5 mm audio jack → PC line-in → Audacity FFT screenshot → figures/audacity-fft-1khz.png
  Option C: Spectrum analyzer screenshot
```

### 9.4 Measurement Summary Table (Template for Bab IV)

| Parameter         | Target       | Measured | Error   |
|-------------------|--------------|----------|---------|
| audio_clk         | 24.576 MHz   | 24.56897 MHz | −288 ppm |
| BCLK (48k mode)   | 3.072 MHz    | _________| _______ |
| Fs (48k mode)     | 48.000 kHz   | _________| _______ |
| BCLK (96k mode)   | 6.144 MHz    | _________| _______ |
| Fs (96k mode)     | 96.000 kHz   | _________| _______ |
| FIFO watermark IRQ latency | <0.33 ms | _______ | _______ |
| Underrun count (prefilled FIFO) | 0 | _______ | _______ |

---

## 10. Thesis Documentation Integration (DTETI UGM Template)

This section maps each implementation element to the **exact location** in the existing DTETI UGM LaTeX template (`thesisdtetiugm.cls`, chapter files under `contents/`).

### 10.1 Chapter Mapping

| Implementation Element | Template File | Section |
|------------------------|---------------|---------|
| I2S protocol background | `contents/chapter-2/chapter-2.tex` | `\section{Protokol I2S}` |
| AXI4-Lite overview | `contents/chapter-2/chapter-2.tex` | `\section{Antarmuka AXI4-Lite}` |
| PCM5102A DAC description | `contents/chapter-2/chapter-2.tex` | `\section{DAC PCM5102A}` |
| FIFO & interrupt theory | `contents/chapter-2/chapter-2.tex` | `\section{Buffering FIFO dan Interupsi}` |
| MMCM/Clocking Wizard | `contents/chapter-2/chapter-2.tex` | `\section{Clocking pada FPGA Basys3}` |
| System architecture diagram | `contents/chapter-3/chapter-3.tex` | `\section{Arsitektur Sistem}` |
| Clock calculations & table | `contents/chapter-3/chapter-3.tex` | `\section{Perancangan Clock}` |
| Register map table | `contents/chapter-3/chapter-3.tex` | `\section{Peta Register AXI4-Lite}` |
| FIFO design details | `contents/chapter-3/chapter-3.tex` | `\section{Perancangan FIFO TX}` |
| IRQ watermark design | `contents/chapter-3/chapter-3.tex` | `\section{Subsistem Interupsi Watermark}` |
| Vivado IP steps | `contents/chapter-4/chapter-4.tex` | `\section{Implementasi IP pada Vivado}` |
| Simulation results | `contents/chapter-4/chapter-4.tex` | `\section{Pengujian Simulasi RTL}` |
| ILA capture results | `contents/chapter-4/chapter-4.tex` | `\section{Pengujian Hardware dengan ILA}` |
| PCM5102A audio results | `contents/chapter-4/chapter-4.tex` | `\section{Pengujian Output Audio}` |
| Measurement tables | `contents/chapter-4/chapter-4.tex` | subsections under Bab IV |
| Vitis software arch | `contents/chapter-4/chapter-4.tex` | `\section{Implementasi Perangkat Lunak}` |
| Conclusions | `contents/chapter-5/chapter-5.tex` | `\section{Kesimpulan}` |
| Future work | `contents/chapter-5/chapter-5.tex` | `\section{Saran}` |
| Capture guide / proof | `contents/appendix/appendix-isi-lampiran.tex` | see §10.4 |

> The template uses **5 main chapters** (`chapter-1` through `chapter-5`) in the I2S-only scope — `chapter-6` can be removed or repurposed. Update `main.tex` accordingly by commenting out the `\include{contents/chapter-6/chapter-6}` line.

### 10.2 Figure Placement Guide

Place all figure source files under `contents/` following the existing pattern (see `contents/chapter-2/gambar-buatan-sendiri.PNG` as example). The recommended figure paths and LaTeX labels are:

| Figure | Suggested Path | `\label` | Used in |
|--------|----------------|----------|---------|
| System block diagram | `contents/chapter-3/fig-block-diagram-i2s.pdf` | `fig:block-i2s` | Bab III §3.1 |
| Vivado Clocking Wizard output | `contents/chapter-4/fig-clk-wiz-actual.png` | `fig:clk-wiz` | Bab IV §4.1 |
| Vivado Block Design screenshot | `contents/chapter-4/fig-vivado-bd.png` | `fig:vivado-bd` | Bab IV §4.1 |
| Simulation waveform (BCLK/WS/DATA) | `contents/chapter-4/fig-sim-waveform.png` | `fig:sim-wave` | Bab IV §4.2 |
| ILA capture 48 kHz mode | `contents/chapter-4/fig-ila-48k.png` | `fig:ila-48k` | Bab IV §4.3 |
| ILA capture 96 kHz mode | `contents/chapter-4/fig-ila-96k.png` | `fig:ila-96k` | Bab IV §4.3 |
| PCM5102A oscilloscope output | `contents/chapter-4/fig-scope-sine.png` | `fig:scope-sine` | Bab IV §4.4 |
| Audacity FFT proof (optional) | `contents/chapter-4/fig-audacity-fft.png` | `fig:fft-proof` | Bab IV §4.4 |
| Vitis ISR call flow diagram | `contents/chapter-4/fig-isr-flow.pdf` | `fig:isr-flow` | Bab IV §4.5 |

**LaTeX include snippet (copy into chapter-4.tex):**

```latex
\begin{figure}[H]
  \centering
  \includegraphics[width=0.95\linewidth]{contents/chapter-4/fig-ila-48k}
  \caption{Hasil capture ILA: sinyal BCLK, WS, dan DATA pada mode ~48~kHz.}
  \label{fig:ila-48k}
\end{figure}
```

### 10.3 Table Placement Guide

| Table | `\label` | Used in |
|-------|----------|---------|
| Clock calculation (§2.2) | `tab:clock-calc` | Bab III §3.2 |
| Register map (§3.1) | `tab:regmap` | Bab III §3.3 (use `longtable`) |
| CONTROL bit map (§3.2) | `tab:ctrl-bits` | Bab III §3.3 |
| STATUS bit map (§3.3) | `tab:sts-bits` | Bab III §3.3 |
| FIFO parameters (§5.1) | `tab:fifo-params` | Bab III §3.4 |
| Measurement summary (§9.4) | `tab:meas` | Bab IV §4.6 (fill after hardware test) |
| Frequency selection (§8.5) | `tab:freq-sel` | Bab IV §4.5 |

**LaTeX `longtable` snippet for register map (copy into chapter-3.tex):**

```latex
\begin{longtable}{@{}p{1.5cm}p{2.5cm}p{1.5cm}p{1.5cm}p{7cm}@{}}
\caption{Peta register peripheral I2S TX (AXI4-Lite, base 0x44A0\_0000).}
\label{tab:regmap}\\
\toprule
Offset & Nama & Akses & Reset & Deskripsi \\ \midrule
\endfirsthead
\toprule
Offset & Nama & Akses & Reset & Deskripsi \\ \midrule
\endhead
\bottomrule
\endfoot
0x00 & ID\_VER   & RO    & 0x00010001 & {[}31:16{]} IP ID; {[}15:0{]} Versi \\
0x04 & CONTROL  & RW    & 0x00000000 & ENABLE, MUTE, CLR\_UNR, FIFO\_RST, FS\_MODE \\
0x08 & STATUS   & RO    & 0x00000002 & FIFO\_EMPTY, FIFO\_FULL, UNDERRUN, FIFO\_LEVEL \\
0x0C & WATERMARK & RW   & 0x00000010 & Level threshold untuk watermark IRQ \\
0x10 & IRQ\_EN  & RW    & 0x00000000 & {[}0{]} WATERMARK\_IRQ\_EN \\
0x14 & IRQ\_STATUS & RO/W1C & 0x00000000 & {[}0{]} WATERMARK\_PENDING (W1C) \\
0x18 & VOLUME   & RW    & 0x00000064 & {[}6:0{]} Atenuasi (opsional) \\
0x1C & TX\_LEFT & WO    & —          & {[}23:0{]} Sample kiri (24-bit) \\
0x20 & TX\_RIGHT & WO   & —          & {[}23:0{]} Sample kanan; push frame \\
\end{longtable}
```

### 10.4 Appendix: Capture Guide

Add a new appendix file `contents/appendix/appendix-capture-guide.tex` and reference it from `main.tex`:

```latex
% In main.tex, after existing appendix lines:
\chapterappendixadd{contents/appendix/appendix-capture-guide}
```

The appendix should contain step-by-step instructions for capturing:
1. Clocking Wizard requested vs. actual screenshot (Vivado IP GUI)
2. Vivado Block Design export (File → Export → Export Block Diagram)
3. Simulation waveform (Vivado Simulator screenshot)
4. ILA waveform (Hardware Manager screenshot)
5. Oscilloscope / Audacity audio proof

---

## 11. Diagram Placeholder Index

The following diagram files should be created (e.g., with draw.io, PowerPoint, or Inkscape) and placed at the paths listed. Placeholder `README` files are provided in `docs/figures/` to track which diagrams are pending.

| File | Status | Tool Suggestion |
|------|--------|-----------------|
| `docs/figures/fig-block-diagram-i2s.drawio` | ⬜ Pending | draw.io (export to PDF/PNG) |
| `docs/figures/fig-isr-flow.drawio` | ⬜ Pending | draw.io |
| `contents/chapter-3/fig-block-diagram-i2s.pdf` | ⬜ Pending (copy from docs/figures after export) | — |
| `contents/chapter-4/fig-clk-wiz-actual.png` | ⬜ Pending (capture from Vivado) | Screenshot |
| `contents/chapter-4/fig-vivado-bd.png` | ⬜ Pending (capture from Vivado) | Screenshot |
| `contents/chapter-4/fig-sim-waveform.png` | ⬜ Pending (capture from Vivado Simulator) | Screenshot |
| `contents/chapter-4/fig-ila-48k.png` | ⬜ Pending (capture from Vivado HW Manager) | Screenshot |
| `contents/chapter-4/fig-ila-96k.png` | ⬜ Pending | Screenshot |
| `contents/chapter-4/fig-scope-sine.png` | ⬜ Pending (oscilloscope / Audacity) | Photo / Screenshot |
| `contents/chapter-4/fig-audacity-fft.png` | ⬜ Pending (optional) | Audacity screenshot |

---

*End of Implementation Plan — version 1.0, 2026.*
