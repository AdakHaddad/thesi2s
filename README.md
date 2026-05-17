This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.

## DAC: PCM5102A

- **Overview:** The PCM5102A is the DAC module used in this project's hardware development. It accepts I2S audio (BCLK, LRCLK, SDIN) and provides high-quality analog stereo outputs suitable for headphones or line-level inputs.

- **Key features:** 24-bit/192kHz support, built-in low-pass filter, no external I2C configuration required, single-supply analog outputs (typically via coupling capacitors).

- **Connections (typical):**
	- Clock (BCLK): bit clock from I2S master
	- Word select (LRCLK): left/right channel select
	- Serial data (SDIN): I2S audio data
	- VCC / GND: power supply (follow board/module specs)
	- L/R OUT: analog outputs (use output coupling caps and proper grounding)

- **Notes for integration:**
	- Ensure I2S format (left-justified vs. I2S) and bit depth match the transmitter.
	- Use proper decoupling and analog grounding to minimize noise.
	- PCM5102A modules typically do not require firmware configuration—verify wiring and clocking.

- **References:** See the PCM5102A datasheet and module vendor notes for detailed electrical and layout guidance.

### Module diagram (placeholder)

Insert the official PCM5102A module/board diagram from Texas Instruments here manually. If you use the TI datasheet figure, make sure you keep the citation and any usage requirements from the source document.

- **Datasheet (recommended reference):** https://www.ti.com/lit/ds/symlink/pcm5102a.pdf


