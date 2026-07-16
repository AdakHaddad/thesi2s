# Catatan Presentasi Skripsi

## Pesan utama

Penelitian ini menghasilkan IP transmitter I2S berbasis Verilog dan AXI4-Lite yang dapat diintegrasikan ke SoC MicroBlaze V pada FPGA Basys3. IP menghasilkan sinyal Philips I2S melalui NCO berbasis phase accumulator dan dapat dikonfigurasi melalui perangkat lunak.

Jelaskan kontribusi sebagai integrasi lengkap:

- RTL transmitter I2S TX-only.
- Register map AXI4-Lite.
- NCO untuk frekuensi sampling integer dalam rentang operasi RTL.
- Serializer Philips I2S dengan slot 32 bit, MSB-first, dan one-bit delay.
- Firmware MicroBlaze V yang mengirim sampel melalui status polling.

Gunakan istilah “frekuensi sampling” secara konsisten. Jangan menyebutnya “arbitrary sampling frequency” tanpa menjelaskan bahwa input berupa integer dan dibatasi oleh RTL hingga 195.312 Hz.

## Urutan penjelasan yang disarankan

1. Masalah: IP audio vendor dapat membatasi fleksibilitas, sedangkan sistem membutuhkan transmitter I2S yang dapat dikonfigurasi melalui software.
2. Solusi: IP custom AXI4-Lite pada SoC MicroBlaze V.
3. Alur data: MicroBlaze V → AXI SmartConnect → IP I2S → BCLK/WS/DATA/MCLK → PCM5102A.
4. Timing: clock sistem 100 MHz menjadi sumber NCO untuk BCLK dan MCLK.
5. Verifikasi: testbench RTL, waveform, osiloskop, PCM5102A, resource, timing, dan power.
6. Batasan: TX-only, tanpa FIFO, tanpa DMA, tanpa interrupt, dan filter stereo belum independen.

## Poin penting NCO

Untuk (F_s=96) kHz:

```text
BCLK = 64 × Fs = 6.144 MHz
BCLK toggle rate = 2 × BCLK = 128 × Fs = 12.288 MHz
MCLK = 256 × Fs = 24.576 MHz
MCLK toggle rate = 2 × MCLK = 512 × Fs
```

Pada setiap clock sistem 100 MHz, accumulator menambahkan nilai increment. Saat hasil penjumlahan mencapai atau melebihi 100.000.000, hardware menghasilkan satu pulse `phase_wrap`, melakukan satu toggle, dan menyimpan nilai sisa.

Tekankan bahwa satu `phase_wrap` menghasilkan satu toggle, bukan satu periode penuh BCLK. Dua toggle membentuk satu periode BCLK.

## Cara menjelaskan formula tanpa menghafal

Mulai dari kebutuhan protokol, bukan dari kode:

```text
1 frame stereo = 32 bit kiri + 32 bit kanan = 64 periode BCLK
BCLK = 64 × frekuensi sampling
MCLK = 256 × frekuensi sampling
```

Hardware mengubah keluaran clock pada setiap dua event toggle. Karena itu, nilai increment untuk accumulator harus dua kali frekuensi keluaran:

```text
BCLK toggle rate = 2 × BCLK = 128 × Fs
MCLK toggle rate = 2 × MCLK = 512 × Fs
```

Formula NCO yang dapat dijelaskan adalah:

```text
frekuensi toggle = clock sistem × increment / modulus
```

Dengan `clock sistem = 100 MHz` dan `modulus = 100.000.000`:

```text
frekuensi toggle = increment
```

Jadi, untuk `Fs = 96 kHz`:

```text
increment BCLK = 128 × 96.000 = 12.288.000
increment MCLK = 512 × 96.000 = 49.152.000
```

Jika penguji bertanya mengapa BCLK bukan 12,288 MHz, jawab:

> Nilai 12,288 MHz adalah laju toggle. Satu periode BCLK membutuhkan dua toggle, sehingga frekuensi BCLK efektif adalah 6,144 MHz.

## Cara menjelaskan kode RTL NCO

Gunakan tiga baris inti berikut sebagai alur:

```verilog
wire [31:0] bclk_toggle_rate_hz = {sample_rate_sync, 7'b0};
wire [31:0] bclk_phase_sum = bclk_phase_acc_q + bclk_toggle_rate_hz;
wire bclk_phase_wrap = (bclk_phase_sum >= AXI_CLK_HZ);
```

Penjelasan lisan:

1. `{sample_rate_sync, 7'b0}` adalah penggeseran tujuh bit ke kiri, sehingga nilainya menjadi `128 × Fs`.
2. Nilai tersebut ditambahkan ke accumulator pada setiap clock sistem.
3. Saat hasil mencapai modulus 100.000.000, `bclk_phase_wrap` menjadi aktif.
4. Hardware mengurangi modulus dari hasil penjumlahan dan menyimpan sisanya.
5. BCLK melakukan satu toggle.

Contoh jawaban singkat:

> Accumulator bekerja seperti penghitung pecahan. Nilainya terus bertambah dengan increment yang merepresentasikan frekuensi target. Saat melewati modulus, hardware menghasilkan satu event toggle dan menyimpan sisa hitung agar kesalahan tidak terakumulasi.

## Cara menjelaskan kode register

Jelaskan bahwa register membuat software dapat mengendalikan hardware melalui alamat memory-mapped:

```c
#define DATA_LEFT  (I2S_BASE + 0x00U)
#define DATA_RIGHT (I2S_BASE + 0x04U)
#define CONTROL    (I2S_BASE + 0x08U)
#define STATUS_REG (I2S_BASE + 0x0CU)
```

Makna sederhananya:

- `I2S_BASE` adalah alamat awal IP.
- Offset `0x00` dan `0x04` menyimpan sampel kiri dan kanan.
- Offset `0x08` mengatur mode operasi.
- Offset `0x0C` memberi informasi sinkronisasi dari hardware.

Untuk menjelaskan bitfield `CONTROL`:

```c
#define CTRL_ENABLE (1U << 0)
#define CTRL_MUTE   (1U << 1)
#define CTRL_WIDTH(w) (((uint32_t)((w) >= 32U ? 0U : ((w) & 0x1FU))) << 2U)
#define CTRL_RATE(hz) (((uint32_t)(hz) & 0x000FFFFFU) << 7U)
```

Cara membacanya:

- `1U << 0` menempatkan nilai enable pada bit 0.
- `1U << 1` menempatkan mute pada bit 1.
- `CTRL_WIDTH` menempatkan lebar sampel mulai bit 2.
- Nilai 0 pada field lebar digunakan sebagai kode khusus untuk 32 bit.
- `CTRL_RATE` menempatkan frekuensi sampling mulai bit 7.

## Cara menjelaskan serializer I2S

`bit_count_q` memiliki 6 bit sehingga dapat menghitung 0 sampai 63:

```text
0–31  = slot kiri
32–63 = slot kanan
```

Pada setiap event BCLK yang sesuai, serializer memilih sumber sampel berdasarkan bagian paling signifikan dari `bit_count_q`. Bit pertama setelah perubahan WS diisi nol sebagai one-bit delay. Setelah itu payload dikirim dari MSB ke LSB. Posisi yang tersisa di dalam slot diisi nol jika lebar sampel lebih kecil dari 32 bit.

Kalimat presentasi:

> Firmware menyimpan sampel, tetapi RTL menentukan kapan sampel dilatch dan bagaimana setiap bit dikirim. Pembagian tugas ini menjaga timing I2S tetap deterministik.

## Cara menjelaskan bug sign bit

Gunakan konsep sederhana:

> Sampel negatif menggunakan bit tanda. Masker yang diterapkan setelah penggeseran menghapus bit tersebut, sehingga nilai negatif terbaca sebagai nilai positif besar. Perbaikan dilakukan dengan mempertahankan ekstensi tanda melalui `int32_t`.

## Cara menjelaskan kode status polling

```c
if (frame_bit != g_last_frame_bit) {
    g_last_frame_bit = frame_bit;
    stream_software_dds_sample();
}
```

Jelaskan satu kalimat per baris:

1. Firmware membandingkan status sekarang dengan status sebelumnya.
2. Jika berbeda, hardware telah memulai frame baru.
3. Firmware menyimpan status terbaru.
4. Firmware mengirim sampel berikutnya.

Jangan mengatakan bahwa polling menghasilkan clock audio. Clock tetap dihasilkan oleh RTL NCO. Polling hanya menentukan kapan software memperbarui data.

Saat menampilkan waveform, jelaskan hubungan berikut:

- `bclk_phase_acc_q`: nilai accumulator yang meningkat.
- `bclk_phase_wrap`: penanda terjadinya toggle.
- `bclk_q`: keluaran BCLK aktual.
- `sample_rate_sync`: nilai frekuensi sampling yang telah diterima RTL.

## Mengapa ada empat register?

| Register | Fungsi |
|---|---|
| `DATA_LEFT` | Menyimpan sampel kanal kiri. |
| `DATA_RIGHT` | Menyimpan sampel kanal kanan. |
| `CONTROL` | Mengatur enable, mute, lebar sampel, dan frekuensi sampling. |
| `STATUS` | Memberi tanda bahwa pasangan sampel telah dilatch pada awal frame stereo. |

`STATUS` diperlukan karena firmware tidak boleh mengganti sampel ketika serializer masih mengirim frame sebelumnya. Register ini menyediakan handshake sederhana antara software dan hardware.

## Apa itu status polling?

Status polling adalah metode ketika MicroBlaze membaca `STATUS[0]` secara berulang. Bit tersebut berubah setiap kali hardware melakukan latch pasangan sampel baru.

```c
frame_bit = frame_status_bit();
if (frame_bit != g_last_frame_bit) {
    g_last_frame_bit = frame_bit;
    stream_software_dds_sample();
}
```

Ketika nilai bit berubah, firmware mengirim pasangan sampel berikutnya. Metode ini dipilih karena rancangan tidak menggunakan FIFO, DMA, atau interrupt.

