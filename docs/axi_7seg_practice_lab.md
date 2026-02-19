# LAB: Build a Custom AXI 7-Segment Peripheral from Scratch

> Do it yourself. No copy-paste. Type every line. Feel every signal.

---

## What You Will Build

A peripheral that:
- Sits on the AXI bus (connected to SmartConnect, no GPIO)
- The CPU writes a 16-bit hex value once → hardware handles the rest
- Multiplexes 4 digits automatically at ~381 Hz
- Has an enable/disable control

**End result:** Write `0xBEEF` from C code → see `bEEF` on the display.

---

## Before You Start

Make sure you have:
- Vivado 2025.2 installed
- Basys3 board (xc7a35tcpg236-1)
- An existing MicroBlaze project (or create one first)
- Know where your `ip_repo` folder is

**Clean slate:** If you already have `axi_7seg` in your ip_repo, rename or delete it.
You're starting fresh.

---

## STEP 1: Create the Directory Skeleton

Open a terminal. Navigate to your project's `ip_repo` folder.

```
ip_repo/
└── axi_7seg_1.0/
    ├── hdl/
    │   ├── axi_7seg_v1_0_S00_AXI.v    ← you will write this
    │   └── axi_7seg.v                  ← you will write this
    └── drivers/
        └── axi_7seg_v1_0/
            ├── data/
            │   ├── axi_7seg.mdd        ← you will write this
            │   └── axi_7seg.tcl        ← you will write this
            └── src/
                ├── axi_7seg.h          ← you will write this
                ├── axi_7seg.c          ← you will write this
                └── Makefile            ← you will write this
```

Create all these folders and empty files now. Don't write anything in them yet.

**Checkpoint:** You should have 7 empty files in the tree above.

---

## STEP 2: Think About Your Register Map

Before writing any Verilog, answer these questions on paper:

1. What data does the CPU need to send to the display?
2. What control does the CPU need?
3. How many registers do you need?

Think about it...

**Answer:**
- **Register 0 (offset 0x00) — DATA:** The 16-bit hex value. 4 nibbles = 4 digits.
- **Register 1 (offset 0x04) — CTRL:** bit 0 = enable, bits [7:4] = decimal point per digit.

Why offset 0x04 and not 0x01? Because AXI uses byte addresses and each register is 32 bits (4 bytes). So register 1 starts at byte 4.

```
Address   Register   Bits Used         Purpose
0x00      slv_reg0   [15:0]            Hex display value
0x04      slv_reg1   [0]               Display enable
                     [7:4]             Decimal point select
```

**Checkpoint:** You understand that 2 registers are enough. Write this table in your notebook.

---

## STEP 3: Write the AXI Slave Module (The Hard Part)

Open `axi_7seg_v1_0_S00_AXI.v`. This is the real module. Everything lives here.

### 3a: Module Header

Type the module declaration. Think about what ports you need:
- **AXI signals** — the standard 23 signals for AXI4-Lite slave
- **Your outputs** — `seg[6:0]`, `dp`, `an[3:0]`

```verilog
`timescale 1 ns / 1 ps

module axi_7seg_v1_0_S00_AXI #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)(
    // YOUR outputs first
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    // AXI signals
    input  wire                                S_AXI_ACLK,
    input  wire                                S_AXI_ARESETN,
    // ... (all 21 remaining AXI signals)
);
```

**Stop. Type all 23 AXI signals yourself.** Group them by channel:
1. Write Address channel: `AWADDR`, `AWPROT`, `AWVALID`, `AWREADY`
2. Write Data channel: `WDATA`, `WSTRB`, `WVALID`, `WREADY`
3. Write Response channel: `BRESP`, `BVALID`, `BREADY`
4. Read Address channel: `ARADDR`, `ARPROT`, `ARVALID`, `ARREADY`
5. Read Data channel: `RDATA`, `RRESP`, `RVALID`, `RREADY`

For each signal, ask yourself: is it input or output? (Hint: `VALID` from master = input, `READY` from slave = output.)

**Checkpoint:** You have a module with 3 custom outputs + 23 AXI signals = 26 ports total.

### 3b: Internal Wires and Registers

Declare the internal AXI state:

```verilog
    // Mirror registers for AXI handshake
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr;
    reg        axi_awready;
    reg        axi_wready;
    reg [1:0]  axi_bresp;
    reg        axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr;
    reg        axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
    reg [1:0]  axi_rresp;
    reg        axi_rvalid;
