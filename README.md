# thesi2s

<!-- BD_MERMAID_INDEX_START -->

## Vivado Block Designs (auto-generated)

Generated Mermaid files:

- `docs/bd/design_mysoc.tcl.mmd`

Preview (first diagram):

```mermaid
flowchart LR
  %% Auto-generated from: design_mysoc.tcl

  n__nameHier_["$nameHier]"]
  n_DLMB["DLMB"]
  n_ILMB["ILMB"]
  n_LMB_Clk["LMB_Clk"]
  n_SYS_Rst["SYS_Rst"]
  n_axi_7segment_0["axi_7segment_0
xilinx.com:user:axi_7segment:1.0"]
  n_axi_gpio_0["axi_gpio_0
xilinx.com:ip:axi_gpio:2.0"]
  n_axi_smc["axi_smc
xilinx.com:ip:smartconnect:1.0"]
  n_axi_uartlite_0["axi_uartlite_0
xilinx.com:ip:axi_uartlite:2.0"]
  n_clk_wiz_0["clk_wiz_0
xilinx.com:ip:clk_wiz:6.0"]
  n_dlmb_bram_if_cntlr["dlmb_bram_if_cntlr
xilinx.com:ip:lmb_bram_if_cntlr:4.0"]
  n_dlmb_v10["dlmb_v10
xilinx.com:ip:lmb_v10:3.0"]
  n_ilmb_bram_if_cntlr["ilmb_bram_if_cntlr
xilinx.com:ip:lmb_bram_if_cntlr:4.0"]
  n_ilmb_v10["ilmb_v10
xilinx.com:ip:lmb_v10:3.0"]
  n_lmb_bram["lmb_bram
xilinx.com:ip:blk_mem_gen:8.4"]
  n_mdm_1["mdm_1
xilinx.com:ip:mdm_riscv:1.0"]
  n_microblaze_riscv_0["microblaze_riscv_0
xilinx.com:ip:microblaze_riscv:1.0"]
  n_microblaze_riscv_0_local_memory["microblaze_riscv_0_local_memory"]
  n_rst_clk_wiz_0_100M["rst_clk_wiz_0_100M
xilinx.com:ip:proc_sys_reset:5.0"]

  n_axi_smc -->|AXI/intf: axi_smc/M02_AXI -> axi_7segment_0/S00_AXI| n_axi_7segment_0
  n_axi_smc -->|AXI/intf: axi_smc/M01_AXI -> axi_gpio_0/S_AXI| n_axi_gpio_0
  n_axi_smc -->|AXI/intf: axi_smc/M00_AXI -> axi_uartlite_0/S_AXI| n_axi_uartlite_0
  n_dlmb_bram_if_cntlr -->|AXI/intf: dlmb_bram_if_cntlr/BRAM_PORT -> lmb_bram/BRAM_PORTA| n_lmb_bram
  n_dlmb_v10 -->|AXI/intf: dlmb_v10/LMB_M -> DLMB| n_DLMB
  n_dlmb_v10 -->|AXI/intf: dlmb_v10/LMB_Sl_0 -> dlmb_bram_if_cntlr/SLMB| n_dlmb_bram_if_cntlr
  n_ilmb_bram_if_cntlr -->|AXI/intf: ilmb_bram_if_cntlr/BRAM_PORT -> lmb_bram/BRAM_PORTB| n_lmb_bram
  n_ilmb_v10 -->|AXI/intf: ilmb_v10/LMB_M -> ILMB| n_ILMB
  n_ilmb_v10 -->|AXI/intf: ilmb_v10/LMB_Sl_0 -> ilmb_bram_if_cntlr/SLMB| n_ilmb_bram_if_cntlr
  n_mdm_1 -->|AXI/intf: mdm_1/MBDEBUG_0 -> microblaze_riscv_0/DEBUG| n_microblaze_riscv_0
  n_microblaze_riscv_0 -->|AXI/intf: microblaze_riscv_0/M_AXI_DP -> axi_smc/S00_AXI| n_axi_smc
  n_microblaze_riscv_0 -->|AXI/intf: microblaze_riscv_0/DLMB -> microblaze_riscv_0_local_memory/DLMB| n_microblaze_riscv_0_local_memory
  n_microblaze_riscv_0 -->|AXI/intf: microblaze_riscv_0/ILMB -> microblaze_riscv_0_local_memory/ILMB| n_microblaze_riscv_0_local_memory
  n_LMB_Clk -->|net: LMB_Clk -> dlmb_bram_if_cntlr/LMB_Clk| n_dlmb_bram_if_cntlr
  n_LMB_Clk -->|net: LMB_Clk -> dlmb_v10/LMB_Clk| n_dlmb_v10
  n_LMB_Clk -->|net: LMB_Clk -> ilmb_bram_if_cntlr/LMB_Clk| n_ilmb_bram_if_cntlr
  n_LMB_Clk -->|net: LMB_Clk -> ilmb_v10/LMB_Clk| n_ilmb_v10
  n_SYS_Rst -->|net: SYS_Rst -> dlmb_bram_if_cntlr/LMB_Rst| n_dlmb_bram_if_cntlr
  n_SYS_Rst -->|net: SYS_Rst -> dlmb_v10/SYS_Rst| n_dlmb_v10
  n_SYS_Rst -->|net: SYS_Rst -> ilmb_bram_if_cntlr/LMB_Rst| n_ilmb_bram_if_cntlr
  n_SYS_Rst -->|net: SYS_Rst -> ilmb_v10/SYS_Rst| n_ilmb_v10
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> axi_7segment_0/s00_axi_aclk| n_axi_7segment_0
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> axi_gpio_0/s_axi_aclk| n_axi_gpio_0
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> axi_smc/aclk| n_axi_smc
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> axi_uartlite_0/s_axi_aclk| n_axi_uartlite_0
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> microblaze_riscv_0/Clk| n_microblaze_riscv_0
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> microblaze_riscv_0_local_memory/LMB_Clk| n_microblaze_riscv_0_local_memory
  n_clk_wiz_0 -->|net: clk_wiz_0/clk_out1 -> rst_clk_wiz_0_100M/slowest_sync_clk| n_rst_clk_wiz_0_100M
  n_clk_wiz_0 -->|net: clk_wiz_0/locked -> rst_clk_wiz_0_100M/dcm_locked| n_rst_clk_wiz_0_100M
  n_clk_wiz_0 -->|net: clk_wiz_0/reset -> rst_clk_wiz_0_100M/ext_reset_in| n_rst_clk_wiz_0_100M
  n_mdm_1 -->|net: mdm_1/Debug_SYS_Rst -> rst_clk_wiz_0_100M/mb_debug_sys_rst| n_rst_clk_wiz_0_100M
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/peripheral_aresetn -> axi_7segment_0/s00_axi_aresetn| n_axi_7segment_0
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/peripheral_aresetn -> axi_gpio_0/s_axi_aresetn| n_axi_gpio_0
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/peripheral_aresetn -> axi_smc/aresetn| n_axi_smc
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/peripheral_aresetn -> axi_uartlite_0/s_axi_aresetn| n_axi_uartlite_0
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/mb_reset -> microblaze_riscv_0/Reset| n_microblaze_riscv_0
  n_rst_clk_wiz_0_100M -->|net: rst_clk_wiz_0_100M/bus_struct_reset -> microblaze_riscv_0_local_memory/SYS_Rst| n_microblaze_riscv_0_local_memory
```

<!-- BD_MERMAID_INDEX_END -->