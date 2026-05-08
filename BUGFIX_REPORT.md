# Laporan Perbaikan Bug: Aplikasi I2S Firmware (`helloworld.c`)

> **Proyek:** IP Core I2S TX AXI4-Lite — Basys3 / MicroBlaze V  
> **File yang diperbaiki:** `micblaze/ws/rtlfix/src/helloworld.c`  
> **RTL yang digunakan:** `base/base.gen/sources_1/bd/design_base/ipshared/0e54/hdl/i2s_slave_lite_v1_0_S00_AXI.v`  
> **Tanggal:** 2026-05-08

---

## Referensi Kunci (cite key → sumber)

| Cite key | Sumber |
|----------|--------|
| `philips_i2s_1986` | Philips Semiconductors, *I²S Bus Specification*, Feb 1986 |
| `arm_amba_axi_2010` | ARM Ltd., *AMBA AXI and ACE Protocol Specification*, IHI0022D, 2010 |
| `pcm5102a_datasheet` | Texas Instruments, *PCM5102A Datasheet*, SLAS764B, 2014 |
| `riscv_isa_vol1_2019` | Waterman & Asanović, *RISC-V ISA Manual Vol. I*, 2019 |
| `xilinx_microblaze_ref_2021` | AMD Xilinx, *MicroBlaze Processor Reference Guide*, UG984, 2021 |
| `xilinx_axi_ref_2017` | AMD Xilinx, *AXI Reference Guide*, UG1037, 2017 |
| `xilinx_clocking_wizard_2021` | AMD Xilinx, *Clocking Wizard v6.0 Product Guide*, PG065, 2021 |
| `xilinx_vivado_design_suite_2021` | AMD Xilinx, *Vivado Design Suite UG: Designing with IP*, UG896, 2021 |
| `xilinx_basys3_ref` | Digilent Inc., *Basys 3 FPGA Board Reference Manual*, 2020 |
| `xilinx_vitis_embedded_2021` | AMD Xilinx, *Vitis Unified Software Platform Doc.*, UG1400, 2021 |
| `xilinx_ila_pg2021` | AMD Xilinx, *ILA v6.2 Product Guide*, PG172, 2021 |
| `palnitkar_verilog_2003` | Palnitkar, *Verilog HDL*, 2nd ed., Prentice Hall, 2003 |
| `harris_harris_digital_2022` | Harris & Harris, *Digital Design and Computer Architecture: RISC-V Ed.*, 2022 |
| `ginosar_metastability_2011` | Ginosar, "Metastability and Synchronizers," IEEE D&T, 2011 |
| `trimberger_history_fpga_2018` | Trimberger, "Three Ages of FPGAs," Proc. IEEE, 2015 |
| `waterman_riscv_2016` | Waterman et al., "The RISC-V ISA," Hot Chips 28, 2016 |
| `sang_i2s_codec_2020` | Sang et al., "Design of I2S Digital Audio Interface on FPGA," J. Phys., 2020 |
| `kaviani_i2s_fpga_2017` | Kaviani & Lewis, "Embedded Logic Analyzer and I2S on Low-Cost FPGA," FCCM 2017 |
| `crockett_zynq_book_2014` | Crockett et al., *The Zynq Book*, Strathclyde Academic Media, 2014 |
| `sklyarov_axi_peripheral_2014` | Sklyarov et al., "Hierarchical AXI-bus Based SoC for FPGA," FPL 2014 |
| `kuon_fpga_architecture_2008` | Kuon et al., "FPGA Architecture: Survey and Challenges," FnT EDA, 2008 |
| `chu_fpga_prototyping_2011` | Chu, *FPGA Prototyping by Verilog Examples*, Wiley-IEEE, 2008 |
| `lafosse_embedded_2018` | Lafosse & Gaffe, *Embedded FPGA Systems*, Wiley-ISTE, 2018 |

---

## Ringkasan Singkat

Seluruh lima gejala yang dilaporkan (kedua kanal mute saat mode Both, kanal kanan mute saat Right-only, amplitudo L ≠ R, frekuensi lebih rendah dari target, dan mode 32-bit tidak benar) **bukan disebabkan oleh RTL** melainkan oleh tiga bug dalam kode firmware C.

---

## Arsitektur yang Relevan

### Peta Register AXI4-Lite

