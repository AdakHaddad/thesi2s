# thesi2s

<!-- BD_MERMAID_INDEX_START -->

## Vivado Block Designs (auto-generated)

Generated Mermaid files:

- `docs/bd/design_mysoc.tcl_axi.mmd`
- `docs/bd/design_mysoc.tcl_clkreset.mmd`

Preview (AXI view):

```mermaid
flowchart LR
  %% AXI view from design_mysoc.tcl

  n__nameHier_["$nameHier]"]
  n_DLMB["DLMB"]
  n_ILMB["ILMB"]
  n_axi_7segment_0["axi_7segment_0"]
  n_axi_gpio_0["axi_gpio_0"]
  n_axi_smc["axi_smc"]
  n_axi_uartlite_0["axi_uartlite_0"]
  n_clk_wiz_0["clk_wiz_0"]
  n_dlmb_bram_if_cntlr["dlmb_bram_if_cntlr"]
  n_dlmb_v10["dlmb_v10"]
  n_ilmb_bram_if_cntlr["ilmb_bram_if_cntlr"]
  n_ilmb_v10["ilmb_v10"]
  n_lmb_bram["lmb_bram"]
  n_mdm_1["mdm_1"]
  n_microblaze_riscv_0["microblaze_riscv_0"]
  n_microblaze_riscv_0_local_memory["microblaze_riscv_0_local_memory"]
  n_rst_clk_wiz_0_100M["rst_clk_wiz_0_100M"]
  n_rst_clk_wiz_0_audio["rst_clk_wiz_0_audio"]

  n_axi_smc -->|AXI| n_axi_7segment_0
  n_axi_smc -->|AXI| n_axi_gpio_0
  n_axi_smc -->|AXI| n_axi_uartlite_0
  n_dlmb_bram_if_cntlr -->|AXI| n_lmb_bram
  n_dlmb_v10 -->|AXI| n_DLMB
  n_dlmb_v10 -->|AXI| n_dlmb_bram_if_cntlr
  n_ilmb_bram_if_cntlr -->|AXI| n_lmb_bram
  n_ilmb_v10 -->|AXI| n_ILMB
  n_ilmb_v10 -->|AXI| n_ilmb_bram_if_cntlr
  <<<<<<< MERGED
  # thesi2s / MicroBlaze RISC-V Project (Basys3)

  This repository contains Vivado block designs, MicroBlaze/Vitis application sources, and supporting scripts for building and exporting hardware platforms.

  ## Quick Start

  ### 1. Rebuild Vivado Project

  Open Vivado, then in the Tcl Console run:

  ```tcl
  cd {C:/Users/LENOVO/Documents/tesi2s/micblaze}
  source rebuild_project.tcl
  ```

  Or from the command line:

  ```bash
  vivado -mode batch -source rebuild_project.tcl
  ```

  ### 2. Build Bitstream

  In the Tcl Console:

  ```tcl
  launch_runs impl_1 -to_step write_bitstream -jobs 4
  wait_on_run impl_1
  ```

  ### 3. Export Hardware (XSA)

  ```tcl
  write_hw_platform -fixed -include_bit -force design_soc_wrapper.xsa
  ```

  ### 4. Setup Vitis

  1. Open Vitis
  2. Create Platform Project -> select `design_soc_wrapper.xsa`
  3. Create Application Project -> choose the newly created platform
  4. Build and program the board

  ## Vivado Block Designs (auto-generated)

  Generated Mermaid files:

  - `docs/bd/design_mysoc.tcl_axi.mmd`
  - `docs/bd/design_mysoc.tcl_clkreset.mmd`

  Preview (AXI view):

  ```mermaid
  flowchart LR
    %% AXI view from design_mysoc.tcl

    n__nameHier_["$nameHier]"]
    n_DLMB["DLMB"]
    n_ILMB["ILMB"]
    n_axi_7segment_0["axi_7segment_0"]
    n_axi_gpio_0["axi_gpio_0"]
    n_axi_smc["axi_smc"]
    n_axi_uartlite_0["axi_uartlite_0"]
    n_clk_wiz_0["clk_wiz_0"]
    n_dlmb_bram_if_cntlr["dlmb_bram_if_cntlr"]
    n_dlmb_v10["dlmb_v10"]
    n_ilmb_bram_if_cntlr["ilmb_bram_if_cntlr"]
    n_ilmb_v10["ilmb_v10"]
    n_lmb_bram["lmb_bram"]
    n_mdm_1["mdm_1"]
    n_microblaze_riscv_0["microblaze_riscv_0"]
    n_microblaze_riscv_0_local_memory["microblaze_riscv_0_local_memory"]
    n_rst_clk_wiz_0_100M["rst_clk_wiz_0_100M"]
    n_rst_clk_wiz_0_audio["rst_clk_wiz_0_audio"]

    n_axi_smc -->|AXI| n_axi_7segment_0
    n_axi_smc -->|AXI| n_axi_gpio_0
    n_axi_smc -->|AXI| n_axi_uartlite_0
    n_dlmb_bram_if_cntlr -->|AXI| n_lmb_bram
    n_dlmb_v10 -->|AXI| n_DLMB
    n_dlmb_v10 -->|AXI| n_dlmb_bram_if_cntlr
    n_ilmb_bram_if_cntlr -->|AXI| n_lmb_bram
    n_ilmb_v10 -->|AXI| n_ILMB
    n_ilmb_v10 -->|AXI| n_ilmb_bram_if_cntlr
    n_mdm_1 -->|AXI| n_microblaze_riscv_0
    n_microblaze_riscv_0 -->|AXI| n_axi_smc
    n_microblaze_riscv_0 -->|AXI| n_microblaze_riscv_0_local_memory
  ```

  ## File Structure

  ```
  micoblaze/
  ├── micoblaze.xpr          # Vivado project file
  ├── micoblaze.srcs/        # Source files (BD, XDC, IP)
  ├── rebuild_project.tcl   # Script rebuild project
  └── README.md
  ```

  >>>>>>> MERGED