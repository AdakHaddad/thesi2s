# Vivado IP Packager - Visual Step-by-Step Guide

## Creating Custom AXI-Lite IP Using GUI

### Overview
This guide shows how to create the 7-segment IP using Vivado's built-in IP Packager instead of manual file creation.

---

## Step 1: Start Create and Package IP Wizard

```
Menu: Tools → Create and Package New IP
```

**Dialog: Create and Package New IP**
```
┌─────────────────────────────────────────────────────────────┐
│  Create and Package New IP                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ○ Package your current project                             │
│  ○ Package a specified directory                            │
│  ● Create a new AXI4 peripheral    ← SELECT THIS            │
│  ○ Create AXI4 Verification IP     ← SELECT THIS            │
│                                                             │
│                              [Next >]  [Cancel]             │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 2: Peripheral Details

```
┌─────────────────────────────────────────────────────────────┐
│  Peripheral Details                                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Name:         [axi_7seg                    ]               │
│  Version:      [1].[0]                                      │
│  Display name: [AXI 7-Segment Display       ]               │
│  Description:  [Custom 7-seg controller     ]               │
│                                                             │
│  Vendor:       [user.org    ]                               │
│  Vendor URL:   [            ]                               │
│                                                             │
│  IP location:  [C:/tesi2s/micblaze/ip_repo  ] [Browse...]   │
│                                                             │
│                              [< Back]  [Next >]  [Cancel]   │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 3: Add AXI Interface

```
┌─────────────────────────────────────────────────────────────┐
│  Add Interfaces                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Name     │ Interface Type │ Mode   │ Data Width │ Regs│  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ S00_AXI  │ Lite           │ Slave  │ 32         │ 4   │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  [+ Add Interface]  [- Remove]  [Edit...]                   │
│                                                             │
│  Edit Interface:                                            │
│  ┌─────────────────────────────────────┐                    │
│  │ Interface Type: ● Lite  ○ Full     │                    │
│  │ Interface Mode: ● Slave ○ Master   │                    │
│  │ Data Width (bits): [32      ▼]     │                    │
│  │ Number of Registers: [4     ]      │ ← 4 for our regs   │
│  └─────────────────────────────────────┘                    │
│                                                             │
│                              [< Back]  [Next >]  [Cancel]   │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 4: Create Peripheral

```
┌─────────────────────────────────────────────────────────────┐
│  Create Peripheral                                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Next Steps:                                                │
│                                                             │
│  ○ Add IP to the repository                                 │
│  ● Edit IP           ← SELECT THIS                          │
│                                                             │
│  This will create a project to edit the IP                  │
│                                                             │
│                              [< Back]  [Finish]  [Cancel]   │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 5: Edit Generated Verilog

After clicking Finish, a new Vivado window opens with the IP project.

**Generated File Structure:**
```
axi_7seg_1.0/
├── component.xml
├── xgui/
│   └── axi_7seg_v1_0.tcl
├── hdl/
│   ├── axi_7seg_v1_0.v           ← Main wrapper (edit this)
│   └── axi_7seg_v1_0_S00_AXI.v   ← AXI slave logic
└── drivers/
```

**Modify the main file to add our display logic:**

In `axi_7seg_v1_0.v`, add the external ports:

```verilog
module axi_7seg_v1_0 #(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)(
    // ADD THESE LINES - 7-Segment outputs
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    // Existing AXI ports...
    input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    // ... rest of AXI signals
);
```

---

## Step 6: Package IP Window

```
┌─────────────────────────────────────────────────────────────┐
│  Package IP - axi_7seg                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────┐  ┌────────────────────────────────┐  │
│  │ ✓ Identification  │  │ Vendor: user.org               │  │
│  │ ✓ Compatibility   │  │ Library: user                  │  │
│  │ ✓ File Groups     │  │ Name: axi_7seg                 │  │
│  │ ! Customization   │  │ Version: 1.0                   │  │
│  │ ▸ Ports and Int.  │  │                                │  │
│  │   Addressing      │  │ Display Name:                  │  │
│  │   Review Package  │  │ AXI 7-Segment Display          │  │
│  └───────────────────┘  └────────────────────────────────┘  │
│                                                             │
│  ! indicates section needs attention                        │
└─────────────────────────────────────────────────────────────┘
```

### For "Ports and Interfaces" section:

