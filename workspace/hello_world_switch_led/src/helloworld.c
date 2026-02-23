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
#define GPIO_BASE_ADDR_SWITCH XPAR_AXI_GPIO_0_BASEADDR
#define GPIO_BASE_ADDR_LED (XPAR_AXI_GPIO_0_BASEADDR + 0x08)

int main()
{
    init_platform();

    print("Hello World. Edited by Agus Bejo\n\r");
    print("Successfully ran Hello World application");
    while(1){
        u32 sw_data=Xil_In32(GPIO_BASE_ADDR_SWITCH);
        xil_printf("switch data = %X\n", sw_data);
        Xil_Out32(GPIO_BASE_ADDR_LED,sw_data);
    sleep(1);
    }
    cleanup_platform();
    return 0;
}

