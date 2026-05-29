/*****************************************************************************
* I2S DDS Feature Test — with internal hardware signal generator
*
* CONTROL register map (matches RTL, do not add bits):
*   bit[0]    ENABLE       1 = output active
*   bit[1]    MUTE         1 = force zero output (HW: clocks continue)
*   bit[2]    FS_FAMILY    0 = 48/96 kHz family, 1 = 44.1/88.2 kHz family
*   bit[3]    FS_MODE      0 = low Fs (48 or 44.1), 1 = high Fs (96 or 88.2)
*   bit[7:4]  RESERVED     Write ignored
*   bit[12:8] SAMPLE_WIDTH payload bits per slot (0 defaults to 32 in RTL)
*   bit[28:13] DDS_FREQ    DDS frequency in Hz (0-65535)
*   bit[29]   RESERVED
*   bit[30]   DDS_MODE     0 = Sine, 1 = Square
*   bit[31]   DDS_ENABLE   1 = HW DDS, 0 = use AXI DATA registers
*
* Channel routing (L/R/B) is FIRMWARE-ONLY — no new register bits used.
*   SW mode  : zero the silent DATA_LEFT or DATA_RIGHT register directly.
*   HW DDS   : IP sends same sample to both channels. To silence one side,
*              firmware continuously writes 0 to that DATA register every
*              frame (the HW latches DATA regs at frame start, so this wins).
*****************************************************************************/

#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xuartlite_l.h"
#include <ctype.h>

/* Read the RISC-V cycle counter (mcycle CSR) */
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
#if defined(XPAR_I2S_DDS_0_BASEADDR)
#define I2S_BASE       XPAR_I2S_DDS_0_BASEADDR
#elif defined(XPAR_I2S_0_BASEADDR)
#define I2S_BASE       XPAR_I2S_0_BASEADDR
#else
#error "Cannot find I2S DDS base address in xparameters.h"
#endif
/* ---- Register map ---- */
#define DATA_LEFT      (I2S_BASE + 0x00U)
#define DATA_RIGHT     (I2S_BASE + 0x04U)
#define CONTROL        (I2S_BASE + 0x08U)

/* ---- Control bits (RTL-exact, no extra bits) ---- */
#define CTRL_ENABLE          (1U << 0)
#define CTRL_MUTE            (1U << 1)
#define CTRL_FS              (1U << 2)
#define CTRL_FS_MODE         (1U << 3)
/* bits 7:4 reserved — never write */
#define CTRL_WIDTH(w)        (((uint32_t)(w) & 0x1FU) << 8U)
#define CTRL_DDS_FREQ(f)     (((uint32_t)(f) & 0xFFFFU) << 13U)
/* bit 29 reserved */
#define CTRL_DDS_MODE        (1U << 30)
#define CTRL_DDS_ENABLE      (1U << 31)

/* ---- Audio ---- */
#define AMPLITUDE      32000

/* Channel routing — firmware-only, no register bits consumed */
typedef enum { CH_BOTH = 0, CH_LEFT = 1, CH_RIGHT = 2 } ch_route_t;

/* ---- Sine table (software fallback) ---- */
static const int16_t SINE[32] = {
         0,   6393,  12539,  18204,  23170,  27245,  30273,  32137,
     32767,  32137,  30273,  27245,  23170,  18204,  12539,   6393,
         0,  -6393, -12539, -18204, -23170, -27245, -30273, -32137,
    -32767, -32137, -30273, -27245, -23170, -18204, -12539,  -6393
};

/* ---- Deadline (SW sample timer) — reset when entering SW mode ---- */
static uint64_t g_sw_deadline = 0U;

