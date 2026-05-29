# DDS + IIR Integration Guide

This guide shows how to use the DDS IP in `fix/ready_to_run/` as the signal source and an IIR filter IP as the device under test.

## Recommended Structure

Put both blocks in the same Vivado block design when they run on the same sample clock.

Signal flow:

`DDS -> IIR -> ILA or output`

This lets you generate a known waveform, pass it through the filter, and observe the result in one design.

## What To Edit

- Block design: `proj/bdesign_clock_core.bd`
- DDS RTL: `ip_repo/i2s_dds_1_0/hdl/i2s_dds.v`
- DDS AXI control wrapper: `ip_repo/i2s_dds_1_0/hdl/i2s_dds_slave_lite_v1_0_S00_AXI.v`

If your IIR filter is a separate custom IP, add its HDL or IP files in the same project and connect it in the BD.

## Vivado Tcl To Add The Filter

If the filter already exists as packaged IP, run this in the Vivado Tcl console after opening the DDS project:

```tcl
open_bd_design ./proj/bdesign_clock_core.bd
set filter_ip [create_bd_cell -type ip -vlnv <vendor>:<library>:<filter_name>:<version> iir_0]
connect_bd_net [get_bd_pins i2s_dds_0/<sample_out_port>] [get_bd_pins iir_0/<sample_in_port>]
connect_bd_net [get_bd_pins iir_0/<sample_out_port>] [get_bd_pins <next_block>/<input_port>]
save_bd_design
make_wrapper -files [get_files bdesign_clock_core.bd] -top
update_compile_order -fileset sources_1
```

If the filter is only RTL and not packaged yet, add its source files first:

```tcl
add_files -norecurse [glob ./iiradji/**/*.v]
update_compile_order -fileset sources_1
```

Then package that RTL as an IP or instantiate it in a non-BD top-level. In a BD, Vivado works cleanly only when the filter is available as IP.

Important: the current `i2s_dds` block exposes `i2s_mclk`, `i2s_bclk`, `i2s_ws`, and `i2s_data`, plus AXI-Lite control. It does not expose a ready-made PCM sample stream, so a true sample-domain IIR filter cannot be wired after the serial outputs. For filter testing, the DDS must provide a sample output, or you need a separate sample generator before the IIR.

## Connection Plan

1. Keep DDS and IIR in the same clock domain if possible.
2. Route the DDS sample output into the IIR input.
3. Route the IIR output to either an ILA probe or the next output stage.
4. Use AXI only for configuration, not for streaming the sample path.

## When To Use A Separate Block Design

Use a separate BD only if the DDS and IIR are being tested independently or if they need different clocks and you do not want to add clock-domain crossing logic.

## Practical Rule

- Use the BD for wiring.
- Use the IP RTL for DDS generation behavior.
- Use the IIR IP for filter behavior.

## Testing Order

1. Verify DDS alone first.
2. Insert the IIR block.
3. Compare the filtered output against the unfiltered signal in ILA.
4. Once stable, connect the filtered stream to the audio/output path if needed.