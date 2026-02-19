# Mastering Custom AXI Peripherals: axi_7seg Complete Guide

> From number systems to working hardware — everything you need to understand.

## Table of Contents

**Part A: Foundations**
1. [Number Systems (decimal, binary, hex)](#1-number-systems)
2. [Bits, Nibbles, Bytes, Words](#2-bits-nibbles-bytes-words)
3. [The 0x, 0b Prefixes](#3-prefixes)

**Part B: Hardware**
4. [How 7-Segment Displays Work](#4-seven-segment-display)
5. [Basys3 4-Digit Multiplexing](#5-multiplexing)

**Part C: Bus Protocol**
6. [What is a Bus?](#6-what-is-a-bus)
7. [AXI4-Lite Protocol](#7-axi4-lite)
8. [Registers and Address Map](#8-registers)

**Part D: Building the IP**
9. [Architecture of axi_7seg](#9-architecture)
10. [Verilog Code Walkthrough](#10-verilog-walkthrough)
11. [IP Packaging (component.xml)](#11-ip-packaging)
12. [C Driver](#12-c-driver)

**Part E: Integration**
13. [Vivado Block Design Steps](#13-vivado-integration)
14. [XDC Constraints](#14-xdc)
15. [GPIO vs Custom Peripheral](#15-gpio-vs-custom)
16. [Templates for Other Peripherals](#16-templates)

---

# Part A: Foundations

---

## 1. Number Systems

Computers use **binary** (base-2) because transistors have two states: ON/OFF.
Humans prefer **decimal** (base-10) because we have 10 fingers.
**Hexadecimal** (base-16) is a shortcut for writing binary.

### Decimal (base-10)

What you use every day. Digits: 0 1 2 3 4 5 6 7 8 9

```
  2  0  2
  │  │  │
  │  │  └── 2 × 10⁰ = 2 × 1   =   2
  │  └──── 0 × 10¹ = 0 × 10  =   0
  └────── 2 × 10² = 2 × 100 = 200
                                ───
                                202
```

### Binary (base-2)

What the FPGA actually uses. Digits: 0 1

```
  1  1  0  0  1  0  1  0
  │  │  │  │  │  │  │  │
  │  │  │  │  │  │  │  └── 0 × 2⁰ = 0 ×   1 =   0
  │  │  │  │  │  │  └──── 1 × 2¹ = 1 ×   2 =   2
  │  │  │  │  │  └────── 0 × 2² = 0 ×   4 =   0
  │  │  │  │  └──────── 1 × 2³ = 1 ×   8 =   8
  │  │  │  └────────── 0 × 2⁴ = 0 ×  16 =   0
  │  │  └──────────── 0 × 2⁵ = 0 ×  32 =   0
  │  └────────────── 1 × 2⁶ = 1 ×  64 =  64
  └──────────────── 1 × 2⁷ = 1 × 128 = 128
                                         ───
                                         202
```

### Hexadecimal (base-16)

A shortcut for binary. Digits: 0 1 2 3 4 5 6 7 8 9 A B C D E F

```
Hex:     0  1  2  3  4  5  6  7  8  9  A   B   C   D   E   F
Decimal: 0  1  2  3  4  5  6  7  8  9  10  11  12  13  14  15
Binary:  0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111
```

**Key insight: 1 hex digit = exactly 4 binary digits.**

```
Binary:  1100  1010
Hex:       C     A     → 0xCA

Binary:  1111  1110
Hex:       F     E     → 0xFE
```

That's why hex exists — writing `0xCA` is much easier than `11001010`.

---

## 2. Bits, Nibbles, Bytes, Words

```
bit     = 1 binary digit              0 or 1
nibble  = 4 bits  = 1 hex digit       0x0 to 0xF       (0-15)
byte    = 8 bits  = 2 hex digits      0x00 to 0xFF     (0-255)
halfword= 16 bits = 4 hex digits      0x0000 to 0xFFFF (0-65535)
word    = 32 bits = 8 hex digits      0x00000000 to 0xFFFFFFFF
```

Visual:

```
                          1 word (32 bits)
┌───────────────────────────────────────────────────────────────┐
│                        0x0000CAFE                             │
│                                                               │
│   byte 3      byte 2      byte 1      byte 0                 │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐             │
│ │  0x00   │ │  0x00   │ │  0xCA   │ │  0xFE   │             │
│ │         │ │         │ │         │ │         │             │
│ │ nib nib │ │ nib nib │ │ nib nib │ │ nib nib │             │
│ │  0   0  │ │  0   0  │ │  C   A  │ │  F   E  │             │
│ └─────────┘ └─────────┘ └─────────┘ └─────────┘             │
│                                                               │
│ bits: 31..24    23..16     15..8       7..0                   │
└───────────────────────────────────────────────────────────────┘
```

### For our 7-segment display:

```
We use the lower 16 bits = 4 nibbles = 4 hex digits = 4 display digits

slv_reg0 = 0x____CAFE
                 ││││
                 ││││
                 ││└└── nibble 0 = 0xE = 4'b1110 → AN0 shows "E"
                 └└──── nibble 1 = 0xF = 4'b1111 → AN1 shows "F"
                        nibble 2 = 0xA = 4'b1010 → AN2 shows "A"
                        nibble 3 = 0xC = 4'b1100 → AN3 shows "C"

Display:  [ C ] [ A ] [ F ] [ E ]
           AN3   AN2   AN1   AN0
```

Why nibble, not byte? Because one hex digit (0-F) only needs 4 bits, and the 7-segment display only shows one character per digit. Using a full byte per digit would waste 4 bits.

---

## 3. The 0x, 0b Prefixes

These prefixes tell the compiler/reader which number system:

```
Prefix    System        Example       Decimal value
──────    ──────        ───────       ─────────────
(none)    decimal       202           202
0x        hexadecimal   0xCA          202
0b        binary        0b11001010    202
```

Without prefixes, ambiguity:

```
"10" could mean:
  10     = ten         (decimal)
  0x10   = sixteen     (hex: 1×16 + 0 = 16)
  0b10   = two         (binary: 1×2 + 0 = 2)

"11" could mean:
  11     = eleven      (decimal)
  0x11   = seventeen   (hex: 1×16 + 1 = 17)
  0b11   = three       (binary: 1×2 + 1 = 3)

"100" could mean:
  100    = one hundred (decimal)
  0x100  = two hundred fifty six (hex: 1×256 = 256)
  0b100  = four        (binary: 1×4 = 4)
```

### In different languages:

```
C code:     0xCAFE         0b11001010       202
Verilog:    16'hCAFE       8'b11001010      8'd202
              ↑               ↑                ↑
              size'base       size'base        size'base
              16 bits, hex    8 bits, binary   8 bits, decimal
Python:     0xCAFE         0b11001010       202
```

Verilog is special — it uses `size'base` format:
```
4'hA     = 4-bit hex A          = 1010
8'hCA    = 8-bit hex CA         = 11001010
16'hCAFE = 16-bit hex CAFE      = 1100101011111110
7'b1000000 = 7-bit binary       = 1000000
32'd100  = 32-bit decimal 100   = 00...01100100
```

---

# Part B: Hardware

---

## 4. How 7-Segment Displays Work

A 7-segment display is just **7 LEDs** arranged in a figure-8 pattern:

```
     aaaa           Segment names:
    f    b            a = top
    f    b            b = top-right
     gggg             c = bottom-right
    e    c            d = bottom
    e    c            e = bottom-left
     dddd  .dp        f = top-left
                      g = middle
                      dp = decimal point
```

To show a digit, you turn specific segments ON:

```
Digit "0": a,b,c,d,e,f ON   g OFF       Digit "A": a,b,c,e,f,g ON   d OFF
 ████                                     ████
█    █                                    █    █
█    █                                    █    █
                                           ████
█    █                                    █    █
█    █                                    █    █
 ████

Digit "1": b,c ON   rest OFF             Digit "F": a,e,f,g ON   b,c,d OFF
     █                                    ████
     █                                   █
                                         █
     █                                    ████
     █                                   █
                                         █
```

### Common Anode (Basys3)

The Basys3 uses **common anode** displays:

```
        VCC (3.3V)
         │
    ┌────┴────┐  ← Anode (shared, active LOW)
    │         │     AN = 0 → digit ON
    │  7-seg  │     AN = 1 → digit OFF
    │         │
    └┬┬┬┬┬┬┬┬┘
     │││││││└── seg[0] (a)  ← Cathodes (active LOW)
     ││││││└─── seg[1] (b)     0 = LED ON  (current flows)
     │││││└──── seg[2] (c)     1 = LED OFF (no current)
     ││││└───── seg[3] (d)
     │││└────── seg[4] (e)
     ││└─────── seg[5] (f)
     │└──────── seg[6] (g)
     └───────── dp
```

**Active LOW** means:
- Write `0` to turn a segment **ON** (counterintuitive!)
- Write `1` to turn a segment **OFF**

Example — showing "0":
```
segments a,b,c,d,e,f = ON (0), g = OFF (1)
seg[6:0] = gfedcba = 1000000
                      │└┘└┘└┘
                      g=OFF  a,b,c,d,e,f=ON
```

---

## 5. Basys3 4-Digit Multiplexing

The Basys3 has **4 digits** but they all share the **same 7 segment wires**:

```
           seg[6:0] + dp  (shared by ALL digits)
           ││││││││
    ┌──────┼┼┼┼┼┼┼┼──────┐
    │      ││││││││       │
  ┌─┴─┐ ┌─┴─┐ ┌─┴─┐ ┌─┴─┐
  │ D3│ │ D2│ │ D1│ │ D0│    ← 4 digits
  └─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘
    │      │      │      │
   AN3    AN2    AN1    AN0    ← anodes (select which digit)
```

**Problem:** Only 7+1 = 8 wires for segments, but 4 digits. How to show different values?

**Solution:** Rapidly switch between digits (multiplexing):

```
Time slice 1 (0.66ms):
  AN = 1110 (only digit 0 ON)
  seg = pattern for digit 0

Time slice 2 (0.66ms):
  AN = 1101 (only digit 1 ON)
  seg = pattern for digit 1

Time slice 3 (0.66ms):
  AN = 1011 (only digit 2 ON)
  seg = pattern for digit 2

Time slice 4 (0.66ms):
  AN = 0111 (only digit 3 ON)
  seg = pattern for digit 3

  ← repeat from time slice 1 (~2.6ms total cycle = ~381 Hz) →

Human eye can't see the switching → all 4 digits appear lit simultaneously
```

### Software vs Hardware multiplexing

**Software (old approach with GPIO):**
```c
while(1) {
    Xil_Out32(GPIO_AN, 0xE);     // select digit 0
    Xil_Out32(GPIO_SEG, seg_0);  // set segments
    usleep(1000);                // wait 1ms
    Xil_Out32(GPIO_AN, 0xD);     // select digit 1
    Xil_Out32(GPIO_SEG, seg_1);  // set segments
    usleep(1000);
    // ... repeat for digits 2, 3
    // CPU is stuck here forever!
}
```

**Hardware (new approach with axi_7seg):**
```c
Xil_Out32(AXI_7SEG_BASE, 0xCAFE);        // write once
Xil_Out32(AXI_7SEG_BASE + 0x04, 0x01);   // enable
// Done! CPU is free to do other things
// FPGA hardware handles multiplexing automatically
```

---

# Part C: Bus Protocol

---

## 6. What is a Bus?

A bus is a **shared communication highway** between components:

```
┌──────────────┐     ┌─────────────────────────────────────────────┐
│              │     │               AXI Bus                       │
│  MicroBlaze  ├─────┤  ┌─────────┐  ┌──────┐  ┌────────────┐    │
│  (CPU)       │     │  │ UART    │  │ GPIO │  │ axi_7seg   │    │
│              │     │  │ 0x4060  │  │0x4000│  │ 0x44A0     │    │
│  "I want to  │     │  └─────────┘  └──────┘  └────────────┘    │
│   write 0xCA │     │                                             │
│   to 0x44A0" │     │  SmartConnect looks at address, routes      │
│              │     │  the transaction to the right peripheral    │
└──────────────┘     └─────────────────────────────────────────────┘
```

The **SmartConnect** (axi_smc) acts as a router:
- CPU says "write 0xCAFE to address 0x44A00000"
- SmartConnect checks: 0x44A00000 belongs to axi_7seg
- SmartConnect forwards the write to axi_7seg
- axi_7seg stores 0xCAFE in slv_reg0

---

## 7. AXI4-Lite Protocol

### Three types of AXI

```
AXI4-Full   → complex, burst transfers (DDR memory, DMA)
AXI4-Lite   → simple, single register read/write  ← WE USE THIS
AXI4-Stream → continuous data flow (audio, video)
```

AXI4-Lite is perfect for peripherals with a few control registers.

### 5 Channels

```
         MASTER (CPU)                              SLAVE (our IP)
        ┌──────────┐                              ┌──────────┐
        │          ├── Write Address (AW) ───────>│          │
        │          ├── Write Data    (W)  ───────>│          │
        │          │<── Write Response(B)  ────────┤          │
        │          │                               │          │
        │          ├── Read Address  (AR) ───────>│          │
        │          │<── Read Data    (R)  ────────┤          │
        └──────────┘                              └──────────┘
```

Each channel has a **handshake** using VALID and READY signals:

### Write transaction step by step

```
CPU wants to write 0xCAFE to register at offset 0x00:

Step 1: CPU puts address on AW channel
  AWADDR  = 0x00        "I want to write to offset 0x00"
  AWVALID = 1           "this address is valid"

Step 2: CPU puts data on W channel (can happen same time as step 1)
  WDATA   = 0x0000CAFE  "here's the data"
  WSTRB   = 4'b1111     "write all 4 bytes"
  WVALID  = 1           "this data is valid"

Step 3: Slave accepts both
  AWREADY = 1           "I got the address"
  WREADY  = 1           "I got the data"
  → slv_reg0 now contains 0x0000CAFE

Step 4: Slave sends response
  BRESP   = 2'b00       "OK, write succeeded"
  BVALID  = 1           "response is valid"

Step 5: CPU acknowledges
  BREADY  = 1           "I got your response"
  → transaction complete
```

### Read transaction step by step

```
CPU wants to read register at offset 0x00:

Step 1: CPU puts address on AR channel
  ARADDR  = 0x00        "I want to read offset 0x00"
  ARVALID = 1           "this address is valid"

Step 2: Slave accepts
  ARREADY = 1           "I got the address"

Step 3: Slave sends data
  RDATA   = 0x0000CAFE  "here's the data from slv_reg0"
  RRESP   = 2'b00       "OK"
  RVALID  = 1           "data is valid"

Step 4: CPU accepts
  RREADY  = 1           "I got the data"
  → CPU now has 0x0000CAFE
```

### Timing diagram

```
             ┌──┐  ┌──┐  ┌──┐  ┌──┐  ┌──┐  ┌──┐
Clock:    ───┘  └──┘  └──┘  └──┘  └──┘  └──┘  └──

AWADDR:   ──╔═══════╗──────────────────────────────  0x00
AWVALID:  ──╔═══════╗──────────────────────────────
AWREADY:  ──────────╔═══╗──────────────────────────

WDATA:    ──╔═══════╗──────────────────────────────  0xCAFE
WVALID:   ──╔═══════╗──────────────────────────────
WREADY:   ──────────╔═══╗──────────────────────────
                     ↑
              TRANSFER HAPPENS HERE
              (both VALID and READY = 1 at clock edge)

BRESP:    ──────────────────╔═══╗──────────────────  2'b00
BVALID:   ──────────────────╔═══╗──────────────────
BREADY:   ═════════════════════════════════════════
```

---

## 8. Registers and Address Map

### What is a register?

A register is a small piece of memory inside the peripheral that the CPU can read/write:

```
slv_reg0 = 32 flip-flops = 32 bits of storage
           ┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐
bit index: │31│30│29│28│27│26│25│24│23│22│21│20│19│18│17│16│15│14│13│12│11│10│9 │8 │7 │6 │5 │4 │3 │2 │1 │0 │
           └─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘

When CPU writes: Xil_Out32(BASE + 0x00, 0xCAFE)
→ slv_reg0 stores:  0x0000CAFE
→ bits 15:0 = 0xCAFE = 1100_1010_1111_1110
```

### How addresses map to registers

```
Address bus width = 4 bits → addresses 0x0 to 0xF

But registers are 32-bit (4 bytes), so each register takes 4 addresses:

Address    Register      Why?
───────    ─────────     ─────────────────────
0x00       slv_reg0      bytes at 0x00, 0x01, 0x02, 0x03
0x04       slv_reg1      bytes at 0x04, 0x05, 0x06, 0x07
0x08       slv_reg2      bytes at 0x08, 0x09, 0x0A, 0x0B
0x0C       slv_reg3      bytes at 0x0C, 0x0D, 0x0E, 0x0F
```

In Verilog, this is handled by `ADDR_LSB`:

```verilog
localparam integer ADDR_LSB = 2;  // ignore bottom 2 bits (byte offset)

// Address 0x00 → bits [3:2] = 00 → slv_reg0
// Address 0x04 → bits [3:2] = 01 → slv_reg1
// Address 0x08 → bits [3:2] = 10 → slv_reg2
// Address 0x0C → bits [3:2] = 11 → slv_reg3

case (axi_awaddr[3:2])   // [ADDR_LSB+OPT_MEM_ADDR_BITS : ADDR_LSB]
    2'b00: // write to slv_reg0
    2'b01: // write to slv_reg1
    2'b10: // write to slv_reg2
    2'b11: // write to slv_reg3
endcase
```

### Write strobes (WSTRB)

WSTRB allows writing **individual bytes** within a 32-bit register:

```
WSTRB has 4 bits, one per byte:

WSTRB = 4'b1111 → write all 4 bytes      (Xil_Out32)
WSTRB = 4'b0011 → write bytes 0,1 only   (Xil_Out16)
WSTRB = 4'b0001 → write byte 0 only      (Xil_Out8)

         byte 3    byte 2    byte 1    byte 0
        ┌────────┬────────┬────────┬────────┐
WSTRB:  │ bit 3  │ bit 2  │ bit 1  │ bit 0  │
        │ 1=write│ 1=write│ 1=write│ 1=write│
        │ 0=skip │ 0=skip │ 0=skip │ 0=skip │
        └────────┴────────┴────────┴────────┘
```

In Verilog:

```verilog
for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
    if (S_AXI_WSTRB[byte_index] == 1)
        slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];

// "+: 8" means "8 bits starting from position byte_index*8"
// byte_index=0: slv_reg0[7:0]   ← byte 0
// byte_index=1: slv_reg0[15:8]  ← byte 1
// byte_index=2: slv_reg0[23:16] ← byte 2
// byte_index=3: slv_reg0[31:24] ← byte 3
```

### Our register map for axi_7seg

```
┌─────────────────────────────────────────────────────────────┐
│ REG0: DATA (offset 0x00)                                    │
├─────────────────────────────────────────────────────────────┤
│ bits: 31            16 15    12 11     8 7      4 3      0  │
│       ┌──────────────┬─────────┬────────┬────────┬────────┐ │
│       │   unused     │ digit 3 │ digit 2│ digit 1│ digit 0│ │
│       │              │ (AN3)   │ (AN2)  │ (AN1)  │ (AN0)  │ │
│       └──────────────┴─────────┴────────┴────────┴────────┘ │
│                                                              │
│  Each digit = 1 nibble = 4 bits = hex 0-F                    │
│  Write 0xCAFE → shows "C A F E"                             │
│  Write 0x1234 → shows "1 2 3 4"                             │
│  Write 0x0000 → shows "0 0 0 0"                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ REG1: CTRL (offset 0x04)                                    │
├─────────────────────────────────────────────────────────────┤
│ bits: 31               8 7  6  5  4  3         1  0         │
│       ┌─────────────────┬──┬──┬──┬──┬──────────┬──┐        │
│       │    unused       │d3│d2│d1│d0│  unused  │en│        │
│       └─────────────────┴──┴──┴──┴──┴──────────┴──┘        │
│                                                              │
│  en (bit 0):                                                 │
│    0 = display OFF (all segments off)                         │
│    1 = display ON                                            │
│                                                              │
│  d0-d3 (bits 7:4) = decimal point per digit:                 │
│    bit 4 (d0) = dp on digit 0 (AN0, rightmost)               │
│    bit 5 (d1) = dp on digit 1 (AN1)                          │
│    bit 6 (d2) = dp on digit 2 (AN2)                          │
│    bit 7 (d3) = dp on digit 3 (AN3, leftmost)                │
│                                                              │
│  Example: 0x01 → enable display, no decimal points           │
│  Example: 0x21 → enable + dp on digit 1                      │
│  Example: 0xF1 → enable + dp on all digits                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ REG2 (offset 0x08) — reserved (unused)                       │
│ REG3 (offset 0x0C) — reserved (unused)                       │
└─────────────────────────────────────────────────────────────┘
```

---

# Part D: Building the IP

---

## 9. Architecture of axi_7seg

### File structure

```
ip_repo/axi_7seg_1.0/
├── component.xml              ← tells Vivado "what is this IP?"
├── hdl/
│   ├── axi_7seg.v             ← top wrapper (connects everything)
│   └── axi_7seg_v1_0_S00_AXI.v  ← all logic lives here
└── drivers/axi_7seg_v1_0/
    ├── data/
    │   ├── axi_7seg.mdd       ← driver metadata
    │   └── axi_7seg.tcl       ← generates xparameters.h
    └── src/
        ├── axi_7seg.h         ← C header for Vitis
        ├── axi_7seg.c         ← C self-test function
        └── Makefile            ← build instructions
```

### Block diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    axi_7seg (top wrapper)                     │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │            axi_7seg_v1_0_S00_AXI                      │  │
│  │                                                        │  │
│  │  ┌─────────────────────┐  ┌──────────────────────────┐│  │
│  │  │  AXI Slave Logic    │  │  7-Segment User Logic    ││  │
│  │  │                     │  │                          ││  │
│  │  │  AW channel ──┐     │  │  slv_reg0 ──> hex_data   ││  │
│  │  │  W  channel ──┤     │  │                 │        ││  │
│  │  │               ▼     │  │                 ▼        ││  │
│  │  │  ┌───────────────┐  │  │  ┌──────────────────┐   ││  │
│  │  │  │ slv_reg0 DATA │──┼──┼─>│ refresh_counter  │   ││──┼──> seg[6:0]
│  │  │  │ slv_reg1 CTRL │──┼──┼─>│ digit_sel (mux)  │   ││──┼──> dp
│  │  │  │ slv_reg2      │  │  │  │ hex_to_7seg      │   ││──┼──> an[3:0]
│  │  │  │ slv_reg3      │  │  │  │ enable logic     │   ││  │
│  │  │  └───────────────┘  │  │  └──────────────────┘   ││  │
│  │  │               ▲     │  │                          ││  │
│  │  │  AR channel ──┤     │  │                          ││  │
│  │  │  R  channel ──┘     │  │                          ││  │
│  │  └─────────────────────┘  └──────────────────────────┘│  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
│  s00_axi_aclk ──────── (100MHz clock)                        │
│  s00_axi_aresetn ───── (active-low reset)                    │
└─────────────────────────────────────────────────────────────┘
```

### Data flow (from C code to LED)

```
Step 1: C code                    Xil_Out32(BASE, 0xCAFE)
                                       │
Step 2: CPU instruction           store word → MicroBlaze M_AXI bus
                                       │
Step 3: SmartConnect              address 0x44A00000 → route to axi_7seg
                                       │
Step 4: AXI handshake             AWADDR=0x00, WDATA=0xCAFE → slv_reg0
                                       │
Step 5: User logic reads reg      hex_data = slv_reg0[15:0] = 0xCAFE
                                       │
Step 6: Refresh counter           cycles 00→01→10→11→00... at ~381Hz
                                       │
Step 7: Digit mux                 digit_sel=00 → nibble = 0xE, an = 1110
                                  digit_sel=01 → nibble = 0xF, an = 1101
                                  digit_sel=10 → nibble = 0xA, an = 1011
                                  digit_sel=11 → nibble = 0xC, an = 0111
                                       │
Step 8: Hex-to-7seg decoder      0xE → 7'b0000110 → segments a,d,e,f,g ON
                                       │
Step 9: FPGA pins                 seg[6:0] → physical pins → LED lights up!
```

---

## 10. Verilog Code Walkthrough

### 10.1 Top wrapper (axi_7seg.v)

This file just connects ports. Think of it as a "box" around the real logic:

```verilog
module axi_7seg (
    output wire [6:0] seg,    // ← external ports to FPGA pins
    output wire       dp,
    output wire [3:0] an,
    input  wire s00_axi_aclk, // ← AXI bus connections
    // ... all AXI signals
);

    // Just instantiate the real module inside
    axi_7seg_v1_0_S00_AXI inst (
        .seg(seg),            // connect external ports
        .dp(dp),
        .an(an),
        .S_AXI_ACLK(s00_axi_aclk),  // connect AXI signals
        // ...
    );
endmodule
```

### 10.2 AXI slave + user logic (axi_7seg_v1_0_S00_AXI.v)

#### Address decoder constants

```verilog
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
// C_S_AXI_DATA_WIDTH = 32
// ADDR_LSB = (32/32) + 1 = 2
// This means: ignore address bits [1:0] (they're byte offset within word)

localparam integer OPT_MEM_ADDR_BITS = 1;
// Use 2 address bits for register select → 2^2 = 4 registers
// Register select = address[ADDR_LSB+1 : ADDR_LSB] = address[3:2]
```

#### Write handshake

```verilog
// Write transfer happens when BOTH master and slave are ready
assign slv_reg_wren = axi_wready && S_AXI_WVALID
                   && axi_awready && S_AXI_AWVALID;

// awready goes high for 1 clock when both AWVALID and WVALID are asserted
always @(posedge S_AXI_ACLK) begin
    if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
        axi_awready <= 1'b1;   // "I accept your address"
    else
        axi_awready <= 1'b0;   // "not ready yet"
end
```

#### Register write with strobes

```verilog
if (slv_reg_wren) begin
    case (axi_awaddr[3:2])       // which register?
        2'b00:                    // offset 0x00 → slv_reg0
            for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
                if (S_AXI_WSTRB[byte_index])  // is this byte enabled?
                    slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
        2'b01:                    // offset 0x04 → slv_reg1
            // ... same pattern
    endcase
end
```

#### Register read

```verilog
// Combinational mux: select read data based on address
always @(*) begin
    case (axi_araddr[3:2])
        2'b00: reg_data_out = slv_reg0;   // CPU reads slv_reg0
        2'b01: reg_data_out = slv_reg1;   // CPU reads slv_reg1
        2'b10: reg_data_out = slv_reg2;
        2'b11: reg_data_out = slv_reg3;
        default: reg_data_out = 0;
    endcase
end
```

#### 7-Segment user logic — refresh counter

```verilog
// 18-bit counter running at 100MHz
reg [17:0] refresh_counter;
wire [1:0] digit_sel = refresh_counter[17:16];  // top 2 bits = digit select

always @(posedge S_AXI_ACLK)
    refresh_counter <= refresh_counter + 1;
```

Why bits [17:16]?

```
Counter counts: 0, 1, 2, ... 262143, 0, 1, 2, ...

Bit [17:16] changes:
  counter 0x00000 - 0x0FFFF → digit_sel = 00 → digit 0 active
  counter 0x10000 - 0x1FFFF → digit_sel = 01 → digit 1 active
  counter 0x20000 - 0x2FFFF → digit_sel = 10 → digit 2 active
  counter 0x30000 - 0x3FFFF → digit_sel = 11 → digit 3 active
  (repeats)

Each digit ON for: 65536 / 100000000 = 0.00066 seconds = 0.66ms
Full cycle:         262144 / 100000000 = 0.0026 seconds = 2.6ms = ~381 Hz

Way too fast for human eye to see → smooth display
```

#### 7-Segment user logic — digit mux

```verilog
always @(*) begin
    case (digit_sel)
        2'b00: begin
            current_nibble = hex_data[3:0];    // rightmost nibble
            anode_reg = 4'b1110;               // AN0 active (LOW = ON)
            dp_reg = ~dp_sel[0];               // dp for digit 0
        end
        2'b01: begin
            current_nibble = hex_data[7:4];
            anode_reg = 4'b1101;               // AN1 active
            dp_reg = ~dp_sel[1];
        end
        2'b10: begin
            current_nibble = hex_data[11:8];
            anode_reg = 4'b1011;               // AN2 active
            dp_reg = ~dp_sel[2];
        end
        2'b11: begin
            current_nibble = hex_data[15:12];  // leftmost nibble
            anode_reg = 4'b0111;               // AN3 active
            dp_reg = ~dp_sel[3];
        end
    endcase
end
```

Visual for `hex_data = 0xCAFE`:

```
digit_sel = 00 → nibble = hex_data[3:0]   = 0xE → AN0 → display "E"
digit_sel = 01 → nibble = hex_data[7:4]   = 0xF → AN1 → display "F"
digit_sel = 10 → nibble = hex_data[11:8]  = 0xA → AN2 → display "A"
digit_sel = 11 → nibble = hex_data[15:12] = 0xC → AN3 → display "C"
```

#### 7-Segment user logic — hex decoder

Converts 4-bit nibble to 7 segment pattern (active LOW):

```verilog
case (current_nibble)
    4'h0: seg_reg = 7'b1000000;  // segments: a b c d e f ON, g OFF
    4'h1: seg_reg = 7'b1111001;  // segments: b c ON
    // ... etc
endcase
```

How to read `7'b1000000`:

```
                    7'b 1  0  0  0  0  0  0
                        │  │  │  │  │  │  │
  bit index:            6  5  4  3  2  1  0
  segment:              g  f  e  d  c  b  a
  state:               OFF ON ON ON ON ON ON
                        │  │  │  │  │  │  │
                        │  │  │  │  │  │  └── a = ON  → top bar
                        │  │  │  │  │  └──── b = ON  → top-right
                        │  │  │  │  └────── c = ON  → bottom-right
                        │  │  │  └──────── d = ON  → bottom bar
                        │  │  └────────── e = ON  → bottom-left
                        │  └──────────── f = ON  → top-left
                        └────────────── g = OFF → middle bar

  Result:    ████
            █    █
            █    █
                       ← no middle bar
            █    █
            █    █
             ████       → shows "0"
```

#### Enable logic

```verilog
assign seg = display_en ? seg_reg   : 7'b1111111;  // all OFF when disabled
assign dp  = display_en ? dp_reg    : 1'b1;        // OFF
assign an  = display_en ? anode_reg : 4'b1111;     // all digits OFF

// display_en = slv_reg1[0]
// So writing 0x01 to CTRL register turns display ON
// Writing 0x00 turns it OFF
```

---

## 11. IP Packaging (component.xml)

The `component.xml` file is what makes Vivado recognize your Verilog as an "IP block" instead of just loose files.

### What it tells Vivado

```
component.xml says:
│
├── "My name is axi_7seg, version 1.0, made by xilinx.com:user"
│
├── "I have a bus interface called S00_AXI"
│   ├── "It's AXI4-Lite, slave mode"
│   ├── "These Verilog ports map to these AXI signals:"
│   │     s00_axi_awaddr  → AWADDR
│   │     s00_axi_wdata   → WDATA
│   │     ... etc
│   └── "My address space is 4KB (4096 bytes)"
│
├── "I have a clock called s00_axi_aclk"
│   ├── "It's associated with the S00_AXI bus"
│   └── "Its reset is s00_axi_aresetn (active LOW)"
│
├── "I have extra output ports: seg[6:0], dp, an[3:0]"
│
├── "My source files are:"
│   ├── hdl/axi_7seg.v
│   ├── hdl/axi_7seg_v1_0_S00_AXI.v
│   └── drivers/...
│
└── "I work on artix7 FPGAs"
```

### Why it matters

Without `component.xml`:
- Vivado can't auto-connect your IP to the SmartConnect
- Vivado can't assign addresses in the Address Editor
- Vivado doesn't know which clock goes with which bus
- Your IP won't show up in the "Add IP" catalog

---

## 12. C Driver

### Header file (axi_7seg.h)

```c
// Register offset constants (must match Verilog!)
#define AXI_7SEG_DATA_OFFSET  0x00   // → slv_reg0
#define AXI_7SEG_CTRL_OFFSET  0x04   // → slv_reg1

// Low-level: write any value to any register
#define AXI_7SEG_mWriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

// Low-level: read any register
#define AXI_7SEG_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

// High-level: set display value
#define AXI_7SEG_SetHex(BaseAddress, Value) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_DATA_OFFSET, (Value) & 0xFFFF)

// High-level: enable/disable
#define AXI_7SEG_Enable(BaseAddress)  ...
#define AXI_7SEG_Disable(BaseAddress) ...
```

### How C code becomes hardware action

```
Your C code:
    AXI_7SEG_SetHex(0x44A00000, 0xCAFE);

Expands to:
    Xil_Out32(0x44A00000 + 0x00, 0xCAFE & 0xFFFF);

Which becomes:
    Xil_Out32(0x44A00000, 0x0000CAFE);

Which the compiler turns into:
    RISC-V instruction: sw x1, 0(x2)
    where x1 = 0x0000CAFE, x2 = 0x44A00000

Which MicroBlaze puts on the AXI bus:
    AWADDR = 0x44A00000
    WDATA  = 0x0000CAFE
    WSTRB  = 4'b1111

SmartConnect routes to axi_7seg:
    offset = 0x00 → slv_reg0

Your Verilog stores it:
    slv_reg0 <= 0x0000CAFE

Your user logic reads it:
    hex_data = slv_reg0[15:0] = 0xCAFE

Display shows: C A F E
```

### Example application (main.c)

```c
#include "xparameters.h"
#include "axi_7seg.h"
#include "sleep.h"

#define SEG_BASE XPAR_AXI_7SEG_0_S00_AXI_BASEADDR

int main() {
    // Display "CAFE"
    AXI_7SEG_SetHex(SEG_BASE, 0xCAFE);
    AXI_7SEG_Enable(SEG_BASE);

    // Count up in hex
    u16 count = 0;
    while (1) {
        AXI_7SEG_SetHex(SEG_BASE, count);
        count++;          // 0x0000 → 0x0001 → ... → 0xFFFF → wraps to 0x0000
        usleep(100000);   // 100ms delay
    }

    return 0;
}
```

---

# Part E: Integration

---

## 13. Vivado Block Design Steps

```
Step 1: Add IP repository
  ┌────────────────────────────┐
  │ Settings → IP → Repository │
  │ [+] → micblaze/ip_repo     │
  │ → OK                       │
  └────────────────────────────┘

Step 2: Remove old GPIO 7-seg (if present)
  - Delete axi_gpio used for 7-segment
  - Delete external ports: seven_seg_led_*

Step 3: Add axi_7seg
  Right-click canvas → Add IP → search "axi_7seg" → double-click

Step 4: Connect AXI bus
  Click "Run Connection Automation" → check S00_AXI → OK
  (auto-connects to SmartConnect, clock, reset)

Step 5: Make display ports external
  Right-click seg → Make External   (becomes seg_0)
  Right-click dp  → Make External   (becomes dp_0)
  Right-click an  → Make External   (becomes an_0)

Step 6: Validate design
  Tools → Validate Design (F6)

Step 7: Create wrapper
  Right-click design_soc → Create HDL Wrapper → Let Vivado manage

Step 8: Generate bitstream
  Flow → Generate Bitstream → wait

Step 9: Export hardware
  File → Export Hardware → Include bitstream → save .xsa file
```

### Result in block design

```
  MicroBlaze ──> SmartConnect ──M00──> axi_uartlite
                              ──M01──> axi_gpio_0 (switches)
                              ──M02──> axi_gpio_1 (LEDs)
                              ──M03──> axi_7seg_0 ──> seg_0[6:0]
                                                  ──> dp_0
                                                  ──> an_0[3:0]
```

---

## 14. XDC Constraints

The XDC maps Verilog port names to physical FPGA pins.

**Port names must match exactly between wrapper and XDC:**

```
Wrapper port name    XDC port name     FPGA pin    What it is
─────────────────    ─────────────     ────────    ──────────
seg_0[0]             seg_0[0]          W7          segment a
seg_0[1]             seg_0[1]          W6          segment b
seg_0[2]             seg_0[2]          U8          segment c
seg_0[3]             seg_0[3]          V8          segment d
seg_0[4]             seg_0[4]          U5          segment e
seg_0[5]             seg_0[5]          V5          segment f
seg_0[6]             seg_0[6]          U7          segment g
dp_0                 dp_0              V7          decimal point
an_0[0]              an_0[0]           U2          anode 0 (rightmost)
an_0[1]              an_0[1]           U4          anode 1
an_0[2]              an_0[2]           V4          anode 2
an_0[3]              an_0[3]           W4          anode 3 (leftmost)
```

The `_0` suffix comes from Vivado auto-naming when you "Make External" on the `axi_7seg_0` instance.

If names don't match → Vivado can't assign pins → defaults to wrong IOSTANDARD (LVCMOS18) → placement fails.

---

## 15. GPIO vs Custom Peripheral

| Aspect | GPIO (axi_gpio) | Custom (axi_7seg) |
|--------|------------------|--------------------|
| **Vivado setup** | Just add GPIO IP, easy | Must write Verilog, package IP |
| **Multiplexing** | Software (CPU does it) | Hardware (FPGA does it) |
| **CPU usage** | 100% (stuck in loop) | 0% (write once, forget) |
| **Display quality** | May flicker (depends on CPU speed) | No flicker (hardware timing) |
| **Code complexity** | Simple but blocking | Simple and non-blocking |
| **Reusability** | None (different code each time) | IP can be reused in any project |
| **Learning** | Good for beginners | Teaches real peripheral design |

### When to use GPIO

- Quick prototyping
- Output doesn't need constant refresh (LEDs, not 7-seg)
- Reading inputs (buttons, switches)

### When to use custom peripheral

- Output needs constant refresh (7-seg, VGA, audio)
- CPU can't afford to be stuck in a loop
- You want clean, reusable IP
- Performance matters

---

## 16. Templates for Other Peripherals

The exact same pattern works for any peripheral. Here's the recipe:

### Recipe

```
1. Copy the axi_7seg structure
2. Change the register map (what each register does)
3. Change the user logic (what happens with register values)
4. Change the output ports (what signals go to FPGA pins)
5. Package as IP → add to block design → write C driver
```

### Example: PWM controller

```verilog
// Register map:
// slv_reg0[7:0]  = duty cycle (0-255)
// slv_reg1[0]    = enable

// User logic:
reg [7:0] pwm_counter;
always @(posedge S_AXI_ACLK)
    pwm_counter <= pwm_counter + 1;

assign pwm_out = slv_reg1[0] && (pwm_counter < slv_reg0[7:0]);

// C code:
// Xil_Out32(PWM_BASE + 0x00, 128);  // 50% duty
// Xil_Out32(PWM_BASE + 0x04, 1);    // enable
```

### Example: Read-only sensor

```verilog
// External sensor data comes in as input port
input wire [15:0] sensor_data;

// Override read mux for reg0 → CPU reads sensor value
case (axi_araddr[3:2])
    2'b00: reg_data_out = {16'b0, sensor_data};  // live sensor data
    2'b01: reg_data_out = slv_reg1;               // normal register
endcase

// C code:
// u32 temp = Xil_In32(SENSOR_BASE + 0x00);  // read sensor
```

### Example: Interrupt source

```verilog
// Add interrupt output
output wire interrupt;

// slv_reg0 = status bits (set by hardware, cleared by CPU write)
// slv_reg1 = interrupt enable mask
assign interrupt = |(slv_reg0 & slv_reg1);

// C code:
// u32 status = Xil_In32(BASE + 0x00);    // check what happened
// Xil_Out32(BASE + 0x00, status);         // clear by writing back
```

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────────┐
│                  axi_7seg Quick Reference                     │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Base: XPAR_AXI_7SEG_0_S00_AXI_BASEADDR                     │
│                                                               │
│  REG0 (0x00): [15:0] = 4 hex digits                          │
│  REG1 (0x04): [0]=enable, [7:4]=decimal points               │
│                                                               │
│  C usage:                                                     │
│    #include "axi_7seg.h"                                      │
│    AXI_7SEG_SetHex(BASE, 0xCAFE);   // show "CAFE"          │
│    AXI_7SEG_Enable(BASE);            // turn on              │
│    AXI_7SEG_Disable(BASE);           // turn off             │
│    AXI_7SEG_SetDP(BASE, 0x04);       // dp on digit 2       │
│                                                               │
│  Pin mapping (Basys3):                                        │
│    seg_0[0]=W7 [1]=W6 [2]=U8 [3]=V8 [4]=U5 [5]=V5 [6]=U7   │
│    dp_0=V7                                                    │
│    an_0[0]=U2  [1]=U4  [2]=V4  [3]=W4                       │
│                                                               │
│  Number systems:                                              │
│    0xCAFE = hex    = 51966 decimal                            │
│    0b1010 = binary = 10 decimal = 0xA hex                    │
│    1 nibble = 4 bits = 1 hex digit                            │
│    1 byte = 8 bits = 2 hex digits = 2 nibbles                │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```
