# Task 4: Seven-Segment Display using Custom AXI Peripheral on MicroBlaze (Basys3)

> Custom AXI4-Lite IP for driving 4-digit seven-segment display on Basys3 FPGA, controlled by MicroBlaze RISC-V soft processor.

## Overview

| Item | Detail |
|------|--------|
| Board | Digilent Basys3 (xc7a35tcpg236-1) |
| Tool | Vivado 2025.2 + Vitis 2025.2 |
| Processor | MicroBlaze RISC-V |
| Custom IP | `axi_7seg` v1.0 (AXI4-Lite slave) |
| Display | 4-digit common-anode seven-segment |
| Base Address | `0x44A10000` |

## Architecture

```
MicroBlaze RISC-V
       |
   AXI SmartConnect
       |
  +---------+----------+-----------+
  |         |          |           |
AXI_GPIO_0 AXI_GPIO_1 AXI_UART  axi_7seg_0
(LED/SW)   (DIP)      (USB)     (7-Segment)
                                  |
                          +-------+-------+
                          |       |       |
                        seg[6:0] an[3:0]  dp
                          |       |       |
                     (FPGA Pins - Basys3 7-seg)
```

## Part A: Create the Custom AXI IP in Vivado

### A1. Create and Package IP

1. Open your Vivado project
2. **Tools** > **Create and Package New IP**
3. Select **Create a new AXI4 peripheral**
4. Fill in:
   - Name: `axi_7seg`
   - Version: `1.0`
   - Display name: `AXI4-Lite 7-Segment Display Controller for Basys3`
   - Repository path: `<project>/ip_repo`
5. Interface: **1x Slave AXI4-Lite**, 4 registers, 32-bit data
6. Select **Edit IP** and click **Finish**

> SCREENSHOT A1: "Create and Package New IP" wizard showing the AXI4 settings

### A2. Edit the HDL - Top Module (`axi_7seg.v`)

Replace the generated top module with the following. This adds 3 output ports (`seg`, `dp`, `an`) and passes them to the AXI slave module.

```verilog
`timescale 1 ns / 1 ps

module axi_7seg #(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)(
    // 7-segment display outputs
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    // AXI Slave Bus Interface S00_AXI
    input  wire                                    s00_axi_aclk,
    input  wire                                    s00_axi_aresetn,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]         s00_axi_awaddr,
    input  wire [2:0]                              s00_axi_awprot,
    input  wire                                    s00_axi_awvalid,
    output wire                                    s00_axi_awready,
    input  wire [C_S00_AXI_DATA_WIDTH-1:0]         s00_axi_wdata,
    input  wire [(C_S00_AXI_DATA_WIDTH/8)-1:0]     s00_axi_wstrb,
    input  wire                                    s00_axi_wvalid,
    output wire                                    s00_axi_wready,
    output wire [1:0]                              s00_axi_bresp,
    output wire                                    s00_axi_bvalid,
    input  wire                                    s00_axi_bready,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]         s00_axi_araddr,
    input  wire [2:0]                              s00_axi_arprot,
    input  wire                                    s00_axi_arvalid,
    output wire                                    s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1:0]         s00_axi_rdata,
    output wire [1:0]                              s00_axi_rresp,
    output wire                                    s00_axi_rvalid,
    input  wire                                    s00_axi_rready
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
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWPROT(s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WSTRB(s00_axi_wstrb),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready)
    );

