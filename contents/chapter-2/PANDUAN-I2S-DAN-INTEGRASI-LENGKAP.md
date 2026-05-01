# Panduan lengkap: I2S, IP `i2s.v` / AXI, DAC, UART, dan alur data (in & out)

Dokumen ini merangkum **satu gambaran utuh** supaya kamu paham dari hulu ke hilir: sinyal I2S, isi RTL saat ini, rencana v2, hubungan dengan DAC (PCM5102A), format file audio, serta **mengapa UART tidak sama** dengan bus audio.

---

## 1. Tiga jalur yang sering dicampur (ini penting)

| Jalur | Fungsi | “Kecepatannya” |
|--------|--------|----------------|
| **UART** | Debug, perintah dari PC, log, kadang transfer file kecil | **Baud** (mis. 9600, 115200) = bit per detik di kabel serial |
| **AXI4-Lite** | CPU (MicroBlaze) baca/tulis **register** peripheral | Tergantung `S_AXI_ACLK` dan burst tidak ada (single transfer) |
| **I2S** | Stream **sampel audio** ke DAC | Tergantung **BCLK** dan **LRCK (WS)**; **bukan baud** |

**Kesalahan umum:** mengira “baud UART harus disamakan dengan DAC” atau “9600 harus sama dengan clock I2S”. Keduanya **domain berbeda**. Yang harus konsisten untuk audio adalah **LRCK = frekuensi sampling** dan **BCLK** yang memenuhi format slot bit, bukan baud UART.

---

## 2. I2S itu apa (level konsep)

I2S (Inter-IC Sound) memakai minimal:

- **BCLK (SCK / bit clock):** clock per **bit** data serial pada kabel `DATA`.
- **LRCK / WS (word select):** memilih saluran **kiri vs kanan**; frekuensi WS = **frekuensi sampling stereo** \(F_s\) (satu period WS = satu frame kiri+kanan).
- **DATA (SD / DIN ke DAC):** bit audio MSB dulu, sesuai format Philips I2S.
- **MCLK (opsional):** master clock referensi; banyak DAC bisa derive dari BCLK, tergantung chip dan PCB.

**Philips I2S (stereo, slot 32 bit per saluran):**

- Satu saluran = **32 period BCLK** (satu “slot”).
- Stereo = **64 BCLK per frame** (kiri 32, kanan 32).
- Di dalam slot sering ada **1 bit delay** setelah tepi WS, lalu bit sampel (16/24 bit), sisanya padding `0`.

Hubungan frekuensi (ringkas):

\[
f_{\mathrm{BCLK}} = 64 \times F_s
\quad\text{(untuk format 32 bit × 2 saluran per frame)}
\]

\[
F_s = \frac{f_{\mathrm{BCLK}}}{64}
\]

---

## 3. Representasi sampel: **integer** di kabel, bukan float

- **I2S membawa bilangan bulat bertanda** (two’s complement) dengan lebar tetap, mis. **16** atau **24 bit** per saluran (di dalam slot yang bisa 32 bit).
- **File WAV** bisa berisi PCM **integer** atau **float** (IEEE).  
  Jika isi float dikirim ke register/hardware yang mengharapkan **integer PCM**, bit pattern akan salah → keluaran seperti **noise**.
- **Yang benar:** di PC atau di firmware, lakukan **konversi float → int** (normalisasi, clamp, kuantisasi ke \(N\) bit) **sebelum** masuk FIFO/register menuju serializer.

---

## 4. Frekuensi sampling: 8 kHz, 44,1 kHz, 48 kHz, 96 kHz, “384 kHz”

- **8 kHz** — teleponi narrowband.
- **44,1 kHz** — CD.
- **48 kHz** — audio pro / video.
- **96 / 192 kHz** — hi-res (jika DAC + clock + board mendukung).
- **384 kHz** — muncul pada **beberapa** DAC/codec kelas tertentu; **tidak otomatis** didukung modul breakout atau konfigurasi clock kamu. **Selalu cek datasheet** dan ukur di osiloskop/ILA.

Di FPGA, \(F_s\) **efektif** ditentukan oleh **berapa kali LRCK berganti per detik** yang kamu bangkitkan dari **pembagi + osilator aktual** (MMCM sering tidak tepat 24,576 MHz → nilai “≈” wajar di skripsi).

---

## 5. RTL kamu **sekarang** (`i2s_slave_lite_v1_0_S00_AXI.v` + `i2s.v`)

### 5.1 Dua domain clock

1. **`S_AXI_ACLK`** — domain **register AXI** (`slv_reg0..3`, FSM AXI).
2. **`audio_clk`** — domain **serializer I2S** (BCLK/WS/DATA, counter bit).

`slv_reg0` di-sampling ke `sample_q` di domain audio saat batas frame. Untuk desain v2 dengan FIFO cepat, nanti perlu **CDC** yang benar (async FIFO / gray pointer), bukan asumsi “selalu aman”.

### 5.2 Register **v1** (kebenaran dari kode hari ini)

