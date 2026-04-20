# Outline Spesifikasi: Peripheral I2S-Only AXI4-Lite pada Basys3 (Xilinx Artix-7)

> **Status:** Draft v1.0 — dokumen ini adalah *spesifikasi ringkas* (bukan bab skripsi penuh).
> Gunakan sebagai acuan formal untuk implementasi RTL, pengujian, dan penulisan skripsi.

---

## Daftar Isi

1. [Ruang Lingkup](#1-ruang-lingkup)
2. [Non-Ruang Lingkup](#2-non-ruang-lingkup)
3. [Persyaratan Fungsional](#3-persyaratan-fungsional)
4. [Persyaratan Non-Fungsional](#4-persyaratan-non-fungsional)
5. [Antarmuka Pin](#5-antarmuka-pin)
6. [Clocking dan Sample Rate](#6-clocking-dan-sample-rate)
7. [Format Frame / Slot I2S](#7-format-frame--slot-i2s)
8. [Peta Register](#8-peta-register)
9. [Perilaku FIFO](#9-perilaku-fifo)
10. [Perilaku Interrupt](#10-perilaku-interrupt)
11. [Model Interaksi Software (Vitis)](#11-model-interaksi-software-vitis)
12. [Checklist Verifikasi](#12-checklist-verifikasi)
13. [Placeholder Gambar dan Tabel](#13-placeholder-gambar-dan-tabel)

---

## 1. Ruang Lingkup

Peripheral ini adalah **pemancar audio digital I2S (Inter-IC Sound) satu arah** yang:

- Diimplementasikan sebagai **IP custom AXI4-Lite slave** pada FPGA Xilinx Artix-7 (Basys3).
- Menghasilkan sinyal **I2S_BCLK, I2S_LRCLK (WS), dan I2S_SD** untuk mengemudi DAC **PCM5102A** (mode slave, tanpa MCLK eksternal).
- Menerima data audio stereo dari prosesor **MicroBlaze** melalui bus AXI4-Lite, disimpan dalam **FIFO internal**, lalu dikeluarkan secara serial mengikuti protokol I2S standar Philips.
- Mendukung dua mode sample rate: **~48 kHz** dan **~96 kHz**, dipilih via register.
- Meng-generate **interrupt** kepada MicroBlaze pada kondisi FIFO watermark dan FIFO underrun.

---

## 2. Non-Ruang Lingkup

Berikut hal-hal yang **tidak** dicakup dalam spesifikasi ini:

| # | Item yang Dikecualikan | Alasan |
|---|------------------------|--------|
| 1 | Penerimaan audio (I2S RX / ADC path) | Sistem hanya membutuhkan pemutar audio (TX only) |
| 2 | MCLK output ke DAC | PCM5102A dikonfigurasi *no-MCLK* (SCK-less mode); MCLK dinonaktifkan |
| 3 | Protokol I2C (konfigurasi codec eksternal) | DAC PCM5102A tidak memerlukan konfigurasi register via bus serial |
| 4 | DMA atau AXI-Stream | Data ditulis oleh CPU melalui register AXI4-Lite; DMA tidak digunakan |
| 5 | Sample rate selain ~48 kHz dan ~96 kHz | Hanya dua mode yang diverifikasi dengan clock 24.56897 MHz |
| 6 | Bit depth selain 24-bit | Slot 32-bit dengan data 24-bit MSB-first (8 bit padding nol di LSB) |
| 7 | Multi-channel (>2 ch / TDM) | Hanya stereo (Left + Right) |
| 8 | Hot-plug / power management | Tidak relevan pada target Basys3 |

---

## 3. Persyaratan Fungsional

| ID | Persyaratan |
|----|-------------|
| F-01 | Peripheral **harus** menampilkan antarmuka AXI4-Lite slave 32-bit (data dan strobe) dengan 4-bit address. |
| F-02 | Peripheral **harus** menghasilkan sinyal I2S_BCLK, I2S_LRCLK, dan I2S_SD sesuai standar Philips I2S (WS berubah satu siklus BCLK sebelum MSB). |
| F-03 | Peripheral **harus** menyimpan sampel audio stereo (32-bit per frame, kiri/kanan) pada FIFO internal berkedalaman 256 frame. |
| F-04 | Peripheral **harus** mendukung pemilihan mode sample rate via bit MODE di register CONFIG: `0` = ~48 kHz, `1` = ~96 kHz. |
| F-05 | Peripheral **harus** meng-assert sinyal `interrupt` saat FIFO berada di bawah nilai watermark (default 64 frame). |
| F-06 | Peripheral **harus** meng-assert sinyal `interrupt` saat terjadi FIFO underrun (FIFO kosong saat I2S engine meminta data). |
| F-07 | Bit penyebab interrupt (FIFO_WATERMARK dan FIFO_UNDERRUN) **harus** bersifat **Write-1-to-Clear (W1C)**. |
| F-08 | Software **harus** dapat mengaktifkan/menonaktifkan interrupt masing-masing sumber secara independen. |
| F-09 | Peripheral **harus** melaporkan kondisi FIFO (fill level, full, empty) pada register STATUS. |
| F-10 | Reset aktif-rendah (S_AXI_ARESETN) **harus** mengembalikan semua register dan FIFO ke kondisi awal. |

---

## 4. Persyaratan Non-Fungsional

| ID | Persyaratan |
|----|-------------|
| NF-01 | Semua logika diimplementasikan dalam Verilog-2001 atau SystemVerilog, dapat disintesis pada Vivado 2020.x ke atas. |
| NF-02 | Periode latensi tulis AXI4-Lite (AWVALID→BVALID) **tidak boleh** melebihi 2 siklus clock AXI dalam kondisi normal. |
| NF-03 | Peripheral **harus** lolos simulasi fungsional dengan testbench yang memverifikasi seluruh kasus di [Checklist Verifikasi](#12-checklist-verifikasi). |
| NF-04 | Konsumsi LUT dan FF pada Artix-7 **tidak boleh** melebihi 500 LUT dan 300 FF (estimasi; diverifikasi setelah sintesis). |
| NF-05 | Dokumen ini (spec-outline.md) **harus** konsisten dengan kode RTL yang dikirim ke repositori. |

---

## 5. Antarmuka Pin

### 5.1 Antarmuka AXI4-Lite (Slave)

| Port | Arah | Lebar | Deskripsi |
|------|------|-------|-----------|
| `S_AXI_ACLK` | Input | 1 | Clock AXI4-Lite (sama dengan system clock MicroBlaze) |
| `S_AXI_ARESETN` | Input | 1 | Reset sinkron aktif-rendah |
| `S_AXI_AWADDR` | Input | 4 | Alamat tulis (byte-addressed, 4 LSB) |
| `S_AXI_AWVALID` | Input | 1 | Alamat tulis valid |
| `S_AXI_AWREADY` | Output | 1 | Peripheral siap terima alamat tulis |
| `S_AXI_WDATA` | Input | 32 | Data tulis |
| `S_AXI_WSTRB` | Input | 4 | Byte strobe tulis |
| `S_AXI_WVALID` | Input | 1 | Data tulis valid |
| `S_AXI_WREADY` | Output | 1 | Peripheral siap terima data tulis |
| `S_AXI_BRESP` | Output | 2 | Respons tulis (`2'b00` = OKAY) |
| `S_AXI_BVALID` | Output | 1 | Respons tulis valid |
| `S_AXI_BREADY` | Input | 1 | Master siap terima respons |
| `S_AXI_ARADDR` | Input | 4 | Alamat baca |
| `S_AXI_ARVALID` | Input | 1 | Alamat baca valid |
| `S_AXI_ARREADY` | Output | 1 | Peripheral siap terima alamat baca |
| `S_AXI_RDATA` | Output | 32 | Data baca |
| `S_AXI_RRESP` | Output | 2 | Respons baca (`2'b00` = OKAY) |
| `S_AXI_RVALID` | Output | 1 | Data baca valid |
| `S_AXI_RREADY` | Input | 1 | Master siap terima data baca |

### 5.2 Antarmuka I2S (Keluar ke DAC PCM5102A)

| Port | Arah | Lebar | Pin Basys3 (JA) | Deskripsi |
|------|------|-------|-----------------|-----------|
| `I2S_BCLK` | Output | 1 | JA[1] | Bit clock — 64× sample rate |
| `I2S_LRCLK` | Output | 1 | JA[2] | Word Select / LR clock = sample rate |
| `I2S_SD` | Output | 1 | JA[3] | Serial data audio (MSB-first) |

> **Catatan:** PCM5102A tidak membutuhkan MCLK. Pin `FMT` pada PCM5102A di-strap ke GND (format I2S standar). Pin `XSMT` (soft mute) dapat dihubungkan ke VCC untuk selalu aktif.

### 5.3 Interrupt

| Port | Arah | Lebar | Deskripsi |
|------|------|-------|-----------|
| `interrupt` | Output | 1 | Sinyal interrupt ke MicroBlaze Interrupt Controller (level-high, aktif sampai di-clear) |

---

## 6. Clocking dan Sample Rate

### 6.1 Parameter Clock

| Parameter | Nilai |
|-----------|-------|
| Clock referensi Basys3 | 100 MHz |
| Clock audio (keluaran MMCM) | **24.56897 MHz** |
| Clock AXI / MicroBlaze | 100 MHz (terpisah dari audio clock) |

### 6.2 Derivasi Sample Rate

Protokol I2S stereo 32-bit slot memerlukan:

```
BCLK = 2 (kanal) × 32 (bit/slot) × f_s = 64 × f_s
```

Divisor BCLK diturunkan dari `audio_clk`:

```
BCLK = audio_clk / bclk_div
f_s  = BCLK / 64 = audio_clk / (bclk_div × 64)
```

| Mode (`CONFIG[0]`) | `bclk_div` | BCLK (MHz) | f_s (kHz) | Deviasi dari nominal |
|--------------------|-----------|-----------|----------|----------------------|
| `0` — ~48 kHz | **8** | 3.07112 | **47.986** | −0.029 % |
| `1` — ~96 kHz | **4** | 6.14224 | **95.972** | −0.029 % |

> Deviasi < 0,03 % memenuhi toleransi ±0,1 % yang disyaratkan PCM5102A untuk jitter WS.

### 6.3 Diagram Clocking (Placeholder)

<!-- fig:clock-tree — lihat Bagian 13 -->
`![Diagram clock tree peripheral I2S](figures/fig-clock-tree.png)`

---

## 7. Format Frame / Slot I2S

### 7.1 Spesifikasi

| Parameter | Nilai |
|-----------|-------|
| Standar | Philips I2S (WS berubah 1 siklus BCLK **sebelum** MSB) |
| Bit per slot | 32 |
| Bit data per kanal | 24 (MSB-first, rata kiri) |
| Padding | 8 bit nol di posisi LSB slot |
| Kanal | Stereo: Left (LRCLK=0) diikuti Right (LRCLK=1) |
| Urutan bit | MSB dulu |
| Polaritas BCLK | Data disampling pada rising edge BCLK |

### 7.2 Representasi Satu Frame (64 siklus BCLK)

```
LRCLK: ___[LOW = LEFT, 32 siklus BCLK]___[HIGH = RIGHT, 32 siklus BCLK]___

        ↓ MSB bit ke-23                          ↓ bit ke-0  ↓ padding (8 bit nol)
BCLK:  _|_|_|_|_|_|_|_ ... _|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_
SD:    [B23][B22]...[B1][B0][0][0][0][0][0][0][0][0] | [B23]...[B0][0..0]
         ←──── 24 bit data ─────────────────────→ padding   ← kanal kanan →
```

### 7.3 Format Data di Register / FIFO

Setiap entri FIFO berupa **satu kata 32-bit** mewakili **satu sampel satu kanal**:

```
Bit [31:8]  — sampel audio 24-bit (two's complement, signed)
Bit [7:0]   — diabaikan / diisi nol saat transmisi
```

Software menulis kanal kiri dan kanal kanan secara **bergantian**: tulis LEFT lalu RIGHT per pasang sample.

<!-- fig:i2s-frame — lihat Bagian 13 -->
`![Diagram timing frame I2S 32-bit slot 24-bit data](figures/fig-i2s-frame-timing.png)`

---

## 8. Peta Register

Base address default (Vivado Block Design): `0x44A1_0000`

Address space: 16 byte (4 register × 4 byte), decode pada bit [3:2].

### 8.1 Ringkasan Register

| Offset | Nama | Akses | Deskripsi |
|--------|------|-------|-----------|
| `0x00` | `CONTROL` | R/W | Kontrol enable dan start/stop |
| `0x04` | `STATUS` | RO | Status FIFO dan engine |
| `0x08` | `DATA_FIFO` | WO | Port tulis data audio ke FIFO |
| `0x0C` | `CONFIG` | R/W | Konfigurasi mode, interrupt enable, watermark |

### 8.2 Register CONTROL (Offset 0x00)

| Bit | Nama | Akses | Reset | Deskripsi |
|-----|------|-------|-------|-----------|
| 31:3 | — | — | 0 | Dicadangkan; tulis 0 |
| 2 | `FLUSH` | W1S | 0 | Tulis 1 untuk mengosongkan FIFO dan mereset engine |
| 1 | `START` | R/W | 0 | 1 = engine I2S aktif menghasilkan clock dan data |
| 0 | `ENABLE` | R/W | 0 | 1 = peripheral di-enable (clock I2S berjalan) |

> `ENABLE` harus di-set sebelum `START`. Urutan: tulis `ENABLE=1`, isi FIFO, tulis `START=1`.

### 8.3 Register STATUS (Offset 0x04)

| Bit | Nama | Akses | Reset | Deskripsi |
|-----|------|-------|-------|-----------|
| 31:19 | — | — | 0 | Dicadangkan |
| 18:10 | `FILL_LEVEL` | RO | 0 | Jumlah entri yang saat ini ada di FIFO (0–256, 9-bit) |
| 9 | `FIFO_FULL` | RO | 0 | 1 = FIFO penuh (256 entri) |
| 8 | `FIFO_EMPTY` | RO | 1 | 1 = FIFO kosong |
| 7:3 | — | — | 0 | Dicadangkan |
| 2 | `UNDERRUN` | RO | 0 | 1 = pernah terjadi underrun sejak reset atau clear (W1C di CONFIG) |
| 1 | `RUNNING` | RO | 0 | 1 = engine I2S sedang aktif mengirim frame |
| 0 | `BUSY` | RO | 0 | 1 = engine sedang di tengah transmisi slot |

### 8.4 Register DATA_FIFO (Offset 0x08)

| Bit | Nama | Akses | Deskripsi |
|-----|------|-------|-----------|
| 31:0 | `SAMPLE` | WO | Tulis satu sampel 32-bit (bit [31:8] = data 24-bit, bit [7:0] = padding). Operasi baca mengembalikan 0x0000_0000. |

> Menulis ke register ini saat FIFO penuh (`FIFO_FULL=1`) **diabaikan** (drop-on-overflow); bit `OVERFLOW` dapat ditambahkan pada iterasi desain berikutnya.

### 8.5 Register CONFIG (Offset 0x0C)

| Bit | Nama | Akses | Reset | Deskripsi |
|-----|------|-------|-------|-----------|
| 31:24 | — | — | 0 | Dicadangkan |
| 23:16 | `WATERMARK` | R/W | `0x40` (64) | Ambang batas FIFO (satuan: entri). Interrupt watermark di-assert saat `FILL_LEVEL < WATERMARK`. |
| 15:4 | — | — | 0 | Dicadangkan |
| 3 | `IE_UNDERRUN` | R/W | 0 | 1 = aktifkan interrupt underrun |
| 2 | `IE_WATERMARK` | R/W | 0 | 1 = aktifkan interrupt watermark |
| 1 | `IC_UNDERRUN` | W1C | 0 | Tulis 1 untuk men-clear flag `UNDERRUN` di register STATUS (bit 2) sekaligus de-assert interrupt underrun |
| 0 | `MODE` | R/W | 0 | 0 = ~48 kHz (`bclk_div=8`), 1 = ~96 kHz (`bclk_div=4`) |

---

## 9. Perilaku FIFO

### 9.1 Parameter

| Parameter | Nilai |
|-----------|-------|
| Kedalaman | **256 entri** (setiap entri = 32-bit = 1 sampel mono) |
| Kapasitas setara frame stereo | 128 frame (256 sampel / 2 kanal) |
| Tipe | Synchronous FIFO (single-clock domain: `audio_clk`) |
| Watermark default | 64 entri |

### 9.2 Aliran Data

```
Software (MicroBlaze)
        │
        │ AXI4-Lite Write → DATA_FIFO (0x08)
        ▼
  ┌─────────────────┐
  │   TX FIFO       │  256 × 32-bit
  │ (audio_clk      │
  │  domain)        │
  └────────┬────────┘
           │ Pop satu entri setiap 32 siklus BCLK (satu slot)
           ▼
    I2S Shift Register → I2S_SD
```

> **Perhatian CDC (Clock Domain Crossing):** FIFO harus menggunakan handshake yang aman antara domain `S_AXI_ACLK` (tulis) dan `audio_clk` (baca) apabila keduanya berbeda frekuensi. Apabila `S_AXI_ACLK = audio_clk`, tidak diperlukan CDC tambahan.

### 9.3 Kondisi Batas

| Kondisi | Perilaku |
|---------|----------|
| FIFO penuh, software menulis | Data baru **dibuang** (drop-on-overflow); `STATUS[FIFO_FULL]` tetap 1 |
| FIFO kosong, engine I2S meminta | Engine mengirim **frame nol (0x0000_0000)**; flag `UNDERRUN` di-set |
| Reset (`CONTROL[FLUSH]=1`) | FIFO dikosongkan, pointer reset, `UNDERRUN` di-clear |

---

## 10. Perilaku Interrupt

### 10.1 Sumber Interrupt

| Sumber | Bit Flag | Bit Enable | Kondisi Assert | Kondisi De-assert |
|--------|----------|------------|----------------|-------------------|
| Watermark | — | `CONFIG[IE_WATERMARK]` | `FILL_LEVEL < WATERMARK` | `FILL_LEVEL ≥ WATERMARK` |
| Underrun | `STATUS[UNDERRUN]` | `CONFIG[IE_UNDERRUN]` | FIFO kosong saat pop | Software tulis `CONFIG[IC_UNDERRUN]=1` (W1C) |

### 10.2 Logika Kombinasional Output Interrupt

```verilog
assign interrupt = (ie_watermark & (fill_level < watermark))
                 | (ie_underrun  & underrun_flag);
```

### 10.3 Skenario Interrupt Watermark

1. Software mengisi FIFO sampai penuh (256 entri).
2. Engine I2S mulai mengonsumsi data.
3. Saat `FILL_LEVEL` turun di bawah `WATERMARK` (default 64), `interrupt` di-assert.
4. ISR (Interrupt Service Routine) di MicroBlaze menulis sejumlah sampel baru ke `DATA_FIFO` sampai `FILL_LEVEL ≥ WATERMARK`.
5. `interrupt` otomatis de-assert.

### 10.4 Skenario Interrupt Underrun

1. FIFO kosong sebelum software sempat mengisi ulang.
2. Engine I2S mengirim frame nol; `STATUS[UNDERRUN]` di-set.
3. `interrupt` di-assert (jika `IE_UNDERRUN=1`).
4. ISR membaca `STATUS`, mengisi ulang FIFO, lalu menulis `CONFIG[IC_UNDERRUN]=1` untuk clear.
5. `interrupt` de-assert.

---

## 11. Model Interaksi Software (Vitis)

### 11.1 Urutan Inisialisasi

```c
// 1. Nonaktifkan interrupt terlebih dahulu
Xil_Out32(I2S_BASE + 0x0C, 0x00000000);  // CONFIG: semua IE=0

// 2. Atur mode sample rate (~48 kHz)
// CONFIG[MODE]=0, WATERMARK=64 (0x40), IE_WATERMARK=1, IE_UNDERRUN=1
Xil_Out32(I2S_BASE + 0x0C, (0x40 << 16) | 0x0C);
// bit[23:16]=0x40, bit[3]=IE_UNDERRUN=1, bit[2]=IE_WATERMARK=1, bit[0]=MODE=0

// 3. Isi FIFO awal (minimal >= WATERMARK entri)
for (int i = 0; i < 256; i++) {
    Xil_Out32(I2S_BASE + 0x08, audio_buffer[i]);
}

// 4. Enable peripheral dan start engine
Xil_Out32(I2S_BASE + 0x00, 0x00000001);  // ENABLE=1
Xil_Out32(I2S_BASE + 0x00, 0x00000003);  // ENABLE=1, START=1

// 5. Daftarkan dan aktifkan interrupt di MicroBlaze Interrupt Controller
XIntc_Connect(&intc, I2S_IRQ_ID, (XInterruptHandler)i2s_isr, NULL);
XIntc_Enable(&intc, I2S_IRQ_ID);
```

### 11.2 Rutinitas ISR (Refill)

```c
void i2s_isr(void *callback_ref) {
    u32 status = Xil_In32(I2S_BASE + 0x04);  // baca STATUS
    u32 fill   = (status >> 10) & 0x1FF;      // FILL_LEVEL [18:10], 9-bit

    if (status & 0x04) {  // UNDERRUN flag
        xil_printf("[ISR] FIFO Underrun! Mengisi ulang...\r\n");
        Xil_Out32(I2S_BASE + 0x0C,               // W1C IC_UNDERRUN
                  Xil_In32(I2S_BASE + 0x0C) | 0x02);
    }

    // Refill hingga FIFO penuh
    u32 to_fill = 256 - fill;
    for (u32 i = 0; i < to_fill; i++) {
        Xil_Out32(I2S_BASE + 0x08, next_sample());
    }
}
```

### 11.3 Fungsi `next_sample()`

Fungsi ini mengembalikan sampel 32-bit berikutnya dari buffer audio circular.
Data audio 24-bit ditempatkan di bit [31:8]; bit [7:0] diisi nol.

```c
u32 next_sample(void) {
    s32 pcm24 = audio_ring[ring_rd_ptr++ % RING_SIZE];  // nilai 24-bit signed
    return (u32)(pcm24 & 0xFFFFFF) << 8;               // geser ke bit [31:8]
}
```

---

## 12. Checklist Verifikasi

### 12.1 Simulasi Fungsional (ModelSim / Vivado Sim)

- [ ] **SIM-01** — Reset: setelah `ARESETN=0→1`, semua register kembali ke nilai reset, FIFO kosong, `interrupt=0`.
- [ ] **SIM-02** — Tulis FIFO: 256 operasi tulis AXI4-Lite ke `DATA_FIFO`; verifikasi `STATUS[FILL_LEVEL]=256` dan `STATUS[FIFO_FULL]=1`.
- [ ] **SIM-03** — Start engine: setelah `CONTROL[START]=1`, sinyal `I2S_BCLK` dan `I2S_LRCLK` muncul dengan frekuensi sesuai mode.
- [ ] **SIM-04** — Frame timing: verifikasi bahwa `I2S_LRCLK` berubah tepat 1 siklus `I2S_BCLK` sebelum MSB data dikirim (standar Philips).
- [ ] **SIM-05** — Data integrity: kirim pola 0xA5B6C700 (24-bit = 0xA5B6C7), verifikasi bit-by-bit pada `I2S_SD`.
- [ ] **SIM-06** — Mode ~48 kHz: ukur periode `I2S_LRCLK` ≈ 20.84 µs (f_s ≈ 47.986 kHz).
- [ ] **SIM-07** — Mode ~96 kHz: ukur periode `I2S_LRCLK` ≈ 10.42 µs (f_s ≈ 95.972 kHz).
- [ ] **SIM-08** — Watermark interrupt: biarkan FIFO terkuras hingga <64 entri; verifikasi `interrupt=1`. Refill ≥64; verifikasi `interrupt=0`.
- [ ] **SIM-09** — Underrun interrupt: biarkan FIFO kosong sepenuhnya saat engine aktif; verifikasi `STATUS[UNDERRUN]=1` dan `interrupt=1`. Tulis W1C; verifikasi flag clear.
- [ ] **SIM-10** — Drop on overflow: saat `FIFO_FULL=1`, tulis satu data lagi; verifikasi FIFO tidak meluap (fill tetap 256).
- [ ] **SIM-11** — FLUSH: set `CONTROL[FLUSH]=1`; verifikasi FIFO kosong dalam satu siklus clock.
- [ ] **SIM-12** — AXI read: baca semua register; verifikasi nilai sesuai state saat ini; baca `DATA_FIFO` mengembalikan 0.

### 12.2 Pengujian di Hardware (ILA — Integrated Logic Analyzer)

- [ ] **HW-01** — Pasang ILA probe pada `I2S_BCLK`, `I2S_LRCLK`, `I2S_SD`, `interrupt`, dan `STATUS[FILL_LEVEL]`.
- [ ] **HW-02** — Verifikasi frekuensi `I2S_BCLK` menggunakan ILA: mode ~48 kHz ≈ 3.071 MHz, mode ~96 kHz ≈ 6.142 MHz.
- [ ] **HW-03** — Verifikasi frekuensi `I2S_LRCLK`: mode ~48 kHz ≈ 47.99 kHz, mode ~96 kHz ≈ 95.97 kHz.
- [ ] **HW-04** — Trigger ILA pada rising edge `interrupt`; verifikasi `FILL_LEVEL < WATERMARK` pada saat yang sama.
- [ ] **HW-05** — Verifikasi penyelarasan WS: `I2S_LRCLK` berubah tepat 1 siklus sebelum MSB pada `I2S_SD`.
- [ ] **HW-06** — Jalankan audio loop 10 detik tanpa underrun; verifikasi di UART log bahwa flag `UNDERRUN` tidak pernah di-set.

### 12.3 Pengujian dengan DAC PCM5102A (No-MCLK Mode)

- [ ] **DAC-01** — Verifikasi strapping pin PCM5102A: `FMT=GND` (I2S standar), `XSMT=VCC` (unmute), `SCK=GND` atau tidak terhubung.
- [ ] **DAC-02** — Hubungkan `I2S_BCLK`, `I2S_LRCLK`, `I2S_SD` ke pin BCK, LRCK, DIN PCM5102A.
- [ ] **DAC-03** — Putar sinyal sine 1 kHz 24-bit pada mode ~48 kHz; dengarkan output analog: harus terdengar bersih tanpa artefak.
- [ ] **DAC-04** — Putar sinyal sine 1 kHz 24-bit pada mode ~96 kHz; verifikasi output analog tetap konsisten.
- [ ] **DAC-05** — Ukur THD+N output analog menggunakan audio analyzer atau FFT pada ADC eksternal (opsional, untuk data kuantitatif skripsi).
- [ ] **DAC-06** — Uji underrun yang disengaja: tunda ISR refill; verifikasi terdengar klik/putus lalu pulih setelah ISR mengisi ulang FIFO.

---

## 13. Placeholder Gambar dan Tabel

Daftar file placeholder yang perlu dibuat sebelum dimasukkan ke dokumen skripsi:

| ID Placeholder | Nama File yang Disarankan | Lokasi | Deskripsi |
|----------------|--------------------------|--------|-----------|
| `fig:block-diagram` | `fig-block-diagram-i2s-peripheral.png` | `contents/figures/` | Diagram blok top-level peripheral (AXI slave + FIFO + I2S engine) |
| `fig:clock-tree` | `fig-clock-tree.png` | `contents/figures/` | Diagram clock tree: 100 MHz → MMCM → 24.56897 MHz → BCLK divider |
| `fig:i2s-frame-timing` | `fig-i2s-frame-timing.png` | `contents/figures/` | Diagram timing satu frame I2S 32-bit slot, 24-bit data, stereo |
| `fig:fifo-state` | `fig-fifo-state-machine.png` | `contents/figures/` | State machine FIFO: IDLE → FILL → DRAIN → UNDERRUN |
| `fig:interrupt-logic` | `fig-interrupt-logic.png` | `contents/figures/` | Diagram logika kombinasional sumber interrupt |
| `fig:ila-capture-48k` | `fig-ila-bclk-lrclk-48k.png` | `contents/figures/` | Screenshot ILA: BCLK + LRCLK mode ~48 kHz |
| `fig:ila-capture-96k` | `fig-ila-bclk-lrclk-96k.png` | `contents/figures/` | Screenshot ILA: BCLK + LRCLK mode ~96 kHz |
| `fig:ila-interrupt` | `fig-ila-interrupt-watermark.png` | `contents/figures/` | Screenshot ILA: rising edge interrupt saat FILL_LEVEL < WATERMARK |
| `fig:pcm5102a-setup` | `fig-pcm5102a-setup.jpg` | `contents/figures/` | Foto/diagram koneksi fisik PCM5102A ke header JA Basys3 |
| `tbl:register-map` | *(tabel di dokumen ini, Bagian 8)* | — | Peta register lengkap dengan bitfield — sudah ada di spec ini |
| `tbl:clocking` | *(tabel di dokumen ini, Bagian 6)* | — | Tabel derivasi sample rate — sudah ada di spec ini |
| `tbl:pin-assignment` | `tbl-pin-assignment-basys3.tex` | `contents/chapter-3/` | Tabel assignment pin FPGA Basys3 (XDC reference) |

---

*Dokumen ini dibuat sebagai bagian dari skripsi S1 Teknik Elektro DTETI UGM.*
*Revisi selanjutnya harus mencerminkan perubahan pada kode RTL di repositori yang sama.*
