/*****************************************************************************
* I2S register feature test — all control bits
*
* CONTROL register map:
*   bit[0]    ENABLE       1 = output active
*   bit[1]    MUTE         1 = force zero output
*   bit[2]    FS_FAMILY    0 = 48/96 kHz family, 1 = 44.1/88.2 kHz family
*   bit[3]    FS_MODE      0 = low Fs (48 or 44.1), 1 = high Fs (96 or 88.2)
*   bit[12:8] SAMPLE_WIDTH sample bit width (default 24 if 0)
*
* Fs combination table:
*   FS=0, FS_MODE=0 → 48   kHz
*   FS=1, FS_MODE=0 → 44.1 kHz
*   FS=0, FS_MODE=1 → 96   kHz
*   FS=1, FS_MODE=1 → 88.2 kHz
*****************************************************************************/

#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xuartlite_l.h"

/* Read the RISC-V cycle counter (mcycle CSR) — free-running at CPU clock rate.
 * MicroBlaze RISC-V runs at 100 MHz (XPAR_CPU_CORE_CLOCK_FREQ_HZ).
 * Each tick = 10 ns. */
static inline uint64_t rdcycle64(void)
{
    uint32_t lo, hi, hi2;
    do {
        __asm__ volatile ("rdcycleh %0" : "=r"(hi));
        __asm__ volatile ("rdcycle  %0" : "=r"(lo));
        __asm__ volatile ("rdcycleh %0" : "=r"(hi2));
    } while (hi != hi2);
    return ((uint64_t)hi << 32) | lo;
}

/* ---- Register map ---- */
#define I2S_BASE       XPAR_I2S_0_BASEADDR
#define DATA_LEFT      (I2S_BASE + 0x00U)
#define DATA_RIGHT     (I2S_BASE + 0x04U)
#define CONTROL        (I2S_BASE + 0x08U)

/* ---- Control bits ---- */
#define CTRL_ENABLE          (1U << 0)
#define CTRL_MUTE            (1U << 1)
#define CTRL_FS              (1U << 2)
#define CTRL_FS_MODE         (1U << 3)
#define CTRL_WIDTH(w)        (((uint32_t)(w) & 0x1FU) << 8U)

/* ---- Audio ---- */
#define SAMPLE_RATE    48000U
#define AMPLITUDE      32000   // hampir full scale, dari 22000

/* ---- Sine table ---- */
static const int16_t SINE[32] = {
         0,   6393,  12539,  18204,  23170,  27245,  30273,  32137,
     32767,  32137,  30273,  27245,  23170,  18204,  12539,   6393,
         0,  -6393, -12539, -18204, -23170, -27245, -30273, -32137,
    -32767, -32137, -30273, -27245, -23170, -18204, -12539,  -6393
};

/* ---- State ---- */
static uint32_t g_freq    = 1000U;
static uint8_t  g_left    = 1U;
static uint8_t  g_right   = 1U;
static uint8_t  g_enable  = 1U;
static uint8_t  g_mute    = 0U;
static uint8_t  g_fs      = 0U;   /* 0 = 48/96 kHz family */
static uint8_t  g_fs_mode = 0U;   /* 0 = low Fs           */
static uint8_t  g_width   = 24U;

/* ---- Derived timing ---- */
static uint32_t current_sample_rate(void)
{
    if (!g_fs && !g_fs_mode) return 48000U;
    if ( g_fs && !g_fs_mode) return 44100U;
    if (!g_fs &&  g_fs_mode) return 96000U;
    return 88200U;
}

/* ---- Apply current state to CONTROL register ---- */
static void apply_control(void)
{
    uint32_t ctrl = 0U;
    if (g_enable)  ctrl |= CTRL_ENABLE;
    if (g_mute)    ctrl |= CTRL_MUTE;
    if (g_fs)      ctrl |= CTRL_FS;
    if (g_fs_mode) ctrl |= CTRL_FS_MODE;
    ctrl |= CTRL_WIDTH(g_width);
    Xil_Out32(CONTROL, ctrl);
    xil_printf("CTRL = 0x%08X\r\n", ctrl);
}

