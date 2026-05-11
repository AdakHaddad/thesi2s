# Catatan Skripsi (I2S AXI4-Lite)

## Kenapa FIFO tidak diimplementasikan (versi saat ini)

Implementasi IP I2S TX pada skripsi ini menggunakan model *register-driven*:

- Firmware (Vitis bare-metal) menulis `DATA_LEFT (0x00)` dan `DATA_RIGHT (0x04)`.
- IP men-*shadow* nilai register tersebut ke domain `audio_clk` dan men-serialize ke pin `BCLK/WS/DATA`.
- Tidak ada antrean/buffer sampel di dalam IP (tidak ada FIFO, tidak ada level counter, tidak ada watermark IRQ).

FIFO TX sebenarnya sangat berguna untuk menjaga kontinuitas audio, tetapi pada versi skripsi ini FIFO sengaja tidak diimplementasikan karena:

1. **Ruang lingkup dan fokus skripsi**: fokus utama adalah validasi timing Philips I2S (1-bit delay, 64 BCLK/frame stereo), integrasi AXI4-Lite, dan pembangkitan sinyal pada hardware (Basys3 + PCM5102A).
2. **Kompleksitas desain naik signifikan**: FIFO yang "benar" membutuhkan pengelolaan pointer, status level, deteksi underrun/overflow, serta register status yang konsisten.
3. **Risiko CDC (Clock Domain Crossing)**: data biasanya ditulis dari domain `S_AXI_ACLK` dan dibaca pada domain `audio_clk`. FIFO yang aman untuk dua domain memerlukan sinkronisasi Gray-code pointer atau IP FIFO vendor, serta verifikasi tambahan.
4. **Beban verifikasi bertambah**: selain timing I2S, perlu diuji juga kasus corner seperti underrun, refill burst, dan latensi interrupt.

## Dampak dari tidak ada FIFO

- Kualitas audio/kelancaran sangat bergantung pada seberapa stabil firmware menulis sampel ke register sesuai laju `Fs`.
- Pada beban CPU tinggi atau jitter penjadwalan, risiko *underrun* (klik/noise) meningkat.

## Rencana pengembangan (future work)

- Menambahkan buffer antrean sampel (FIFO TX) di dalam IP, lengkap dengan `STATUS` (level/underrun) dan ambang notifikasi (watermark).
- Opsional: menambahkan mekanisme interrupt dan/atau DMA untuk streaming audio yang lebih stabil.

Pertanyaan yang sangat kritis! Pemahaman tentang batas antara *Hardware* (RTL) dan *Software* (Application Layer) adalah materi yang sangat sering ditanyakan oleh dosen penguji saat sidang skripsi desain SoC/FPGA.

Jawabannya: **Ya, atenuasi (volume) dan manipulasi sinyal TENTU SAJA bisa dilakukan murni di RTL.** Berikut adalah penjelasan mengapa untuk kasus dasar sering dilempar ke *software*, dan fitur apa saja yang justru **wajib** atau **lebih baik** ditaruh di RTL.

---

### 1. Mengapa Volume "Lebih Baik" di App Layer (Untuk Skripsi Anda)?

Konsep "lebih baik" di sini merujuk pada **efisiensi *resource* FPGA** dan **fleksibilitas**, terutama karena Anda menggunakan prosesor MicroBlaze.

* **Menghemat DSP Slices:** Jika Anda membuat pengatur volume di RTL, Anda harus membuat rangkaian *Multiplier* (perkalian matriks/biner) di dalam Verilog. Ini akan memakan blok **DSP48** di dalam chip Artix-7 Basys3 Anda. Jika MicroBlaze Anda sedang menganggur, lebih baik menyuruh MicroBlaze yang menghitung perkalian tersebut daripada membuang *logic gate* FPGA yang berharga.
* **Kurva Logaritmik (Desibel):** Pendengaran manusia itu logaritmik, bukan linear. Menurunkan volume dari 100% ke 50% di telinga tidak terdengar "setengahnya". Di bahasa C (Vitis), membuat rumus logaritmik sangat mudah (tinggal panggil `math.h`). Membuat fungsi logaritma atau tabel *Look-Up* logaritmik di RTL (Verilog) jauh lebih rumit dan memakan banyak *Block RAM* (BRAM).
* **Waktu Pengembangan (Time-to-Market):** Mengubah rumus matematika di kode C hanya butuh *compile* 5 detik. Mengubah *multiplier width* atau logika di RTL mengharuskan Anda melakukan *Synthesis* dan *Implementation* ulang di Vivado yang bisa memakan waktu 10-30 menit.

