# Direktori Gambar Skripsi – I2S TX AXI4-Lite

Folder ini adalah tempat menyimpan semua file gambar/figur yang dirujuk
oleh file `.tex` pada Bab II–IV.

> **Catatan**: Semua file di bawah ini **belum ada** dan perlu dibuat /
> di-capture / di-export setelah tahap perancangan dan pengujian selesai.
> Simpan file di folder ini, lalu hapus komentar (`%`) pada perintah
> `\includegraphics` yang sudah ditulis di file chapter yang bersangkutan.

---

## Daftar File Gambar yang Diharapkan

### Bab II – Tinjauan Pustaka dan Dasar Teori

| Nama File | Keterangan | Bab/Gambar |
|-----------|------------|------------|
| `i2s-timing-diagram.pdf` | Diagram timing I2S: BCLK, WS, SDATA – dua frame stereo 24-bit/32-bit slot | Gambar 2.1 |
| `pcm5102a-pinout.png` | Pinout PCM5102A dan diagram koneksi ke Basys3 | Gambar 2.2 |
| `axi4lite-transaction.pdf` | Diagram alur transaksi tulis dan baca AXI4-Lite | Gambar 2.3 |
| `basys3-board.jpg` | Foto board FPGA Basys3 (Artix-7 XC7A35T) | Gambar 2.4 |
| `mmcm-clocking.pdf` | Diagram hirarki clock: 100 MHz → MMCM → 24,569 MHz → BCLK → WS | Gambar 2.5 |
| `fifo-watermark-diagram.pdf` | Diagram TX FIFO (256 frame) dengan pointer dan mekanisme watermark IRQ | Gambar 2.6 |

### Bab III – Perancangan Sistem

| Nama File | Keterangan | Bab/Gambar |
|-----------|------------|------------|
| `block-diagram-system.pdf` | Diagram blok sistem keseluruhan: MicroBlaze V → AXI → I2S TX → PCM5102A | Gambar 3.1 |
| `state-machine-serializer.pdf` | Diagram state machine serializer I2S (IDLE, LEFT\_CH, RIGHT\_CH) | Gambar 3.2 |
| `block-design-planned.pdf` | Rancangan diagram blok IP Integrator Vivado | Gambar 3.3 |
| `flowchart-main-cpp.pdf` | Flowchart program Vitis `main.cpp` (init, isi FIFO, ISR loop) | Gambar 3.4 |

### Bab IV – Implementasi dan Pengujian

| Nama File | Keterangan | Bab/Gambar |
|-----------|------------|------------|
| `mmcm-requested-vs-actual.png` | Screenshot Clocking Wizard Vivado: requested vs actual (24,569 MHz) | Gambar 4.1 |
| `vivado-block-design.png` | Screenshot block design Vivado IP Integrator (hasil akhir) | Gambar 4.2 |
| `sim-waveform-i2s.png` | Waveform simulasi RTL (XSIM/GTKWave): BCLK, WS, SDATA | Gambar 4.3 |
| `ila-capture-48k.png` | Screenshot ILA Vivado Hardware Manager – Mode 0 (~48 kHz) | Gambar 4.4 |
| `ila-capture-96k.png` | Screenshot ILA Vivado Hardware Manager – Mode 1 (~96 kHz) | Gambar 4.5 |
| `audio-test-output.jpg` | Bukti keluaran audio: foto osiloskop atau screenshot Audacity | Gambar 4.6 |

---

## Catatan Format

- Gunakan **PDF** untuk gambar vektor (diagram, state machine, flowchart)
  agar hasil cetak tajam.
- Gunakan **PNG** untuk screenshot software (ILA, Vivado, Audacity).
- Gunakan **JPG/JPEG** untuk foto hardware.
- Resolusi minimal untuk PNG/JPG: **150 dpi** (cetak), **300 dpi** (optimal).