```

Then the address decoding constants:

```verilog
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;
```

**Why ADDR_LSB = 2?** Because `(32/32) + 1 = 2`. We skip the lowest 2 address bits (byte offset within a 32-bit word). Address bits [3:2] select which register.

**Why OPT_MEM_ADDR_BITS = 1?** Because we have 4 registers (2 bits to address them: 00, 01, 10, 11). This value is the MSB index, so it's `1` (bit positions [1:0] = 2 bits).

Then declare the slave registers:

```verilog
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;  // DATA
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;  // CTRL
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;  // unused (but keep for standard template)
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;  // unused
    wire slv_reg_wren;
    wire slv_reg_rden;
    reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;
```

Connect internal regs to output ports:

```verilog
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;
```

**Checkpoint:** All internal wires declared. No logic yet.

### 3c: Write Channel — The Handshake

This is the part where the CPU writes data to your registers. There are 3 pieces:

**Piece 1: Write Address Ready**
```verilog
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_awready <= 1'b0;
        else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
                axi_awready <= 1'b1;
            else
                axi_awready <= 1'b0;
        end
    end
```

**Read this out loud:** "On clock edge: if reset, clear ready. Otherwise, if I'm not already ready AND master has both address and data valid, accept them (go ready for one cycle)."

**Piece 2: Latch the address**
```verilog
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_awaddr <= 0;
        else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            axi_awaddr <= S_AXI_AWADDR;
    end
```

**Piece 3: Write Data Ready** (same pattern as address ready)
```verilog
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_wready <= 1'b0;
        else if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end
```

**Checkpoint:** Type all three. Understand: ready pulses HIGH for exactly one clock cycle.

### 3d: Write to Registers

Now the actual write. When both ready signals fire:

```verilog
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;
            slv_reg2 <= 0;
            slv_reg3 <= 0;
        end else if (slv_reg_wren) begin
            case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
                2'h0:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h1:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h2:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h3:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                default: begin
                    slv_reg0 <= slv_reg0;
                    slv_reg1 <= slv_reg1;
                    slv_reg2 <= slv_reg2;
                    slv_reg3 <= slv_reg3;
                end
            endcase
        end
    end
```

**Key insight:** `S_AXI_WSTRB` is the write strobe. Each bit says "write this byte". The `+:` operator selects 8 bits starting at position `byte_index*8`. This lets the CPU write individual bytes without corrupting the rest of the register.

**Checkpoint:** The CPU can now write to your registers. Test your understanding: if the CPU writes `0x0000BEEF` to address 0x00, what value does `slv_reg0` get?

### 3e: Write Response

After every write, you must respond "OK":

```verilog
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_bvalid <= 0;
            axi_bresp  <= 2'b0;
        end else begin
            if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0;  // OKAY response
            end else if (S_AXI_BREADY && axi_bvalid)
                axi_bvalid <= 1'b0;
        end
    end
