# Direktori Figures (Gambar)

Direktori ini menyimpan gambar/figur yang digunakan dalam skripsi.

## Daftar gambar yang harus ditempatkan di sini

| Nama file | Digunakan di | Deskripsi |
|-----------|-------------|-----------|
| `block-diagram-i2s-axi.pdf` | Bab III (Gambar 3.1) | Diagram blok arsitektur sistem peripheral I2S TX + AXI4-Lite |
| `clocking-wizard-requested-vs-actual.png` | Bab IV (Gambar 4.1) | Screenshot Clocking Wizard -- kolom Requested vs Actual frequency |
| `sim-waveform-i2s.png` | Bab IV (Gambar 4.2) | Screenshot waveform simulasi Vivado Simulator (BCLK, WS, DATA) |
| `ila-bclk-ws-data.png` | Bab IV (Gambar 4.3) | Screenshot ILA Hardware Manager -- sinyal BCLK, WS, DATA |
| `ila-fifo-irq.png` | Bab IV (Gambar 4.4) | Screenshot ILA -- FIFO level dan sinyal IRQ saat playback |
| `scope-or-audio-proof.png` | Bab IV (Gambar 4.5) | Bukti output audio: foto osiloskop atau screenshot Audacity |

## Cara menggunakan gambar di LaTeX

Setelah gambar disimpan di direktori ini, hapus komentar pada perintah
`\includegraphics` yang ada di masing-masing chapter dan hapus blok `\fbox`
placeholder-nya.

Contoh:
```latex
% Sebelum (placeholder):
\fbox{\begin{minipage}...}

% Sesudah (gambar tersedia):
\includegraphics[width=0.95\linewidth]{contents/figures/block-diagram-i2s-axi.pdf}
```

Lihat Lampiran "Panduan Pengambilan Gambar dan Bukti Pengujian" untuk
instruksi lengkap cara mengambil setiap gambar.