```
┌─────────────────────────────────────────────────────────────┐
│  Ports and Interfaces                                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [Merge changes from Ports and Interfaces Wizard]           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Port/Interface   │ Direction │ Type        │ Width │    │
│  ├─────────────────────────────────────────────────────┤    │
│  │ S00_AXI          │ Slave     │ AXI4-Lite   │ -     │    │
│  │ s00_axi_aclk     │ Input     │ Clock       │ 1     │    │
│  │ s00_axi_aresetn  │ Input     │ Reset       │ 1     │    │
│  │ seg              │ Output    │ Data        │ 7     │ ←  │
│  │ dp               │ Output    │ Data        │ 1     │ ←  │
│  │ an               │ Output    │ Data        │ 4     │ ←  │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  New ports (seg, dp, an) should appear after you           │
│  click "Merge changes"                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 7: Review and Package

```
┌─────────────────────────────────────────────────────────────┐
│  Review and Package                                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Summary:                                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ ✓ All packaging steps complete                      │    │
│  │ ✓ No critical warnings                              │    │
│  │ ✓ IP will be packaged to:                           │    │
│  │   C:/tesi2s/micblaze/ip_repo/axi_7seg_1.0          │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│                         [Re-Package IP]                     │
│                                                             │
│  After packaging:                                           │
│  ○ Close project                                            │
│  ● Keep project open                                        │
└─────────────────────────────────────────────────────────────┘
```

Click **Re-Package IP** to finalize.

---

## Step 8: Add to Block Design

Back in your main project:

```
┌─────────────────────────────────────────────────────────────┐
│  Add IP (Ctrl+I)                                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Search: [7seg                                    ]         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ ★ AXI 7-Segment Display (1.0)                       │    │
│  │   user.org:user:axi_7seg:1.0                        │    │
│  │   Custom 7-seg controller for Basys3                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  Double-click to add to design                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Connection Automation Result

After running connection automation:

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│    ┌──────────────┐          ┌──────────────┐                     │
│    │ microblaze   │          │              │                     │
│    │ _riscv_0     │──M_AXI──>│   axi_smc    │                     │
│    │              │          │              │                     │
│    └──────────────┘          │  M00─────────┼──> axi_uartlite     │
│                              │  M01─────────┼──> axi_gpio_0       │
│    ┌──────────────┐          │  M02─────────┼──> axi_gpio_1       │
│    │  clk_wiz_0   │──clk────>│  M03─────────┼──> axi_7seg_0   ────┼──> seg[6:0]
│    │              │          │              │                 ────┼──> dp
│    └──────────────┘          │              │                 ────┼──> an[3:0]
│                              └──────────────┘                     │
│                                                                    │
│    ┌──────────────┐                                               │
│    │ rst_clk_wiz  │──aresetn─────────────────────────────────────>│
│    │ _0_100M      │                                               │
│    └──────────────┘                                               │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Address Editor View

```
┌─────────────────────────────────────────────────────────────────────┐
│  Address Editor                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ▼ microblaze_riscv_0                                              │
│    ▼ Data                                                           │
│      ┌────────────────┬──────────────┬────────┬──────────────────┐  │
│      │ Cell           │ Offset Addr  │ Range  │ High Address     │  │
│      ├────────────────┼──────────────┼────────┼──────────────────┤  │
│      │ dlmb_bram      │ 0x0000_0000  │ 128K   │ 0x0001_FFFF      │  │
│      │ axi_gpio_0     │ 0x4000_0000  │ 64K    │ 0x4000_FFFF      │  │
│      │ axi_gpio_1     │ 0x4001_0000  │ 64K    │ 0x4001_FFFF      │  │
│      │ axi_uartlite_0 │ 0x4060_0000  │ 64K    │ 0x4060_FFFF      │  │
│      │ axi_7seg_0     │ 0x44A0_0000  │ 64K    │ 0x44A0_FFFF  ★   │  │
│      └────────────────┴──────────────┴────────┴──────────────────┘  │
│                                                                     │
│  ★ = Our new custom peripheral                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Common Issues and Solutions

| Symptom | Cause | Solution |
|---------|-------|----------|
| IP not in catalog | Repository not added | Settings → IP → Repository → Add |
| "Merge changes" greyed out | Ports not in HDL | Edit Verilog to add port declarations |
| Critical warning in packaging | Missing port inference | Manually add ports in Ports section |
| Can't connect to SmartConnect | Wrong interface type | Verify AXI-Lite slave configuration |
| Address overlap error | Duplicate addresses | Change offset in Address Editor |

---

## Files Created by This Process

```
C:/tesi2s/micblaze/
├── ip_repo/
│   └── axi_7seg_1.0/
│       ├── component.xml          ✓ Auto-generated
│       ├── xgui/
│       │   └── axi_7seg_v1_0.tcl  ✓ Auto-generated
│       ├── hdl/
│       │   ├── axi_7seg_v1_0.v    ✓ You edit this
│       │   └── axi_7seg_v1_0_S00_AXI.v  ✓ Auto-generated
│       └── drivers/
│           └── axi_7seg_v1_0/
│               └── src/
│                   └── axi_7seg.h  ✓ You create this
├── docs/
│   ├── TUGAS3_Tutorial.md
│   └── Vivado_IP_Packager_Guide.md  (this file)
└── sw/
    └── tugas3_7seg/
        └── main.c
```
