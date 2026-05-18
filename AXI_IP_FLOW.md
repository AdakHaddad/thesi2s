# AXI IP Design & Verification Flow

This document describes a recommended workflow for developing an IP core that is wrapped with AXI interfaces, and practical steps to verify the testbench.

## Overview

- Develop core logic independently from AXI protocol complexity.
- Add AXI wrapper(s) to adapt core to AXI4-Lite (control) and/or AXI4-Stream (data). 
- Use focused simulation to catch logic bugs, then integration simulation for protocol and corner cases, and only use hardware (bitstream) for timing/physical validation.

## Recommended Flow (step-by-step)

1. **Write a short spec**: functionality, reg map, data widths, clocks, reset behavior, performance targets, expected interfaces (AXI4-Lite, AXI-Stream, clocks).
2. **Implement core RTL**: plain Verilog/SystemVerilog module(s) without AXI glue. Keep port-level interface simple (valid/ready or simple input/output signals).
3. **Create a local unit testbench**: self-checking TB exercising functional behavior (golden model comparisons, corner cases). Iterate until stable.
4. **Add AXI wrapper**: small adapter module mapping AXI transactions to core ports (AXI4-Lite registers, AXI-Stream handshakes). Keep wrapper small and isolated.
5. **Integration TB**: use AXI BFMs or existing AXI verification libraries to exercise protocol details, randomize delays, and assert bus-level correctness.
6. **Simulate coverage & regressions**: enable functional coverage (if available) and run a regression suite (deterministic seeds + randomized tests).
7. **Top-level / Block Design**: add wrapper/core to your Vivado Block Design or top-level wrapper with clocks, resets, and constraints.
8. **Hardware validation**: program bitstream when necessary. Use osiloskop/simulasi probes and incremental builds for hardware-specific issues.
9. **Package and document**: create .xci/.zip with example BD, reg map, and simulation TB.

## Example repo layout

- rtl/
  - core.sv
  - axi_wrapper.sv
- tb/
  - tb_core.sv        # unit TB for core
  - tb_axi.sv         # integration TB with AXI BFMs
  - run_sim.sh
- doc/
  - regmap.md

## Tools & quick commands

- Vivado XSIM (recommended for Vivado flows): open project and run simulation from IP integrator or run `xsim` for compiled simulations.
- Icarus Verilog + GTKWave (good for simple Verilog):

```bash
iverilog -g2012 -o tb.vvp tb_core.sv core.sv
vvp tb.vvp
gtkwave dump.vcd
```

- For SystemVerilog features: use Questa/VCS or Verilator (with cocotb for Python-driven tests).
- cocotb + Verilator example (run from repo root):

```bash
pytest -q tests/test_core.py   # assumes cocotb test harness and verilator build
```

## Making the testbench verifiable (best practices)

- Make TB self-checking: the TB should automatically `PASS` or `FAIL` (use exit codes, printed summaries, or assertions) rather than requiring manual waveform inspection for functional correctness.
- Use assertions: add `assert` statements (SystemVerilog) or explicit check routines in TB to catch protocol/logic violations early.
- Reference model: implement a golden model (C/Python/behavioral SV) and compare outputs cycle-by-cycle.
- Deterministic seeds: when using randomized stimuli, log and reuse RNG seeds to reproduce failing tests.
- Edge/corner-case tests: include reset, backpressure, stalled bus, max/min lengths, misaligned transfers.
- Protocol fuzzing: random delays, random valid/ready timings, and malformed transactions to test robustness.
- Automated regression: create a script that runs all TBs and reports summary pass/fail. Example: `./tb/run_sim.sh` that returns non-zero on failure.

## Verifying the testbench — concrete steps

1. Create a small, self-checking unit TB (`tb_core.sv`) with:
   - deterministic stimulus vectors + randomized tests
   - golden-model comparator
   - an `initial` block that prints a concise PASS/FAIL and uses `$finish` (exit code is simulator dependent).

2. Run unit simulation and assert expected outputs. Confirm TB prints `PASS` and simulator exit code is success.

3. Add AXI integration TB (`tb_axi.sv`) using a BFM or simple modeled master:
   - exercise register read/writes (AXI4-Lite): verify reg map and side-effects.
   - exercise streaming data paths (AXI4-Stream): verify throughput, backpressure, and dropped/partial frames.

4. Regression run: create `run_sim.sh` that:
   - builds each TB
   - runs each test (multiple seeds)
   - captures logs and returns non-zero on any failure

5. Use waveform checklist when manually inspecting waves:
   - clock/reset timing correct
   - valid/ready handshakes obeyed (no illegal simultaneous sample)
   - register write/read show expected values
   - data integrity across clock domains (if CDC used)

6. Add functional coverage and assertions (if supported) to measure test completeness. Aim for coverage points for all reg accesses, error conditions, and corner protocols.

7. If a failure appears only on hardware:
   - add osiloskop/simulasis to observe suspect signals (AXI channels, core internal state)
   - try incremental bitstreams or smaller systems to isolate the issue

## Pass/fail criteria (practical)

- Unit tests: all self-checking TBs exit with PASS and return code 0.
- Integration: no protocol assertion fails; sampled outputs match the golden model over long randomized runs.
- Coverage: critical coverage points reached (or known exceptions documented).
- Hardware: if needed, measured signals (osiloskop/simulasi/oscilloscope/headset) match reference behavior within timing/analog constraints.

## Automation & CI

- Put `run_sim.sh` and a lightweight harness into CI. Fail pipeline on any non-zero exit.
- Log waveform segments and failing seeds for quick reproduction.

## Quick verification checklist (one-liner actions)

- Unit sim PASS? -> yes/no
- Integration AXI protocol checks PASS? -> yes/no
- Golden-model compare PASS? -> yes/no
- Coverage adequate? -> yes/no
- Hardware-only issues reproducible in osiloskop/simulasi? -> yes/no

---

If you want, I can scaffold a minimal `core.sv`, `axi_wrapper.sv`, `tb_core.sv`, and `tb_axi.sv` in this repo and add a `run_sim.sh` for Icarus/GTKWave or a cocotb example. Which simulator/toolchain do you prefer? (Vivado XSIM, Icarus+GTKWave, Questa/VCS, or Verilator+cocotb?)
