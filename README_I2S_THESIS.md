# I2S (Inter-IC Sound) Verilog Module - Thesis Study Guide

## Table of Contents
1. [Introduction to I2S](#introduction-to-i2s)
2. [I2S Protocol Fundamentals](#i2s-protocol-fundamentals)
3. [Signal Description](#signal-description)
4. [Timing Diagrams](#timing-diagrams)
5. [Verilog Implementation Analysis](#verilog-implementation-analysis)
6. [Register Map](#register-map)
7. [FIFO Buffer Design](#fifo-buffer-design)
8. [Bus Interfaces (APB vs AXI)](#bus-interfaces-apb-vs-axi)
9. [Testbench Guide](#testbench-guide)
10. [Design Parameters](#design-parameters)
11. [Integration with FPGA](#integration-with-fpga)
12. [Common Issues and Debugging](#common-issues-and-debugging)

---

## Introduction to I2S

### What is I2S?

**I2S (Inter-IC Sound)** is a serial bus interface standard developed by Philips Semiconductors (now NXP) in 1986. It is specifically designed for transmitting digital audio data between integrated circuits (ICs) in audio equipment.

### Why Use I2S?

| Advantage | Description |
|-----------|-------------|
| **Simplicity** | Only 3 wires needed for basic operation |
| **Synchronous** | Clock signal ensures reliable data transfer |
| **Standard** | Widely supported by audio DACs, ADCs, and codecs |
| **Low Latency** | Direct serial transfer with minimal buffering |
| **Flexibility** | Supports various bit depths and sample rates |

### Common Applications

- Digital audio players (MP3 players, smartphones)
- Audio DAC/ADC interfaces
- Digital signal processors (DSPs)
- Bluetooth audio modules
- Professional audio equipment
- Embedded audio systems

---

## I2S Protocol Fundamentals

### Three Essential Signals

```
┌──────────────────────────────────────────────────────────────────┐
│                       I2S CONNECTION                              │
│                                                                   │
│   ┌─────────────┐                          ┌─────────────┐       │
│   │             │───── SCK (Serial Clock) ─────▶│             │   │
│   │   MASTER    │───── WS  (Word Select)  ─────▶│   SLAVE     │   │
│   │  (e.g.MCU)  │───── SD  (Serial Data)  ─────▶│  (e.g.DAC)  │   │
│   │             │                          │             │       │
│   └─────────────┘                          └─────────────┘       │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Signal Definitions

| Signal | Full Name | Direction | Description |
|--------|-----------|-----------|-------------|
| **SCK** | Serial Clock | Master → Slave | Bit clock, one pulse per data bit |
| **WS** | Word Select | Master → Slave | Channel indicator (0=Left, 1=Right) |
| **SD** | Serial Data | Transmitter → Receiver | Audio data bits (MSB first) |

### Data Format

I2S transmits audio data with these characteristics:

1. **MSB First**: Most significant bit is transmitted first
2. **Two's Complement**: Signed audio samples
3. **Left-Justified or Standard**: Data alignment relative to WS edge
4. **Word Length**: Typically 16, 24, or 32 bits per channel

---

## Timing Diagrams

### Standard I2S Timing (Philips Standard)

```
                    ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐
SCK ────────────────┘   └───┘   └───┘   └───┘   └───┘   └───┘   └───
                    ↑   ↑   ↑   ↑   ↑   ↑   ↑   ↑   ↑
                   Rising edges: Data is sampled

        ┌───────────────────────────────────────┐
WS  ────┘         LEFT CHANNEL                  └──────────────────
                                                 RIGHT CHANNEL

        ←─── 1 bit delay ───┼───────────────────────────────────────
SD          D(n-1) │ D(n-2) │ D(n-3) │ ... │ D(1) │ D(0) │
           (MSB)   │        │        │     │      │(LSB) │
```

### Detailed 32-bit Frame Timing

```
                            LEFT CHANNEL (32 bits)                    RIGHT CHANNEL (32 bits)
        ├──────────────────────────────────────────────────────┤├──────────────────────────────────────────────────────┤

WS      ─────────────────────────────────────────────────────────┐
        │                    LOW (0)                             │                    HIGH (1)
        └─────────────────────────────────────────────────────────────────────────────────────────────────────────────

SCK     ─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬
          0 1 2 3 4 5 6 7 8 9...                              31  0 1 2 3 4 5 6 7 8 9...                              31

SD       │B31│B30│B29│B28│B27│...│B1 │B0 │   │B31│B30│B29│...
         (MSB)                      (LSB)     (MSB)
         ←────── Left Audio Data ───────→     ←────── Right Audio Data ───────→
```

### Clock Relationship

For a typical audio configuration:
- **Sample Rate**: 48 kHz (samples per second per channel)
- **Bit Depth**: 24 bits per sample
- **Channels**: 2 (stereo)

```
SCK Frequency = Sample Rate × Bit Depth × Channels
SCK = 48,000 × 24 × 2 = 2.304 MHz

For 32-bit frames (padded):
SCK = 48,000 × 32 × 2 = 3.072 MHz
```

---

## Verilog Implementation Analysis

### Module Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            I2S MODULE                                        │
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌────────────┐ │
│  │              │    │              │    │              │    │            │ │
│  │  APB/AXI     │───▶│   REGISTER   │───▶│    FIFO      │───▶│ I2S TX     │ │
│  │  INTERFACE   │    │     FILE     │    │   BUFFER     │    │  LOGIC     │ │
│  │              │    │              │    │              │    │            │ │
│  └──────────────┘    └──────────────┘    └──────────────┘    └────────────┘ │
│         │                   │                   │                   │        │
│         │                   │                   │                   ▼        │
│         │                   │                   │           ┌────────────┐  │
│         │                   │                   │           │  SCK       │  │
│         │                   │                   │           │  WS        │  │
│         │                   │                   │           │  SD        │  │
│         │                   │                   │           └────────────┘  │
│         │                   │                   │                            │
│         └───────────────────┴───────────────────┴──────────▶ IRQ            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Key Verilog Code Components

#### 1. Clock Divider (SCK Generation)

```verilog
// I2S clock generation (sck) with clock division
always @(posedge pclk or negedge presetn) begin
  if (!presetn) begin
    sck_reg <= 0;
    clk_count <= 0;
  end else if (clk_count < div) begin
    clk_count <= clk_count + 1;
    sck_reg <= 0;
  end else begin
    clk_count <= 0;
    sck_reg <= ~sck_reg;  // Toggle sck every div cycles
  end
end
```

**Explanation**:
- `pclk` is the APB/system clock (e.g., 100 MHz)
- `div` is the programmable division factor
- `sck_reg` toggles every `div` clock cycles
- SCK frequency = pclk / (2 × div)

**Example Calculation**:
```
If pclk = 100 MHz and div = 32:
SCK = 100 MHz / (2 × 32) = 1.5625 MHz
```

#### 2. Word Select Generation (Channel Indicator)

```verilog
// I2S word select generation (ws), toggling every 32 bits
always @(posedge sck or negedge presetn) begin
  if (!presetn) begin
    ws_reg <= 1;
    ws_count <= 0;
  end else if (ws_count < 31) begin
    ws_count <= ws_count + 1;
  end else begin
    ws_count <= 0;
    ws_reg <= ~ws_reg;  // Toggle ws every 32 clock cycles
  end
end
```

**Explanation**:
- WS toggles every 32 SCK cycles
- WS=0 indicates LEFT channel
- WS=1 indicates RIGHT channel
- Creates a complete stereo frame of 64 SCK cycles

#### 3. Serial Data Shift-Out

```verilog
// I2S serial data output (sd), sends 1 bit per sck cycle
always @(posedge sck or negedge presetn) begin
  if (!presetn) begin
    bit_count <= 31;
  end else begin
    sd <= data_fifo[bit_count];  // Output data bit
    bit_count <= bit_count - 1;
  end
end
```

**Explanation**:
- Shifts out 1 bit per SCK rising edge
- Starts from MSB (bit 31) down to LSB (bit 0)
- `data_fifo` holds the current audio sample

---

## Register Map

### Address Space

| Address | Register Name | Access | Description |
|---------|---------------|--------|-------------|
| 0x00 | CONTROL_REG | R/W | Control and clock division |
| 0x04 | DATA_REG | W | Audio data (writes to FIFO) |
| 0x08 | INTERRUPT_REG | R/W | Interrupt enable/status |
| 0x0C | STATE_REG | R | Module state and FIFO status |

### CONTROL_REG (0x00)

```
┌───────────────────────────────────────────────────────────────┐
│ 31                              8 │ 7                       0 │
│           Reserved                │          DIV             │
└───────────────────────────────────────────────────────────────┘
```

| Bits | Field | Description |
|------|-------|-------------|
| [7:0] | DIV | Clock divider value. SCK = PCLK / (2 × DIV) |
| [31:8] | Reserved | Reserved for future use |

### DATA_REG (0x04)

```
┌───────────────────────────────────────────────────────────────┐
│ 31                              16│ 15                      0 │
│         Left Channel              │      Right Channel        │
│            OR                     │         OR                │
│       Full 32-bit Sample          │                           │
└───────────────────────────────────────────────────────────────┘
```

Writing to this register pushes data into the FIFO buffer.

### INTERRUPT_REG (0x08)

```
┌───────────────────────────────────────────────────────────────┐
│ 31                                                          1 │ 0 │
│                          Reserved                             │IE │
└───────────────────────────────────────────────────────────────┘
```

| Bit | Field | Description |
|-----|-------|-------------|
| [0] | IE | Interrupt Enable (1=enabled, 0=disabled) |

### STATE_REG (0x0C)

```
┌───────────────────────────────────────────────────────────────┐
│ 31                              2 │ 1    │ 0                  │
│           Reserved                │EMPTY │ FULL               │
└───────────────────────────────────────────────────────────────┘
```

---

## FIFO Buffer Design

### Purpose of FIFO

The FIFO (First-In-First-Out) buffer serves crucial purposes:

1. **Decouples Clock Domains**: APB clock vs I2S SCK clock
2. **Prevents Underrun**: Buffers data for continuous transmission
3. **Interrupt Generation**: Signals when buffer needs service

### FIFO Architecture

```
                    ┌────────────────────────────────────────┐
                    │              FIFO MEMORY               │
                    │          mem[3:0] (4 × 32-bit)         │
    APB Clock       │                                        │       SCK Clock
    Domain          │   ┌────┐ ┌────┐ ┌────┐ ┌────┐          │       Domain
        │           │   │ 0  │ │ 1  │ │ 2  │ │ 3  │          │           │
        ▼           │   └────┘ └────┘ └────┘ └────┘          │           ▼
   ┌────────┐       │      ▲                    ▲            │      ┌────────┐
   │ wr_ptr │───────│──────┘                    │            │──────│ rd_ptr │
   └────────┘       │   Write                  Read          │      └────────┘
                    │   Pointer               Pointer         │
                    └────────────────────────────────────────┘

   Full Condition:  wr_ptr == {~rd_ptr[2], rd_ptr[1:0]}
   Empty Condition: wr_ptr == rd_ptr
```

### Pointer Logic Explained

The FIFO uses 3-bit pointers with clever wrap-around detection:

```verilog
reg [2:0] wr_ptr, rd_ptr;  // 3 bits for 4-entry FIFO

// Full: pointers differ only in MSB
assign fifo_full  = (wr_ptr == {~rd_ptr[2], rd_ptr[1:0]});

// Empty: pointers are equal
assign fifo_empty = (wr_ptr == rd_ptr);
```

**Why 3 bits for 4 entries?**
- Bits [1:0] address the memory (0-3)
- Bit [2] is wrap-around indicator
- Allows distinguishing full from empty

---

## Bus Interfaces (APB vs AXI)

### APB (Advanced Peripheral Bus)

The APB version (`I2S.v`) uses a simple 2-phase protocol:

```
        Setup Phase        Access Phase
            │                    │
            ▼                    ▼
PCLK   ─────┬─────┬─────┬─────┬─────┬─────
            │     │     │     │     │
PSEL   ─────┴─────┴─────┴─────┴─────┴─────
                  │                 │
PENABLE ──────────┴─────────────────┴─────
                  │                 │
PWRITE ───────────┴─────────────────┴─────
```

**APB Signals**:
| Signal | Description |
|--------|-------------|
| PCLK | Clock |
| PRESETn | Active-low reset |
| PSEL | Peripheral select |
| PENABLE | Enable (second phase) |
| PWRITE | Write=1, Read=0 |
| PADDR | Address bus |
| PWDATA | Write data |
| PRDATA | Read data |

### AXI4-Lite

The AXI version (`i2s_axi.v`) uses separate read/write channels:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         AXI4-LITE CHANNELS                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   ┌─────────────┐                           ┌─────────────┐             │
│   │ Write Addr  │───── AWADDR, AWVALID ────▶│             │             │
│   │   Channel   │◀──── AWREADY ────────────│             │             │
│   └─────────────┘                           │             │             │
│                                             │             │             │
│   ┌─────────────┐                           │    I2S      │             │
│   │ Write Data  │───── WDATA, WVALID ─────▶│   SLAVE     │             │
│   │   Channel   │◀──── WREADY ─────────────│             │             │
│   └─────────────┘                           │             │             │
│                                             │             │             │
│   ┌─────────────┐                           │             │             │
│   │ Write Resp  │◀──── BRESP, BVALID ──────│             │             │
│   │   Channel   │───── BREADY ────────────▶│             │             │
│   └─────────────┘                           │             │             │
│                                             │             │             │
│   ┌─────────────┐                           │             │             │
│   │ Read Addr   │───── ARADDR, ARVALID ───▶│             │             │
│   │   Channel   │◀──── ARREADY ────────────│             │             │
│   └─────────────┘                           │             │             │
│                                             │             │             │
│   ┌─────────────┐                           │             │             │
│   │ Read Data   │◀──── RDATA, RRESP, RVALID│             │             │
│   │   Channel   │───── RREADY ────────────▶│             │             │
│   └─────────────┘                           └─────────────┘             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Comparison

| Feature | APB | AXI4-Lite |
|---------|-----|-----------|
| Complexity | Simple | Medium |
| Performance | Lower | Higher |
| Pipelining | No | Yes |
| Channels | Shared | Separate R/W |
| Use Case | Simple peripherals | Higher throughput |

---

## Testbench Guide

### Testbench Structure (`I2S_TB.v`)

```verilog
module testI2S;
  // 1. Declare signals
  reg pclk, presetn, psel, penable, pwrite;
  reg [31:0] paddr, pwdata;
  wire [31:0] prdata;
  wire irq, sck, ws, sd;

  // 2. Generate clock
  always #5 pclk = ~pclk;  // 100 MHz (10ns period)

  // 3. Stimulus
  initial begin
    // Reset
    pclk = 0; presetn = 0;
    #20 presetn = 1;

    // Configure and send data
    // ...
  end

  // 4. Instantiate DUT
  i2s dut (...);
endmodule
```

### Test Sequence

1. **Reset Phase**
   ```verilog
   presetn = 0;
   #20 presetn = 1;
   ```

2. **Configure Interrupts**
   ```verilog
   paddr = 8'h08;
   pwdata = 32'h00000001;  // Enable interrupt
   ```

3. **Set Clock Divider**
   ```verilog
   paddr = 8'h00;
   pwdata = 32'h00000001;  // div = 1
   ```

4. **Write Audio Data**
   ```verilog
   paddr = 8'h04;
   pwdata = 32'h11111111;  // Sample data
   ```

### Expected Waveforms

Use a waveform viewer (GTKWave, ModelSim) to observe:

```
Time(ns)  0    20   30   40   50   60   70   80
          │    │    │    │    │    │    │    │
presetn   ─────┘────────────────────────────────
pclk      ─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─
sck       ─────────────┬───┬───┬───┬───┬───┬───
ws        ─────────────┴───────────────────────
sd        ─────────────X───X───X───X───X───X───
```

---

## Design Parameters

### Configurable Parameters

| Parameter | Your Design | Typical Range |
|-----------|-------------|---------------|
| Bit Depth | 24 bits | 16, 24, 32 bits |
| Sample Rate | 96 kHz | 44.1, 48, 96, 192 kHz |
| FIFO Depth | 4 entries | 4-256 entries |
| System Clock | 100 MHz | 50-200 MHz |

### Calculating Clock Divider

```
Required SCK = Sample Rate × Bits per Frame × 2 (channels)

For 96 kHz, 24-bit (padded to 32):
SCK = 96,000 × 32 × 2 = 6.144 MHz

If PCLK = 100 MHz:
DIV = PCLK / (2 × SCK)
DIV = 100 MHz / (2 × 6.144 MHz) ≈ 8
```

---

## Integration with FPGA

### Block Diagram (Xilinx Vivado)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          FPGA SYSTEM                                     │
│                                                                          │
│   ┌──────────────┐     ┌─────────────┐     ┌─────────────────┐          │
│   │              │     │             │     │                 │          │
│   │  MicroBlaze  │────▶│    AXI      │────▶│  I2S            │──▶ SCK   │
│   │   RISC-V     │     │ Interconnect│     │  Transmitter    │──▶ WS    │
│   │              │     │             │     │                 │──▶ SD    │
│   └──────────────┘     └─────────────┘     └─────────────────┘          │
│          │                    │                                          │
│          │                    ▼                                          │
│          │             ┌─────────────┐                                   │
│          │             │  UART       │───▶ TX                            │
│          │             └─────────────┘                                   │
│          │                                                               │
│          ▼                                                               │
│   ┌──────────────┐                                                       │
│   │  Block RAM   │                                                       │
│   │  (Program)   │                                                       │
│   └──────────────┘                                                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Pin Assignment Example (Constraints)

```tcl
# I2S Output Pins (Example for Arty A7)
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports sck]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports ws]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports sd]
```

---

## Common Issues and Debugging

### Issue 1: No Output on SCK

**Symptoms**: SCK remains constant
**Causes**:
- Reset not released
- DIV value is 0 or too large
- Clock not connected

**Solution**:
```verilog
// Ensure DIV is set correctly
control_reg <= 32'h00000022;  // Default DIV = 34
```

### Issue 2: Glitchy WS Signal

**Symptoms**: WS toggles at wrong times
**Causes**:
- Asynchronous reset glitches
- Incorrect bit counter

**Solution**:
```verilog
// Use synchronous reset or proper synchronization
always @(posedge sck) begin
  if (!aresetn_sync) ...
end
```

### Issue 3: FIFO Underrun

**Symptoms**: Same data repeated, IRQ constantly asserted
**Causes**:
- Software not feeding data fast enough
- FIFO depth too small

**Solution**:
- Increase FIFO depth
- Use DMA for data transfer
- Optimize software loop

### Issue 4: Audio Distortion

**Symptoms**: Audible clicks, noise
**Causes**:
- Clock jitter
- Wrong sample format
- Timing violations

**Solution**:
- Use clean clock source (PLL)
- Verify data alignment (MSB first)
- Check timing constraints

---

## References and Resources

### Specifications
- [I2S Bus Specification (Philips/NXP)](https://www.nxp.com/docs/en/user-manual/UM11732.pdf)
- [AXI4-Lite Specification (ARM)](https://developer.arm.com/documentation/ihi0022/latest)

### Academic Resources
- UC Berkeley EECS 151 - Digital Design (Labs include I2S)
- https://inst.eecs.berkeley.edu/~eecs151/

### Tools
- Xilinx Vivado Design Suite
- GTKWave (Waveform Viewer)
- Icarus Verilog (Open Source Simulator)

---

## Quick Reference Card

### I2S Formulas

```
SCK Frequency = Sample_Rate × Bits_Per_Frame × Num_Channels
WS Frequency  = Sample_Rate
DIV Value     = System_Clock / (2 × SCK_Frequency)
```

### Typical Configurations

| Sample Rate | Bit Depth | SCK (MHz) | DIV (100MHz sys) |
|-------------|-----------|-----------|------------------|
| 44.1 kHz | 16 | 1.411 | 35 |
| 48 kHz | 16 | 1.536 | 33 |
| 48 kHz | 24 | 2.304 | 22 |
| 96 kHz | 24 | 4.608 | 11 |
| 96 kHz | 32 | 6.144 | 8 |

---

*This document is part of the I2S Verilog Module Thesis project.*
*Created for educational purposes.*