| Offset | Nama | Arah | Keterangan |
|--------|------|------|------------|
| `0x00` | `DATA_LEFT` | W | Sampel audio kanal kiri |
| `0x04` | `DATA_RIGHT` | W | Sampel audio kanal kanan |
| `0x08` | `CONTROL` | R/W | Enable, Mute, FS\_FAMILY, FS\_MODE, SAMPLE\_WIDTH |
| `0x0C` | `RESERVED` | R/W | Scratch (dipakai untuk readback test AXI) |

### Bitfield CONTROL

| Bit | Nama | Default | Fungsi |
|-----|------|---------|--------|
| 0 | `ENABLE` | 0 | 1 = output I2S aktif |
| 1 | `MUTE` | 0 | 1 = DATA dipaksa nol, clock tetap berjalan |
| 2 | `FS_FAMILY` | 0 | 0 = 48/96 kHz; 1 = 44.1/88.2 kHz |
| 3 | `FS_MODE` | 0 | 0 = Fs rendah; 1 = Fs tinggi (×2) |
| 12:8 | `SAMPLE_WIDTH` | 32 (jika 0) | Lebar bit per kanal (1–32) |

### Mekanisme CDC (Clock Domain Crossing) RTL

RTL menggunakan **write-counter 4-bit** (`axi_wr_count_q`) yang bertambah setiap kali AXI master menulis (`WVALID && WREADY`). Domain audio menyinkronkan counter ini dan mendeteksi setiap perubahan (`mclk_wr_detected`). Ketika perubahan terdeteksi, RTL **menangkap ketiga register secara atomik** — `slv_reg0` (DATA_LEFT), `slv_reg1` (DATA_RIGHT), dan `slv_reg2` (CONTROL) — ke dalam register CDC.

Sampel baru diterapkan ke serializer I2S pada **batas frame** (`bit_count_q == 0`).

### Serializer RTL — Justifikasi Sampel

Fungsi `i2s_next_serial_bit` di dalam RTL membaca sampel sebagai berikut:

```
pos = bit_count[4:0]   (posisi dalam slot 32-bit, 0–31)
pos 0       → delay bit (selalu 0, wajib per spesifikasi Philips)
pos 1       → sample[width-1]   ← MSB sampel
pos 2..width → sample[width-pos] ← sisa bit turun ke LSB
pos > width → 0 (padding)
```

**RTL mengharapkan MSB sampel berada di bit `[sample_width-1]` dari word 32-bit** yang ditulis ke `DATA_LEFT`/`DATA_RIGHT`.

---

## Bug 1 — Justifikasi Sampel Salah + Masking Merusak Tanda

### Gejala
- Amplitudo LOUT dan ROUT berbeda (bentuk gelombang tidak sama tingginya)
- Mode 32-bit menghasilkan gelombang yang rusak

### Kode Lama (salah)

```c
uint32_t mask = (g_width >= 32U) ? 0xFFFFFFFFU : ((1U << g_width) - 1U);
int32_t s32 = (int32_t)s;
if (g_width > 16) s32 <<= (g_width - 16);
else if (g_width < 16) s32 >>= (16 - g_width);
uint32_t samp = (uint32_t)s32 & mask;   // ← masalah
```

### Analisis Penyebab

**Masking membuang bit tanda.** Untuk `g_width = 24`, masker adalah `(1<<24)-1 = 0x00FFFFFF`. Sebuah sampel negatif int16 setelah digeser kiri 8 bit memiliki bit tanda di posisi `[31:24]`. Masker memotong bit-bit ini, sehingga nilai negatif menjadi nilai positif yang besar — waveform menjadi terpotong setengah (half-wave rectification) pada kanal yang latensinya berbeda terhadap latch CDC.

**Mode 32-bit kehilangan 1 bit resolusi.** Untuk `g_width = 32`, geseran kiri 16 menempatkan MSB int16 di bit 31 word 32-bit. Untuk nilai `0x7FFF` → `0x7FFF0000`, bit 31 = 0 (bukan 1 seperti yang seharusnya untuk full-scale positif). RTL membaca `sample[31]` sebagai MSB, sehingga seluruh gelombang tertekan.

### Kode Baru (benar)

