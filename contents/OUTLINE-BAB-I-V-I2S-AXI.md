# Outline skripsi: IP I2S TX AXI4-Lite (Basys3, PCM5102A, 24-bit stereo, 2 mode Fs, FIFO, watermark IRQ, Vitis, ILA)

Dokumen ini adalah **outline siap pakai** (Markdown) untuk mengisi skripsi berbasis template DTETI (`thesisdtetiugm`). Di akhir ada **pemetaan ke file `chapter-*.tex`**, **inventaris gambar/tabel**, **checklist isi minimal per subbab**, dan **rujukan** ke catatan teknis di repo.

---

## Pemetaan outline (Bab I–V) ke template enam bab LaTeX

Template [main.tex](../main.tex) memuat `\include{contents/chapter-1/chapter-1}` … `chapter-6`. Outline lima bab kamu dipetakan seperti berikut agar **tidak perlu mengubah struktur `\include`**:

| Outline (konsep) | File LaTeX | Keterangan |
|-------------------|------------|------------|
| **Bab I** Pendahuluan | [contents/chapter-1/chapter-1.tex](chapter-1/chapter-1.tex) | Sesuaikan judul/rumusan dengan fokus **I2S AXI**; bagian I2C bisa dipangkas atau dipindah lampiran jika judul final hanya I2S. |
| **Bab II** Tinjauan pustaka / landasan teori | [contents/chapter-2/chapter-2.tex](chapter-2/chapter-2.tex) | Tambah/subbab FIFO, watermark, MMCM sesuai outline 2.4-2.6; sudah ada subbab integrasi DAC/UART. |
| **Bab III** Perancangan sistem | [contents/chapter-3/chapter-3.tex](chapter-3/chapter-3.tex) | Saat ini judul bab template: *Metode Penelitian* -- isi bisa diarahkan ke **spesifikasi + arsitektur + register map**; bagian "alat bahan" bisa diringkas atau diletakkan di awal Bab IV. |
| **Bab IV** Implementasi dan pengujian | [contents/chapter-4/chapter-4.tex](chapter-4/chapter-4.tex) | Ganti placeholder template dengan RTL, Vivado, ILA, PCM5102, tabel ukur. |
| *(opsional)* Diskusi tambahan / perbandingan | [contents/chapter-5/chapter-5.tex](chapter-5/chapter-5.tex) | Template "Tambahan (Opsional)"; isi jika perlu memisahkan pembahasan panjang. |
| **Bab V** Kesimpulan dan saran | [contents/chapter-6/chapter-6.tex](chapter-6/chapter-6.tex) | Sudah berjudul *Kesimpulan dan Saran*. |

---

## Bab I. Pendahuluan

### 1.1 Latar belakang

- Pentingnya audio digital; I2S sebagai protokol audio serial pada sistem embedded/FPGA.
- Kebutuhan *peripheral* audio yang dapat diprogram lewat bus on-chip; keterbatasan atau biaya menggunakan IP/pemacu yang tidak transparan.
- Integrasi **AXI4-Lite** (memory-mapped register) untuk kontrol dari **MicroBlaze V** + **Vitis**.
- Fokus sistem: **TX-only**, **dua mode** frekuensi sampling (≈48 kHz / ≈96 kHz) dari satu `audio_clk` riil (MMCM), **24-bit** per saluran dalam **slot 32-bit**, **FIFO + interupsi watermark** untuk mengurangi underrun dan beban CPU.
- Tantangan **clock audio** pada FPGA: frekuensi *requested* vs *actual* Clocking Wizard; dampak pada \(F_s\) yang dilaporkan sebagai nilai ≈.

**Checklist isi minimal:** motivasi masalah, batasan platform (Basys3), peran PCM5102A, satu kalimat scope (tanpa RX/DMA/Linux jika memang batasan).

### 1.2 Rumusan masalah