**Pengecualian:** Jika MicroBlaze Anda sedang sangat sibuk (misalnya menjalankan sistem operasi Linux, memproses TCP/IP Ethernet, dan membaca SD Card sekaligus), maka CPU tidak akan sempat mengalikan sampel audio satu per satu. Pada skenario sibuk ini, atenuasi **wajib** dipindah ke RTL agar CPU tidak terbebani (*Hardware Offloading*).

---

### 2. Fitur Apa yang "Lebih Baik" (Bahkan Wajib) di RTL?

Prinsip utama desain SoC adalah: **Gunakan Software untuk pengambilan keputusan dan matematika kompleks, gunakan Hardware (RTL) untuk kecepatan, *timing* presisi, dan tugas paralel/berulang.**

Jika Anda ingin mengembangkan IP Anda lebih lanjut (atau sebagai saran "Future Work" di Bab 5 skripsi Anda), fitur-fitur inilah yang **sangat bagus jika ditaruh di RTL**:

#### A. Serialisasi Tepat Waktu (Sudah Anda Lakukan)
Mengubah data 32-bit paralel menjadi data serial 1-bit yang keluar persis setiap detak clock (BCLK) 3 MHz. MicroBlaze (Software) **tidak akan pernah bisa** melakukan ini dengan stabil karena adanya interupsi CPU dan latensi memori. Ini wajib RTL.

#### B. FIFO Buffering (Antrean Data)
Saat ini IP Anda tidak punya FIFO (antrean). Jika CPU telat menulis ke register `DATA_LEFT` walau hanya 1 mikrodetik, suara akan terputus (*glitch/stuttering*). 
* **Tugas RTL:** Membuat memori antrean (FIFO BRAM) sebesar 512 sampel. CPU MicroBlaze melempar 512 sampel sekaligus ke antrean dengan sangat cepat, lalu CPU bisa pergi tidur/mengerjakan hal lain sementara RTL I2S memutar antrean tersebut secara santai ke DAC.

#### C. DMA (Direct Memory Access) Controller
Ini adalah level *master* dalam desain SoC. Daripada MicroBlaze membaca lagu dari Memori lalu memindahkannya ke IP I2S secara manual (lewat register), RTL bisa didesain memiliki **DMA AXI4-Full Master**. 
* **Tugas RTL:** IP I2S akan "membajak" bus memori, mengambil data lagu langsung dari DDR RAM sendiri tanpa melibatkan CPU sama sekali. CPU 100% bebas.

#### D. DSP Filtering (IIR/FIR Filters)
Jika Anda ingin membuat *Equalizer* (Bass, Treble) atau sekadar memotong *noise* frekuensi tinggi (*Low-Pass Filter*).
* **Mengapa di RTL?** Memfilter sinyal pada 96 kHz berarti harus melakukan puluhan operasi perkalian dan penambahan (MAC - *Multiply and Accumulate*) setiap 10 mikrodetik. Jika dilakukan di software, MicroBlaze akan "hang" karena kehabisan nafas. Hardware (RTL) bisa memproses ratusan perkalian FIR Filter dalam 1 *clock cycle* secara paralel.

#### E. Hardware Resampler (Sample Rate Converter)
Misal lagu dari PC formatnya 44.1 kHz, tapi IP I2S Anda berjalan di clock 48 kHz. 
* **Tugas RTL:** Interpolasi kompleks untuk mengubah sinyal 44.1k menjadi 48k secara *real-time* di sirkuit tanpa kehilangan kualitas suara.

