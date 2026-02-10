# TUGAS-3: Custom AXI-Lite 7-Segment Display - Complete Tutorial

## Table of Contents
1. [AXI-Lite Protocol Basics](#1-axi-lite-protocol-basics)
2. [Creating Custom IP in Vivado](#2-creating-custom-ip-in-vivado)
3. [Block Design Integration](#3-block-design-integration)
4. [Vitis Software Setup](#4-vitis-software-setup)

---

## 1. AXI-Lite Protocol Basics

### What is AXI-Lite?

AXI-Lite is a simplified version of the AXI (Advanced eXtensible Interface) protocol, part of the ARM AMBA specification. It's designed for simple, low-throughput memory-mapped communication.

### Key Characteristics:
- **32-bit data bus** (fixed width)
- **Single transaction** (no burst support)
- **Memory-mapped registers** (read/write via addresses)
- **5 channels**: Write Address, Write Data, Write Response, Read Address, Read Data

### AXI-Lite Channels:

```
┌─────────────────┐                    ┌─────────────────┐
│                 │   Write Address    │                 │
│                 │  ───────────────>  │                 │
│                 │   (AWADDR, AWVALID)│                 │
│                 │                    │                 │
│                 │   Write Data       │                 │
│     MASTER      │  ───────────────>  │      SLAVE      │
│  (MicroBlaze)   │   (WDATA, WSTRB)   │   (Custom IP)   │
│                 │                    │                 │
│                 │   Write Response   │                 │
│                 │  <───────────────  │                 │
│                 │   (BRESP, BVALID)  │                 │
│                 │                    │                 │
│                 │   Read Address     │                 │
│                 │  ───────────────>  │                 │
│                 │   (ARADDR)         │                 │
│                 │                    │                 │
│                 │   Read Data        │                 │
│                 │  <───────────────  │                 │
│                 │   (RDATA, RRESP)   │                 │
└─────────────────┘                    └─────────────────┘
```

### Signal Descriptions:

#### Write Address Channel
| Signal      | Direction | Description |
|-------------|-----------|-------------|
| AWADDR      | M→S       | Write address |
| AWPROT      | M→S       | Protection type (usually ignored) |
| AWVALID     | M→S       | Write address valid |
| AWREADY     | S→M       | Slave ready to accept address |

#### Write Data Channel
| Signal      | Direction | Description |
|-------------|-----------|-------------|
| WDATA       | M→S       | Write data (32 bits) |
| WSTRB       | M→S       | Byte strobes (which bytes are valid) |
| WVALID      | M→S       | Write data valid |
| WREADY      | S→M       | Slave ready to accept data |

#### Write Response Channel
| Signal      | Direction | Description |
|-------------|-----------|-------------|
| BRESP       | S→M       | Write response (00=OKAY) |
| BVALID      | S→M       | Response valid |
| BREADY      | M→S       | Master ready for response |

#### Read Address Channel
| Signal      | Direction | Description |
|-------------|-----------|-------------|
| ARADDR      | M→S       | Read address |
| ARPROT      | M→S       | Protection type |
| ARVALID     | M→S       | Read address valid |
| ARREADY     | S→M       | Slave ready to accept address |

#### Read Data Channel
| Signal      | Direction | Description |
|-------------|-----------|-------------|
| RDATA       | S→M       | Read data (32 bits) |
| RRESP       | S→M       | Read response (00=OKAY) |
| RVALID      | S→M       | Read data valid |
| RREADY      | M→S       | Master ready for data |

### Handshake Protocol:

The AXI protocol uses a **VALID/READY handshake**:
- Transfer occurs when **BOTH** VALID and READY are HIGH on the same clock edge

```
        ┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐
CLK     │   │   │   │   │   │   │   │   │   │
    ────┘   └───┘   └───┘   └───┘   └───┘   └───

              ┌───────────────────┐
VALID   ──────┘                   └─────────────
                      ┌───────────┐
READY   ──────────────┘           └─────────────
                          ▲
                          │
                    Transfer occurs here
```

### Our 7-Segment IP Register Map:

```
Base Address + 0x00: DISPLAY_REG  [15:0] = 4-digit hex value
Base Address + 0x04: CTRL_REG     [0]    = Enable
                                  [7:4]  = Decimal point mask
Base Address + 0x08: DIGIT_REG    [6:0]  = Digit 0 segments
                                  [14:8] = Digit 1 segments
                                  [22:16]= Digit 2 segments
                                  [30:24]= Digit 3 segments
Base Address + 0x0C: MODE_REG     [0]    = 0=Hex, 1=Raw
```

### How Our Verilog Implements AXI-Lite:

```verilog
// 1. Write transaction detection
assign slv_reg_wren = axi_wready && S_AXI_WVALID &&
                      axi_awready && S_AXI_AWVALID;

// 2. Register selection based on address bits [3:2]
case (axi_awaddr[3:2])
    2'b00: display_reg <= S_AXI_WDATA;  // Offset 0x00
    2'b01: ctrl_reg    <= S_AXI_WDATA;  // Offset 0x04
    2'b10: digit_reg   <= S_AXI_WDATA;  // Offset 0x08
    2'b11: mode_reg    <= S_AXI_WDATA;  // Offset 0x0C
endcase

// 3. Read mux
case (axi_araddr[3:2])
    2'b00:   reg_data_out = display_reg;
    2'b01:   reg_data_out = ctrl_reg;
    2'b10:   reg_data_out = digit_reg;
    2'b11:   reg_data_out = mode_reg;
endcase
```

---

## 2. Creating Custom IP in Vivado

### Method A: Using IP Packager (Recommended)

#### Step 1: Create IP from Template

1. **Open Vivado** and your project
2. Go to **Tools → Create and Package New IP**
3. Select **Create a new AXI4 peripheral**
4. Click **Next**

#### Step 2: Configure Peripheral

1. **Name**: `axi_7seg`
2. **Version**: `1.0`
3. **Display Name**: `AXI 7-Segment Display Controller`
4. **Description**: `Custom AXI-Lite peripheral for 4-digit 7-segment display`
5. **IP Location**: `C:/tesi2s/micblaze/ip_repo/axi_7seg_1.0`
6. Click **Next**

#### Step 3: Add AXI Interface

1. **Interface Type**: Lite
2. **Interface Mode**: Slave
3. **Data Width**: 32
4. **Number of Registers**: 4
5. Click **Next**

#### Step 4: Edit IP

1. Select **Edit IP**
2. Click **Finish**

This opens a new Vivado project for IP editing.

#### Step 5: Replace Generated HDL

1. In the IP project, navigate to **Sources → Design Sources**
2. Right-click on the generated `.v` file
3. Select **Replace File** or edit directly
4. Replace with our `axi_7seg_v1_0.v` content

#### Step 6: Add Ports to IP

1. In **Package IP** window (Window → Package IP)
2. Go to **Ports and Interfaces**
3. Click **Merge changes from Ports and Interfaces Wizard**
4. Verify these ports are detected:
   - `seg[6:0]` - Output
   - `dp` - Output
   - `an[3:0]` - Output

#### Step 7: Review and Package

1. Go through each section in Package IP:
   - **Identification**: Verify name/version
   - **Compatibility**: Add device families
   - **File Groups**: Verify source files included
   - **Customization Parameters**: Leave defaults
   - **Ports and Interfaces**: Verify all ports
   - **Addressing and Memory**: Verify register map
   - **Review and Package**: Check for warnings

2. Click **Package IP**
3. Close the IP project when prompted

### Method B: Manual IP Creation (What We Did)

We already created the files manually:

```
ip_repo/axi_7seg_1.0/
├── component.xml          # IP-XACT descriptor
├── hdl/
│   └── axi_7seg_v1_0.v   # Verilog source
└── drivers/
    └── axi_7seg_v1_0/
        └── src/
            └── axi_7seg.h # C driver
```

To use this method:

1. Create directory structure as shown
2. Write the Verilog module with proper AXI-Lite interface
3. Create `component.xml` with proper SPIRIT schema
4. Add IP repository to Vivado project

---

## 3. Block Design Integration

### Step-by-Step GUI Method:

#### Step 1: Add IP Repository

1. Open your Vivado project
2. Go to **Settings** (gear icon) or **Project → Settings**
3. Navigate to **IP → Repository**
4. Click **+** (Add)
5. Browse to `C:/tesi2s/micblaze/ip_repo`
6. Click **OK**
7. Click **Refresh All** if the IP isn't visible

#### Step 2: Open Block Design

1. In **Sources** panel, expand **Design Sources**
2. Double-click `design_soc.bd` to open block design

#### Step 3: Add Custom IP

1. Right-click in diagram area → **Add IP** (or press Ctrl+I)
2. Search for `axi_7seg`
3. Double-click to add `axi_7seg_v1_0`

#### Step 4: Run Connection Automation

1. A green banner appears: "Run Connection Automation"
2. Click on it
3. Select `axi_7seg_0/S_AXI`
4. Verify it connects to `/microblaze_riscv_0` (Data master)
5. Click **OK**

This automatically:
- Adds a port on SmartConnect
- Connects clock and reset
- Assigns an address

#### Step 5: Make Ports External

1. Select the `seg` pin on `axi_7seg_0`
2. Right-click → **Make External** (or Ctrl+T)
3. Repeat for `dp` and `an` pins

Or select all three and make external at once.

#### Step 6: Rename External Ports (Optional)

1. Select the external port (e.g., `seg_0`)
2. In Properties, change name to `seg`
3. Repeat for `dp` and `an`

#### Step 7: Verify Address Assignment

1. Go to **Address Editor** tab
2. Find `axi_7seg_0`
3. Verify/set address to `0x44A0_0000`
4. Range should be `64K`

#### Step 8: Validate Design

1. Click **Validate Design** (checkmark icon) or press F6
2. Fix any errors (missing connections, etc.)

#### Step 9: Save and Generate

1. **Save** the block design (Ctrl+S)
2. Right-click on block design → **Generate Output Products**
3. Select **Global** and click **Generate**

#### Step 10: Create/Update HDL Wrapper

1. Right-click on `design_soc.bd`
2. Select **Create HDL Wrapper**
3. Choose **Let Vivado manage wrapper**
4. Click **OK**

### Final Block Design Should Look Like:

```
┌──────────────────────────────────────────────────────────────────┐
│                         design_soc                                │
│                                                                   │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────────────┐ │
│  │  clk_wiz_0  │────>│microblaze   │     │                     │ │
│  │             │     │ _riscv_0    │     │  axi_smc            │ │
│  └─────────────┘     │             │────>│  (SmartConnect)     │ │
│                      └─────────────┘     │                     │ │
│                            │             │  M00 → axi_uartlite │ │
│                            v             │  M01 → axi_gpio_0   │ │
│  ┌─────────────┐     ┌─────────────┐     │  M02 → axi_gpio_1   │ │
│  │   mdm_1     │────>│local_memory │     │  M03 → (unused)     │ │
│  │             │     │   (BRAM)    │     │  M04 → axi_7seg_0   │──┐
│  └─────────────┘     └─────────────┘     └─────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                      axi_7seg_0                              │ │
│  │   seg[6:0] ─────────────────────────────────────────> seg    │ │
│  │   dp ───────────────────────────────────────────────> dp     │ │
│  │   an[3:0] ──────────────────────────────────────────> an     │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Address Map After Integration:

| Peripheral    | Base Address | Range | High Address |
|---------------|--------------|-------|--------------|
| BRAM          | 0x00000000   | 128K  | 0x0001FFFF   |
| axi_gpio_0 (SW)| 0x40000000  | 64K   | 0x4000FFFF   |
| axi_gpio_1 (LED)| 0x40010000 | 64K   | 0x4001FFFF   |
| axi_uartlite_0| 0x40600000   | 64K   | 0x4060FFFF   |
| **axi_7seg_0**| **0x44A00000**| **64K**| **0x44A0FFFF**|

---

## 4. Vitis Software Setup

### Step 1: Export Hardware from Vivado

1. After successful bitstream generation
2. Go to **File → Export → Export Hardware**
3. Check **Include bitstream**
4. Export to: `C:/tesi2s/micblaze/micblaze.xsa`
5. Click **OK**

### Step 2: Launch Vitis

1. Go to **Tools → Launch Vitis**
2. Or open Vitis separately and create workspace

### Step 3: Create/Update Platform

#### If Platform Exists:
1. Right-click on platform → **Update Hardware Specification**
2. Select new `.xsa` file
3. Build platform

#### If New Platform:
1. **File → New → Platform Project**
2. Name: `platform`
3. Select your `.xsa` file
4. Processor: `microblaze_riscv_0`
5. OS: `standalone`
6. Click **Finish**
7. Build platform

### Step 4: Create Application Project

1. **File → New → Application Project**
2. Select your platform
3. Application name: `tugas3_7seg`
4. Template: **Empty Application (C)**
5. Click **Finish**

### Step 5: Add Source Files

1. Expand `tugas3_7seg` → `src`
2. Right-click `src` → **Import Sources**
3. Import `main.c` from `sw/tugas3_7seg/`
4. Copy `axi_7seg.h` from `ip_repo/axi_7seg_1.0/drivers/axi_7seg_v1_0/src/`

Or copy files manually:
```
tugas3_7seg/
└── src/
    ├── main.c
    └── axi_7seg.h
```

### Step 6: Update Base Address

Check `xparameters.h` in your BSP for the actual address:

```c
// In platform/microblaze_riscv_0/standalone_microblaze_riscv_0/bsp/include/xparameters.h
// Look for:
#define XPAR_AXI_7SEG_0_BASEADDR 0x44A00000
```

If the define doesn't exist (because it's a custom IP), add it manually in `main.c`:

```c
#ifndef XPAR_AXI_7SEG_0_BASEADDR
#define XPAR_AXI_7SEG_0_BASEADDR 0x44A00000
#endif
```

### Step 7: Build Application

1. Right-click on `tugas3_7seg` project
2. Select **Build Project**
3. Fix any compilation errors

### Step 8: Run/Debug on Hardware

1. Connect your Basys3 board via USB
2. Right-click on `tugas3_7seg` → **Run As → Launch Hardware**

Or for debugging:
1. Right-click → **Debug As → Launch Hardware**
2. Set breakpoints as needed
3. Use Debug perspective

### Complete main.c Template:

```c
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"

/* Include custom driver */
#include "axi_7seg.h"

/* Define address if not in xparameters.h */
#ifndef XPAR_AXI_7SEG_0_BASEADDR
#define XPAR_AXI_7SEG_0_BASEADDR 0x44A00000
#endif

int main()
{
    Axi7Seg display;

    init_platform();

    xil_printf("TUGAS-3: 7-Segment Display Test\r\n");

    /* Initialize display */
    Axi7Seg_Initialize(&display, XPAR_AXI_7SEG_0_BASEADDR);
    Axi7Seg_Enable(&display, 1);

    /* Display "HELO" */
    Axi7Seg_DisplayHello(&display);
    sleep(2);

    /* Count in hex */
    for (u16 i = 0; i <= 0xFFFF; i++) {
        Axi7Seg_DisplayHex(&display, i);
        usleep(10000);  // 10ms
    }

    cleanup_platform();
    return 0;
}
```

### Troubleshooting:

| Problem | Solution |
|---------|----------|
| IP not found in catalog | Refresh IP Catalog, check repository path |
| Connection automation fails | Manually connect clk, reset, and AXI |
| Address not assigned | Use Address Editor to manually assign |
| Display shows nothing | Check enable bit, verify pin constraints |
| Wrong segments lit | Check active-low logic in constraints |
| Build fails in Vitis | Rebuild platform after hardware export |

---

## Quick Reference Card

### Register Addresses (Base: 0x44A00000)
```
DISPLAY_REG: 0x44A00000  (16-bit hex value)
CTRL_REG:    0x44A00004  (enable[0], dp[7:4])
DIGIT_REG:   0x44A00008  (raw segments)
MODE_REG:    0x44A0000C  (0=hex, 1=raw)
```

### C Driver Quick Start
```c
#include "axi_7seg.h"

Axi7Seg disp;
Axi7Seg_Initialize(&disp, 0x44A00000);
Axi7Seg_Enable(&disp, 1);
Axi7Seg_DisplayHex(&disp, 0x1234);
Axi7Seg_DisplayDecimal(&disp, 1234);
Axi7Seg_SetDecimalPoints(&disp, 0x05);
```

### Segment Mapping
```
     AAA          Bit: 0=A, 1=B, 2=C, 3=D, 4=E, 5=F, 6=G
    F   B
     GGG          Example: '8' = 0x7F (all segments)
    E   C                  '1' = 0x06 (B+C only)
     DDD
```
