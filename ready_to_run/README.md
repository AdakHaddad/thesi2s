# Ready-to-Run Fix Project

This directory contains a complete, portable version of the `nobufgmux` project with the fixed `i2s` IP and associated software.

## Contents

- `ip_repo/i2s/`: Fixed I2S IP core.
- `proj/`: Block design and constraints from the `nobufgmux` project.
- `sw/`: Fixed `helloworld.c` for MicroBlaze.
- `rebuild.tcl`: Tcl script to reconstruct the Vivado project.

## How to use

1. Open Vivado.
2. In the Tcl Console, navigate to this directory:
   ```tcl
   cd {path/to/ready_to_run}
   ```
3. Run the rebuild script:
   ```tcl
   source rebuild.tcl
   ```
4. Once the project is created:
   - Run **Generate Bitstream**.
   - **Export Hardware** (File -> Export -> Export Hardware), including the bitstream, to get a new `.xsa`.
5. In Vitis:
   - Create a new platform project using the exported `.xsa`.
   - Create an application project.
   - Use the `helloworld.c` located in the `sw/` folder.

## Project Origin
- **FPGA Project:** `nobufgmux/`
- **IP Core:** `ip_repo/i2s_1_0`
- **Software:** `micblaze/ws/rtlfix/src/helloworld.c`
