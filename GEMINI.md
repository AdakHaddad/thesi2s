# Project Instructions (GEMINI.md)

## Communication & Documentation Constraints
- **Do not mention specific Vivado project names in text**: Avoid mentioning local project names in documentation text. Refer to the "GitHub repository" or "project repository" instead.
- **Source of Truth Directories**:
    - **IP Core**: `ip_repo/i2s`
    - **Block Design**: the Vivado block design directory
    - **Testbench**: `testblocks/`
    - **Application Code**: `micblaze/rtlfix`
- **False Context Mitigation**: Root `.md` files (except READMEs) have been removed to prevent reading outdated information. Always refer to the directories above for the latest implementation details.
