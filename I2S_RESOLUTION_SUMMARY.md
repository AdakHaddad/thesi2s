# I2S Bring-Up Resolution Summary

## Project Context

- **Platform**: Basys3 (`xc7a35tcpg236-1`)
- **Design**: `i2s_new` (MicroBlaze RISC-V + custom AXI I2S IP)
- **Software app**: `workspace/hello_world/src/helloworld.c`
- **Target DAC**: PCM5102-style I2S module

## Initial Symptoms

1. No sound after clean rebuild.
2. JA I2S pins measured as no activity in normal flow.
3. Temporary activity observed only in specific programming sequences.
4. Later, audio appeared but only on one channel (left).

## Root Causes Identified

## 1) Constraint formatting and reset stability issues

- I2S `get_ports` constraints used inconsistent spacing.
- `reset` input could float, causing unstable behavior.

### Fixes applied

- In `i2s_new/i2s_new.srcs/constrs_1/new/cnstr.xdc`:
  - normalized:
    - `i2s_mclk_0`
    - `i2s_bclk_0`
    - `i2s_ws_0`
    - `i2s_data_0`
  - added reset pull-down:
    - `set_property ... PULLDOWN true [get_ports reset]`

## 2) Fragile I2S clocking/CDC in custom IP

- The I2S bit/word generation path depended on a cross-domain pulse method that was sensitive to reset/domain interactions.

### Fixes applied

- In `ip_repo/i2s_1_0/hdl/i2s_slave_lite_v1_0_S00_AXI.v`:
  - changed BCLK enable generation to direct audio-domain condition:
    - `wire bclk_en_w = (clock_div_q == 3'd0);`
  - moved I2S output generator to audio domain:
    - `always @(posedge audio_clk or posedge audio_rst)`
  - removed dependence on AXI-domain pulse synchronizer for BCLK stepping.

## 3) Debugger workflow reprogramming mismatch

- Sound behavior changed depending on whether Vivado or Vitis programmed the FPGA.
- Vitis run/reset could re-apply a stale or mismatched hardware context if launch config was not controlled.

### Required workflow

1. Program FPGA in Vivado with known-good bitstream.
2. In Vitis launch config:
   - **Program Device = OFF**
   - **Stop At Entry = OFF**
3. Run only ELF download/execute on processor.

## Validation Performed

## A) Pin mapping confirmation

Implementation report confirmed fixed IO placement:

- `JA1 (J1) -> i2s_mclk_0`
- `JA2 (L2) -> i2s_bclk_0`
- `JA3 (J2) -> i2s_ws_0`
- `JA4 (G2) -> i2s_data_0`

## B) Hardware-path isolation test

- Temporary wrapper-level debug toggles were used to prove physical JA output path.
- Result: JA pins toggled correctly when forced at top level.
- Conclusion: board pinout/probing path is valid; failures were design/runtime flow related.

## C) Audio generation app hardening

`helloworld.c` was upgraded to:

- loud continuous 1 kHz square wave
- explicit channel-mode rotation every 2 seconds:
  - LEFT only
  - RIGHT only
  - BOTH

This made audible debugging and channel mapping checks deterministic.

## Final Status

## Resolved

- I2S hardware path is functional.
- Audio output is now achievable with correct programming/run sequence.
- Runtime flow to avoid losing signal after debug launch is established.

## Partially resolved / remaining observation

- Audio currently reported as audible on left channel only.
- This is no longer a dead-I2S issue; it is now likely **channel routing/mapping or analog output wiring**.

## Most likely remaining causes for left-only output

1. DAC analog path connected only to `L OUT`.
2. `R OUT` not connected, muted, or not routed to amplifier.
3. LRCLK/channel slot interpretation mismatch on receiver side.

## Recommended next checks (stereo completion)

1. Verify analog wiring:
   - test both `L` and `R` output pins from DAC board.
2. Keep SCK/MCLK disconnected if that board loads it down.
3. Use the current rotating channel test and confirm:
   - LEFT mode -> left only
   - RIGHT mode -> right only
   - BOTH mode -> both
4. If channels are swapped or collapsed, adjust I2S channel packing/order in software or WS polarity in RTL.

## Files Changed During Resolution

- `i2s_new/i2s_new.srcs/constrs_1/new/cnstr.xdc`
- `ip_repo/i2s_1_0/hdl/i2s_slave_lite_v1_0_S00_AXI.v`
- `workspace/hello_world/src/helloworld.c`

---

If needed, the next follow-up document can capture oscilloscope screenshots and a final stereo pass/fail matrix for publication in the thesis appendix.
