# I2S Manim Animation

This folder contains a starter Manim script to animate the I2S transmit path.

Prerequisites
- Python 3.9+ (use your virtualenv)
- Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Render commands

- Render a single scene (low quality, preview):

```bash
manim -pql i2s_animation.py RegisterMapScene
manim -pql i2s_animation.py ControlBitfieldScene
manim -pql i2s_animation.py FrameLatchScene
manim -pql i2s_animation.py SerializationScene
```

- Render the full script (if you add a combined scene target):

```bash
manim -pql i2s_animation.py I2SAnimation
```

Notes
- The included script is a starter: tweak styling, timing, and bit visuals to match
  the exact I2S timing you need. For high-quality output use `-pqh` or `-p`.