/* ---- State ---- */
static uint32_t   g_freq       = 1000U;
static uint8_t    g_enable     = 1U;
static uint8_t    g_mute       = 0U;
static uint8_t    g_fs         = 0U;
static uint8_t    g_fs_mode    = 0U;
static uint8_t    g_width      = 24U;
static uint8_t    g_dds_en     = 1U;
static uint8_t    g_dds_mode   = 0U;
static uint16_t   g_dds_freq   = 1000U;
static ch_route_t g_channel    = CH_BOTH;

/* ---- Derived timing ---- */
static uint32_t current_sample_rate(void)
{
    if (!g_fs && !g_fs_mode) return 48000U;
    if ( g_fs && !g_fs_mode) return 44100U;
    if (!g_fs &&  g_fs_mode) return 96000U;
    return 88200U;
}

/* ---- Apply CONTROL register (no extra bits, RTL-safe) ---- */
static void apply_control(void)
{
    uint32_t ctrl = 0U;
    if (g_enable)   ctrl |= CTRL_ENABLE;
    if (g_mute)     ctrl |= CTRL_MUTE;
    if (g_fs)       ctrl |= CTRL_FS;
    if (g_fs_mode)  ctrl |= CTRL_FS_MODE;
    if (g_dds_en)   ctrl |= CTRL_DDS_ENABLE;
    if (g_dds_mode) ctrl |= CTRL_DDS_MODE;
    ctrl |= CTRL_WIDTH(g_width);
    ctrl |= CTRL_DDS_FREQ(g_dds_freq);
    Xil_Out32(CONTROL, ctrl);
    xil_printf("   CTRL = 0x%08X\r\n", ctrl);
}

/* ---- Apply channel routing to DATA registers ----
 *
 * In SW mode this is called once per sample (stream_sample handles it).
 * In HW DDS mode this is called periodically from the main loop so that
 * the IP latches 0 on the silent channel at the next frame boundary.
 * MUTE and ENABLE are checked here too — they are HW-gated in the IP,
 * but writing 0 explicitly does no harm and makes the state consistent.
 */
static void apply_channel_route(uint32_t sample)
{
    uint32_t out_l = sample;
    uint32_t out_r = sample;

    if (!g_enable || g_mute) {
        out_l = 0U;
        out_r = 0U;
    } else {
        if (g_channel == CH_RIGHT) out_l = 0U;
        if (g_channel == CH_LEFT)  out_r = 0U;
    }

    Xil_Out32(DATA_LEFT,  out_l);
    Xil_Out32(DATA_RIGHT, out_r);
}

/* ---- Setter helpers (print → apply) ---- */
static void set_enable(uint8_t v)
{
    g_enable = v;
    xil_printf(">> %-14s = %u\r\n", "ENABLE", (unsigned)g_enable);
    apply_control();
}

static void set_mute(uint8_t v)
{
    g_mute = v;
    xil_printf(">> %-14s = %s\r\n", "MUTE", g_mute ? "1 (Silence)" : "0 (Audio)");
    apply_control();
}

static void set_dds_en(uint8_t v)
{
    g_dds_en = v;
    xil_printf(">> %-14s = %s\r\n", "DDS ENABLE", g_dds_en ? "1 (HW)" : "0 (SW)");
    if (!g_dds_en)
        g_sw_deadline = rdcycle64();   /* snap deadline — prevents freeze on mode switch */
    apply_control();
}

static void set_dds_mode(uint8_t v)
{
    g_dds_mode = v;
    xil_printf(">> %-14s = %s\r\n", "DDS MODE", g_dds_mode ? "1 (Square)" : "0 (Sine)");
    apply_control();
}

static void set_channel(ch_route_t ch)
{
    g_channel = ch;
    const char *s = (ch == CH_LEFT)  ? "Left only"
                  : (ch == CH_RIGHT) ? "Right only"
                  : "Both";
    xil_printf(">> %-14s = %s\r\n", "CHANNEL", s);
    /* No CONTROL register change — routing is data-register only */
    if (g_dds_en) {
        /* Immediately push 0 to silent channel so next HW latch picks it up */
        apply_channel_route(0U);
    }
}

