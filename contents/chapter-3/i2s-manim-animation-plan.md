# I2S Logic Animation Plan for Manim

## Direction
Use Manim when the goal is a precise, reusable animation of the I2S transmit path.
This is better than manual PowerPoint animation if the timing, bit motion, and register
flow need to stay consistent across edits.

## Core Idea
Animate the system as a data pipeline:

1. Firmware writes register values.
2. The I2S core captures control state and sample data.
3. The serializer emits bits on BCLK.
4. WS/LRCLK separates left and right channels.
5. The DAC receives the final stream.

## Recommended Scene Set

### Scene 1: System Topology
Show three fixed blocks:
- CPU / firmware
- I2S transmitter IP
- PCM5102A DAC

Animation:
- Draw the blocks.
- Fade in arrows between them.
- Add labels for AXI4-Lite, BCLK, WS, and DATA.

Purpose:
- Give the viewer the full signal path before the detailed logic starts.

### Scene 2: Register Map
Show the memory map as a vertical or horizontal panel.

Registers:
- DATA_LEFT at `0x00`
- DATA_RIGHT at `0x04`
- CONTROL at `0x08`

Animation:
- Highlight each register one by one.
- Move a sample token from CPU into the left and right data registers.
- Flash the CONTROL register when configuration changes.

Purpose:
- Explain that the design is controlled by software writes.

### Scene 3: CONTROL Bitfield
Show a 32-bit bar for CONTROL.

Fields:
- `ENABLE`
- `MUTE`
- `FS_FAMILY`
- `FS_MODE`
- `SAMPLE_WIDTH`

Animation:
- Light up each bit range.
- Attach a short label next to the highlighted field.
- Show example values changing at runtime.

Purpose:
- Show that the app defines operating mode at runtime.

### Scene 4: Stereo Latch
Show two sample boxes, left and right, entering a shadow register.

Animation:
- Samples move into a staging area.
- At the frame boundary, both channels update together.
- Mark the latch moment with a vertical line.

Purpose:
- Make the frame-coherent update visible.

### Scene 5: I2S Serialization
Show a compact timing strip:
- BCLK as a square wave
- WS as a channel marker
- DATA as a shifting bit stream

Animation:
- Toggle BCLK continuously.
- Shift bits out MSB first.
- Insert the one-bit delay after WS change.
- Keep the serializer aligned with the sample width.

Purpose:
- Teach the actual I2S timing rule.

### Scene 6: Output to DAC
Show the serialized data entering the PCM5102A block.

Animation:
- Data stream reaches the DAC.
- A waveform appears at the output.
- Optionally add a speaker icon or headphones icon.

Purpose:
- Close the loop from firmware write to audible result.

## Scene Timing

- Scene 1: 3 to 4 s
- Scene 2: 4 s
- Scene 3: 5 s
- Scene 4: 3 s
- Scene 5: 6 to 8 s
- Scene 6: 3 s

## Visual Rules

- Keep the layout horizontal.
- Use one accent color per data type:
  - blue for CPU actions
  - orange for register movement
  - green for active serial output
- Avoid dense labels.
- Prefer simple geometric shapes over realistic icons.
- Keep the background dark or neutral so timing lines and bits are easy to see.

## Suggested Manim Objects

- `Rectangle` for blocks
- `Arrow` for data flow
- `Text` and `MathTex` for labels
- `SurroundingRectangle` for highlights
- `Line` and `DashedLine` for frame boundaries
- `VGroup` for register panels
- `ValueTracker` for moving sample and bit positions

## Implementation Order

1. Build a reusable style layer for blocks, arrows, and labels.
2. Implement the system topology scene.
3. Add the register map scene.
4. Add the CONTROL bitfield scene.
5. Add the latch and serialization scenes.
6. Export the full animation and embed it in PowerPoint.

## Minimal Delivery Recommendation

If time is short, animate only these three parts:
- register write
- CONTROL bitfield
- bit serialization

That gives the clearest explanation with the least production effort.
