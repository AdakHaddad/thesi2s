from manim import *


class SystemTopology(Scene):
    def construct(self):
        title = Text("I2S Transmit Path", font_size=36).to_edge(UP)
        cpu = Rectangle(width=2.5, height=1.2, color=BLUE).shift(LEFT * 4)
        cpu_label = Text("CPU / Firmware", font_size=20).move_to(cpu.get_center())

        ip = Rectangle(width=3.2, height=1.4, color=ORANGE)
        ip_label = Text("I2S Transmitter IP", font_size=20).move_to(ip.get_center())

        dac = Rectangle(width=2.5, height=1.2, color=GREEN).shift(RIGHT * 4)
        dac_label = Text("PCM5102A DAC", font_size=20).move_to(dac.get_center())

        arrow1 = Arrow(start=cpu.get_right(), end=ip.get_left(), buff=0.1)
        arrow1_label = Text("AXI4-Lite writes", font_size=16).next_to(arrow1, UP)
        arrow2 = Arrow(start=ip.get_right(), end=dac.get_left(), buff=0.1)
        arrow2_label = Text("BCLK / WS / DATA", font_size=16).next_to(arrow2, UP)

        self.play(FadeIn(title))
        self.play(Create(cpu), Write(cpu_label))
        self.play(Create(ip), Write(ip_label))
        self.play(Create(dac), Write(dac_label))
        self.play(GrowArrow(arrow1), Write(arrow1_label))
        self.play(GrowArrow(arrow2), Write(arrow2_label))
        self.wait(2)

        # ----- Parameters (match firmware defaults where possible) -----
        # Default firmware values (see helloworld.c)
        SAMPLE_WIDTH_DEFAULT = 24  # g_width default in firmware
        FS_DEFAULT = 48000         # default family/mode -> 48 kHz
        # Slot width used for I2S slots (bits per channel in slot). Research uses 32.
        SLOT_WIDTH = 32


class RegisterMapScene(Scene):
    def construct(self):
        title = Text("Register Map", font_size=34).to_edge(UP)
        regs = VGroup()

        names = ["0x00: DATA_LEFT", "0x04: DATA_RIGHT", "0x08: CONTROL"]
        boxes = VGroup(*[Square(side_length=1.6, color=GREY) for _ in names])
        labels = VGroup(*[Text(n, font_size=20) for n in names])
        boxes.arrange(RIGHT, buff=0.8).shift(LEFT * 1.5)
        for b, l in zip(boxes, labels):
            l.move_to(b.get_center())
        regs.add(boxes, labels)

        cpu = Rectangle(width=2.5, height=1.2, color=BLUE).shift(LEFT * 4)
        cpu_label = Text("CPU writes", font_size=20).move_to(cpu.get_center())
        arrow = Arrow(start=cpu.get_right(), end=boxes[1].get_top() + DOWN * 0.4, buff=0.1)

        self.play(FadeIn(title))
        self.play(Create(cpu), Write(cpu_label))
        self.play(LaggedStart(*[Create(b) for b in boxes], lag_ratio=0.25))
        self.play(LaggedStart(*[Write(l) for l in labels], lag_ratio=0.25))
        # Move a token to DATA_LEFT and DATA_RIGHT
        token = Dot(color=ORANGE).scale(1.2).move_to(cpu.get_right() + RIGHT * 0.5)
        self.play(FadeIn(token))
        self.play(token.animate.move_to(boxes[0].get_center()), run_time=1)
        self.play(Flash(boxes[0], flash_radius=0.6))
        self.wait(0.5)
        self.play(token.animate.move_to(boxes[1].get_center()), run_time=1)
        self.play(Flash(boxes[1], flash_radius=0.6))
        # Flash control
        ctrl_token = Square(side_length=0.6, color=ORANGE).move_to(cpu.get_right() + RIGHT * 0.5)
        self.play(FadeIn(ctrl_token))
        self.play(ctrl_token.animate.move_to(boxes[2].get_center()), run_time=1)
        self.play(Indicate(boxes[2], scale_factor=1.1))
        self.wait(1)


class ControlBitfieldScene(Scene):
    def construct(self):
        title = Text("CONTROL Register Bitfield", font_size=30).to_edge(UP)
        bar = Rectangle(width=10, height=1, color=GREY).shift(DOWN * 0.5)
        bits = VGroup(*[Rectangle(width=10/32 - 0.02, height=0.9) for _ in range(32)])
        for i, b in enumerate(bits):
            b.set_stroke(width=0.5)
        bits.arrange(RIGHT, buff=0.01).move_to(bar.get_center())

        # highlight ranges as examples
        labels = ["EN", "MUTE", "FS_FAMILY", "FS_MODE", "SAMPLE_WIDTH"]
        ranges = [(0, 0), (1, 1), (2, 2), (3, 3), (8, 12)]

        self.play(FadeIn(title))
        self.play(Create(bar))
        self.play(LaggedStart(*[Create(b) for b in bits], lag_ratio=0.02, run_time=1.2))
        for lab, (start, end) in zip(labels, ranges):
            group = VGroup(*bits[start:end + 1])
            box = SurroundingRectangle(group, color=ORANGE, buff=0.05)
            txt = Text(lab, font_size=20).next_to(box, UP)
            self.play(Create(box), Write(txt))
            self.wait(1.0)
            self.play(FadeOut(txt), Uncreate(box))
        self.wait(1)