static void set_width(uint8_t w)
{
    g_width = w;
    xil_printf(">> %-14s = %u bit\r\n", "SAMPLE WIDTH", (unsigned)w);
    apply_control();
}

static void set_dds_freq(uint16_t f)
{
    g_dds_freq = f;
    g_freq     = (uint32_t)f;
    xil_printf(">> %-14s = %u Hz\r\n", "DDS FREQ", (unsigned)f);
    apply_control();
}

/* ---- Print state / help ---- */
static void print_state(void)
{
    const char *ch_str = (g_channel == CH_LEFT)  ? "Left only"
                       : (g_channel == CH_RIGHT) ? "Right only"
                       : "Both";
    xil_printf("\r\n=============================\r\n");
    xil_printf("  I2S + DDS Feature Test\r\n");
    xil_printf("=============================\r\n");
    xil_printf(">> %-14s = %u\r\n",   "DDS ENABLE",    (unsigned)g_dds_en);
    xil_printf(">> %-14s = %s\r\n",   "DDS MODE",      g_dds_mode ? "Square" : "Sine");
    xil_printf(">> %-14s = %u Hz\r\n","DDS FREQ",      (unsigned)g_dds_freq);
    xil_printf(">> %-14s = %u\r\n",   "ENABLE",        (unsigned)g_enable);
    xil_printf(">> %-14s = %s\r\n",   "MUTE",          g_mute ? "1 (Silence)" : "0 (Audio)");
    xil_printf(">> %-14s = %s\r\n",   "CHANNEL",       ch_str);
    xil_printf(">> %-14s = %u bit\r\n","SAMPLE WIDTH", (unsigned)g_width);
    xil_printf(">> %-14s = %u Hz\r\n","Fs",            (unsigned)current_sample_rate());
    xil_printf("-----------------------------\r\n");
    xil_printf(" D      toggle DDS ON/OFF\r\n");
    xil_printf(" S      toggle Sine/Square\r\n");
    xil_printf(" +/-    DDS Freq +100/-100 Hz\r\n");
    xil_printf(" */_    DDS Freq +1k/-1k Hz\r\n");
    xil_printf(" 1/2/5  Freq preset 1k/2k/5kHz\r\n");
    xil_printf(" E      toggle ENABLE\r\n");
    xil_printf(" M      toggle MUTE\r\n");
    xil_printf(" L      Left only\r\n");
    xil_printf(" R      Right only\r\n");
    xil_printf(" B      Both channels\r\n");
    xil_printf(" F      toggle Fs family\r\n");
    xil_printf(" O      toggle Fs mode\r\n");
    xil_printf(" W      cycle width 16/24/32\r\n");
    xil_printf(" ?      show this menu\r\n");
    xil_printf("=============================\r\n");
}

/* ---- Software stream_sample (SW DDS path only) ---- */
static void stream_sample(void)
{
    static uint32_t phase = 0U;
    uint32_t sr   = current_sample_rate();
    uint32_t step = (uint32_t)(((uint64_t)g_freq << 32) / sr);

    int16_t s = (int16_t)(((int32_t)SINE[phase >> 27] * AMPLITUDE) / 32767);
    int32_t s32;
    if      (g_width >= 32U) s32 = (int32_t)s << 16;
    else if (g_width > 16U)  s32 = (int32_t)s << (g_width - 16U);
    else if (g_width < 16U)  s32 = (int32_t)s >> (16U - g_width);
    else                     s32 = (int32_t)s;

    apply_channel_route((uint32_t)s32);
    phase += step;
}

/* ---- Handle keypress ---- */
static inline uint16_t clamp_u16(uint32_t v)
{
    return (uint16_t)(v > 0xFFFFU ? 0xFFFFU : v);
}

