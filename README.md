# Latex Template for Thesis Writing at DTETI UGM

## Info

- This template is originally written by [Canggih Puspo Wibowo](https://github.com/canggihpw/thesisdtetiugm). Now, this template is developed by Yohan Fajar Sidik (DTETI FT UGM)
- The template is intended for a bachelor thesis. Other templates (master and doctoral) are availables, but they need adjustment.


## What's new

- [2023-02-17] Initial release.
- [2023-05-30] [v1.1](https://github.com/Dr-Sidik/template_thesis_latex_dteti/releases/tag/v1.1)
- [2025-04-09] [v1.2](https://github.com/Dr-Sidik/template_thesis_latex_dteti/releases/tag/v1.2)

## How-to-use 

Read the detailed information in **main.tex**.
In case some **sty files** are not available in your TeX installation, just copy the required one from **packages/** directory into the same directory as **main.tex**. Hopefully this will help beginner users.

## Build Instructions (I²S Thesis)

### Prerequisites

- TeX Live 2020+ or MiKTeX 21+, including packages: `babel`, `graphicx`, `amsmath`, `longtable`, `listings`, `caption`, `subcaption`, `fancyhdr`, `titlesec`, `setspace`, `geometry`.
- BibTeX for references.

### Compiling

Run from the repository root (where `main.tex` is located):

```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Or with `latexmk` (recommended):

```bash
latexmk -pdf main.tex
```

To clean auxiliary files:

```bash
latexmk -c
```

### Figure Placeholders

The `figures/` directory contains grey placeholder PNG files. Replace each file with the actual screenshot/diagram before submitting:

| File | Description |
|------|-------------|
| `figures/fig_blok_sistem.png` | Overall system block diagram (draw.io / Visio) |
| `figures/fig_i2s_timing.png` | I²S timing diagram (WaveDrom or similar) |
| `figures/fig_i2s_format.png` | 32-bit slot format illustration |
| `figures/fig_fifo_diagram.png` | FIFO TX block diagram |
| `figures/fig_flowchart_software.png` | Vitis `main.cpp` flowchart |
| `figures/fig_clocking_wizard.png` | Clocking Wizard requested vs actual freq (Vivado screenshot) |
| `figures/fig_blok_desain_vivado.png` | Vivado IP Integrator block design screenshot |
| `figures/fig_simulasi_timing.png` | RTL simulation waveform (Vivado Simulator) |
| `figures/fig_ila_capture.png` | ILA waveform capture from Basys3 hardware |
| `figures/fig_pcm5102a_koneksi.png` | PCM5102A wiring diagram to Basys3 |
| `figures/fig_osiloskop_output.png` | Oscilloscope or audio output evidence |

See **Appendix: Panduan Pengambilan Gambar dan Bukti Pengujian** in the compiled PDF for step-by-step capture instructions for each figure.

## Content:
### Main files
```
|-- thesisdtetiugm.cls (Class file)
|-- main.tex (The template file)
```
### Content directory

This directory and the subdirectories are not compulsory. 
It is arranged in such a way to make it easier in writing.
```
|-- contents/
    |-- nomenclature/
    	|-- nomenclature.tex
    |-- statement/
    	|-- statement.tex
    |-- endorsement/
    	|-- endorsement.pdf
    |-- preface/
    	|-- preface.tex
    |-- abstract/
    	|-- abstract.tex
        |-- intisari.tex
    |-- chapter-1/
    	|-- chapter-1.tex
    |-- chapter-2/
    	|-- chapter-2.tex
        |-- sample-fig.png
    |-- chapter-3/
    	|-- chapter-3.tex
    |-- chapter-4/
    	|-- chapter-4.tex
    |-- chapter-5/
    	|-- chapter-5.tex
    |-- chapter-6/
    	|-- chapter-6.tex
    |-- appendix/
    	|-- appendix.tex
```
### Additional files
```
|-- packages/ (Additional sty files for helping beginner users)
|-- references.bib (Bibtex file)
```
### Sample directory
Only used for template sample.
```
|-- sample/
    |-- logougm.png
    |-- sample_code.m
    |-- scanned-endorsement.jpg
    |-- scanned-statement.jpg
```

## License
MIT License