/* ---- Print current state ---- */
static void print_state(void)
{
    xil_printf("\r\n=============================\r\n");
    xil_printf(" I2S Register Feature Test\r\n");
    xil_printf("=============================\r\n");
    xil_printf(" Freq        : %lu Hz\r\n",  (unsigned long)g_freq);
    xil_printf(" Channel     : %s\r\n",
               ( g_left &&  g_right) ? "Both"  :
               ( g_left && !g_right) ? "Left"  :
               (!g_left &&  g_right) ? "Right" : "None");
    xil_printf(" ENABLE      : %u\r\n",  g_enable);
    xil_printf(" MUTE        : %u\r\n",  g_mute);
    xil_printf(" FS_FAMILY   : %u (%s)\r\n", g_fs,
               g_fs ? "44.1/88.2 kHz family" : "48/96 kHz family");
    xil_printf(" FS_MODE     : %u (%s)\r\n", g_fs_mode,
               g_fs_mode ? "high Fs" : "low Fs");
    xil_printf(" Fs result   : %s\r\n",
               (!g_fs && !g_fs_mode) ? "48 kHz"   :
               ( g_fs && !g_fs_mode) ? "44.1 kHz" :
               (!g_fs &&  g_fs_mode) ? "96 kHz"   : "88.2 kHz");
    xil_printf(" SAMPLE_WIDTH: %u bit\r\n", g_width);
    xil_printf("-----------------------------\r\n");
    xil_printf(" 1/2/5  = freq 1k/2k/5kHz\r\n");
    xil_printf(" L/R/B  = Left/Right/Both\r\n");
    xil_printf(" E      = toggle ENABLE\r\n");
    xil_printf(" M      = toggle MUTE\r\n");
    xil_printf(" F      = toggle FS family\r\n");
    xil_printf(" O      = toggle FS_MODE\r\n");
    xil_printf(" W      = cycle width 16/24/32\r\n");
    xil_printf(" ?      = show this menu\r\n");
    xil_printf("=============================\r\n");
}

/* ---- Audio sample ---- */
static void stream_sample(void)
{
    static uint32_t phase = 0U;
    uint32_t sr   = current_sample_rate();
    uint32_t step = (uint32_t)(((uint64_t)g_freq << 32) / sr);

    /* Scale 16-bit sine to full AMPLITUDE range */
    int16_t s = (int16_t)(((int32_t)SINE[phase >> 27] * AMPLITUDE) / 32767);

    /*
     * RTL expects the sample MSB at bit [sample_width-1] of the 32-bit word.
     * We have a 16-bit value; shift it so its MSB lands at bit (g_width-1).
     * For g_width=16: no shift. For g_width=24: <<8. For g_width=32: <<16.
     * Arithmetic right-shift for narrower widths preserves sign.
     * No mask needed — the RTL serialiser ignores bits above sample_width-1.
     */
    int32_t s32;
    if (g_width >= 32U) {
        /* True 32-bit: sign-extend the 16-bit sample to fill the word */
        s32 = (int32_t)s << 16;
    } else if (g_width > 16U) {
        s32 = (int32_t)s << (g_width - 16U);
    } else if (g_width < 16U) {
        s32 = (int32_t)s >> (16U - g_width);
    } else {
        s32 = (int32_t)s;
    }
    uint32_t samp = (uint32_t)s32;

    /*
     * Write both channels every frame, even the silent one.
     * The RTL latches DATA_LEFT and DATA_RIGHT together at frame boundary
     * via the CDC write-counter, so both must always be written.
     */
    Xil_Out32(DATA_LEFT,  g_left  ? samp : 0U);
    Xil_Out32(DATA_RIGHT, g_right ? samp : 0U);
    phase += step;
}

