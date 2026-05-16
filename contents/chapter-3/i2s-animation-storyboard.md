# I2S Logic Animation Storyboard

## Goal
Show how the I2S transmitter moves from software control to serial audio output:
1. CPU writes registers.
2. IP latches control and sample data.
3. Serializer shifts bits out on BCLK.
4. WS/LRCLK marks left and right channels.

## Best Tool Choice

### Use PowerPoint if:
- You want a fast result.
- The animation is mainly for a thesis defense or slide presentation.
- You want to manually control each step and easily adjust layouts.
- The logic is simple enough to show with shapes, arrows, and motion paths.

### Use Manim if:
- You want precise timing and repeatable animation.
- You need code-driven visual consistency.
- You plan to reuse the animation in video, paper, or multiple slides.
- You want exact waveform-style motion or frame-by-frame control.

### Recommendation
For a Core Dumped-style explanation inside PPT, start with PowerPoint.
If the animation must be very accurate to the I2S timing diagram, use Manim.

## Visual Style

- Keep the layout horizontal: software on the left, IP in the center, DAC/output on the right.
- Use 3 colors only:
  - Blue for CPU/software actions.
  - Orange for register updates and data movement.
  - Green for active output / valid serial data.
- Use simple blocks, arrows, and a timing strip at the bottom.
- Avoid too much text on screen; let labels appear one at a time.

## Scene Breakdown

### Scene 1: System Overview
Show three blocks:
- CPU / firmware
- I2S IP
- PCM5102A DAC

Add arrows:
- CPU -> I2S IP: write control and sample data
- I2S IP -> DAC: BCLK, WS, DATA

On-screen text:
- "Software configures the transmitter"
- "Hardware serializes audio"

### Scene 2: Register Write
Highlight the memory map:
- DATA_LEFT at 0x00
- DATA_RIGHT at 0x04
- CONTROL at 0x08

Animation:
- CPU block flashes.
- Arrow moves to the CONTROL register.
- Then sample data moves to DATA_LEFT and DATA_RIGHT.

Caption:
- "Firmware writes control and stereo samples through AXI4-Lite"

### Scene 3: Control Bitfield
Show a 32-bit CONTROL register bar.

Highlight bits in order:
- ENABLE
- MUTE
- FS_FAMILY
- FS_MODE
- SAMPLE_WIDTH

Animation:
- Each bit lights up when explained.
- Show the selected value next to the bit.

Caption:
- "The application defines the runtime behavior"

### Scene 4: Frame Latching
Show a frame boundary between left and right channels.

Animation:
- Sample value enters shadow register.
- At the frame edge, left and right update together.
- Show a vertical marker for the latch moment.

Caption:
- "Both channels are latched together at frame boundary"

### Scene 5: Bit Serialization
Show one stereo frame as a sequence of bits.

Animation:
- BCLK toggles continuously.
- WS changes state between left and right.
- DATA shifts MSB first.
- First bit after WS transition is zero.

Caption:
- "Philips I2S uses MSB-first with a one-bit delay"

### Scene 6: Audio Output
Show the DAC receiving the stream.

Animation:
- DATA line reaches PCM5102A.
- Output wave appears on speaker/headphone icon.

Caption:
- "The serial stream becomes analog audio"

## Suggested Timing

- Scene 1: 3 to 4 seconds
- Scene 2: 4 seconds
- Scene 3: 5 seconds
- Scene 4: 3 seconds
- Scene 5: 6 to 8 seconds
- Scene 6: 3 seconds

## If Using PowerPoint

- Build each scene as a separate slide.
- Use Morph transition if available.
- Use fade for labels and wipe for arrows.
- Use motion paths only for moving sample blocks.
- Keep one master layout and duplicate it across scenes.

## If Using Manim

- Model the CPU, IP, and DAC as fixed rectangles.
- Use an animated register bar for CONTROL.
- Use moving dots or bit boxes for DATA.
- Use separate scenes for register write, latching, and serialization.
- Export as MP4 and insert the video into PowerPoint.

## Short Decision Rule

- Choose PowerPoint if you want faster production and slide editing flexibility.
- Choose Manim if timing accuracy and code reuse matter more than setup time.
