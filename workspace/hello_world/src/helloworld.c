/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * I2S diagnostic style similar to ESP test:
 * - startup register check
 * - continuous tone generation
 * - periodic runtime status
 */

#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "sleep.h"

#define I2S_BASE  XPAR_I2S_0_BASEADDR
#define I2S_REG0  (I2S_BASE + 0x00U)

#define SAMPLE_RATE_HZ 48000U
#define TONE_FREQ_HZ   1000U
#define TONE_AMPLITUDE 28000

int main()
{
    u32 rd = 0;
    u32 sample_count = 0;
    u32 half_period = SAMPLE_RATE_HZ / (2U * TONE_FREQ_HZ);
    u32 phase_count = 0;
    int16_t s = TONE_AMPLITUDE;
    u32 mode = 0; /* 0: Left only, 1: Right only, 2: Both */
    init_platform();

    xil_printf("\r\n=== I2S DIAGNOSTIC ===\r\n");
    xil_printf("UART expected baud: 115200\r\n");
    xil_printf("Base: 0x%08X\r\n", I2S_BASE);
    xil_printf("Tone: %lu Hz, Fs=%lu, amp=%d\r\n",
               (unsigned long)TONE_FREQ_HZ, (unsigned long)SAMPLE_RATE_HZ, TONE_AMPLITUDE);
    xil_printf("Check scope on JA: J2=LRCK, L2=BCLK, G2=DATA\r\n");

    xil_printf("\r\n[TEST] I2S REG0 readback\r\n");
    Xil_Out32(I2S_REG0, 0x7FFF7FFFU);
    rd = Xil_In32(I2S_REG0);
    xil_printf("REG0 write 0x7FFF7FFF read 0x%08X %s\r\n",
               rd, (rd == 0x7FFF7FFFU) ? "OK" : "FAIL");

    xil_printf("Streaming square tone continuously...\r\n");
    xil_printf("Channel mode rotates every 2s: LEFT -> RIGHT -> BOTH\r\n");

    while (1) {
        for (u32 n = 0; n < 256; n++) {
            if (phase_count >= half_period) {
                phase_count = 0;
                s = (s > 0) ? -TONE_AMPLITUDE : TONE_AMPLITUDE;
            }
            int16_t left = 0;
            int16_t right = 0;
            if (mode == 0) {
                left = s;
            } else if (mode == 1) {
                right = s;
            } else {
                left = s;
                right = s;
            }
            u32 packed = (((u32)(uint16_t)left) << 16) | ((uint16_t)right);
            Xil_Out32(I2S_REG0, packed);
            phase_count++;
            sample_count++;
        }

        if ((sample_count % (2U * SAMPLE_RATE_HZ)) == 0U) {
            mode = (mode + 1U) % 3U;
            xil_printf("[I2S] mode=%s, samples=%lu\r\n",
                       (mode == 0U) ? "LEFT" : ((mode == 1U) ? "RIGHT" : "BOTH"),
                       (unsigned long)sample_count);
        }
    }

    cleanup_platform();
    return 0;
}