endmodule
```

### A3. Edit the HDL - AXI Slave Module (`axi_7seg_v1_0_S00_AXI.v`)

This is the main logic. Replace the generated slave module. Key features:
- **Register 0** (`+0x00`): 16-bit hex display value (4 nibbles = 4 digits)
- **Register 1** (`+0x04`): Control - bit[0] = display enable, bits[7:4] = decimal point select
- Built-in **hex-to-7seg decoder** (0-F)
- Built-in **4-digit multiplexing** using 18-bit refresh counter (~381Hz per digit)

```verilog
`timescale 1 ns / 1 ps

module axi_7seg_v1_0_S00_AXI #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)(
    // 7-segment outputs
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    // AXI Lite Slave Interface
    input  wire                                S_AXI_ACLK,
    input  wire                                S_AXI_ARESETN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       S_AXI_AWADDR,
    input  wire [2:0]                          S_AXI_AWPROT,
    input  wire                                S_AXI_AWVALID,
    output wire                                S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0]       S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]   S_AXI_WSTRB,
    input  wire                                S_AXI_WVALID,
    output wire                                S_AXI_WREADY,
    output wire [1:0]                          S_AXI_BRESP,
    output wire                                S_AXI_BVALID,
    input  wire                                S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       S_AXI_ARADDR,
    input  wire [2:0]                          S_AXI_ARPROT,
    input  wire                                S_AXI_ARVALID,
    output wire                                S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0]       S_AXI_RDATA,
    output wire [1:0]                          S_AXI_RRESP,
    output wire                                S_AXI_RVALID,
    input  wire                                S_AXI_RREADY
);

    // === AXI4LITE signals ===
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

    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;

    // === Slave registers ===
    // slv_reg0[15:0] = 16-bit hex display value (4 nibbles = 4 digits)
    // slv_reg1[0]    = display enable
    // slv_reg1[7:4]  = decimal point select (1 bit per digit)
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
    wire slv_reg_wren;
    wire slv_reg_rden;
    reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // === Write address handshake ===
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awready <= 1'b0;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
                axi_awready <= 1'b1;
            else
                axi_awready <= 1'b0;
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_awaddr <= 0;
        else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            axi_awaddr <= S_AXI_AWADDR;
    end

    // === Write data handshake ===
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_wready <= 1'b0;
        else if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end

    // === Write register logic ===
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

    // === Write response ===
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_bvalid <= 0;
            axi_bresp  <= 2'b0;
        end else begin
            if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0;
            end else if (S_AXI_BREADY && axi_bvalid)
                axi_bvalid <= 1'b0;
        end
    end

    // === Read address handshake ===
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

    // === Read data ===
    always @(*) begin
        case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
            2'h0: reg_data_out = slv_reg0;
            2'h1: reg_data_out = slv_reg1;
            2'h2: reg_data_out = slv_reg2;
            2'h3: reg_data_out = slv_reg3;
            default: reg_data_out = 0;
        endcase
    end

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

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_rdata <= 0;
        else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            axi_rdata <= reg_data_out;
    end

    // ============================================================
    // USER LOGIC: 7-Segment Display Controller
    // ============================================================

    wire        display_en = slv_reg1[0];
    wire [3:0]  dp_sel     = slv_reg1[7:4];
    wire [15:0] hex_data   = slv_reg0[15:0];

    // Refresh counter for digit multiplexing
    // At 100MHz, 18-bit counter gives ~381Hz refresh per digit
    reg [17:0] refresh_counter;
    wire [1:0] digit_sel = refresh_counter[17:16];

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // Select which nibble to display based on active digit
    reg [3:0] current_nibble;
    reg [3:0] anode_reg;
    reg       dp_reg;

    always @(*) begin
        case (digit_sel)
            2'b00: begin
                current_nibble = hex_data[3:0];
                anode_reg      = 4'b1110;   // AN0 active
                dp_reg         = ~dp_sel[0];
            end
            2'b01: begin
                current_nibble = hex_data[7:4];
                anode_reg      = 4'b1101;   // AN1 active
                dp_reg         = ~dp_sel[1];
            end
            2'b10: begin
                current_nibble = hex_data[11:8];
                anode_reg      = 4'b1011;   // AN2 active
                dp_reg         = ~dp_sel[2];
            end
            2'b11: begin
                current_nibble = hex_data[15:12];
                anode_reg      = 4'b0111;   // AN3 active
                dp_reg         = ~dp_sel[3];
            end
        endcase
    end

    // Hex to 7-segment decoder (active LOW, common anode)
    //   seg[0]=a, seg[1]=b, seg[2]=c, seg[3]=d,
    //   seg[4]=e, seg[5]=f, seg[6]=g
    reg [6:0] seg_reg;

    always @(*) begin
        case (current_nibble)
            4'h0: seg_reg = 7'b1000000; // 0
            4'h1: seg_reg = 7'b1111001; // 1
            4'h2: seg_reg = 7'b0100100; // 2
            4'h3: seg_reg = 7'b0110000; // 3
            4'h4: seg_reg = 7'b0011001; // 4
            4'h5: seg_reg = 7'b0010010; // 5
            4'h6: seg_reg = 7'b0000010; // 6
            4'h7: seg_reg = 7'b1111000; // 7
            4'h8: seg_reg = 7'b0000000; // 8
            4'h9: seg_reg = 7'b0010000; // 9
            4'hA: seg_reg = 7'b0001000; // A
            4'hB: seg_reg = 7'b0000011; // b
            4'hC: seg_reg = 7'b1000110; // C
            4'hD: seg_reg = 7'b0100001; // d
            4'hE: seg_reg = 7'b0000110; // E
            4'hF: seg_reg = 7'b0001110; // F
            default: seg_reg = 7'b1111111;
        endcase
    end

    // Output: display enabled or all OFF
    assign seg = display_en ? seg_reg : 7'b1111111;
    assign dp  = display_en ? dp_reg  : 1'b1;
    assign an  = display_en ? anode_reg : 4'b1111;

endmodule
```

