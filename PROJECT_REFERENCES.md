Canonical project references
==========================

To avoid stale or conflicting documentation, do not create additional top-level `.md` files describing project structure.

When referencing implementation sources for the I2S project, use these canonical directories:

- Block design (Vivado project): `nobufgmux/`
- I2S IP core: `ip_repo/i2s`
- Testbenches: `testblocks/`
- Application / MicroBlaze code: `micblaze/rtlfix`

If you need a longer explanation or tutorial, add it inside the relevant directory above (for example, `nobufgmux/README.md`), not as a repo-wide context file.

This file intentionally stays short so presentation tooling (e.g. `better-ppt`) and AI assistants do not pick up stale project context.
