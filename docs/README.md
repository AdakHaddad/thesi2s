# I2S DDS Visualization

This directory contains animations and visualizers to explain the I2S DDS (Direct Digital Synthesis) mechanism and data movement.

## Interactive Web Visualizer
- **File**: `i2s_animation.html`
- **Description**: A real-time interactive SVG animation showing the phase accumulator, BCLK toggling, and data shifting.
- **How to use**: Open the file in any modern web browser. You can adjust the Sampling Frequency (Fs) using the slider to see how the DDS step affects the clock generation.

## Manim Video Script
- **File**: `../tools/manim/i2s_visualizer.py`
- **Description**: A Manim (Python) script for generating high-quality explanatory videos.
- **How to run**:
  ```bash
  cd ../tools/manim
  manim -pql i2s_visualizer.py I2SVisualizer
  ```

## Key Concepts Visualized
1. **Phase Accumulator**: Shows how the integer frequency word is added to the accumulator every system clock cycle.
2. **Overflow/Wrap**: Demonstrates that BCLK toggles only when the accumulator wraps around.
3. **Data Latching**: Shows the exact moment (BCLK rising edge at bit 0) when samples are latched from the AXI registers.
4. **I2S Timing**: Visualizes the "one-bit delay" characteristic of the Philips I2S protocol.