```

### 3f: Read Channel

The CPU reads back from your registers. Same handshake pattern:

```verilog
    // Read address handshake
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 0;
        end else begin
            if (~axi_arready && S_AXI_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr  <= S_AXI_ARADDR;
            end else
                axi_arready <= 1'b0;
        end
    end

    // Read data mux
    always @(*) begin
        case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
            2'h0: reg_data_out = slv_reg0;
            2'h1: reg_data_out = slv_reg1;
            2'h2: reg_data_out = slv_reg2;
            2'h3: reg_data_out = slv_reg3;
            default: reg_data_out = 0;
        endcase
    end

    // Read valid and response
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end else begin
            if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0;
            end else if (axi_rvalid && S_AXI_RREADY)
                axi_rvalid <= 1'b0;
        end
    end

    // Latch read data
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_rdata <= 0;
        else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            axi_rdata <= reg_data_out;
    end
```

**Checkpoint:** The AXI bus infrastructure is done. Everything above this point is boilerplate that ANY AXI peripheral uses. You could copy this for a motor controller, an LED strip, anything. The only unique part is coming next.

---

### 3g: YOUR Logic — The 7-Segment Controller

This is where your peripheral becomes *yours*. Everything above was bus plumbing. Now you make it do something.

**Extract useful signals from registers:**

```verilog
    wire        display_en = slv_reg1[0];
    wire [3:0]  dp_sel     = slv_reg1[7:4];
    wire [15:0] hex_data   = slv_reg0[15:0];
```

Think about what you just did: the CPU writes to `slv_reg0` and `slv_reg1` via AXI. You just "tapped" into those registers to extract the bits you care about. The register is 32 bits but you only need 16 bits of data + a few control bits.

**Refresh counter — the heartbeat of multiplexing:**

```verilog
    reg [17:0] refresh_counter;
    wire [1:0] digit_sel = refresh_counter[17:16];

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
```

**Why 18 bits?** The clock is 100 MHz. An 18-bit counter overflows every 2^18 = 262,144 cycles = ~2.6 ms. But we use bits [17:16] to select the digit, which change every 2^16 = 65,536 cycles = ~655 us. That's ~1526 Hz total switching, or ~381 Hz per digit. Fast enough that your eye sees all 4 digits lit simultaneously.

**Digit multiplexer — pick which nibble shows on which digit:**

```verilog
    reg [3:0] current_nibble;
    reg [3:0] anode_reg;
    reg       dp_reg;

    always @(*) begin
        case (digit_sel)
            2'b00: begin
                current_nibble = hex_data[3:0];    // rightmost digit
                anode_reg      = 4'b1110;           // AN0 active (LOW)
                dp_reg         = ~dp_sel[0];
            end
            2'b01: begin
                current_nibble = hex_data[7:4];
                anode_reg      = 4'b1101;           // AN1 active
                dp_reg         = ~dp_sel[1];
            end
            2'b10: begin
                current_nibble = hex_data[11:8];
                anode_reg      = 4'b1011;           // AN2 active
                dp_reg         = ~dp_sel[2];
            end
            2'b11: begin
                current_nibble = hex_data[15:12];   // leftmost digit
                anode_reg      = 4'b0111;           // AN3 active
                dp_reg         = ~dp_sel[3];
            end
        endcase
    end
```

**Key understanding:**
- Basys3 uses **common anode** — pull the anode LOW to turn ON a digit
- `4'b1110` means: digit 0 ON, digits 1-2-3 OFF
- Only ONE digit is on at any time. But switching at 381 Hz, you see all four.

**Hex-to-7-segment decoder — the lookup table:**

```verilog
    reg [6:0] seg_reg;

    always @(*) begin
        case (current_nibble)
            4'h0: seg_reg = 7'b1000000;  // 0
            4'h1: seg_reg = 7'b1111001;  // 1
            4'h2: seg_reg = 7'b0100100;  // 2
            4'h3: seg_reg = 7'b0110000;  // 3
            4'h4: seg_reg = 7'b0011001;  // 4
            4'h5: seg_reg = 7'b0010010;  // 5
            4'h6: seg_reg = 7'b0000010;  // 6
            4'h7: seg_reg = 7'b1111000;  // 7
            4'h8: seg_reg = 7'b0000000;  // 8
            4'h9: seg_reg = 7'b0010000;  // 9
            4'hA: seg_reg = 7'b0001000;  // A
            4'hB: seg_reg = 7'b0000011;  // b
            4'hC: seg_reg = 7'b1000110;  // C
            4'hD: seg_reg = 7'b0100001;  // d
            4'hE: seg_reg = 7'b0000110;  // E
            4'hF: seg_reg = 7'b0001110;  // F
            default: seg_reg = 7'b1111111;
        endcase
    end
```

**Draw this on paper:** For the digit `0`, segments a-f are ON and g is OFF. Active LOW means ON = 0. So `seg[6:0]` = `gfedcba` = `1000000`. The `g` segment (bit 6) is OFF (1), the rest are ON (0).

Draw the 7-segment shape and label a-g. Then verify at least `0`, `1`, `8`, and `F` yourself.

```
     aaa
    f   b
    f   b
     ggg
    e   c
    e   c
     ddd
```

**Output gating — master enable switch:**

```verilog
    assign seg = display_en ? seg_reg : 7'b1111111;  // all OFF when disabled
    assign dp  = display_en ? dp_reg  : 1'b1;        // dp OFF when disabled
    assign an  = display_en ? anode_reg : 4'b1111;   // all anodes OFF
```

Close the module:
```verilog
endmodule
```

**Checkpoint:** `axi_7seg_v1_0_S00_AXI.v` is complete. This single file contains 100% of the logic: bus + peripheral.

---

## STEP 4: Write the Top Wrapper

Open `axi_7seg.v`. This file is simple — it just wraps the S00_AXI module:

```verilog
`timescale 1 ns / 1 ps

module axi_7seg #(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)(
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    input  wire s00_axi_aclk,
    input  wire s00_axi_aresetn,
    // ... all 21 remaining AXI signals with s00_axi_ prefix (lowercase!)
);

    axi_7seg_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) axi_7seg_v1_0_S00_AXI_inst (
        .seg(seg),
        .dp(dp),
        .an(an),
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        // ... connect all AXI signals
    );