- Bagaimana merancang **IP core I2S TX** yang dapat dikontrol melalui **AXI4-Lite**?
- Bagaimana mendukung **peralihan / dua mode** \(F_s\) (≈48 kHz dan ≈96 kHz) dari satu sumber `audio_clk` (dengan pembagi berbeda)?
- Bagaimana **menyangga data** dengan **FIFO** dan **interupsi watermark** agar pemutaran stabil dengan *programmed I/O*?
- Bagaimana **menguji** fungsionalitas dan **timing** (simulasi opsional, **ILA** wajib, bukti audio)?
- *(Opsional)* Peluang lanjut: DMA, driver Linux / ASoC.

**Checklist isi minimal:** 3–5 pertanyaan terukur; selaras dengan batasan Bab I.4.

### 1.3 Tujuan penelitian

- Merancang peripheral **I2S TX** dengan antarmuka **AXI4-Lite** dan register map terdefinisi.
- Mengimplementasikan **dua mode sampling** (nilai nominal vs hasil ukur "actual").
- Mengimplementasikan **FIFO + IRQ watermark** + penanganan underrun; verifikasi dengan **Vitis**, **PCM5102A**, dan **ILA**.

**Checklist isi minimal:** satu poin per rumusan utama; verba yang dapat dicek (mis. "terverifikasi di hardware").

### 1.4 Batasan masalah

- **TX-only**; stereo; **24-bit** dalam slot **32-bit**; **dua mode** \(F_s\) dari `audio_clk` aktual.
- Tanpa **RX**, tanpa **DMA**, tanpa **Linux** (kecuali disebut sebagai saran).
- Uji pada **Basys3** + modul **PCM5102A**; transfer data via **programmed I/O** (register / ISR refill).

**Checklist isi minimal:** daftar bullet eksplisit; hindari klaim di luar scope.

### 1.5 Manfaat penelitian

- Acuan perancangan **IP audio custom** di FPGA dengan pola register + FIFO + IRQ.
- Fondasi pengembangan sistem lanjut (DMA, multi-channel, integrasi OS).

### 1.6 Sistematika penulisan

- Ringkas isi **Bab II** (teori), **Bab III** (perancangan), **Bab IV** (implementasi & pengujian), **Bab V/VI** (kesimpulan & saran) — sesuai pemetaan file di atas.

---

## Bab II. Tinjauan pustaka dan landasan teori

### 2.1 Dasar audio digital

- Sampling, kuantisasi, stereo; \(F_s\); kedalaman bit; SNR kasar.
- Hubungan **byte rate** stereo vs \(F_s\) dan lebar sampel.

**Checklist:** rumus minimal \( \text{byte/s} \approx F_s \times \text{channels} \times (\text{bits}/8) \).

### 2.2 Protokol I2S

- Sinyal **BCLK**, **WS/LRCK**, **DATA**; opsi **MCLK**.
- Slot **32-bit** per saluran, **64 BCLK** per frame stereo; **delay 1-bit** Philips; pemetaan **24-bit** ke slot.
- Tabel singkat mode yang umum (I2S Philips vs left/right-justified) — fokus ke yang dipakai.
- Kaitan dengan **PCM5102A** (peran slave, mengikuti clock dari FPGA).

**Checklist:** satu gambar gelombang atau blok bit; referensi datasheet TI.

### 2.3 AXI4-Lite

- Register memory-mapped; saluran AW/W/B dan AR/R; *handshake* VALID/READY.
- Gambar *timing* atau diagram saluran (opsional).

**Checklist:** contoh satu transaksi baca/tulis register.

### 2.4 FIFO dan interupsi

- Aliran: CPU → register/FIFO → serializer; alasan FIFO pada audio streaming.
- **Underrun** (FIFO kosong saat frame butuh data); konsep **watermark** dan refill berkelompok di ISR.
- Tabel: kedalaman FIFO, watermark contoh, perkiraan frekuensi IRQ.

**Checklist:** diagram blok FIFO + sumber IRQ.

### 2.5 Clocking pada FPGA (MMCM / Clocking Wizard)

- `audio_clk` *requested* vs *actual*; efek pada \(f_{\mathrm{BCLK}}\), \(f_{\mathrm{WS}}\).
- Contoh numerik untuk mode pembagi /8 vs /4 (sesuai desain RTL kamu).

**Checklist:** satu tabel "target vs terukur".

