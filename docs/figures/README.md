# Diagram Placeholders

This directory holds **source files for diagrams** (draw.io `.drawio`, SVG, etc.)
that are referenced in `docs/implementation-plan.md`.

After exporting to PDF or PNG, copy the output into the corresponding
`contents/chapter-X/` path used by the LaTeX template.

## Pending Diagrams

| File | Description | Export Target |
|------|-------------|---------------|
| `fig-block-diagram-i2s.drawio` | Full system block diagram (MicroBlaze + I2S IP + PCM5102A) | `contents/chapter-3/fig-block-diagram-i2s.pdf` |
| `fig-isr-flow.drawio` | ISR software flow (watermark IRQ → FIFO refill) | `contents/chapter-4/fig-isr-flow.pdf` |

## How to export from draw.io

1. Open `.drawio` file at <https://app.diagrams.net>
2. File → Export As → PDF (for vector) or PNG (for screenshots)
3. Save output to `contents/chapter-X/` with the filename matching the `\includegraphics{}` call in the `.tex` source.
