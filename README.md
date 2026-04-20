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

## Build Steps (I2S Thesis)

### Prerequisites

- A TeX distribution: [TeX Live](https://www.tug.org/texlive/) (Linux/macOS) or
  [MiKTeX](https://miktex.org/) (Windows), or
  [Overleaf](https://www.overleaf.com) (cloud, no local install needed).
- `latexmk` (included with TeX Live / MiKTeX) for automated multi-pass builds.
- BibTeX for references (`references.bib`).

### Compile with `latexmk` (recommended)

```bash
# From the repository root (where main.tex lives):
latexmk -pdf -bibtex main.tex
```

This runs pdfLaTeX + BibTeX automatically as many times as needed.
Output: `main.pdf` in the same directory.

To clean intermediate files after building:

```bash
latexmk -c
```

### Compile manually (pdfLaTeX + BibTeX)

```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Run `pdflatex` three times so that cross-references, table of contents, and
list of figures are resolved correctly.

### Using Overleaf

1. Zip the entire repository (including `thesisdtetiugm.cls`, `main.tex`, `contents/`, `packages/`, `sample/`, `references.bib`, `pgf-pie.sty`).
2. In Overleaf: **New Project → Upload Project** and upload the zip.
3. Overleaf auto-detects `main.tex` as the entry point; hit **Recompile**.
4. Set **Compiler** to `pdfLaTeX` and **TeX Live version** to 2023 or later
   (Project Settings menu, top-right).

### Adding your figures

Each chapter contains figure **placeholder** blocks (visible as bordered boxes
in the PDF). To replace a placeholder with your actual screenshot or photo:

1. Save your image (PNG or JPG, ≥ 1280×720 px) in the corresponding chapter folder,
   e.g. `contents/chapter-4/fig-ila-capture.png`.
2. In the chapter `.tex` file, find the `\fbox{...}` placeholder block for that figure.
3. Replace the entire `\fbox{\parbox{...}{...}}` with:
   ```latex
   \includegraphics[width=0.85\textwidth]{contents/chapter-4/fig-ila-capture.png}
   ```
4. Recompile.

See **Lampiran: Panduan Pengambilan Gambar** in the compiled PDF for a step-by-step
guide on which screenshots to capture and how.

### Filling in personal information

Before submission, update the following placeholders in `main.tex`:

| Placeholder | What to fill |
|---|---|
| `<<AUTHOR>>` | Your full name |
| `<<NIM>>` | Your student ID number |
| `<<JUDUL SKRIPSI>>` | Thesis title (suggested: *Perancangan Peripheral I2S TX dengan Antarmuka AXI4-Lite Menggunakan Verilog*) |
| `<<Nama Prodi>>` | Study programme name |
| `<<TAHUN PENDADARAN>>` | Year of thesis defence |
| `<<Exam date>>` | Date of thesis defence |
| `Dosen Pembimbing 1 ...` | Supervisor name and NIP |

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