**Kesimpulan untuk Sidang Anda:**
Sebagai teknokrat informatika, Anda mendesain sistem "Hybrid". Anda meletakkan *kontrol dan modifikasi data* (volume, play, pause) di *Software* karena lebih fleksibel, dan meletakkan *pengiriman data presisi tinggi* (AXI slave, I2S Serializer) di *Hardware* karena menuntut *timing* yang sangat ketat. Kombinasi ini adalah definisi sejati dari *Hardware/Software Co-Design*.

Ini adalah pertanyaan lanjutan yang sangat tajam! Anda benar sekali. Meskipun fungsi volume (atenuasi) diserahkan ke software, fungsi ENABLE (Play/Pause) dan MUTE justru sangat tepat dan wajib diletakkan di RTL (Hardware).

Bagi dosen penguji, ini adalah bukti bahwa Anda paham perbedaan antara "memodifikasi payload/isi data" (tugas software) dan "mengontrol aliran fisik sirkuit" (tugas RTL).

Berikut adalah alasan teknis mengapa ENABLE dan MUTE ada di register perangkat keras Anda:

1. Sangat Murah Secara Logika Hardware (Zero-Cost Logic)
Berbeda dengan pengatur volume yang membutuhkan blok perkalian (Multiplier/DSP Slices) yang mahal, MUTE dan ENABLE hanya membutuhkan satu gerbang logika dasar.

MUTE di RTL: Hanya butuh satu Multiplexer (MUX) 2-to-1 atau gerbang AND. Jika MUTE = 1, RTL akan langsung memaksa jalur data (TX) ke angka 0 terus-menerus, apa pun isi registernya. Biayanya hanya 1 LUT (Look-Up Table) di FPGA.

Jika Mute dilakukan di software, MicroBlaze harus terus-menerus dan secara aktif mengirimkan sampel bernilai 0 ke register. Ini membuang-buang siklus CPU.

2. Mencegah Suara Popping (Hardware Protection)
Saat FPGA baru dinyalakan (booting) atau MicroBlaze sedang me-reset program, nilai memori sering kali tidak menentu (garbage data). Jika RTL langsung mengirim data ke DAC PCM5102A, speaker bisa mengeluarkan suara ledakan/kresek (pop/click noise) yang bisa merusak telinga atau speaker itu sendiri.

Dengan adanya register ENABLE dan MUTE yang secara default bernilai 0 (Nonaktif/Mute) saat FPGA baru menyala, RTL secara fisik mengunci jalur I2S agar tetap senyap. DAC tidak akan bersuara sampai MicroBlaze selesai booting, siap memutar musik, dan dengan sadar mengubah bit menjadi 1.

3. Menghentikan Clock Fisik (Clock Gating)
"Pause" di software sekadar berarti "berhenti mengirim data baru". Namun di I2S, jika Anda ingin benar-benar melakukan "Pause" (menghentikan sistem), ENABLE = 0 pada RTL tidak hanya menghentikan data, tetapi juga menghentikan sinyal BCLK dan WS/LRCK agar tidak berdetak.

Tindakan menghentikan clock ini (Clock Gating) akan membuat modul DAC PCM5102A masuk ke mode Standby/Sleep. Hal ini sangat menghemat daya dan mencegah noise. Software murni tidak memiliki kemampuan untuk mematikan kabel clock secara fisik; itu harus dilakukan oleh saklar RTL.

Kesimpulan untuk Arsitektur Anda:
Pembagian tugas pada desain IP I2S AXI4-Lite Anda sudah sangat elegan:

Software (App Layer): Memilih lagu, mengubah volume (matematika amplitudo), dan mengatur ritme.

Hardware (RTL): Membuka/menutup gerbang fisik sirkuit (ENABLE), mengamankan jalur sinyal secara instan (MUTE), dan mengatur sinkronisasi detak (Clock/Frequency).