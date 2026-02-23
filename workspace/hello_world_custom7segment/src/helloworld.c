/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"

#define AXI_7SEG_BASE  0x44A10000
#define AXI_7SEG_DATA  (AXI_7SEG_BASE + 0x00)
#define AXI_7SEG_CTRL  (AXI_7SEG_BASE + 0x04)

int main()
{
    init_platform();

    print("Hello World - Display 7 Segment by Agus Bejo\n\r");
    print("Successfully ran Hello World application\n\r");

    Xil_Out32(AXI_7SEG_CTRL, 0x01);

    u32 counter = 0;

    while(1) {
        Xil_Out32(AXI_7SEG_DATA, counter % 10); 

        counter++;
        sleep(1);
    }
    
    cleanup_platform();
    return 0;
}