static void handle_key(uint8_t ch)
{
    uint8_t lower = (uint8_t)tolower((int)ch);
    xil_printf("%c\r\n", (char)ch);

    switch (lower) {
        /* DDS controls */
        case 'd': set_dds_en(!g_dds_en);     break;
        case 's': set_dds_mode(!g_dds_mode); break;

        case '+': case '=':
            set_dds_freq(clamp_u16((uint32_t)g_dds_freq + 100U));
            break;
        case '-':
            set_dds_freq((uint16_t)(g_dds_freq > 100U ? g_dds_freq - 100U : 0U));
            break;
        case '*':
            set_dds_freq(clamp_u16((uint32_t)g_dds_freq + 1000U));
            break;
        case '_':
            set_dds_freq((uint16_t)(g_dds_freq > 1000U ? g_dds_freq - 1000U : 0U));
            break;

        case '1': set_dds_freq(1000U); break;
        case '2': set_dds_freq(2000U); break;
        case '5': set_dds_freq(5000U); break;

        /* Output controls — always apply even with HW DDS active */
        case 'e': set_enable(!g_enable); break;
        case 'm': set_mute(!g_mute);     break;

        /* Channel routing — firmware-only, no CTRL register change */
        case 'l': set_channel(CH_LEFT);  break;
        case 'r': set_channel(CH_RIGHT); break;
        case 'b': set_channel(CH_BOTH);  break;

        /* Fs / width */
        case 'f':
            g_fs = !g_fs;
            xil_printf(">> %-14s = %s\r\n", "Fs FAMILY",
                       g_fs ? "44.1k/88.2k" : "48k/96k");
            apply_control();
            break;
        case 'o':
            g_fs_mode = !g_fs_mode;
            xil_printf(">> %-14s = %s\r\n", "Fs MODE",
                       g_fs_mode ? "Double" : "Standard");
            apply_control();
            break;
        case 'w':
            set_width((g_width == 16U) ? 24U : (g_width == 24U) ? 32U : 16U);
            break;

        case '?': print_state(); return;
        default:  return;
    }
}

int main(void)
{
    init_platform();
    xil_printf("\r\n=== I2S + DDS Hardware Generator ===\r\n");

    apply_control();
    print_state();

    g_sw_deadline = rdcycle64();   /* initialise before first SW sample */

    while (1) {
        /* ---- SW DDS path: timed sample loop ---- */
        if (!g_dds_en) {
            uint32_t sr            = current_sample_rate();
            uint64_t period_cycles = (uint64_t)XPAR_CPU_CORE_CLOCK_FREQ_HZ / sr;

            /* If deadline is stale (just switched from HW DDS, or first entry),
               snap it to now so the wait loop doesn't block for millions of cycles. */
            uint64_t now = rdcycle64();
            if (g_sw_deadline < now)
                g_sw_deadline = now;

            stream_sample();
            g_sw_deadline += period_cycles;
            while (rdcycle64() < g_sw_deadline) {
                /* poll UART inside the wait so keypresses aren't missed */
                if (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
                    handle_key((uint8_t)XUartLite_RecvByte(STDIN_BASEADDRESS));
            }
        } else {
            /* ---- HW DDS path ----
             *
             * Channel routing: if not CH_BOTH, keep writing 0 to the silent
             * DATA register so the IP latches 0 at the next frame boundary.
             * The IP latches DATA regs at bit_count=0 (falling BCLK), so
             * writing once per ~Fs period is more than sufficient.
             * At 48 kHz with a 100 MHz AXI clock that is ~2083 cycles.
             */
            if (g_channel != CH_BOTH || !g_enable || g_mute) {
                apply_channel_route(0U);   /* 0 = placeholder; routing logic inside */
            }

            /* Small delay to avoid hammering the bus */
            for (volatile int i = 0; i < 1000; i++);

            /* UART poll */
            if (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
                handle_key((uint8_t)XUartLite_RecvByte(STDIN_BASEADDRESS));
        }
    }

    cleanup_platform();
    return 0;
}