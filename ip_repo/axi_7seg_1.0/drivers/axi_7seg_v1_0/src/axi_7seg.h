
#ifndef AXI_7SEG_H
#define AXI_7SEG_H

#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

/* Register offsets */
#define AXI_7SEG_DATA_OFFSET  0x00  /* Hex display value [15:0] */
#define AXI_7SEG_CTRL_OFFSET  0x04  /* bit0=enable, bits[7:4]=dp select */

/* Helper macros */
#define AXI_7SEG_mWriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

#define AXI_7SEG_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/* Enable display */
#define AXI_7SEG_Enable(BaseAddress) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) | 0x01)

/* Disable display */
#define AXI_7SEG_Disable(BaseAddress) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) & ~0x01)

/* Set hex value (4 digits, e.g. 0x1234 shows "1234") */
#define AXI_7SEG_SetHex(BaseAddress, Value) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_DATA_OFFSET, (Value) & 0xFFFF)

/* Set decimal points (bit0=AN0, bit1=AN1, bit2=AN2, bit3=AN3) */
#define AXI_7SEG_SetDP(BaseAddress, DpMask) \
    AXI_7SEG_mWriteReg(BaseAddress, AXI_7SEG_CTRL_OFFSET, \
        (AXI_7SEG_mReadReg(BaseAddress, AXI_7SEG_CTRL_OFFSET) & 0x0F) | (((DpMask) & 0x0F) << 4))

/* Self-test */
XStatus AXI_7SEG_SelfTest(void *baseaddr_p);

#endif /* AXI_7SEG_H */