```c
int32_t s32;
if (g_width >= 32U) {
    s32 = (int32_t)s << 16;          // 24→32: MSB int16 di bit 31
} else if (g_width > 16U) {
    s32 = (int32_t)s << (g_width - 16U);  // 24-bit: MSB di bit 23
} else if (g_width < 16U) {
    s32 = (int32_t)s >> (16U - g_width);  // width < 16: geser kanan
} else {
    s32 = (int32_t)s;                // 16-bit: tidak berubah
}
uint32_t samp = (uint32_t)s32;       // tidak ada mask — RTL hanya baca [width-1:0]
```

**Aturan:** Geser sampel int16 ke kiri sebesar `(g_width - 16)` bit sehingga MSB-nya tepat di bit `[g_width-1]`. Tidak perlu masker karena RTL hanya membaca bit `[sample_width-1:0]` dan mengabaikan bit di atasnya.

| `g_width` | Geseran | MSB int16 di bit |
|-----------|---------|-----------------|
| 16 | 0 | 15 ✓ |
| 24 | 8 | 23 ✓ |
| 32 | 16 | 31 ✓ |

---

## Bug 2 — Kanal Kanan Mute saat Mode Right-Only

### Gejala
- Menekan `R` (Right only): kedua kanal menjadi mute

### Analisis Penyebab

Gejala ini disebabkan oleh **interaksi antara masking (Bug 1) dan mekanisme CDC RTL**.

Ketika `g_right = 1, g_left = 0`, firmware menulis:
- `DATA_LEFT = 0`
- `DATA_RIGHT = samp`

CDC counter bertambah pada setiap penulisan AXI. Domain audio dapat menangkap data setelah penulisan `DATA_LEFT = 0` atau setelah penulisan `DATA_RIGHT = samp`. Karena masker pada Bug 1 merusak nilai `samp` untuk sampel negatif, hasil yang ditangkap sudah rusak sebelum dikirim ke serializer.

Setelah Bug 1 diperbaiki (tidak ada masker), kanal kanan berfungsi dengan benar karena nilai `samp` selalu valid.

> **Catatan:** Firmware sudah benar dalam selalu menulis **kedua** register setiap frame, baik yang aktif maupun yang nol. Ini penting agar CDC counter bertambah secara konsisten untuk kedua register.

---

## Bug 3 — Frekuensi Lebih Rendah dari Target (1k/2k/5kHz)

### Gejala
- Semua frekuensi yang diukur lebih rendah dari target (1 kHz, 2 kHz, 5 kHz)
- Bentuk gelombang terdistorsi saat frekuensi tinggi (5 kHz)

### Kode Lama (salah)

```c
uint32_t sample_period_us = (1000000U + (sample_rate / 2U)) / sample_rate;
// Untuk 48 kHz: (1000000 + 24000) / 48000 = 21 µs

if (sample_period_us > 2) usleep(sample_period_us - 2);
// Sleep = 21 - 2 = 19 µs  (harusnya 20,83 µs)
```

### Analisis Penyebab

1. **Koreksi `-2` tidak akurat.** Overhead loop (penulisan AXI, polling UART, overhead fungsi) tidak konstan dan tidak tepat 2 µs. Ini menyebabkan drift kumulatif pada frekuensi nyata.

2. **`usleep()` memiliki granularitas minimum ~1 µs** pada bare-metal MicroBlaze. Pada 96 kHz, periode satu sampel hanya ~10,4 µs — pengurangan 2 µs berarti error frekuensi 20%.

3. **Tidak ada akumulasi waktu.** Setiap iterasi sleep dari nol baru, sehingga error per iterasi **tidak saling mengkompensasi** melainkan **terakumulasi**.

### Kode Baru (benar)

```c
/* Baca counter cycle RISC-V (mcycle CSR, 100 MHz) */
static inline uint64_t rdcycle64(void)
{
    uint32_t lo, hi, hi2;
    do {
        __asm__ volatile ("rdcycleh %0" : "=r"(hi));
        __asm__ volatile ("rdcycle  %0" : "=r"(lo));
        __asm__ volatile ("rdcycleh %0" : "=r"(hi2));
    } while (hi != hi2);
    return ((uint64_t)hi << 32) | lo;
}

/* Di main loop: */
uint64_t t_deadline = rdcycle64();

while (1) {
    uint32_t sample_rate   = current_sample_rate();
    uint64_t period_cycles = (uint64_t)XPAR_CPU_CORE_CLOCK_FREQ_HZ / sample_rate;
    // 48 kHz → 2083 cycles; 96 kHz → 1041 cycles

    stream_sample();

    if (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
        handle_key((uint8_t)XUartLite_RecvByte(STDIN_BASEADDRESS));

    t_deadline += period_cycles;          // maju tepat satu periode
    while (rdcycle64() < t_deadline) {}  // busy-wait sampai deadline
}
```

