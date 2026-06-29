# Revisi Note

## Bab I — Pendahuluan (chapter-1.tex)

- **fig:ch1-block-sistem-i2s** — Ditambahkan kalimat pengantar sebelum figure: menjelaskan alur data MicroBlaze → AXI4-Lite → IP I2S TX → DAC PCM5102A, menggunakan "diperlihatkan pada Gambar~".

## Bab III — Metode Penelitian (chapter-3.tex)

- **fig:ch3-wiring-dac** — Ditambahkan kalimat pengantar: konfigurasi koneksi pin PMOD Basys3 ke modul DAC PCM5102A, menggunakan "diperlihatkan pada Gambar~".
- **fig:ch3-bd-support-ip** — Ditambahkan kalimat pengantar: peran MicroBlaze V, AXI UARTLite, dan AXI SmartConnect dalam Block Design, menggunakan "diperlihatkan pada Gambar~".
- **Cross-ref `tab:ch4-control`** — Diperbaiki label ref dari `tab:ch4-regmap` → `tab:ch4-regmap-final` dan `tab:ch4-control` → `tab:ch4-control-final` (broken cross-reference).

## Bab IV — Perancangan dan Implementasi (chapter-4.tex)

- **Subsection baru: "Hierarki File dan Modul"** — Ditambahkan setelah paragraf pembuka section 4.1, sebelum "Pembangunan Sistem Dasar MicroBlaze V". Isinya:
  - Empat file sumber utama (`i2s.v`, `i2s_slave_lite_v1_0_S00_AXI.v`, `helloworld.c`, `i2s.h/.c`) beserta peran masing-masing.
  - Diagram hierarki instansiasi modul RTL dalam `\begin{verbatim}`.
  - Alur data dari firmware ke DAC: `helloworld.c` → AXI4-Lite → core RTL → pin FPGA → PCM5102A.
  - Fungsi-fungsi kunci firmware dan lokasi direktori setiap file.
- **fig:ch4-ip-block** — Ditambahkan kalimat pengantar: menjelaskan lima blok internal IP (AXI4-Lite, register file, NCO, latch sampel, serializer), menggunakan "diperlihatkan pada Gambar~".
- **tab:ch4-control-final** — Ditambahkan kalimat pengantar sebelum register map table: "Rincian bitfield register CONTROL... dijelaskan pada Tabel~".

## Bab V — Hasil dan Pembahasan (chapter-5.tex)

- **fig:ch5-waveform, fig:ch5-bit-counter-waveform, fig:ch5-clock-divider-waveform** — Dihapus komentar dekoratif (`% ===...`) dan ekstra baris kosong di sekitar `\section{Pengujian Sinyal I2S}`.
- **fig:ch5-filter-integration** — Ditambahkan kalimat pengantar sebelum figure: menjelaskan integrasi IP I2S dengan modul `i2s_filter_bridge` dan filter IIR, menggunakan "diperlihatkan pada Gambar~".
- **fig:ch5-hw-analysis** — Ditambahkan ref ke parent figure bersama `tab:ch5-resource` dan `fig:ch5-timing-summary` pada paragraf pembuka section analisis sumber daya.
- **fig:ch5-disc-fs** — Dihapus baris kosong antara paragraf pengantar dan `\begin{landscape}`.

## Lampiran Kode Sumber (appendix-code.tex)

- **Dihapus `\chapter{Ringkasan Kode Sumber}`**, `\label{app:code-summary}`, dan `\section{Repositori}`. Diubah menjadi satu paragraf biasa yang langsung menyebutkan link repositori GitHub — tidak lagi menjadi "Bab L".
