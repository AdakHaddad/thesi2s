# Revisions

## 2026-06-29: Tambah subsistem Dasar Teori di Chapter 2

Menambahkan 3 subsection baru dan merevisi 1 subsection di `contents/chapter-2/chapter-2.tex`:

### Ditambahkan
- **Verilog Hardware Description Language (HDL)** — pengertian Verilog, peran sebagai HDL di level RTL, perbedaan HW/SW programming, alasan pemilihan Verilog dalam penelitian
- **Register Transfer Level (RTL)** — definisi RTL, hubungan logika kombinasional/sekuensial/register/clock, alasan desain IP di level RTL
- **Intellectual Property (IP) Core** — konsep IP core dalam IC/SoC/FPGA, manfaat reusable hardware dan modularitas, klasifikasi Soft/Firm/Hard IP, IP penelitian sebagai Soft IP berbasis RTL Verilog + Vivado IP Packager

### Direvisi
- **Protokol Komunikasi AXI4-Lite** — diperluas dengan: overview AMBA, varian AXI (AXI4/AXI4-Lite/AXI4-Stream), mekanisme read/write register, koneksi ke MicroBlaze V dan register map I2S

### Dihapus
- Subsection lama "Verilog HDL, Perbandingan IP, dan Analisis Metode" (redundan, tergantikan oleh 3 subsection baru)

### Referensi baru yang digunakan
Semua referensi sudah ada di `references.bib`: `palnitkar_verilog_2003`, `harris_harris_digital_2022`, `chu_fpga_prototyping_2011`, `lafosse_embedded_2018`, `trimberger_history_fpga_2018`, `xilinx_ug1118`, `arm_amba_axi_2010`, `xilinx_axi_ref_2017`