endmodule
```

**Notice the naming convention:**
- Top wrapper uses `s00_axi_` prefix (lowercase) — this is what Vivado IP Integrator expects
- Inner module uses `S_AXI_` prefix (uppercase) — internal convention
- The wrapper maps between them

**Why have a wrapper at all?** Because Vivado's IP packager looks at the top module to identify AXI interfaces by port name patterns. The `s00_axi_` prefix tells Vivado "this is bus interface number 0".

**Checkpoint:** Type the entire wrapper yourself. Make sure every port is connected.

---

## STEP 5: Write the Driver Files

### 5a: axi_7seg.mdd (driver metadata)

```
OPTION psf_version = 2.1;

BEGIN driver axi_7seg

  OPTION supported_peripherals = (axi_7seg);
  OPTION copyfiles = all;
  OPTION VERSION = 1.0;
  OPTION NAME = axi_7seg;

END driver
```

This tells Vitis SDK: "I'm a driver called `axi_7seg`, I support peripherals named `axi_7seg`, copy all my source files."

### 5b: axi_7seg.tcl (parameter extraction)

```tcl
proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "axi_7seg" \
        "NUM_INSTANCES" "DEVICE_ID" "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR"
}
```

This generates `xparameters.h` entries like:
```c
#define XPAR_AXI_7SEG_0_BASEADDR 0x44A00000
```

### 5c: axi_7seg.h (C header)

```c
#ifndef AXI_7SEG_H
#define AXI_7SEG_H

#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

/* Register offsets — must match your Verilog register map! */
#define AXI_7SEG_DATA_OFFSET  0x00
#define AXI_7SEG_CTRL_OFFSET  0x04

/* Low-level read/write */
#define AXI_7SEG_mWriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

#define AXI_7SEG_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/* High-level API */
#define AXI_7SEG_SetHex(BaseAddress, Value) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_DATA_OFFSET, (Value) & 0xFFFF)

#define AXI_7SEG_Enable(BaseAddress) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) | 0x01)

#define AXI_7SEG_Disable(BaseAddress) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) & ~0x01)