### A4. Package the IP

1. In the **Package IP** window, go through each tab:
   - **Identification**: verify name = `axi_7seg`, version = `1.0`
   - **File Groups**: click **Merge changes from File Groups Wizard**
   - **Ports and Interfaces**: verify `seg[6:0]`, `dp`, `an[3:0]` appear as ports
   - **Addressing and Memory**: verify `S00_AXI` has address block `S00_AXI_reg`
2. Click **Review and Package** > **Package IP**

> SCREENSHOT A4a: Package IP - "Ports and Interfaces" tab showing seg, dp, an ports
>
> SCREENSHOT A4b: Package IP - "Review and Package" summary


---

## Part B: Block Design in Vivado

### B1. Add IP to Block Design

1. Open your block design (`design_soc`)
2. Click **+** (Add IP) and search for `axi_7seg`
3. Add it to the design

> SCREENSHOT B1: Block design after adding axi_7seg IP (showing the IP block)

### B2. Connect to MicroBlaze

1. Click **Run Connection Automation**
2. Select `axi_7seg_0/S00_AXI` — connect to MicroBlaze's AXI SmartConnect
3. Clock and reset will auto-connect

> SCREENSHOT B2: Run Connection Automation dialog for axi_7seg_0

### B3. Make Ports External

1. Right-click on `axi_7seg_0` port `seg` > **Make External** (creates `seg_0`)
2. Right-click on `axi_7seg_0` port `dp` > **Make External** (creates `dp_0`)
3. Right-click on `axi_7seg_0` port `an` > **Make External** (creates `an_0`)

> SCREENSHOT B3: Block design with seg_0, dp_0, an_0 external ports visible

### B4. Verify Address Map

1. Go to **Address Editor** tab
2. Verify `axi_7seg_0` is assigned an address (default: `0x44A10000`, range 64K)
3. Note down this address — you need it in the C code

> SCREENSHOT B4: Address Editor showing axi_7seg_0 at 0x44A10000

### B5. Validate and Generate

1. Click **Validate Design** (F6) — should show 0 errors
2. **Generate Block Design** > **Generate**

> SCREENSHOT B5: Validation successful message


---

## Part C: XDC Constraints

### C1. Add Pin Assignments

Add these lines to your `.xdc` file for the Basys3 seven-segment display:

```tcl
# 7-Segment Display (axi_7seg custom peripheral)
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

**Important**: The port names (`seg_0`, `dp_0`, `an_0`) must match exactly what Vivado generated when you made the ports external in Step B3.

> SCREENSHOT C1: XDC file open in Vivado text editor


---

## Part D: Synthesis, Implementation, Export

### D1. Generate Bitstream

1. Click **Generate Bitstream** (or run synthesis + implementation first)
2. Wait for completion

> SCREENSHOT D1: Bitstream generation successful

### D2. Export Hardware (XSA)

1. **File** > **Export Hardware**
2. Select **Include bitstream**
3. Save as `7seg_periph.xsa` (or any name you prefer)

> SCREENSHOT D2: Export Hardware dialog with "Include bitstream" checked


---

## Part E: Vitis — Create Platform and Application

### E1. Create Platform

1. Open Vitis, set workspace to your `ws` folder
2. **File** > **New** > **Platform Project**
3. Name: `platform_7seg`
4. Browse to your exported `.xsa` file
5. Processor: `microblaze_riscv_0`, OS: `standalone`, Language: `C`
6. Click **Finish**
7. Right-click platform > **Build Project**

> SCREENSHOT E1: Platform project creation wizard showing XSA selection

### E2. Create Application

1. **File** > **New** > **Application Project**
2. Select platform: `platform_7seg`
3. Application name: `task4_7seg_app`
4. Processor: `microblaze_riscv_0`
5. Template: **Hello World**
6. Click **Finish**

> SCREENSHOT E2: Application project creation - template selection

### E3. Write the C Code

Open `task4_7seg_app/src/helloworld.c` and replace with:

```c
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"

// axi_7seg custom IP base address (from Vivado Address Editor)
#define AXI_7SEG_BASE  0x44A10000
#define AXI_7SEG_DATA  (AXI_7SEG_BASE + 0x00)  // reg0: hex value [15:0]
#define AXI_7SEG_CTRL  (AXI_7SEG_BASE + 0x04)  // reg1: bit[0]=enable

