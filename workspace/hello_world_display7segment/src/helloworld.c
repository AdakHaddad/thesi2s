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

// Define GPIO Base Addresses (Matches AXI GPIO 1 in Vivado)
#define GPIO_BASE_ADDR_SEG XPAR_AXI_GPIO_1_BASEADDR
#define GPIO_BASE_ADDR_AN (XPAR_AXI_GPIO_1_BASEADDR + 0x08)

// Segment patterns for digits 0-9 (Common Anode: 0 turns segment ON)
u32 segment_patterns[] = {
    0b11000000, // 0
    0b11111001, // 1
    0b10100100, // 2
    0b10110000, // 3
    0b10011001, // 4
    0b10010010, // 5
    0b10000010, // 6
    0b11111000, // 7
    0b10000000, // 8
    0b10010000  // 9
};

int main()
{
    init_platform();

    print("Hello World - Display 7 Segment by Agus Bejo\n\r");
    print("Successfully ran Hello World application\n\r");

    u32 counter = 0;

    while(1) {
        int idx = counter % 10;

        // Get the 7-segment pattern for the current counter digit
        u32 seg_data = segment_patterns[idx];

        // Set Anode (Active Low). 0xE = 1110 (Enables the rightmost digit)
        u32 an_data = 0xE;

        // Write to Hardware
        Xil_Out32(GPIO_BASE_ADDR_SEG, seg_data);
        Xil_Out32(GPIO_BASE_ADDR_AN, an_data);

        counter++;
        sleep(1);
    }

    cleanup_platform();
    return 0;
}