### 2.6 PCM5102A

- Pinout modul; peran BCLK/WS/DIN; variasi board (MCLK tidak terhubung jika tidak dipakai).
- Batasan "programmable" vs **master clock digital dari FPGA**.

**Checklist:** foto/skema wiring; rujuk datasheet.

---

## Bab III. Perancangan sistem

### 3.1 Spesifikasi sistem

- Daftar fitur IP: TX-only, 24-bit stereo, 2 mode \(F_s\), FIFO, watermark IRQ, AXI4-Lite, asumsi clock.

### 3.2 Arsitektur sistem (tingkat tinggi)

- Blok: MicroBlaze → AXI interconnect → IP I2S; Clocking Wizard → `audio_clk`; opsional AXI INTC untuk `irq`.
- Diagram koneksi ke PCM5102A.

### 3.3 Perancangan register map

- Tabel offset, jenis akses (RO/RW/WO/W1C/W1P), deskripsi field.
- Aturan: tulis **TX_LEFT** lalu **TX_RIGHT** mem-*push* frame; **FIFO_RST**; **IRQ_STATUS** W1C; **FS_MODE** hanya aman saat ENABLE=0 (atau auto-reset FIFO saat ganti mode — sesuai implementasi final).

### 3.4 Perancangan pembagi clock dan mode \(F_s\)

- Logika div /8 vs /4 dari `audio_clk`; rumus \(F_s\) dengan 64 BCLK per frame.
- Tabel "target vs actual" untuk kedua mode.

### 3.5 Format frame: I2S 24-bit pada slot 32-bit

- *State* bit counter; padding; urutan MSB.

### 3.6 FIFO TX

- Struktur memori (BRAM); kedalaman; aturan **push** (AXI) / **pop** (serializer).
- Estimasi underrun dan mitigasi (prefill, watermark).

### 3.7 Interupsi watermark dan underrun

- Logika `irq`, `IRQ_EN`, `IRQ_STATUS`; skenario refill di ISR.

### 3.8 Implementasi di Vivado (perancangan integrasi)

- Block Design: instans IP, MMCM, reset, pemetaan alamat, pin `.xdc`.

---

## Bab IV. Implementasi dan pengujian

### 4.1 Implementasi RTL dan integrasi Vivado

- Struktur file Verilog; parameter AXI; koneksi BD; *constraints* pin I2S.

### 4.2 Konfigurasi Clocking Wizard

- Screenshot atau tabel **Requested vs Actual** untuk `audio_clk` (dan clock sistem).

### 4.3 Simulasi RTL dan testbench

- Pola uji diketahui; verifikasi 64 BCLK per frame; urutan WS/DATA.

### 4.4 Pengujian ILA

- Probe: BCLK, WS, DATA, level FIFO, underrun, irq.
- Tangkapan satu frame penuh; *trigger* pada tepi WS.

### 4.5 Pengujian audio PCM5102A

- Wiring Basys3 ↔ modul; opsi tanpa MCLK jika sesuai modul.
- Sinyal uji (mis. sine 1 kHz); bukti osiloskop / rekaman.

### 4.6 Evaluasi kinerja

- Tabel hasil ukur \(F_s\), \(f_{\mathrm{BCLK}}\); kejadian underrun; beban ISR.

### 4.7 Kendala dan solusi

- *Pain points* (clock actual, CDC, prioritas interupsi, debug tips).

---

## Bab V. Kesimpulan dan saran

*(Diisi pada [chapter-6.tex](chapter-6/chapter-6.tex) sesuai template `thesi2s`.)*

### 5.1 Kesimpulan

- Jawab tujuan: IP berfungsi, dua mode, stabilitas dengan FIFO+IRQ, bukti ILA/audio.

### 5.2 Saran pengembangan

- DMA; \(F_s\) tambahan; RX / multi-channel; Linux (UIO / ASoC); port platform; optimasi daya.

---

## Inventaris gambar dan tabel (`contents/figures/`)

Letakkan berkas di folder **`thesi2s/contents/figures/`** (buat folder jika belum ada). Nama di bawah selaras dengan **placeholder yang sudah ada di LaTeX** Bab II dan dengan kebutuhan outline Bab III–IV.