// Convert decimal 0-9999 to BCD for display
// e.g. 42 -> 0x0042, 1234 -> 0x1234
u32 dec_to_bcd(u32 val) {
    u32 d0 = val % 10;
    u32 d1 = (val / 10) % 10;
    u32 d2 = (val / 100) % 10;
    u32 d3 = (val / 1000) % 10;
    return (d3 << 12) | (d2 << 8) | (d1 << 4) | d0;
}

int main()
{
    init_platform();
    print("=== Task 4: axi_7seg Custom IP Test ===\n\r");

    // CRITICAL: Enable the display (bit 0 of control register)
    Xil_Out32(AXI_7SEG_CTRL, 0x01);

    u32 counter = 0;

    while(1) {
        u32 bcd = dec_to_bcd(counter % 10000);
        Xil_Out32(AXI_7SEG_DATA, bcd);

        xil_printf("Count: %d  Display: 0x%04X\n\r", counter, bcd);

        counter++;
        sleep(1);
    }

    cleanup_platform();
    return 0;
}
```

> SCREENSHOT E3: The C code in Vitis editor

### E4. Build

1. Right-click `task4_7seg_app` > **Build Project**
2. Verify 0 errors in console

> SCREENSHOT E4: Build console showing "Build Finished" with 0 errors


---

## Part F: Program and Run

### F1. Program FPGA

1. Connect Basys3 via USB
2. **Xilinx** > **Program FPGA**
3. Select the bitstream from your platform
4. Click **Program**

> SCREENSHOT F1: Program FPGA dialog

### F2. Run Application

1. Right-click `task4_7seg_app` > **Run As** > **Launch Hardware (Single Application Debug)**
2. Observe the seven-segment display

> SCREENSHOT F2: The Basys3 board with 7-segment display showing numbers (photo)

### F3. Serial Output

1. Open a serial terminal (PuTTY, Tera Term, or Vitis Serial Monitor)
2. Settings: COM port, 9600 baud, 8N1
3. You should see:
```
=== Task 4: axi_7seg Custom IP Test ===
Count: 0  Display: 0x0000
Count: 1  Display: 0x0001
Count: 2  Display: 0x0002
...
```

> SCREENSHOT F3: Serial terminal output


---

## Register Map Reference

| Offset | Register | Bits | Description |
|--------|----------|------|-------------|
| `0x00` | DATA | [15:0] | Hex display value. Each nibble = one digit. `0x1234` shows "1234" |
| `0x04` | CTRL | [0] | Display enable. **0 = OFF (default), 1 = ON** |
| `0x04` | CTRL | [7:4] | Decimal point select. Bit4=AN0, Bit5=AN1, Bit6=AN2, Bit7=AN3 |

### Common Pitfall

The display enable bit defaults to **0** on power-up/reset. If you forget to write `0x01` to the CTRL register, all 4 digits stay completely blank — even if you wrote valid data to the DATA register.


---

## Screenshot Checklist

Take these screenshots for your documentation/report:

| # | What to Screenshot | When |
|---|-------------------|------|
| A1 | Create and Package New IP wizard | Creating IP |
| A4a | Package IP - Ports and Interfaces tab | Packaging IP |
| A4b | Package IP - Review and Package | Packaging IP |
| B1 | Block design with axi_7seg block visible | Block design |
| B2 | Run Connection Automation dialog | Block design |
| B3 | Block design with external ports (seg_0, dp_0, an_0) | Block design |
| B4 | Address Editor showing 0x44A10000 | Block design |
| B5 | Validate Design success | Block design |
| C1 | XDC constraints file | Constraints |
| D1 | Bitstream generation success | Synthesis |
| D2 | Export Hardware dialog | Export |
| E1 | Platform project creation with XSA | Vitis |
| E2 | Application template selection | Vitis |
| E3 | C source code in editor | Vitis |
| E4 | Build console - 0 errors | Vitis |
| F1 | Program FPGA dialog | Running |
| F2 | Basys3 board photo with display lit up | Running |
| F3 | Serial terminal output | Running |


---

## File Structure

```
ip_repo/
  axi_7seg_1.0/
    hdl/
      axi_7seg.v                    # Top module (wrapper)
      axi_7seg_v1_0_S00_AXI.v      # AXI slave + display logic
    drivers/
      axi_7seg_v1_0/
        src/
          axi_7seg.h                # Driver header (macros)
          axi_7seg.c                # Self-test function
        data/
          axi_7seg.mdd              # Driver metadata
          axi_7seg.tcl              # BSP integration script
    component.xml                   # IP-XACT packaging descriptor
```