Jawaban singkat saat ditanya mengapa tidak memakai interrupt:

> Status polling lebih sederhana untuk demonstrasi transmitter register-mapped. Interrupt atau DMA dapat mengurangi beban CPU, tetapi berada di luar ruang lingkup rancangan ini.

## Bagian bug firmware

Pertahankan bagian ini karena bug menjelaskan alasan teknis di balik firmware final.

### Bug 1: masker bit

Masker memotong bit tanda sampel negatif setelah penggeseran. Akibatnya, keluaran audio menjadi asimetris. Solusi yang digunakan adalah menjaga ekstensi tanda melalui `int32_t` dan menghapus pemotongan yang merusak bit tanda.

### Bug 2: `usleep()`

`usleep()` tidak memberikan timing sampel yang presisi dan tidak sinkron dengan frame I2S. Solusi final menggunakan perubahan `STATUS[0]` sebagai pemicu pengiriman sampel.

Jangan menyebut bug sebagai kegagalan akhir. Jelaskan bahwa bug ditemukan pada tahap integrasi, diperbaiki, lalu diverifikasi kembali.

## Cara menjelaskan hasil

- Waveform RTL membuktikan reset, enable, mute, one-bit delay, MSB-first, padding, WS, dan urutan bit.
- Osiloskop membuktikan keluaran analog nada 1 kHz, 2 kHz, dan 5 kHz pada PCM5102A.
- Pengujian mode menunjukkan perubahan frekuensi sampling, lebar sampel, routing kanal, enable, dan mute.
- Resource, timing, dan power berasal dari laporan implementasi SoC final pada `freshi2s`, bukan estimasi IP standalone.

Hasil implementasi final:

- 2.435 LUT atau 11,71%.
- 2.330 flip-flop atau 5,60%.
- 32 BRAM atau 64%.
- WNS 0,064 ns.
- WHS 0,031 ns.
- WPWS 3,000 ns.
- Total power 0,209 W.
- Dynamic power 0,135 W.
- Static power 0,073 W.

## Filter digital

Jelaskan dengan jujur bahwa integrasi filter final menggunakan satu instance `filter_coeff`. Slot kiri diproses, kemudian hasil mono digunakan pada jalur keluaran. Jangan mengklaim pemrosesan stereo independen atau dua state filter terpisah.

Jika ditanya tentang keterbatasan filter:

> Integrasi ini membuktikan kompatibilitas antarmuka antara stream I2S dan filter paralel 16-bit. Pemrosesan kiri-kanan dengan state independen memerlukan dua instance filter dan pengaturan pipeline yang berbeda.

## Hal yang harus diperiksa pada slide

Sebelum presentasi, periksa deck karena beberapa slide lama masih tidak sesuai dengan desain final:

- Slide “Register Map (3 Registers)” harus menjadi empat register.
- Slide firmware “Tiga Register MMIO” harus menjelaskan `STATUS`.
- Slide bug harus menyebut dua bug utama, bukan “Bug 3” jika tidak ada Bug 1 dan Bug 2 yang konsisten.
- Diagram yang masih menunjukkan `Timer`, `i2s_dds_0`, atau label pre-production harus diganti dengan screenshot `freshi2s` terbaru.
- Semua angka resource, timing, dan power harus sama dengan Bab V.
- Jangan menampilkan angka simulasi atau pengukuran yang tidak tercantum pada tesis final.

## Pertanyaan penguji yang mungkin muncul

### Mengapa memakai NCO, bukan PLL?

NCO memungkinkan perubahan frekuensi sampling melalui register tanpa membuat konfigurasi PLL baru. Konsekuensinya, edge clock tetap terkuantisasi terhadap clock sistem 100 MHz dan memiliki jitter kuantisasi.

### Mengapa AXI4-Lite, bukan AXI4-Stream?

AXI4-Lite cukup untuk demonstrasi register-mapped dan konfigurasi sederhana. AXI4-Stream, FIFO, dan DMA lebih sesuai untuk sistem audio dengan throughput tinggi.

### Apakah desain mendukung receiver I2S?

Tidak. Desain hanya merupakan transmitter atau TX-only.

### Apakah frekuensi sampling benar-benar bebas?

Frekuensi sampling dapat diprogram sebagai nilai integer dalam rentang RTL. Nilai yang melebihi batas aman akan dibatasi oleh RTL.

### Apa arti resource 32 BRAM?

Angka tersebut berasal dari implementasi SoC lengkap yang mencakup memori MicroBlaze dan blok sistem lain, bukan konsumsi IP I2S secara standalone.

## Kalimat penutup

Rancangan ini membuktikan bahwa transmitter I2S custom dapat diintegrasikan ke SoC MicroBlaze V dan dikendalikan melalui AXI4-Lite. NCO memberikan fleksibilitas frekuensi sampling, sedangkan status polling menjaga pengiriman sampel tetap sinkron dengan frame I2S. Pengembangan berikutnya dapat menambahkan FIFO, DMA, interrupt, dan dua jalur filter dengan state independen.
