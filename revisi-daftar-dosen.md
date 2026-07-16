# Daftar Revisi Dosen dan Penyelesaian

Dokumen ini merangkum catatan revisi dosen, tindakan perbaikan, dan lokasi perubahan pada naskah skripsi.

## Ringkasan hasil implementasi yang digunakan

Data berikut berasal dari laporan implementasi terbaru pada direktori `freshi2s`:

| Parameter | Hasil |
|---|---:|
| Slice | 903 |
| LUT | 2.435 atau 11,71% |
| Flip-Flop | 2.330 atau 5,60% |
| BRAM | 32 atau 64,00% |
| Total power | 0,209 W |
| Dynamic power | 0,135 W |
| Static power | 0,073 W |
| Clock target | 100 MHz |
| WNS | 0,064 ns |
| WHS | 0,031 ns |
| Estimasi frekuensi operasi maksimum | sekitar 100,64 MHz |

Estimasi frekuensi maksimum dihitung dari periode clock 100 MHz dan WNS positif 0,064 ns:

```text
Tmin = 10 ns - 0,064 ns = 9,936 ns
Fmax ≈ 1 / 9,936 ns ≈ 100,64 MHz
```

Resource dan power tersebut merupakan hasil implementasi sistem SoC yang mengintegrasikan IP I2S, bukan pengukuran IP I2S secara standalone.

## Catatan 1 — Bagian Abstrak

### Catatan dosen

Pada bagian akhir paragraf abstrak perlu dituliskan data hardware utilization hasil rancangan IP I2S, jumlah slice, LUT, estimasi frekuensi maksimum, dan power consumption.

### Penyelesaian

Bagian hasil pada abstrak dan intisari telah ditambahkan dengan data implementasi berikut:

- 903 Slice.
- 2.435 LUT.
- 2.330 Flip-Flop.
- 32 BRAM.
- Total power 0,209 W.
- WNS 0,064 ns pada clock 100 MHz.
- Estimasi frekuensi operasi maksimum sekitar 100,64 MHz.

Istilah “frekuensi sampling arbitrer” juga telah diperjelas menjadi frekuensi sampling integer dalam rentang operasi RTL.

### Lokasi perubahan

- `contents/abstract/abstract.tex`
- `contents/abstract/intisari.tex`

## Catatan 2 — Duplikasi Gambar 1.1 dan Gambar 4.1

### Catatan dosen

Gambar 1.1 dan Gambar 4.1 tidak boleh menampilkan gambar yang sama. Jika sama, gambar pada Bab I dihapus karena arsitektur lebih penting dijelaskan pada bab perancangan.

### Penyelesaian

Gambar arsitektur tidak lagi digunakan pada Bab I. Berkas aktif `chapter-1.tex` tidak memuat environment `figure`, sedangkan gambar arsitektur sistem dipertahankan pada Bab IV sebagai bagian dari perancangan dan implementasi.

### Lokasi gambar utama

- `contents/chapter-4/chapter-4.tex`
- Label gambar arsitektur: `fig:ch4-arch-overall`

## Catatan 3 — Ukuran Gambar 4.2

### Catatan dosen

Gambar 4.2 terlalu besar. Ukuran teks di dalam gambar harus proporsional dengan ukuran font naskah.

### Penyelesaian

Ukuran gambar blok internal IP pada Bab IV telah dibatasi menjadi `0.80\textwidth` dengan rasio aspek dipertahankan. Gambar diletakkan sebagai gambar internal IP, bukan sebagai diagram arsitektur keseluruhan, sehingga detail modul tetap dapat dibaca tanpa memenuhi halaman secara berlebihan.

### Lokasi perubahan

- `contents/chapter-4/chapter-4.tex`
- Asset: `contents/figures/i2s-ip-block.png`
- Label gambar: `fig:ch4-ip-block`

## Catatan 4 — Gambar blok modul internal I2S

### Catatan dosen

Tambahkan gambar blok modul di dalam modul I2S jika tersedia.

### Status penyelesaian

Pembahasan internal IP sudah ditambahkan pada Bab IV, tetapi asset `i2s-ip-block.png` yang saat ini digunakan masih berupa tampilan port eksternal IP. Karena itu, catatan ini belum sepenuhnya selesai secara visual. Asset tersebut perlu diganti dengan diagram internal yang benar-benar menunjukkan AXI4-Lite, register file, NCO, latch sampel, dan serializer.

Diagram internal yang harus ditampilkan menunjukkan hubungan:

```text
AXI4-Lite
    ↓
Register file ──→ NCO ──→ BCLK/MCLK
    ↓
Latch sampel ──→ Serializer Philips I2S ──→ WS/DATA
```

Penjelasan pada Bab IV sudah mencantumkan fungsi setiap blok, yaitu transaksi AXI4-Lite, penyimpanan konfigurasi dan sampel, pembangkitan clock, latching pada batas frame, dan serialisasi MSB-first. Yang masih diperlukan adalah penggantian gambar port eksternal dengan diagram internal tersebut.

### Lokasi perubahan

- `contents/chapter-4/chapter-4.tex`
- Asset saat ini: `contents/figures/i2s-ip-block.png` (port eksternal; perlu diganti)
- Label gambar: `fig:ch4-ip-block`

## Catatan 5 — Bagian Kesimpulan

### Catatan dosen

Kesimpulan perlu menampilkan data hasil rancangan IP I2S, yaitu jumlah slice, LUT, estimasi frekuensi maksimum, dan power consumption.

### Penyelesaian

Bab VI telah diperbarui dengan data implementasi sistem SoC final:

- 903 Slice.
- 2.435 LUT.
- 2.330 Flip-Flop.
- 32 BRAM.
- Total power 0,209 W.
- Dynamic power 0,135 W.
- Static power 0,073 W.
- WNS 0,064 ns pada 100 MHz.
- Estimasi frekuensi operasi maksimum sekitar 100,64 MHz.

Kesimpulan menggunakan frasa “sistem SoC yang mengintegrasikan IP I2S” agar data resource tidak disalahartikan sebagai hasil IP standalone.

### Lokasi perubahan

- `contents/chapter-6/chapter-6.tex`

## Pemeriksaan akhir sebelum pengumpulan

- Kompilasi ulang setelah asset `logos_hog.png` diganti secara manual.
- Pastikan nomor gambar setelah penghapusan gambar Bab I berubah sesuai hasil kompilasi.
- Periksa ukuran teks pada Gambar 4.1 dan Gambar 4.2 setelah PDF dibuat.
- Pastikan angka pada abstrak, Bab V, Bab VI, dan lampiran sama.
- Gunakan istilah “frekuensi sampling” secara konsisten dalam naskah berbahasa Indonesia.
- Pastikan diagram lama yang masih memuat `Timer`, `i2s_dds_0`, atau label `Pre-Production` diganti dengan diagram dari desain `freshi2s` terbaru.
- Tambahkan diagram internal IP yang menunjukkan AXI4-Lite, register file, NCO, latch sampel, dan serializer sebelum menandai Catatan 4 sebagai selesai.