| Nama file (disarankan) | Dipakai di (rencana) | Keterangan |
|-------------------------|----------------------|------------|
| `diagram-aliran-audio-datapath.pdf` | Sudah direferensikan di [chapter-2.tex](chapter-2/chapter-2.tex) | Aliran: sumber → buffer → AXI → I2S → DAC |
| `diagram-clock-bclk-lrck-fs.pdf` | Sudah di [chapter-2.tex](chapter-2/chapter-2.tex) | Relasi BCLK, LRCK, \(F_s\), 64 bit/frame |
| `diagram-uart-vs-i2s-throughput.pdf` | Sudah di [chapter-2.tex](chapter-2/chapter-2.tex) | Throughput UART vs PCM |
| `diagram-sinyal-i2s-philips.pdf` | Bab II | Gelombang atau bit-slot Philips I2S |
| `tabel-mode-i2s-perbandingan.pdf` | Bab II | Opsional: PDF dari spreadsheet |
| `block-diagram-axi4lite-channels.pdf` | Bab II | AW/W/B, AR/R |
| `block-diagram-sistem-i2s-axi.pdf` | Bab I / III | SoC + MMCM + IP + PCM5102A |
| `block-diagram-ip-i2s-tx-intern.pdf` | Bab III | Blok internal IP (AXI, FIFO, clkgen, serializer) |
| `block-design-vivado-i2s-screenshot.png` | Bab III / IV | Screenshot BD |
| `register-map-table.pdf` | Bab III | Tabel register |
| `tabel-divider-fs-actual-vs-target.pdf` | Bab III / IV | Angka terukur vs nominal |
| `flowchart-fifo-refill-isr.pdf` | Bab III / IV | Alur ISR |
| `clocking-wizard-requested-vs-actual.png` | Bab IV | Screenshot wizard |
| `ila-bclk-ws-data.png` | Bab IV | Tangkapan ILA |
| `wiring-pcm5102a-basys3.jpg` | Bab IV | Foto/skema kabel |
| `audio-proof-scope-or-audacity.png` | Bab IV | Bukti dengar/ukur |

**Catatan:** jika kamu hanya punya **PNG/JPG**, salin ke nama yang sama dengan ekstensi `.png`/`.jpg` lalu **sesuaikan** path di `chapter-2.tex` (dan bab lain) agar `\IfFileExists{...}` cocok.

---

## Rujukan teknis (di luar folder `thesi2s`)

| Dokumen | Lokasi |
|---------|--------|
| Panduan in–out I2S, UART, DAC (Markdown) | [contents/chapter-2/PANDUAN-I2S-DAN-INTEGRASI-LENGKAP.md](chapter-2/PANDUAN-I2S-DAN-INTEGRASI-LENGKAP.md) |
| Spesifikasi implementasi v2 (FIFO, register, IRQ) | `D:\Vivado-projects\Basys3\sbml\I2S_V2_IMPLEMENTATION_SPEC.md` |
| Panduan RTL `i2s_slave_lite` | `D:\Vivado-projects\Basys3\sbml\ip_repo\i2s_1_0\I2S_SLAVE_LITE_MASTER_GUIDE.md` |
| Register & alur saat ini (dok proyek FPGA) | `D:\Vivado-projects\Basys3\sbml\I2S_AXI_REGISTER_DOC.md` |

---

## Checklist global sebelum sidang

- [ ] Rumusan, tujuan, batasan, metode, hasil, kesimpulan **satu garis besar** konsisten.
- [ ] Semua gambar di `contents/figures/` yang dipanggil dari LaTeX **ada** atau placeholder `\fbox` sengaja dibiarkan sementara.
- [ ] Tabel **actual vs target** clock dan \(F_s\) diisi angka dari pengukuran (osiloskop / ILA / reported frequency Vivado).
- [ ] Bukti audio minimal: satu sinyal uji + satu rekaman/scope.

---

*Outline ini disusun untuk proyek skripsi I2S AXI4-Lite; sesuaikan judul resmi dan identitas penulis di `main.tex`.*
