# Panduan Verifikasi I2S AXI4-Lite — Testbench Guide

## Ringkasan

Folder ini berisi dua testbench untuk modul **I2S Transmitter AXI4-Lite** (`i2s_slave_lite_v1_0_S00_AXI`):

| File | Jenis | Tujuan |
|------|-------|--------|
| `tb_axi_i2s.v` | Full AXI4-Lite | Mensimulasikan Vitis/firmware: tulis/baca register lewat AXI bus |
| `tb_direct_i2s.v` | Direct register | Paksa register internal langsung (tanpa AXI); debug serialisasi cepat |

RTL sumber DUT ada di `../rtl/i2s_slave_lite_v1_0_S00_AXI.v`.

---

## Prasyarat

### Simulator

Simulasi diuji dengan [Icarus Verilog](http://iverilog.icarus.com/) (open-source):

```bash
# Ubuntu/Debian
sudo apt-get install iverilog gtkwave

# macOS (Homebrew)
brew install icarus-verilog gtkwave
```

Untuk Vivado (Xilinx), lihat bagian [Simulasi di Vivado](#simulasi-di-vivado).

---

## Cara Kompilasi dan Jalankan

### 1. `tb_axi_i2s.v` — Full AXI4-Lite Testbench

```bash
cd tb/

iverilog -o sim_axi.vvp \
    ../rtl/i2s_slave_lite_v1_0_S00_AXI.v \
    tb_axi_i2s.v

vvp sim_axi.vvp
```

Output konsol yang diharapkan:

```
=== tb_axi_i2s: AXI4-Lite I2S Testbench ===
[INFO] Reset released
[PASS] ID register = 0x49325301
[PASS] CTRL write-read round-trip
[INFO] Wrote sample L=0xA5A5 R=0x5A5A, play=1 (48k mode)
[INFO] Captured: L=0xA5A5 R=0x5A5A (expected L=0xA5A5 R=0x5A5A)
[PASS] Frame 0: LEFT  sample matches
[PASS] Frame 0: RIGHT sample matches
[PASS] Frame 1: LEFT  sample matches
[PASS] Frame 1: RIGHT sample matches
[PASS] Frame 2: LEFT  boundary value
[PASS] Frame 2: RIGHT boundary value
[PASS] BCLK period 48k mode within tolerance
[PASS] WS half-period = 32 BCLK cycles
[PASS] DATA silent during MUTE
[PASS] BCLK period 96k mode within tolerance
=== RESULTS: 10 PASSED, 0 FAILED ===
ALL CHECKS PASSED
```

Waveform VCD disimpan di `tb_axi_i2s.vcd`:

```bash
gtkwave tb_axi_i2s.vcd &
```

---

### 2. `tb_direct_i2s.v` — Direct Register Testbench

```bash
cd tb/

iverilog -o sim_direct.vvp \
    ../rtl/i2s_slave_lite_v1_0_S00_AXI.v \
    tb_direct_i2s.v

vvp sim_direct.vvp
```

Output konsol yang diharapkan:

```
=== tb_direct_i2s: Direct-Register I2S Testbench ===
[INFO] AXI bus is idle – internal registers forced directly
[INFO] Reset released
[PASS] BCLK period 48k correct
[PASS] WS half-period = 32 BCLK
[PASS] Pattern A LEFT
[PASS] Pattern A RIGHT
[PASS] Pattern B LEFT
[PASS] Pattern B RIGHT
[PASS] Boundaries LEFT
[PASS] Boundaries RIGHT
[PASS] DATA=0 when play=0
[PASS] DATA=0 when mute=1
[PASS] BCLK period 96k correct
[PASS] Consecutive frame L stable  (x3)
[PASS] Consecutive frame R stable  (x3)
=== RESULTS: 17 PASSED, 0 FAILED ===
ALL CHECKS PASSED
```

Waveform VCD:

```bash
gtkwave tb_direct_i2s.vcd &
```

---

## Cara Membaca Waveform I2S di GTKWave

### Grup sinyal yang disarankan

Tambahkan sinyal berikut ke GTKWave (File → Append Signals From File):

**Grup "AXI Bus" (untuk `tb_axi_i2s` saja):**
- `S_AXI_AWADDR`, `S_AXI_AWVALID`, `S_AXI_AWREADY`
- `S_AXI_WDATA`, `S_AXI_WVALID`, `S_AXI_WREADY`
- `S_AXI_BRESP`, `S_AXI_BVALID`, `S_AXI_BREADY`

**Grup "I2S Outputs":**
- `i2s_bclk`
- `i2s_ws`
- `i2s_data`

**Grup "Internal State" (untuk `tb_direct_i2s` saja):**
- `dut.sample_q` (format: Hex)
- `dut.ctrl_sync_b` (format: Bin)
- `dut.bit_cnt` (format: Unsigned)
- `dut.bclk_r`

---

### Bentuk waveform yang benar (pass criteria visual)

#### 1. BCLK

```
         ┌──┐  ┌──┐  ┌──┐  ┌──┐  ┌──┐
i2s_bclk ┘  └──┘  └──┘  └──┘  └──┘  └──

Periode = audio_clk × 8  ≈ 328 ns (mode 48k)
        = audio_clk × 4  ≈ 164 ns (mode 96k)
```

#### 2. WS (LRCK) — LEFT / RIGHT alternation

```
         ┌─────────────────────────────┐
i2s_ws   │          HIGH (RIGHT)       │
─────────┘                             └─────────
           ←── 32 BCLK ──→             ←── 32 BCLK ──→
           LEFT channel                RIGHT channel
```

- WS berubah pada FALLING edge BCLK (bukan rising).
- WS=0 → kanal KIRI, WS=1 → kanal KANAN.
- Satu periode penuh WS = **64 BCLK cycles** = 1 stereo frame.

#### 3. DATA — Philips I2S framing

```
                WS→0         bit delay   L[15] L[14] ... L[0]   PAD(16 zeros)   WS→1
i2s_bclk   ─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─...─┬─┬─┬─┬─┬─┬─┬─┬─
             0 1 2 3 ...                             15 16   31

i2s_ws     ─────────────────────────────────────────────────────────
           ←──────────────── slot kiri (32 BCLK) ──────────────────→

i2s_data   ─ 0 │L15│L14│...│L0│ 0 │ 0 │...│ 0 │
             ↑                                     ↑
             delay 1 BCLK                          padding zeros
```

**Checklist inspeksi manual:**
- [ ] `i2s_ws` berubah tepat pada BCLK **falling** edge
- [ ] `i2s_data` bit pertama setelah WS→0 adalah **0** (Philips 1-bit delay)
- [ ] Bit berikutnya (posisi 1..16) adalah MSB-first dari sampel KIRI
- [ ] Posisi 17..31: semua **0** (zero padding)
- [ ] Satu BCLK setelah WS→1: **0** (delay), lalu MSB-first sampel KANAN
- [ ] Tidak ada "glitch" pada BCLK atau WS

---

## Register Map Singkat (v1)

| Offset | Nama | Akses | Keterangan |
|--------|------|-------|------------|
| `0x00` | DATA (slv_reg0) | R/W | `[31:16]` = sampel kiri 16-bit, `[15:0]` = kanan |
| `0x04` | CTRL (slv_reg1) | R/W | `[0]`=play, `[1]`=mute, `[2]`=fs_mode |
| `0x08` | STATUS (slv_reg2) | R | `[0]`=serialiser aktif |
| `0x0C` | ID (slv_reg3) | R | `0x49325301` |

### Kontrol (slv_reg1[2:0])

| Bit | Nama | Nilai 0 | Nilai 1 |
|-----|------|---------|---------|
| 0 | play | Stop (DATA = 0) | Serialisasi aktif |
| 1 | mute | Normal | DATA paksa = 0, BCLK/WS tetap jalan |
| 2 | fs_mode | ~48 kHz (BCLK = audio_clk/8) | ~96 kHz (BCLK = audio_clk/4) |

---

## Perbedaan Dua Testbench

| Aspek | `tb_axi_i2s.v` | `tb_direct_i2s.v` |
|-------|----------------|-------------------|
| Interface yang diuji | AXI4-Lite (AWADDR/WDATA/...) | Langsung ke `sample_q`, `ctrl_sync_b` via `force` |
| Kebutuhan AXI handshake | Ya (write/read tasks) | Tidak |
| Kecepatan iterasi debug | Lebih lambat (~100 us per frame write) | Lebih cepat (langsung setelah `force`) |
| Realistis terhadap firmware | Sangat realistis | Tidak (bypass CDC & AXI) |
| Berguna untuk | Validasi integrasi AXI ↔ serialiser | Debug urutan bit, timing WS/BCLK |
| VCD output | `tb_axi_i2s.vcd` | `tb_direct_i2s.vcd` |

---

## Simulasi di Vivado

### Tambah file ke proyek

1. Buka Vivado, klik **Add Sources → Add or Create Simulation Sources**.
2. Tambahkan:
   - `rtl/i2s_slave_lite_v1_0_S00_AXI.v`
   - `tb/tb_axi_i2s.v` **atau** `tb/tb_direct_i2s.v`
3. Set **Top** ke nama modul testbench (`tb_axi_i2s` atau `tb_direct_i2s`).

### Jalankan simulasi

```
Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation
```

### Dump VCD dari Vivado

Tambahkan ini di awal testbench (sudah ada):
```verilog
$dumpfile("tb_axi_i2s.vcd");
$dumpvars(0, tb_axi_i2s);
```

Vivado secara default menyimpan waveform ke format `.wdb` — untuk VCD, gunakan Tcl console:
```tcl
open_vcd /tmp/tb_axi_i2s.vcd
log_vcd *
run 500us
close_vcd
```

---

## Kriteria Kelulusan (Pass Criteria)

### Frekuensi dan timing

| Parameter | Mode 48k | Mode 96k | Toleransi |
|-----------|----------|----------|-----------|
| `audio_clk` | 24.56897 MHz | sama | ±0 (dari MMCM) |
| BCLK | ≈3.071 MHz | ≈6.142 MHz | ±10% simulasi |
| WS (LRCK) | ≈47.986 kHz | ≈95.97 kHz | ±5% |
| BCLK per frame | 64 | 64 | tepat 64 |
| BCLK per channel | 32 | 32 | tepat 32 |

### Data integrity

| Pengujian | Kriteria |
|-----------|----------|
| ID register | Harus `0x49325301` |
| DATA saat play=0 | Semua bit = 0 |
| DATA saat mute=1 | Semua bit = 0 (BCLK/WS tetap jalan) |
| Sampel kiri | Bit [15:0] MSB-first, slot posisi 1..16 |
| Sampel kanan | Bit [15:0] MSB-first, slot posisi 33..48 |
| Padding | Posisi 17..31 dan 49..63 = 0 |
| Philips delay | Posisi 0 dan 32 = 0 |

---

## Pengembangan Lanjutan (v2)

Jika modul dikembangkan ke **v2** dengan FIFO + register map lengkap (TX_LEFT, TX_RIGHT, WATERMARK, IRQ), testbench `tb_axi_i2s.v` perlu diupdate:

1. Ganti tulis ke `slv_reg0` dengan urutan: tulis `TX_LEFT` (0x1C) → tulis `TX_RIGHT` (0x20).
2. Tambah monitoring sinyal `irq` dan baca register `IRQ_STATUS` (0x14).
3. Tambah pengujian FIFO underrun: biarkan serialiser jalan tanpa refill, cek `STATUS[2]`.
4. Tambah pengujian watermark IRQ: isi FIFO 10 frame, cek `irq` aktif saat level ≤ threshold.

---

*Dokumen ini dibuat sebagai panduan verifikasi untuk skripsi I2S AXI4-Lite di Basys3 (PCM5102A, 24-bit stereo, 2 mode Fs).*
