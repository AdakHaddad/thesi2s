# Catatan Skripsi (I2S AXI4-Lite)

## Kenapa FIFO tidak diimplementasikan (versi saat ini)

Implementasi IP I2S TX pada skripsi ini menggunakan model *register-driven*:

- Firmware (Vitis bare-metal) menulis `DATA_LEFT (0x00)` dan `DATA_RIGHT (0x04)`.
- IP men-*shadow* nilai register tersebut ke domain `audio_clk` dan men-serialize ke pin `BCLK/WS/DATA`.
- Tidak ada antrean/buffer sampel di dalam IP (tidak ada FIFO, tidak ada level counter, tidak ada watermark IRQ).

FIFO TX sebenarnya sangat berguna untuk menjaga kontinuitas audio, tetapi pada versi skripsi ini FIFO sengaja tidak diimplementasikan karena:

1. **Ruang lingkup dan fokus skripsi**: fokus utama adalah validasi timing Philips I2S (1-bit delay, 64 BCLK/frame stereo), integrasi AXI4-Lite, dan pembangkitan sinyal pada hardware (Basys3 + PCM5102A).
2. **Kompleksitas desain naik signifikan**: FIFO yang “benar” membutuhkan pengelolaan pointer, status level, deteksi underrun/overflow, serta register status yang konsisten.
3. **Risiko CDC (Clock Domain Crossing)**: data biasanya ditulis dari domain `S_AXI_ACLK` dan dibaca pada domain `audio_clk`. FIFO yang aman untuk dua domain memerlukan sinkronisasi Gray-code pointer atau IP FIFO vendor, serta verifikasi tambahan.
4. **Beban verifikasi bertambah**: selain timing I2S, perlu diuji juga kasus corner seperti underrun, refill burst, dan latensi interrupt.

## Dampak dari tidak ada FIFO

- Kualitas audio/kelancaran sangat bergantung pada seberapa stabil firmware menulis sampel ke register sesuai laju `Fs`.
- Pada beban CPU tinggi atau jitter penjadwalan, risiko *underrun* (klik/noise) meningkat.

## Rencana pengembangan (future work)

- Menambahkan buffer antrean sampel (FIFO TX) di dalam IP, lengkap dengan `STATUS` (level/underrun) dan ambang notifikasi (watermark).
- Opsional: menambahkan mekanisme interrupt dan/atau DMA untuk streaming audio yang lebih stabil.