class FrameLatchScene(Scene):
    def construct(self):
        title = Text("Frame Latching", font_size=32).to_edge(UP)
        left = Rectangle(width=2, height=1, color=ORANGE).shift(LEFT * 2 + DOWN)
        right = Rectangle(width=2, height=1, color=ORANGE).shift(RIGHT * 2 + DOWN)
        left_label = Text("Left sample", font_size=18).move_to(left.get_center())
        right_label = Text("Right sample", font_size=18).move_to(right.get_center())

        shadow = Rectangle(width=5, height=1.2, color=GREY).shift(UP * 1)
        shadow_label = Text("Shadow register", font_size=20).move_to(shadow.get_center())
        latch_line = DashedLine(start=UP * 0.5 + LEFT * 0.5, end=UP * -1.5 + LEFT * 0.5)

        self.play(FadeIn(title))
        self.play(Create(left), Write(left_label))
        self.play(Create(right), Write(right_label))
        self.play(Create(shadow), Write(shadow_label))
        self.wait(0.6)
        # move samples to shadow then latch
        self.play(left.animate.shift(UP * 1.2), right.animate.shift(UP * 1.2), run_time=1)
        self.play(ShowCreation(latch_line))
        self.play(Indicate(shadow, scale_factor=1.05))
        self.wait(1)


class SerializationScene(Scene):
    def construct(self):
        title = Text("I2S Serialization (Philips Standard)", font_size=32).to_edge(UP)
        self.play(FadeIn(title))

        # timing strip labels and lines
        bclk = Line(LEFT * 5, RIGHT * 5).shift(UP * 1.5)
        bclk_lab = Text("BCLK", font_size=20, color=BLUE).next_to(bclk, LEFT)
        ws = Line(LEFT * 5, RIGHT * 5).shift(UP * 0.5)
        ws_lab = Text("WS (LRCK)", font_size=20, color=YELLOW).next_to(ws, LEFT)
        data = Line(LEFT * 5, RIGHT * 5).shift(DOWN * 0.5)
        data_lab = Text("DATA", font_size=20, color=GREEN).next_to(data, LEFT)

        # Create waves
        bclk_wave = VGroup(*[
            Line(ORIGIN, UP * 0.5).shift(RIGHT * (i * 0.5) + LEFT * 5 + UP * 1.25) if i % 2 == 0 else 
            Line(UP * 0.5, ORIGIN).shift(RIGHT * (i * 0.5) + LEFT * 5 + UP * 1.25)
            for i in range(21)
        ])
        # connect tops and bottoms
        for i in range(len(bclk_wave)-1):
            start = bclk_wave[i].get_end() if i % 2 == 0 else bclk_wave[i].get_start()
            end = bclk_wave[i+1].get_start() if i % 2 != 0 else bclk_wave[i+1].get_end()
            # Wait, easier way for square wave:
            pass
        
        # Simpler visual: Bit boxes shifting
        bits_group = VGroup()
        values = ["0", "MSB", "B1", "B2", "...", "LSB"]
        colors = [GREY, GREEN, GREEN, GREEN, GREEN, GREEN]
        
        for i, (v, c) in enumerate(zip(values, colors)):
            box = Square(side_length=0.6, fill_opacity=0.3, color=c)
            txt = Text(v, font_size=16).move_to(box.get_center())
            bits_group.add(VGroup(box, txt))
        
        bits_group.arrange(RIGHT, buff=0.1).move_to(LEFT * 3 + DOWN * 0.5)
        
        ws_rect = Rectangle(width=5, height=0.6, color=YELLOW, fill_opacity=0.1).move_to(LEFT * 2.5 + UP * 0.5)
        ws_txt = Text("Left Channel (WS=LOW)", font_size=18).move_to(ws_rect.get_center())

        self.play(Create(bclk), Write(bclk_lab), Create(ws), Write(ws_lab), Create(data), Write(data_lab))
        self.play(FadeIn(ws_rect), Write(ws_txt))
        self.play(LaggedStart(*[FadeIn(b) for b in bits_group], lag_ratio=0.1))

        # Show the "One-bit Delay"
        arrow = Arrow(start=ws_rect.get_left() + DOWN * 0.2, end=bits_group[0].get_top(), color=RED)
        delay_txt = Text("One-bit delay", font_size=16, color=RED).next_to(arrow, RIGHT)
        
        self.play(GrowArrow(arrow), Write(delay_txt))
        self.play(Indicate(bits_group[0], color=RED))
        self.wait(1.5)
        self.play(FadeOut(arrow), FadeOut(delay_txt))

        # Shift bits
        for _ in range(3):
            self.play(bits_group.animate.shift(RIGHT * 0.7), run_time=0.6)
            self.play(Flash(bits_group[1], flash_radius=0.4))

        self.wait(1)


class I2SAnimation(Scene):
    def construct(self):
        # combine condensed versions of scenes for a single-run render
        self.play(FadeIn(Text("I2S Animation - Overview", font_size=36)))
        self.wait(0.5)
        self.wait(0.2)
        # We call other scenes by manually creating simplified elements here
        topo = SystemTopology()
        # Note: manim doesn't allow calling construct of other Scene objects
        # from a Scene in a simple way; render scenes individually. This
        # class is a placeholder if you want one-shot composition.
        self.play(FadeOut(*self.mobjects))
        self.wait(0.2)
