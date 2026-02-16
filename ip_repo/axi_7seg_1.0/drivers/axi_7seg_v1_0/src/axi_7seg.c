
#include "axi_7seg.h"

XStatus AXI_7SEG_SelfTest(void *baseaddr_p)
{
    u32 baseaddr = (u32)(UINTPTR)baseaddr_p;

    /* Write test pattern */
    AXI_7SEG_mWriteReg(baseaddr, AXI_7SEG_DATA_OFFSET, 0x1234);

    /* Read back and verify */
    if (AXI_7SEG_mReadReg(baseaddr, AXI_7SEG_DATA_OFFSET) != 0x1234)
        return XST_FAILURE;

    /* Clear */
    AXI_7SEG_mWriteReg(baseaddr, AXI_7SEG_DATA_OFFSET, 0);

    return XST_SUCCESS;
}
