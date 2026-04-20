DIREKTORI GAMBAR – PERIPHERAL I2S SKRIPSI
==========================================

Direktori ini menyimpan semua gambar yang diperlukan untuk skripsi.
Setiap gambar diberi nama sesuai dengan kode yang digunakan dalam
perintah \includegraphics{figures/<nama-file>} pada file .tex.

Daftar gambar yang harus ditambahkan (format PNG atau PDF):
-----------------------------------------------------------
block-diagram-system.png
    → Screenshot block design dari Vivado IP Integrator yang menampilkan
      seluruh komponen SoC: MicroBlaze, AXI Interconnect, Clocking Wizard,
      I2S Peripheral, AXI UART Lite, AXI Timer, AXI Interrupt Controller.

clocking-wizard-config.png
    → Tabel "Requested vs Actual" pada Vivado Clocking Wizard (Output Clocks)
      yang menampilkan clk_out1 (100 MHz) dan clk_out2 (24.56897 MHz ≈ 24.576 MHz).

clocking-wizard-locked.png
    → Tampilan port "locked" pada Clocking Wizard yang terhubung ke
      Processor System Reset.

i2s-frame-format.png
    → Diagram timing format frame I2S: BCLK, WS (LRCLK), dan DATA.
      Menampilkan satu frame stereo penuh (32 bit kiri + 32 bit kanan)
      dengan anotasi slot 24-bit MSB-first dalam slot 32-bit.

pcm5102a-schematic.png
    → Skema koneksi antara header Basys3 dan modul PCM5102A:
      pin BCLK, WS (LRCLK), DIN (DATA), FLT, DEMP, XSMT, SCK, VCC, GND.

rtl-architecture.png
    → Diagram blok arsitektur RTL peripheral I2S:
      AXI4-Lite Slave Interface → Register Bank → TX FIFO → Serializer → I2S Output.
      Tampilkan juga IRQ generator dan Clocking sub-block.

fifo-timing-diagram.png
    → Diagram timing operasi TX FIFO: push (tulis TX_LEFT lalu TX_RIGHT),
      pop (setiap awal frame I2S), sinyal fifo_level, dan sinyal irq_watermark.

ila-waveform-96k.png
    → Screenshot ILA (Integrated Logic Analyzer) pada mode 96kHz:
      Probe bclk, ws, data, fifo_level, irq. Tampilkan minimal 4 frame stereo.

ila-waveform-48k.png
    → Screenshot ILA pada mode 48kHz: sama dengan di atas tetapi dengan
      WS period ≈ 20.83 µs (48kHz).

ila-waveform-underrun.png
    → Screenshot ILA menampilkan kondisi underrun: fifo_empty=1, data=0,
      dan flag underrun=1 menyala.

oscilloscope-ws-bclk.png
    → Foto atau screenshot oscilloscope/logic analyzer yang menampilkan
      sinyal WS (~95.97kHz atau ~47.99kHz) dan BCLK (~6.14MHz atau ~3.07MHz)
      dari pin Basys3 yang terhubung ke PCM5102A.

oscilloscope-audio-output.png
    → Foto atau screenshot oscilloscope pada keluaran analog PCM5102A
      (sinyal 1kHz sine wave yang diputar dari Vitis main.cpp demo).

vivado-resource-utilization.png
    → Screenshot laporan Resource Utilization Summary dari Vivado setelah
      implementasi selesai.
