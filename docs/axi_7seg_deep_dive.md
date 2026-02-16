# Mastering Custom AXI Peripherals: axi_7seg Deep Dive

## Table of Contents
1. [Big Picture - Why Custom Peripheral?](#1-big-picture)
2. [AXI4-Lite Protocol Explained](#2-axi4-lite-protocol)
3. [Architecture of axi_7seg](#3-architecture)
4. [Register Map](#4-register-map)
5. [Verilog Code Walkthrough](#5-verilog-walkthrough)
6. [7-Segment Hardware Logic](#6-seven-segment-logic)
7. [IP Packaging (component.xml)](#7-ip-packaging)
8. [C Driver](#8-c-driver)
9. [Integration in Vivado](#9-integration)
10. [XDC Constraints](#10-xdc-constraints)
11. [Common Patterns for Other Peripherals](#11-common-patterns)

---

## 1. Big Picture

### GPIO approach (old - task3_sevseg)
```
MicroBlaze ──AXI──> axi_gpio_1 ──> seg[6:0], an[3:0]
                    (generic)

CPU must: loop forever → pick digit → set anode → set segments → delay → repeat
Problem:  CPU is 100% busy just refreshing the display
```

### Custom peripheral approach (new - axi_7seg)
```
MicroBlaze ──AXI──> axi_7seg ──> seg[6:0], dp, an[3:0]
                    (dedicated)

CPU just:  write 0xCAFE once → done
Hardware:  auto-multiplexes 4 digits at ~1.5kHz forever
```

### Key difference
| | GPIO | Custom Peripheral |
|---|---|---|
| CPU load | 100% (stuck in loop) | 0% (write once) |
| Refresh | Software (slow, flicker) | Hardware (fast, no flicker) |
| Flexibility | Generic, any purpose | Optimized for 7-segment |
| Complexity | Simple to add | Must write Verilog + package IP |

---

## 2. AXI4-Lite Protocol

AXI4-Lite is a **simplified bus protocol** for register-mapped peripherals. Think of it as a structured way for the CPU to say "write value X to address Y" or "read from address Y".

### Three types of AXI
```
AXI4-Full   → complex, burst transfers (DDR, DMA)
AXI4-Lite   → simple, single register read/write  ← THIS ONE
AXI4-Stream → continuous data flow (audio, video)
```

### AXI4-Lite has 5 channels

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

### Handshake mechanism (VALID/READY)

Every channel uses a **handshake**: data transfers when BOTH valid AND ready are high.

```
        VALID ─────┐     ┌─────
                   │     │
                   └─────┘
        READY ───────┐ ┌───────
                     │ │
                     └─┘
                     ↑
              Transfer happens here
              (both HIGH at same clock edge)
```

### Write transaction (CPU writes to our register)

```
Clock:  ──┬──┬──┬──┬──┬──┬──┬──
          │  │  │  │  │  │  │
AWADDR:   ╔══════╗              ← CPU puts address (0x00 = DATA reg)
AWVALID:  ╔══════╗              ← "address is valid"
AWREADY:     ╔═══╗              ← slave says "I got it"

WDATA:    ╔══════╗              ← CPU puts data (0xBEEF)
WVALID:   ╔══════╗              ← "data is valid"
WREADY:      ╔═══╗              ← slave says "I got it"

BRESP:          ╔═══╗           ← slave response (00 = OK)
BVALID:         ╔═══╗           ← "response ready"
BREADY:   ═══════════╗          ← CPU says "I can accept response"

Result: slv_reg0 now contains 0xBEEF
```

### Read transaction (CPU reads our register)

```
Clock:  ──┬──┬──┬──┬──┬──┬──┬──
          │  │  │  │  │  │  │
ARADDR:   ╔══════╗              ← CPU puts address (0x00)
ARVALID:  ╔══════╗              ← "address is valid"
ARREADY:     ╔═══╗              ← slave says "I got it"

RDATA:          ╔═══╗           ← slave puts data (0xBEEF)
RVALID:         ╔═══╗           ← "data is valid"
RREADY:   ═══════════╗          ← CPU says "I can accept data"

Result: CPU gets 0xBEEF
```

---

## 3. Architecture of axi_7seg

```
┌─────────────────────────────────────────────────────────────┐
│                        axi_7seg (top)                        │
│                                                              │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              axi_7seg_v1_0_S00_AXI                      │ │
│  │                                                          │ │
│  │  ┌──────────────────────┐   ┌─────────────────────────┐ │ │
│  │  │    AXI Slave Logic   │   │   User Logic (7-seg)    │ │ │
│  │  │                      │   │                         │ │ │
│  │  │  AWADDR/WDATA ──────>│   │  slv_reg0[15:0] ──┐    │ │ │
│  │  │  handshake logic     │──>│  (hex_data)       │    │ │ │
│  │  │                      │   │                   ▼    │ │ │
│  │  │  slv_reg0 (DATA)     │   │  ┌────────────────┐   │ │ │
│  │  │  slv_reg1 (CTRL)     │   │  │ Digit Selector │   │ │ │──> seg[6:0]
│  │  │  slv_reg2 (reserved) │   │  │ (refresh_ctr)  │   │ │ │──> dp
│  │  │  slv_reg3 (reserved) │   │  └───────┬────────┘   │ │ │──> an[3:0]
│  │  │                      │   │          │            │ │ │
│  │  │  ARADDR/RDATA <──────│   │          ▼            │ │ │
│  │  │  handshake logic     │   │  ┌────────────────┐   │ │ │
│  │  │                      │   │  │ Hex-to-7seg    │   │ │ │
│  │  └──────────────────────┘   │  │ Decoder        │   │ │ │
│  │                              │  └────────────────┘   │ │ │
│  │                              └─────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                              │
│  AXI Bus ◄──────────────────────────────────────────── clk   │
│  (from SmartConnect)                                  rst    │
└─────────────────────────────────────────────────────────────┘
```

### Two-file structure

| File | Role |
|------|------|
| `axi_7seg.v` | **Top wrapper** - just wires the AXI slave to the outside world |
| `axi_7seg_v1_0_S00_AXI.v` | **All logic** - AXI handshake + registers + 7-segment controller |

Why two files? Vivado's IP packager convention. The top wrapper makes it easy to add multiple AXI interfaces later (e.g., S01_AXI for a second bus).

---

## 4. Register Map

### Address calculation

```
Base address (assigned by Vivado) = e.g., 0x44A0_0000

Register address = Base + Offset

ADDR_LSB = 2  (because 32-bit data = 4 bytes, so bits [1:0] are byte offset)

Register select = address bits [3:2]
  00 → slv_reg0 (offset 0x00)
  01 → slv_reg1 (offset 0x04)
  10 → slv_reg2 (offset 0x08)
  11 → slv_reg3 (offset 0x0C)
```

### Register detail

```
┌─────────────────────────────────────────────────────────────┐
│ REG0: DATA (offset 0x00)                                    │
├─────────────────────────────────────────────────────────────┤
│ 31            16 15    12 11     8 7      4 3      0        │
│ ┌──────────────┬─────────┬────────┬────────┬────────┐       │
│ │   unused     │ digit3  │ digit2 │ digit1 │ digit0 │       │
│ │              │ (AN3)   │ (AN2)  │ (AN1)  │ (AN0)  │       │
│ └──────────────┴─────────┴────────┴────────┴────────┘       │
│                                                              │
│ Each digit = 4-bit nibble = hex 0-F                          │
│ Example: 0x0000CAFE → display shows "C A F E"               │
│          0x00001234 → display shows "1 2 3 4"               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ REG1: CTRL (offset 0x04)                                    │
├─────────────────────────────────────────────────────────────┤
│ 31                    8 7    4   3      1 0                  │
│ ┌──────────────────────┬──────┬──────────┬──┐               │
│ │      unused          │dp_sel│  unused  │en│               │
│ └──────────────────────┴──────┴──────────┴──┘               │
│                                                              │
│ en (bit 0):                                                  │
│   0 = display OFF (all segments off, all anodes off)         │
│   1 = display ON                                             │
│                                                              │
│ dp_sel (bits 7:4):                                           │
│   bit 4 = decimal point on digit 0 (AN0, rightmost)          │
│   bit 5 = decimal point on digit 1 (AN1)                     │
│   bit 6 = decimal point on digit 2 (AN2)                     │
│   bit 7 = decimal point on digit 3 (AN3, leftmost)           │
│                                                              │
│ Example: 0x21 → enable + dp on digit 1                       │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ REG2, REG3 (offset 0x08, 0x0C) - reserved for future use    │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Verilog Walkthrough

### 5.1 AXI Slave Logic (the boring but important part)

This is mostly boilerplate that every AXI peripheral has:

```verilog
// Step 1: Address decode
// ADDR_LSB = 2 means we ignore bits [1:0] (byte offset within 32-bit word)
// OPT_MEM_ADDR_BITS = 1 means we use bits [3:2] → 4 registers max
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;  // = 2
localparam integer OPT_MEM_ADDR_BITS = 1;                    // 2 bits → 4 regs
```

```verilog
// Step 2: Write enable signal
// Transfer happens when BOTH sides are ready
assign slv_reg_wren = axi_wready && S_AXI_WVALID
                   && axi_awready && S_AXI_AWVALID;
```

```verilog
// Step 3: Write to registers
// Address bits [3:2] select which register
case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
    2'h0: slv_reg0[...] <= S_AXI_WDATA[...];  // offset 0x00 → DATA
    2'h1: slv_reg1[...] <= S_AXI_WDATA[...];  // offset 0x04 → CTRL
    2'h2: slv_reg2[...] <= S_AXI_WDATA[...];  // offset 0x08
    2'h3: slv_reg3[...] <= S_AXI_WDATA[...];  // offset 0x0C
endcase
```

```verilog
// Step 4: Write strobe (WSTRB)
// Each bit in WSTRB enables one byte lane
// WSTRB = 4'b1111 → write all 4 bytes
// WSTRB = 4'b0001 → write only byte 0 (bits [7:0])
for (byte_index = 0; byte_index <= 3; byte_index = byte_index+1)
    if (S_AXI_WSTRB[byte_index] == 1)
        slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  ↑
// "+: 8" means "8 bits starting from byte_index*8"
// byte_index=0: bits [7:0]
// byte_index=1: bits [15:8]
// byte_index=2: bits [23:16]
// byte_index=3: bits [31:24]
```

### 5.2 Why write strobes matter

```
Xil_Out32(BASE, 0xCAFE);    → WSTRB = 4'b1111, writes all 4 bytes
Xil_Out16(BASE, 0xCAFE);    → WSTRB = 4'b0011, writes only bytes 0-1
Xil_Out8(BASE+1, 0xCA);     → WSTRB = 4'b0010, writes only byte 1

Without WSTRB handling, Xil_Out8 would corrupt other bytes!
```

---

## 6. 7-Segment Hardware Logic

### 6.1 Refresh counter (digit multiplexing)

```verilog
reg [17:0] refresh_counter;
wire [1:0] digit_sel = refresh_counter[17:16];

always @(posedge S_AXI_ACLK)
    refresh_counter <= refresh_counter + 1;
```

Why 18 bits?
```
Clock = 100 MHz = 100,000,000 cycles/sec

18-bit counter overflows every 2^18 = 262,144 cycles
  → 100,000,000 / 262,144 = ~381 Hz full cycle

Top 2 bits [17:16] change every 2^16 = 65,536 cycles
  → Each digit is ON for 65,536 / 100,000,000 = ~0.66ms
  → All 4 digits cycle at ~381 Hz (no visible flicker)

      digit_sel:  00    01    10    11    00    01 ...
                 ────  ────  ────  ────  ────  ────
                 AN0   AN1   AN2   AN3   AN0   AN1 ...

                 ←──── ~2.6ms one full cycle ────→
```

### 6.2 Digit selector (mux)

```verilog
always @(*) begin
    case (digit_sel)
        2'b00: begin  // rightmost digit
            current_nibble = hex_data[3:0];    // bits [3:0] of DATA reg
            anode_reg = 4'b1110;               // only AN0 active (LOW)
        end
        2'b01: begin
            current_nibble = hex_data[7:4];    // bits [7:4]
            anode_reg = 4'b1101;               // only AN1 active
        end
        2'b10: begin
            current_nibble = hex_data[11:8];   // bits [11:8]
            anode_reg = 4'b1011;               // only AN2 active
        end
        2'b11: begin  // leftmost digit
            current_nibble = hex_data[15:12];  // bits [15:12]
            anode_reg = 4'b0111;               // only AN3 active
        end
    endcase
end
```

Visual:
```
DATA register = 0xCAFE

digit_sel=11    digit_sel=10    digit_sel=01    digit_sel=00
nibble=0xC      nibble=0xA      nibble=0xF      nibble=0xE
an=0111         an=1011         an=1101         an=1110

  ┌───┐          ┌───┐          ┌───┐          ┌───┐
  │ C │          │ A │          │ F │          │ E │
  └───┘          └───┘          └───┘          └───┘
  AN3            AN2            AN1            AN0
  (leftmost)                                   (rightmost)
```

### 6.3 Hex-to-7-segment decoder

```
7-segment display pin mapping:

     aaaa          seg[0] = a
    f    b         seg[1] = b
    f    b         seg[2] = c
     gggg          seg[3] = d
    e    c         seg[4] = e
    e    c         seg[5] = f
     dddd  .dp     seg[6] = g

Common Anode = segments are ACTIVE LOW
  0 = segment ON (current flows)
  1 = segment OFF
```

```verilog
case (current_nibble)
//                   gfedcba
    4'h0: seg_reg = 7'b1000000;  // 0: a,b,c,d,e,f ON     g OFF
    4'h1: seg_reg = 7'b1111001;  // 1: b,c ON               rest OFF
    4'h2: seg_reg = 7'b0100100;  // 2: a,b,d,e,g ON         c,f OFF
    4'h3: seg_reg = 7'b0110000;  // 3: a,b,c,d,g ON         e,f OFF
    4'h4: seg_reg = 7'b0011001;  // 4: b,c,f,g ON           a,d,e OFF
    4'h5: seg_reg = 7'b0010010;  // 5: a,c,d,f,g ON         b,e OFF
    4'h6: seg_reg = 7'b0000010;  // 6: a,c,d,e,f,g ON       b OFF
    4'h7: seg_reg = 7'b1111000;  // 7: a,b,c ON             rest OFF
    4'h8: seg_reg = 7'b0000000;  // 8: all ON
    4'h9: seg_reg = 7'b0010000;  // 9: a,b,c,d,f,g ON       e OFF
    4'hA: seg_reg = 7'b0001000;  // A: a,b,c,e,f,g ON       d OFF
    4'hB: seg_reg = 7'b0000011;  // b: c,d,e,f,g ON         a,b OFF
    4'hC: seg_reg = 7'b1000110;  // C: a,d,e,f ON           b,c,g OFF
    4'hD: seg_reg = 7'b0100001;  // d: b,c,d,e,g ON         a,f OFF
    4'hE: seg_reg = 7'b0000110;  // E: a,d,e,f,g ON         b,c OFF
    4'hF: seg_reg = 7'b0001110;  // F: a,e,f,g ON           b,c,d OFF
endcase
```

### 6.4 Enable logic

```verilog
// When disabled: all segments OFF, all anodes OFF
assign seg = display_en ? seg_reg    : 7'b1111111;  // all OFF
assign dp  = display_en ? dp_reg     : 1'b1;        // OFF
assign an  = display_en ? anode_reg  : 4'b1111;     // all OFF (active LOW)
```

---

## 7. IP Packaging (component.xml)

The `component.xml` is an **IP-XACT** file that tells Vivado:

```
component.xml tells Vivado:
├── WHO is this IP?          → vendor, name, version
├── WHAT bus interfaces?     → S00_AXI (AXI4-Lite slave)
├── WHAT ports?              → seg, dp, an, + all AXI signals
├── WHAT address space?      → S00_AXI_reg, range 4096
├── WHAT source files?       → hdl/*.v, drivers/*
└── WHAT FPGA family?        → artix7
```

Key sections:

```xml
<!-- Bus interface: tells Vivado this IP speaks AXI4-Lite -->
<spirit:busType spirit:name="aximm"/>
<spirit:slave>
    <spirit:memoryMapRef spirit:memoryMapRef="S00_AXI"/>
</spirit:slave>

<!-- Memory map: tells Vivado the address range -->
<spirit:range>4096</spirit:range>     <!-- 4KB address space -->
<spirit:width>32</spirit:width>       <!-- 32-bit registers -->

<!-- Clock association: tells Vivado which clock goes with which bus -->
<spirit:name>ASSOCIATED_BUSIF</spirit:name>
<spirit:value>S00_AXI</spirit:value>  <!-- this clock drives S00_AXI -->

<spirit:name>ASSOCIATED_RESET</spirit:name>
<spirit:value>s00_axi_aresetn</spirit:value>  <!-- this reset pairs with clock -->
```

Without `component.xml`, Vivado doesn't know how to:
- Auto-connect your IP to the SmartConnect
- Assign addresses in the Address Editor
- Associate clocks and resets

---

## 8. C Driver

### Header (axi_7seg.h)

```c
// Register offsets (must match Verilog ADDR_LSB calculation)
#define AXI_7SEG_DATA_OFFSET  0x00   // → axi_awaddr[3:2] = 00 → slv_reg0
#define AXI_7SEG_CTRL_OFFSET  0x04   // → axi_awaddr[3:2] = 01 → slv_reg1

// Low-level read/write
#define AXI_7SEG_mWriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
//  ↑ generates AXI write transaction:
//    AWADDR = BaseAddress + RegOffset
//    WDATA  = Data
//    WSTRB  = 0xF (all bytes)

// High-level helpers
#define AXI_7SEG_SetHex(BaseAddress, Value) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_DATA_OFFSET, (Value) & 0xFFFF)
//  ↑ writes to slv_reg0, which the Verilog reads as hex_data[15:0]
```

### How Xil_Out32 becomes an AXI transaction

```
C code:           Xil_Out32(0x44A00000, 0xCAFE)
                       ↓
Compiler:         sw x1, 0(x2)    (RISC-V store word instruction)
                       ↓
MicroBlaze:       puts address 0x44A00000 on M_AXI bus
                       ↓
SmartConnect:     routes to axi_7seg (address matches its range)
                       ↓
axi_7seg:         AWADDR=0x00, WDATA=0x0000CAFE
                  → slv_reg0 = 0x0000CAFE
                  → hex_data = 0xCAFE
                  → display shows "C A F E"
```

---

## 9. Integration in Vivado

### Step-by-step

```
1. Add IP repo:
   Settings → IP → Repository → [+] → select micblaze/ip_repo → OK

2. Open Block Design (design_soc)

3. Remove old GPIO 7-seg connections:
   - Delete axi_gpio_1 (the one driving seven_seg_led_*)
   - Delete external ports: seven_seg_led_an_tri_o, seven_seg_led_disp_tri_o

4. Add axi_7seg:
   Right-click canvas → Add IP → search "axi_7seg" → double-click

5. Run Connection Automation:
   Click banner → select S00_AXI → OK
   (auto-connects to SmartConnect + clock + reset)

6. Make external ports:
   Right-click seg → Make External → rename to "seg"
   Right-click dp  → Make External → rename to "dp"
   Right-click an  → Make External → rename to "an"

7. Assign address:
   Address Editor → auto-assign or set manually (e.g., 0x44A00000)

8. Validate:
   Tools → Validate Design (F6)

9. Generate wrapper:
   Right-click design_soc → Create HDL Wrapper → Let Vivado manage

10. Build:
    Generate Bitstream → wait
    File → Export Hardware → Include bitstream → .xsa file
```

### Block design result
```
                    ┌─────────────────────────────────────────┐
                    │            design_soc                    │
                    │                                          │
  sys_clock ───────>│  clk_wiz_0 ──> 100MHz                   │
  reset ───────────>│  rst_clk_wiz ──> aresetn                │
                    │                                          │
                    │  microblaze_riscv_0                      │
                    │       │ M_AXI                            │
                    │       ▼                                  │
                    │  ┌─────────┐                             │
                    │  │ axi_smc │                             │
                    │  │         ├──M00──> axi_uartlite ──────>│──> usb_uart
                    │  │         ├──M01──> axi_gpio_0 ────────>│──> switches
                    │  │         ├──M02──> axi_gpio_1 ────────>│──> leds
                    │  │         ├──M03──> axi_7seg_0 ────────>│──> seg[6:0]
                    │  │         │                         ───>│──> dp
                    │  └─────────┘                         ───>│──> an[3:0]
                    │                                          │
                    └─────────────────────────────────────────┘
```

---

## 10. XDC Constraints

The XDC maps **Verilog port names** to **physical FPGA pins** on the Basys3:

```tcl
# These port names must match the wrapper's port names EXACTLY
# After Make External + rename in block design:

# 7 Segment Display
set_property -dict { PACKAGE_PIN W7  IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]  ;# a
set_property -dict { PACKAGE_PIN W6  IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]  ;# b
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]  ;# c
set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]  ;# d
set_property -dict { PACKAGE_PIN U5  IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]  ;# e
set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]  ;# f
set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]  ;# g

set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33 } [get_ports dp]        ;# decimal point

set_property -dict { PACKAGE_PIN U2  IOSTANDARD LVCMOS33 } [get_ports {an[0]}]   ;# rightmost
set_property -dict { PACKAGE_PIN U4  IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4  IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4  IOSTANDARD LVCMOS33 } [get_ports {an[3]}]   ;# leftmost
```

Your current XDC already has these exact lines uncommented, so **no changes needed** as long as you rename the external ports in the block design to `seg`, `dp`, `an`.

---

## 11. Common Patterns for Other Peripherals

Now that you understand axi_7seg, you can create ANY custom peripheral using the same pattern:

### Template: read-only sensor

```verilog
// Example: temperature sensor
// CPU reads slv_reg0 to get current temperature
// Hardware writes to slv_reg0 from sensor logic

wire [15:0] temperature;  // from your sensor module

// Override read data for reg0
always @(*) begin
    case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
        2'h0: reg_data_out = {16'b0, temperature};  // read sensor value
        2'h1: reg_data_out = slv_reg1;               // normal register
        default: reg_data_out = 0;
    endcase
end
```

### Template: PWM output

```verilog
// slv_reg0 = duty cycle (0-255)
// slv_reg1[0] = enable
reg [7:0] pwm_counter;
always @(posedge S_AXI_ACLK)
    pwm_counter <= pwm_counter + 1;
assign pwm_out = slv_reg1[0] && (pwm_counter < slv_reg0[7:0]);
```

### Template: interrupt-generating peripheral

```verilog
// Add an interrupt output port
output wire interrupt;

// slv_reg0 = status (read to check, write to clear)
// slv_reg1 = enable mask
assign interrupt = |(slv_reg0 & slv_reg1);  // interrupt if any enabled status bit set
```

### The recipe (works for any peripheral)

```
1. Start from AXI Lite slave template (Vivado generates this)
2. Decide your register map:
   - Which registers does the CPU write? (control, data out)
   - Which registers does the CPU read? (status, data in)
3. Add your custom ports (output wires, input wires)
4. Connect registers to your logic:
   - Outputs: assign my_output = slv_reg0[...];
   - Inputs: override reg_data_out in the read mux
5. Package as IP (component.xml)
6. Add to block design → connect → build
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                  axi_7seg Quick Reference                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Base Address: XPAR_AXI_7SEG_0_S00_AXI_BASEADDR            │
│                                                              │
│  REG0 (0x00) DATA:  [15:0] = 4 hex digits                  │
│  REG1 (0x04) CTRL:  [0]=enable, [7:4]=decimal points       │
│                                                              │
│  C code:                                                     │
│    #include "axi_7seg.h"                                     │
│    AXI_7SEG_SetHex(BASE, 0xCAFE);   // show "CAFE"         │
│    AXI_7SEG_Enable(BASE);            // turn on             │
│    AXI_7SEG_Disable(BASE);           // turn off            │
│    AXI_7SEG_SetDP(BASE, 0x04);       // dp on digit 2      │
│                                                              │
│  Port mapping (Basys3):                                      │
│    seg[0]=W7  seg[1]=W6  seg[2]=U8  seg[3]=V8              │
│    seg[4]=U5  seg[5]=V5  seg[6]=U7  dp=V7                  │
│    an[0]=U2   an[1]=U4   an[2]=V4   an[3]=W4               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```
