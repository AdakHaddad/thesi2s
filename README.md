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

### Peripheral I2S specification
```
|-- docs/
    |-- spec-outline.md  (Outline spesifikasi peripheral I2S-only AXI4-Lite — bahasa Indonesia)
```

Dokumen `docs/spec-outline.md` memuat ruang lingkup, peta register, parameter clocking, perilaku FIFO/interrupt, model interaksi software (Vitis ISR), dan checklist verifikasi untuk peripheral I2S yang diimplementasikan pada Basys3 (audio_clk = 24.56897 MHz, stereo, 24-bit dalam 32-bit slot, ~48 kHz / ~96 kHz).
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