#define AXI_7SEG_SetDP(BaseAddress, DpMask) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        (AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) & 0x0F) \
        | (((DpMask) & 0x0F) << 4))

XStatus AXI_7SEG_SelfTest(void *baseaddr_p);

#endif
```

**Trace each macro:** `AXI_7SEG_Enable` reads the current CTRL register, OR's bit 0 to 1, writes it back. This preserves the decimal point bits while flipping enable on.

### 5d: axi_7seg.c (self-test)

```c
#include "axi_7seg.h"

XStatus AXI_7SEG_SelfTest(void *baseaddr_p) {
    u32 baseaddr = (u32)(uintptr_t)baseaddr_p;

    // Write test pattern
    AXI_7SEG_mWriteReg(baseaddr, AXI_7SEG_DATA_OFFSET, 0x1234);
    u32 readback = AXI_7SEG_mReadReg(baseaddr, AXI_7SEG_DATA_OFFSET);

    if ((readback & 0xFFFF) != 0x1234)
        return XST_FAILURE;

    return XST_SUCCESS;
}
```

### 5e: Makefile

```makefile
COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIB=libxil.a
RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I./. -I${INCLUDEDIR}
INCLUDEFILES=*.h
LIBSOURCES=$(wildcard *.c)
OUTS=$(LIBSOURCES:.c=.o)
libs:
	echo "Compiling axi_7seg..."
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS}
	make clean
include:
	${CP} $(INCLUDEFILES) $(INCLUDEDIR)
clean:
	rm -rf ${OUTS}