| Offset byte | Nama RTL | Peran I2S |
|-------------|----------|-----------|
| `0x00` | `slv_reg0` | **Aktif:** sampel stereo terpaket 32 bit: `[31:16] = L`, `[15:0] = R`, **16 bit efektif** per saluran (fungsi serializer). |
| `0x04`–`0x0C` | `slv_reg1..3` | Ada di AXI, **tidak** dipakai logika I2S. |

**Tidak ada** FIFO, IRQ, `ID`, `CONTROL`, `STATUS` di v1.

### 5.3 Alur data **in → out** (v1)

```
[Vitis / C] --AXI write--> slv_reg0 (domain AXI)
                              |
         audio_clk: saat bit_count == 0  --> sample_q <= slv_reg0
                              |
                    i2s_next_serial_bit(...)
                              |
                    i2s_data, i2s_bclk, i2s_ws, i2s_mclk
                              |
                         [DAC / PCM5102A]
```

**Lemah v1:** CPU harus menulis **tepat sebelum** frame habis; tanpa FIFO mudah **underrun** (suara putus / noise).

### 5.4 Rumus \(F_s\) dan koreksi `FS_MODE`

Untuk format stereo 32-bit per kanal:

\[
F_s = \frac{f_{\mathrm{audio\_clk}}}{\mathrm{divider} \times 2 \times 64}
\]

Dengan clock aktual hasil Clocking Wizard:

- keluarga 48 kHz: `audio_clk = 24.597 MHz`
- keluarga 44.1 kHz: `audio_clk = 22.426 MHz`

Untuk `audio_clk = 24.597 MHz`:

- divider 4 → `BCLK = 24.597/4/2 = 3.0746 MHz` → `WS = 48.03 kHz`
- divider 2 → `BCLK = 24.597/2/2 = 6.1493 MHz` → `WS = 96.08 kHz`

Masalah pada RTL awal adalah logika `FS_MODE` terbalik:

```verilog
wire bclk_en_w = fs_mode_sync ? (clock_div_q == 3'd0)
                               : (clock_div_q[1:0] == 2'd0);
```

Saat `fs_mode_sync=1`, logika di atas justru memberi pulsa setiap 8 siklus `audio_clk`, sehingga `WS` turun ke sekitar `24.02 kHz`, bukan naik ke sekitar `96 kHz`. Koreksi yang dibutuhkan:

```verilog
wire bclk_en_w = fs_mode_sync ? (clock_div_q[0] == 1'b0)
                               : (clock_div_q[1:0] == 2'd0);
```

Dengan koreksi ini:

- `FS_MODE=0` → low-\(F_s\) (`44.1/48 kHz`) memakai divider 4
- `FS_MODE=1` → high-\(F_s\) (`88.2/96 kHz`) memakai divider 2

**Catatan penting:** bit `fs_sync` di RTL sekarang belum dipakai untuk memilih sumber `audio_clk`. Artinya, perpindahan keluarga 48 kHz ke 44.1 kHz harus dilakukan di top-level dengan clock mux, misalnya `BUFGMUX`, bukan hanya dengan mengubah bit kontrol di serializer.

---

## 6. Rencana **v2** (ringkas — supaya paham arah)

| Fitur | Manfaat |
|--------|---------|
| **Register map** (`ID`, `CONTROL`, `STATUS`, `WATERMARK`, `IRQ_*`, `TX_LEFT`, `TX_RIGHT`) | Kontrol jelas, siap driver & dokumentasi |
| **FIFO** + **watermark IRQ** | Playback stabil; ISR isi batch, bukan per-sample |
| **Push frame** saat tulis `TX_RIGHT` (setelah `TX_LEFT` di-latch) | Komit stereo atomik |
| **FS_MODE** div4 vs div2 | Dua mode \(F_s\) dari `audio_clk` yang sama |
| **Serializer 24-bit** dalam slot 32 | Selaras rekomendasi akademik + PCM5102A |

Detail implementasi ada di repo FPGA: `I2S_V2_IMPLEMENTATION_SPEC.md` dan `I2S_SLAVE_LITE_MASTER_GUIDE.md` (folder `ip_repo/i2s_1_0/`).

---

## 7. DAC dan PCM5102A — “in” dari sisi sistem

### 7.1 Siapa master clock?

Pada skema kamu (FPGA → DAC), FPGA biasanya **master**:

- FPGA menghasilkan **BCLK** dan **LRCK**.
- DAC adalah **slave** pada jalur I2S: ia **mengikuti** clock yang kamu berikan.

**Implikasi:** “mengatur frekuensi sampling” pada DAC = **mengatur LRCK** (dan BCLK konsisten) di FPGA, **bukan** memilih angka di register UART.

### 7.2 Apakah PCM5102A “programmable” seperti SPI?

Secara umum **bukan** seperti codec dengan banyak register untuk memilih \(F_s\) lewat I2C. Yang utama:

- **Format + timing** serial mengikuti **datasheet TI PCM5102A**.
- **\(F_s\)** mengikuti **frekuensi LRCK** yang kamu bangkitkan.

Fitur tambahan (filter, de-emphasis, dll.) ada di datasheet; implementasi pada modul breakout bisa dibatasi ke **mode default** + **wiring**.

