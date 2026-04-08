/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * I2S maximum-volume square wave test.
 * Outputs a ~750 Hz square wave at full scale on both channels.
 * If you can't hear this, the problem is hardware/wiring, not volume.
 */

#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "sleep.h"

#define I2S_BASE  XPAR_I2S_0_BASEADDR
#define I2S_REG0  (I2S_BASE + 0x00U)

/* Full-scale samples: loudest possible */
#define FULL_POS  0x7FFF7FFFU   /* +32767 on both L and R */
#define FULL_NEG  0x80008000U   /* -32768 on both L and R */

int main()
{
    init_platform();

    xil_printf("\r\n=== I2S SQUARE WAVE TEST ===\r\n");
    xil_printf("Base: 0x%08X\r\n", I2S_BASE);
    xil_printf("Check scope on JA: J1=MCLK, L2=BCLK, J2=WS, G2=DATA\r\n");

    /* First: blast a DC value to confirm AXI writes work */
    xil_printf("Writing DC full-scale for 2 seconds...\r\n");
    Xil_Out32(I2S_REG0, FULL_POS);
    sleep(2);

    /* Now: full-scale square wave, ~750 Hz */
    xil_printf("Starting square wave - LISTEN NOW\r\n");

    while (1) {
        Xil_Out32(I2S_REG0, FULL_POS);
        for (volatile int i = 0; i < 320; i++);

        Xil_Out32(I2S_REG0, FULL_NEG);
        for (volatile int i = 0; i < 320; i++);
    }

    cleanup_platform();
    return 0;
}