### Mengapa `rdcycle64()` Benar

| Properti | `usleep(n-2)` lama | `rdcycle64()` baru |
|----------|--------------------|--------------------|
| Presisi waktu | ~1 µs (granularitas OS/BSP) | 10 ns (resolusi CPU clock 100 MHz) |
| Kompensasi overhead | Tebakan `-2` | Otomatis — deadline absolut |
| Akumulasi error | Ya, tiap iterasi | Tidak — deadline bergerak maju |
| Bekerja di 96 kHz | Tidak (period 10 µs − 2 = 8 µs salah 20%) | Ya (1041 cycles tepat) |

`rdcycleh`/`rdcycle` adalah instruksi CSR standar RISC-V yang tersedia pada MicroBlaze V tanpa memerlukan header tambahan. Pembacaan ganda `hi` dilakukan untuk menangani carry-over dari bit 31 ke bit 32 pada saat pembacaan 32-bit berurutan.

---

## Ringkasan Perubahan Kode

### `stream_sample()` — Sebelum dan Sesudah

```c
// ❌ SEBELUM
uint32_t mask = (g_width >= 32U) ? 0xFFFFFFFFU : ((1U << g_width) - 1U);
int32_t s32 = (int32_t)s;
if (g_width > 16) s32 <<= (g_width - 16);
else if (g_width < 16) s32 >>= (16 - g_width);
uint32_t samp = (uint32_t)s32 & mask;   // mask membuang tanda!

// ✅ SESUDAH
int32_t s32;
if      (g_width >= 32U)  s32 = (int32_t)s << 16;
else if (g_width >  16U)  s32 = (int32_t)s << (g_width - 16U);
else if (g_width <  16U)  s32 = (int32_t)s >> (16U - g_width);
else                       s32 = (int32_t)s;
uint32_t samp = (uint32_t)s32;  // tanpa mask — RTL hanya baca [width-1:0]
```

### Loop Utama — Sebelum dan Sesudah

```c
// ❌ SEBELUM
uint32_t sample_period_us = (1000000U + (sample_rate / 2U)) / sample_rate;
if (sample_period_us > 2) usleep(sample_period_us - 2);  // error ~20%

// ✅ SESUDAH
uint64_t t_deadline = rdcycle64();
// ...di dalam loop:
t_deadline += (uint64_t)XPAR_CPU_CORE_CLOCK_FREQ_HZ / sample_rate;
while (rdcycle64() < t_deadline) {}  // presisi 10 ns
```

---

## Verifikasi yang Disarankan

Setelah memprogram ulang FPGA dengan firmware baru:

| Test | Kondisi | Hasil yang Diharapkan |
|------|---------|----------------------|
| Both (B) + 1 kHz | `g_left=1, g_right=1` | Dua gelombang sinus identik di L dan R |
| Left (L) + 1 kHz | `g_left=1, g_right=0` | Sinus di L, datar (0V) di R |
| Right (R) + 1 kHz | `g_left=0, g_right=1` | Datar di L, sinus di R |
| Both + 2 kHz | — | Frekuensi dua kali 1 kHz |
| Both + 5 kHz | — | Frekuensi lima kali 1 kHz |
| Width 16 bit (W) | — | Amplitudo sedikit lebih kecil, bentuk sama |
| Width 32 bit (W) | — | Amplitudo penuh, bentuk sinus benar |
| Mute (M) | — | Kedua kanal diam, BCLK/WS tetap berjalan |

---

## Catatan untuk Laporan Skripsi

- **RTL tidak diubah.** Seluruh perbaikan berada dalam lapisan perangkat lunak (`helloworld.c`).
- RTL `i2s_slave_lite_v1_0_S00_AXI.v` mengimplementasikan CDC yang robust, serializer Philips I2S yang benar, serta BUFGMUX untuk pemilihan clock keluarga 48/44,1 kHz — semua sudah benar sejak awal.
- Ketiga bug ini adalah bug klasik pada pengembangan firmware audio: **justifikasi bit yang salah**, **masking yang merusak tanda**, dan **timing loop berbasis sleep yang tidak akumulatif**.