### 7.3 Apakah DAC mengikuti `i2s.v`?

Secara fungsional: **mengikuti LRCK/BCLK/DATA yang dikeluarkan modul I2S di FPGA** (bisa melalui wrapper `i2s.v`). Nama file tidak penting bagi DAC; yang penting **timing dan format bit**.

---

## 8. UART: mengapa **bukan** `115200 / 2` untuk 16-bit audio?

UART mengutip **bit per detik** di saluran, tetapi satu **byte** 8N1 membutuhkan kira-kira **10 bit waktu** (start + 8 data + stop) → throughput byte \(\approx\) **baud / 10**.

Untuk **stereo 16-bit PCM** pada \(F_s = 44{,}1\) kHz:

- Byte per detik \(\approx 44100 \times 4 = 176{,}400\) byte/s.

Itu **jauh di atas** ~11,5 kbyte/s dari 115200 8N1. Jadi:

- **Salah:** “16-bit jadi baud dibagi 2”.
- **Benar:** lebar sampel **naik** → butuh **lebih banyak** byte per detik → butuh **saluran lebih cepat** atau **bukan** streaming real-time lewat UART itu.

UART tetap berguna untuk **kontrol** dan **transfer blok** (mis. chunk data ke buffer), bukan menggantikan I2S untuk audio CD-quality real-time.

---

## 9. “Supaya clock I2S dan 9600 sama dengan data dari laptop”

Artinya harus dipisah:

- **9600 bps** — kecepatan **UART**.
- **LRCK / BCLK** — **waktu sampling audio**.

Keduanya **tidak wajib sama**. Sinkronisasi **makna** (mis. perintah mulai/stop dari laptop vs pemutaran) dilakukan di **protokol aplikasi**: mis. PC kirim perintah lewat UART, lalu firmware memutar buffer yang sudah diisi.

---

## 10. Diagram alur mental (satu baris)

```
Laptop / file WAV
    → decode & (float→int jika perlu)
    → buffer / FIFO di FPGA atau BRAM
    → AXI register atau DMA
    → serializer I2S (audio_clk)
    → BCLK, WS, DATA (± MCLK)
    → DAC → analog → speaker / scope / Audacity (rekaman)
```

---

## 11. Hubungan dengan skripsi (LaTeX)

Di `contents/chapter-2/chapter-2.tex` sudah ada subsubbab yang menjelaskan poin di atas dan **tiga placeholder gambar**:

1. `contents/figures/diagram-aliran-audio-datapath.pdf`
2. `contents/figures/diagram-clock-bclk-lrck-fs.pdf`
3. `contents/figures/diagram-uart-vs-i2s-throughput.pdf`

Kamu bisa mengganti `.pdf` dengan `.png` dengan mengedit path di LaTeX jika lebih nyaman (mis. kamu sudah punya `gambar-buatan-sendiri.PNG` di folder yang sama — tinggal seragamkan nama file di `\IfFileExists` / `\includegraphics`).

---

## 12. Checklist “saya sudah paham in & out”

- [ ] Bisa menjelaskan peran **BCLK**, **WS**, **DATA**, **MCLK** tanpa mencampur UART.
- [ ] Bisa menghitung \(F_s\) dari \(f_{\mathrm{BCLK}}\) untuk frame 64 BCLK.
- [ ] Paham **mengapa WAV float harus dikonversi** sebelum I2S.
- [ ] Paham **v1** hanya pakai `slv_reg0` dan risiko tanpa FIFO.
- [ ] Paham **v2**: FIFO + IRQ + register map + mode div.
- [ ] Paham **PCM5102A mengikuti LRCK** yang dibangkitkan FPGA.
- [ ] Paham **UART tidak cukup** untuk stream PCM stereo 44,1k mentah pada 115200.

---

## 13. File rujukan di workspace

| Lokasi | Isi |
|--------|-----|
| `D:\Vivado-projects\Basys3\sbml\ip_repo\i2s_1_0\hdl\i2s_slave_lite_v1_0_S00_AXI.v` | RTL AXI + I2S v1 |
| `D:\Vivado-projects\Basys3\sbml\ip_repo\i2s_1_0\hdl\i2s.v` | Wrapper IP |
| `D:\Vivado-projects\Basys3\sbml\ip_repo\i2s_1_0\I2S_SLAVE_LITE_MASTER_GUIDE.md` | Panduan baris-per-blok RTL |
| `D:\Vivado-projects\Basys3\sbml\I2S_AXI_REGISTER_DOC.md` | Dokumen register (sesuai evolusi proyek) |
| `D:\Vivado-projects\Basys3\sbml\I2S_V2_IMPLEMENTATION_SPEC.md` | Spesifikasi target v2 |
| `C:\tesi2s\thesi2s\contents\chapter-2\chapter-2.tex` | Bab II + placeholder gambar |

---

*Dokumen ini disusun sebagai panduan tunggal (in & out). Sesuaikan angka ukur dengan hasil MMCM dan osiloskop pada board-mu saat Bab Metodologi/Hasil.*