/* ---- Handle keypress ---- */
static void handle_key(uint8_t ch)
{
    xil_printf("%c\r\n", ch);
    switch (ch) {

        /* ---- Frequency ---- */
        case '1': g_freq = 1000U; xil_printf(">> 1 kHz\r\n");  break;
        case '2': g_freq = 2000U; xil_printf(">> 2 kHz\r\n");  break;
        case '5': g_freq = 5000U; xil_printf(">> 5 kHz\r\n");  break;

        /* ---- Channel ---- */
        case 'l': case 'L':
            g_left = 1U; g_right = 0U;
            xil_printf(">> Left only\r\n");
            break;
        case 'r': case 'R':
            g_left = 0U; g_right = 1U;
            xil_printf(">> Right only\r\n");
            break;
        case 'b': case 'B':
            g_left = 1U; g_right = 1U;
            xil_printf(">> Both\r\n");
            break;

        /* ---- ENABLE toggle ---- */
        case 'e': case 'E':
            g_enable = !g_enable;
            xil_printf(">> ENABLE = %u\r\n", g_enable);
            apply_control();
            break;

        /* ---- MUTE toggle ---- */
        case 'm': case 'M':
            g_mute = !g_mute;
            xil_printf(">> MUTE = %u (%s)\r\n", g_mute,
                       g_mute ? "silence" : "audio");
            apply_control();
            break;

        /* ---- FS family toggle ---- */
        case 'f': case 'F':
            g_fs = !g_fs;
            xil_printf(">> FS_FAMILY = %u (%s)\r\n", g_fs,
                       g_fs ? "44.1/88.2 kHz family" : "48/96 kHz family");
            apply_control();
            break;

        /* ---- FS_MODE toggle ---- */
        case 'o': case 'O':
            g_fs_mode = !g_fs_mode;
            xil_printf(">> FS_MODE = %u (%s) → Fs = %s\r\n",
                       g_fs_mode,
                       g_fs_mode ? "high Fs" : "low Fs",
                       (!g_fs && !g_fs_mode) ? "48 kHz"   :
                       ( g_fs && !g_fs_mode) ? "44.1 kHz" :
                       (!g_fs &&  g_fs_mode) ? "96 kHz"   : "88.2 kHz");
            apply_control();
            break;

        /* ---- SAMPLE_WIDTH cycle 16 -> 24 -> 32 -> 16 ---- */
        case 'w': case 'W':
            g_width = (g_width == 16U) ? 24U :
                      (g_width == 24U) ? 32U : 16U;
            xil_printf(">> SAMPLE_WIDTH = %u bit\r\n", g_width);
            apply_control();
            break;

        case '?': print_state(); break;

        default:
            xil_printf(">> Unknown key, press ? for menu\r\n");
            break;
    }
}

/* ---- Main ---- */
int main(void)
{
    init_platform();

    xil_printf("\r\n=== I2S RTL FIX DIAGNOSTIC ===\r\n");
    xil_printf("Base Address: 0x%08X\r\n", I2S_BASE);

    // AXI Readback Test using the Reserved register (offset 0x0C)
    // This confirms that the CPU can actually talk to the I2S IP.
    Xil_Out32(I2S_BASE + 0x0CU, 0xDEADBEEF);
    uint32_t rd = Xil_In32(I2S_BASE + 0x0CU);
    xil_printf("AXI Readback Test (Offset 0x0C): 0x%08X - %s\r\n",
               rd, (rd == 0xDEADBEEF) ? "PASS" : "FAIL (Check Address Mapping/SmartConnect)");

    apply_control();
    print_state();

    /*
     * Deadline-based sample loop.
     * usleep(period - constant) drifts when overhead varies (UART read, cache
     * misses, etc.) and at 96 kHz the period is only ~10 µs total — there is no
     * margin to subtract anything.  Instead we track an absolute deadline in
     * CPU cycles and busy-wait until the hardware cycle counter reaches it.
     * This gives sample-accurate timing regardless of per-loop overhead.
     *
     * rdcycle64() reads the RISC-V mcycle CSR at CPU clock rate (100 MHz).
     * period_cycles = 100_000_000 / sample_rate
     *   48 kHz → 2083 cycles (~20.83 µs)
     *   96 kHz → 1041 cycles (~10.41 µs)
     */
    uint64_t t_deadline = rdcycle64();

    while (1) {
        uint32_t sample_rate   = current_sample_rate();
        uint64_t period_cycles = (uint64_t)XPAR_CPU_CORE_CLOCK_FREQ_HZ / sample_rate;

        stream_sample();

        if (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
            handle_key((uint8_t)XUartLite_RecvByte(STDIN_BASEADDRESS));

        /* Advance deadline by exactly one sample period */
        t_deadline += period_cycles;

        /* Busy-wait until the deadline — no sleep() rounding error */
        while (rdcycle64() < t_deadline) {}
    }

    cleanup_platform();
    return 0;
}