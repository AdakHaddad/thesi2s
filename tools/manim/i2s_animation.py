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
        title = Text("I2S Serialization", font_size=34).to_edge(UP)
        self.play(FadeIn(title))

        # timing strip
        bclk = Line(LEFT * 6, RIGHT * 6).shift(DOWN * 1.5)
        bclk_label = Text("BCLK", font_size=20).next_to(bclk, LEFT)
        ws_line = Line(LEFT * 6, RIGHT * 6).shift(DOWN * 0.6)
        ws_label = Text("WS / LRCLK", font_size=20).next_to(ws_line, LEFT)
        data_line = Line(LEFT * 6, RIGHT * 6).shift(UP * 0.2)
        data_label = Text("DATA", font_size=20).next_to(data_line, LEFT)

        self.play(Create(bclk), Write(bclk_label))
        self.play(Create(ws_line), Write(ws_label))
        self.play(Create(data_line), Write(data_label))



        # compute BCLK frequency from sample rate and slot width
        sample_rate = FS_DEFAULT
        slot_width = SLOT_WIDTH
        # stereo frame bits = 2 * slot_width
        bclk_freq = sample_rate * 2 * slot_width

        # Map real period to animation period using a scale, but keep a minimum
        real_period = 1.0 / bclk_freq if bclk_freq > 0 else 1.0
        anim_scale = 0.02  # adjust for faster/slower animation
        anim_period = max(real_period * anim_scale, 0.06)

        # draw a short bit stream as boxes shifting right
        bits = VGroup(*[Square(side_length=0.35, fill_opacity=1, color=GREEN) for _ in range(12)])
        bits.arrange(RIGHT, buff=0.12).move_to(LEFT * 4 + UP * 0.2)
        bit_labels = VGroup(*[Text("", font_size=12).move_to(b.get_center()) for b in bits])
        for b, l in zip(bits, bit_labels):
            self.add(b, l)

        # animate bits shifting under DATA line driven by computed anim_period
        iterations = 16
        for i in range(iterations):
            self.play(bits.animate.shift(RIGHT * 0.6), run_time=anim_period)
            # toggle WS visual every slot_width*2 shifts (simulate LRCLK)
            if (i % (slot_width // 8 if slot_width>=8 else 1)) == 0:
                self.play(Indicate(ws_line, color=YELLOW), run_time=anim_period * 0.1)

        self.wait(0.6)


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