```

**Checkpoint:** All 7 files written. You have a complete IP.

---

## STEP 6: Package the IP in Vivado

1. **Open Vivado** → Tools → Create and Package New IP
2. Choose "Package a specified directory"
3. Point to `ip_repo/axi_7seg_1.0/`
4. Vivado opens the IP Packager

### In the Packager:

**Identification:**
- Name: `axi_7seg`
- Version: `1.0`
- Display Name: `AXI 7-Segment Display`
- Vendor: your name

**File Groups:**
- Click "Merge changes from File Groups Wizard"
- Ensure both `.v` files appear under Synthesis and Simulation

**Ports and Interfaces:**
- You should see `S00_AXI` auto-detected as an AXI4-Lite slave interface
- `seg`, `dp`, `an` should appear as standalone output ports
- If `S00_AXI` is not detected: right-click → Add Bus Interface → manually configure

**Memory Maps:**
- Should auto-detect a memory map from S00_AXI
- Range: 4K (0x1000) — smallest AXI block

**Review and Package:**
- Fix any warnings (yellow triangles)
- Click "Package IP"

**Checkpoint:** IP packaged. A green check on all categories.

---

## STEP 7: Add the IP to Your Block Design

1. In your MicroBlaze project, go to IP Catalog
2. Right-click → Add Repository → point to `ip_repo/`
3. Click "Refresh All" if it doesn't appear immediately
4. Open your block design (`design_soc`)
5. Right-click → Add IP → search `axi_7seg`
6. Place it
7. Click "Run Connection Automation" — Vivado connects it to SmartConnect automatically
8. The `seg`, `dp`, `an` ports won't auto-connect (they're not bus signals)
9. Right-click each → Make External

**This creates external ports named `seg_0`, `dp_0`, `an_0`** (Vivado appends `_0` because it's instance 0).

10. Validate design (F6)
11. Check the Address Editor — your peripheral should have an address like `0x44A00000`

**Checkpoint:** Block design valid. No errors.

---

## STEP 8: XDC Constraints

Open your `.xdc` file. Add pin mappings for the 7-segment display.

**The port names must match what Vivado generated** — with the `_0` suffix:

```
## 7-Segment Display
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {seg_0[0]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {seg_0[1]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {seg_0[2]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {seg_0[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {seg_0[4]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {seg_0[5]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {seg_0[6]}]

set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports dp_0]

set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an_0[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an_0[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an_0[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {an_0[3]}]
```

**Common mistake:** Using `seg[0]` instead of `seg_0[0]`. If ports don't match, Vivado assigns random IOSTANDARD (LVCMOS18) and no pin → placement fails with error `[Place 30-58]`.

**Checkpoint:** Constraints match the generated external port names exactly.

---

## STEP 9: Generate Bitstream

1. Generate Block Design output products
2. Create HDL Wrapper (let Vivado manage it)
3. Run Synthesis
4. Run Implementation
5. Generate Bitstream

If you get IO placement errors, go back to Step 8 and verify port names.

**Checkpoint:** Bitstream generated successfully.

---

## STEP 10: Write Your C Application

In Vitis IDE, create a new application project. The BSP should auto-detect your `axi_7seg` driver.

```c
#include "xparameters.h"
#include "axi_7seg.h"

int main() {
    u32 base = XPAR_AXI_7SEG_0_BASEADDR;

    // Show 0xBEEF on the display
    AXI_7SEG_SetHex(base, 0xBEEF);
    AXI_7SEG_Enable(base);

    // Turn on decimal point on digit 2
    AXI_7SEG_SetDP(base, 0x04);  // bit 2 = AN2

    // Count up forever
    u16 counter = 0;
    while (1) {
        AXI_7SEG_SetHex(base, counter);
        for (volatile int i = 0; i < 500000; i++);  // delay
        counter++;
    }

    return 0;
}
```

**What happens:**
1. CPU writes `0xBEEF` to register at `base + 0x00`
2. CPU writes `0x01` to register at `base + 0x04` (enable)
3. Hardware immediately starts multiplexing: digit 0 shows F, digit 1 shows E, etc.
4. CPU is free to do other work. The display refreshes automatically.
5. Then the counter loop overwrites the DATA register each iteration

**Checkpoint:** Program runs. Display shows counting hex values.

---

## STEP 11: Verify Your Understanding

Answer these without looking back:

1. How many AXI channels are there and what are they called?
2. What does `WSTRB` do?
3. Why is `ADDR_LSB = 2`?
4. Why is anode `4'b1110` and not `4'b0001`?
5. What happens if you write `0xFFFF` to DATA? What do you see?
6. What happens if you never write to CTRL? Does the display show anything?
7. If you change the refresh counter to 16 bits instead of 18, what changes visually?
8. Where does `XPAR_AXI_7SEG_0_BASEADDR` come from?

**Answers:**
1. 5 channels: Write Address (AW), Write Data (W), Write Response (B), Read Address (AR), Read Data (R)
2. Write Strobe — selects which bytes of the 32-bit word to actually write
3. 32-bit data = 4 bytes, need 2 bits to address within a word, so skip 2 LSBs
4. Common anode — LOW activates. `1110` means only AN0 (rightmost) is pulled LOW = ON
5. All four digits show `F` (all segments except g lit, plus g)
6. No — `slv_reg1` resets to 0, so `display_en = 0`, so `an = 4'b1111` (all OFF)
7. Counter overflows faster → digits switch at ~1526 Hz instead of ~381 Hz. Still looks fine but uses slightly more power. If too fast, could cause ghosting.
8. Auto-generated by `axi_7seg.tcl` into `xparameters.h` based on the address Vivado assigned

---

## What You've Learned

You built a custom AXI4-Lite peripheral from scratch. The pattern is always the same:

```
1. Design your register map (what the CPU writes/reads)
2. Write the AXI slave boilerplate (always the same ~150 lines)
3. Add YOUR logic that reads from the slave registers
4. Wrap it in a top module
5. Write component.xml (or let Vivado's packager do it)
6. Write a C driver header with register offsets
7. Connect in block design → XDC → bitstream → C code → done
```

Next time you want a custom peripheral (PWM, motor driver, sensor interface, LED matrix), you change **only step 3**. The rest is the same skeleton.

---

*Now delete everything and do it again without this guide.*
