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

## Build Instructions

### Requirements
- TeX distribution: [TeX Live](https://www.tug.org/texlive/) (Linux/macOS) or [MiKTeX](https://miktex.org/) (Windows)
- Required packages: `babel`, `graphicx`, `booktabs`, `longtable`, `float`, `hyperref`, `caption`, `setspace`, `geometry`, `titlesec`, `tocloft`, `nomencl`, `listings`, `xcolor`
  - All packages are bundled in TeX Live full or can be copied from the `packages/` directory.

### Compile (manual)
Run the following commands from the repository root (same directory as `main.tex`):

```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

The final PDF will be generated as `main.pdf`.

### Adding figures (placeholder replacement)
Figure placeholders are present in `contents/chapter-3/` and `contents/chapter-4/`.
To replace a placeholder with an actual figure:
1. Save the figure to `contents/figures/<filename>` (see `contents/figures/README.md`).
2. In the relevant `.tex` file, remove the `\fbox{...}` placeholder block.
3. Uncomment the `\includegraphics[...]{contents/figures/<filename>}` line above it.
4. Recompile with the sequence above.

See `contents/appendix/appendix-panduan-capture.tex` for step-by-step capture instructions
for each required figure (Clocking Wizard, ILA waveform, simulation waveform, audio proof).

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
