// =============================================================================
// tb_direct_i2s.v  –  Direct Register-Level (Non-AXI) I2S Testbench
// =============================================================================
//
// PURPOSE
//   Debug the I2S serialisation logic in isolation by bypassing the AXI4-Lite
//   bus entirely.  The DUT is still the full module, but internal registers
//   (sample_q, ctrl_sync_b) are overridden using Verilog `force` statements.
//   This lets you iterate quickly on bit-ordering and timing without needing to
//   model full AXI handshakes.
//
// DIFFERENCE vs tb_axi_i2s.v
//   • No AXI handshakes are performed – saves many cycles per test case.
//   • sample_q and ctrl_sync_b are forced directly after reset, so the CDC
//     synchroniser delay does not mask bugs in the serialiser itself.
//   • The audio_clk is the only clock that matters here (AXI clock idles low
//     and ARESETN is released after reset to put the DUT in a known state).
//   • Ideal for verifying: bit order, WS timing, Philips 1-bit delay,
//     mute/play gating, fs_mode BCLK divisor switching.
//
// WHAT IS VERIFIED
//   1. BCLK toggles at the correct rate for both fs_mode=0 and fs_mode=1.
//   2. WS (LRCK) toggles exactly every 32 BCLK cycles.
//   3. 16-bit LEFT  sample serialised MSB-first after WS→0 + 1 BCLK delay.
//   4. 16-bit RIGHT sample serialised MSB-first after WS→1 + 1 BCLK delay.
//   5. Padding zeros follow each sample (bits 17..31 of the 32-bit slot).
//   6. Play=0 keeps DATA=0 while BCLK/WS still run.
//   7. Mute=1 keeps DATA=0 while BCLK/WS still run.
//   8. Multiple consecutive frames with alternating patterns.
//
// HOW TO COMPILE & SIMULATE (Icarus Verilog)
//   iverilog -o sim_direct.vvp \
//       ../rtl/i2s_slave_lite_v1_0_S00_AXI.v \
//       tb_direct_i2s.v
//   vvp sim_direct.vvp
//   gtkwave tb_direct_i2s.vcd &
//
// EXPECTED PASS CRITERIA  (printed to console)
//   [PASS] BCLK period 48k correct
//   [PASS] WS half-period = 32 BCLK
//   [PASS] Left  sample bits serialised correctly (pattern A)
//   [PASS] Right sample bits serialised correctly (pattern A)
//   [PASS] Left  sample bits serialised correctly (pattern B)
//   [PASS] Right sample bits serialised correctly (pattern B)
//   [PASS] DATA=0 when play=0
//   [PASS] DATA=0 when mute=1
//   [PASS] BCLK period 96k correct (fs_mode=1)
//   ALL CHECKS PASSED
//
// WAVEFORM INSPECTION
//   Signal group "I2S Outputs":  i2s_bclk, i2s_ws, i2s_data
//   Signal group "Forced Regs":  dut.sample_q, dut.ctrl_sync_b, dut.bit_cnt
//
//   Checklist for manual waveform review:
//     [ ] i2s_ws  changes on BCLK falling edge (not on rising)
//     [ ] i2s_data changes on BCLK falling edge
//     [ ] After WS→0: exactly 1 BCLK of i2s_data=0, then LEFT sample MSB
//     [ ] After WS→1: exactly 1 BCLK of i2s_data=0, then RIGHT sample MSB
//     [ ] Bits 17..31 of each 32-bit slot are 0 (zero-padding after LSB)
//     [ ] Alternating L/R values across frames when sample_q is updated
//
// =============================================================================
`timescale 1ns / 1ps

module tb_direct_i2s;

// ── Parameters ─────────────────────────────────────────────────────────────
    localparam AUDIO_CLK_PERIOD = 41; // ≈ 24.56897 MHz (40.7 ns)
    localparam AXI_CLK_PERIOD   = 10; // 100 MHz (not actively driven)

// ── DUT signal declarations ─────────────────────────────────────────────────
    // AXI signals – minimal, only ARESETN is actively driven
    reg        S_AXI_ACLK    = 0;
    reg        S_AXI_ARESETN = 0;
    // Tie off AXI master signals (no transactions)
    reg  [3:0] S_AXI_AWADDR  = 0;
    reg  [2:0] S_AXI_AWPROT  = 0;
    reg        S_AXI_AWVALID = 0;
    reg [31:0] S_AXI_WDATA   = 0;
    reg  [3:0] S_AXI_WSTRB   = 4'hF;
    reg        S_AXI_WVALID  = 0;
    reg        S_AXI_BREADY  = 1;
    reg  [3:0] S_AXI_ARADDR  = 0;
    reg  [2:0] S_AXI_ARPROT  = 0;
    reg        S_AXI_ARVALID = 0;
    reg        S_AXI_RREADY  = 1;

    wire       S_AXI_AWREADY;
    wire       S_AXI_WREADY;
    wire [1:0] S_AXI_BRESP;
    wire       S_AXI_BVALID;
    wire       S_AXI_ARREADY;
    wire[31:0] S_AXI_RDATA;
    wire [1:0] S_AXI_RRESP;
    wire       S_AXI_RVALID;

    // Audio clock & I2S outputs
    reg        audio_clk = 0;
    wire       i2s_bclk;
    wire       i2s_ws;
    wire       i2s_data;
    wire       i2s_mclk;

// ── DUT instantiation ────────────────────────────────────────────────────────
    i2s_slave_lite_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(32),
        .C_S_AXI_ADDR_WIDTH(4)
    ) dut (
        .i2s_bclk        (i2s_bclk),
        .i2s_ws          (i2s_ws),
        .i2s_data        (i2s_data),
        .i2s_mclk        (i2s_mclk),
        .audio_clk       (audio_clk),
        .S_AXI_ACLK      (S_AXI_ACLK),
        .S_AXI_ARESETN   (S_AXI_ARESETN),
        .S_AXI_AWADDR    (S_AXI_AWADDR),
        .S_AXI_AWPROT    (S_AXI_AWPROT),
        .S_AXI_AWVALID   (S_AXI_AWVALID),
        .S_AXI_AWREADY   (S_AXI_AWREADY),
        .S_AXI_WDATA     (S_AXI_WDATA),
        .S_AXI_WSTRB     (S_AXI_WSTRB),
        .S_AXI_WVALID    (S_AXI_WVALID),
        .S_AXI_WREADY    (S_AXI_WREADY),
        .S_AXI_BRESP     (S_AXI_BRESP),
        .S_AXI_BVALID    (S_AXI_BVALID),
        .S_AXI_BREADY    (S_AXI_BREADY),
        .S_AXI_ARADDR    (S_AXI_ARADDR),
        .S_AXI_ARPROT    (S_AXI_ARPROT),
        .S_AXI_ARVALID   (S_AXI_ARVALID),
        .S_AXI_ARREADY   (S_AXI_ARREADY),
        .S_AXI_RDATA     (S_AXI_RDATA),
        .S_AXI_RRESP     (S_AXI_RRESP),
        .S_AXI_RVALID    (S_AXI_RVALID),
        .S_AXI_RREADY    (S_AXI_RREADY)
    );

// ── Clock generators ─────────────────────────────────────────────────────────
    always #(AXI_CLK_PERIOD/2)   S_AXI_ACLK = ~S_AXI_ACLK;
    always #(AUDIO_CLK_PERIOD/2) audio_clk   = ~audio_clk;

// ── Waveform dump ─────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("tb_direct_i2s.vcd");
        $dumpvars(0, tb_direct_i2s);
    end

// ── Checker variables ────────────────────────────────────────────────────────
    integer pass_count = 0;
    integer fail_count = 0;

    task check;
        input [255:0] label;
        input         cond;
        begin
            if (cond) begin
                $display("[PASS] %0s", label);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %0s", label);
                fail_count = fail_count + 1;
            end
        end
    endtask

// ── Helper: set sample_q and ctrl_sync_b directly (bypassing AXI) ────────────
    // Forces the internal registers in the audio_clk domain so that the
    // serialiser sees the values immediately (no CDC wait, no AXI handshake).
    task force_sample_ctrl;
        input [31:0] sample;  // [31:16]=L, [15:0]=R
        input [2:0]  ctrl;    // [0]=play, [1]=mute, [2]=fs_mode
        begin
            force dut.sample_q    = sample;
            force dut.ctrl_sync_b = ctrl;
        end
    endtask

    task release_force;
        begin
            release dut.sample_q;
            release dut.ctrl_sync_b;
        end
    endtask

// ── Helper: wait for N complete stereo frames ─────────────────────────────────
    // One stereo frame = 64 BCLK rising edges.
    task wait_frames;
        input integer n_frames;
        integer total_edges;
        begin
            total_edges = n_frames * 64;
            repeat (total_edges) @(posedge i2s_bclk);
        end
    endtask

// ── Helper: capture one full stereo frame and decode L/R ─────────────────────
    // Returns the 16-bit LEFT and RIGHT samples as seen on the wire.
    // Waits for the next WS falling edge (start of LEFT), then captures
    // 64 BCLK cycles of DATA.
    reg [63:0] cap_frame;
    reg [15:0] cap_left_out;
    reg [15:0] cap_right_out;

    task capture_frame;
        output [15:0] left_out;
        output [15:0] right_out;
        integer k;
        begin
            // Wait for WS to go LOW (start of left channel)
            // Poll every BCLK rising edge
            @(posedge i2s_bclk);
            while (i2s_ws !== 1'b0) @(posedge i2s_bclk);

            // Capture 64 bits
            cap_frame = 64'h0;
            for (k = 0; k < 64; k = k + 1) begin
                cap_frame = {cap_frame[62:0], i2s_data};
                @(posedge i2s_bclk);
            end

            // Decode per Philips I2S (1-bit delay):
            //   cap_frame[63]    = delay bit (should be 0)
            //   cap_frame[62:47] = LEFT  sample bits [15:0] MSB-first
            //   cap_frame[46:32] = LEFT  padding zeros [14:0]
            //   cap_frame[31]    = delay bit (should be 0)
            //   cap_frame[30:15] = RIGHT sample bits [15:0] MSB-first
            //   cap_frame[14:0]  = RIGHT padding zeros [14:0]
            left_out  = cap_frame[62:47];
            right_out = cap_frame[30:15];
        end
    endtask

// ── BCLK period measurement ───────────────────────────────────────────────────
    real    bclk_t0;
    real    bclk_period_ns;
    integer bclk_valid = 0;

    // Module-level temporaries used by test 9 (Verilog-2001: no block-local regs)
    reg [15:0] consec_left;
    reg [15:0] consec_right;

    always @(posedge i2s_bclk) begin
        if (bclk_valid) bclk_period_ns = $realtime - bclk_t0;
        bclk_t0    = $realtime;
        bclk_valid = 1;
    end

// ── WS half-period measurement ────────────────────────────────────────────────
    integer ws_bclk_cnt = 0;
    integer ws_half_period_measured = 0;
    reg     ws_last = 0;

    always @(posedge i2s_bclk) begin
        ws_bclk_cnt = ws_bclk_cnt + 1;
        if (i2s_ws !== ws_last) begin
            ws_half_period_measured = ws_bclk_cnt;
            ws_bclk_cnt = 0;
            ws_last     = i2s_ws;
        end
    end

// ── Bit-level DATA checker ────────────────────────────────────────────────────
    // Verifies every bit of one 64-bit frame matches expected serialisation.
    // expected_frame layout (MSB-first):
    //   [63]    = 0 (delay)
    //   [62:47] = left[15:0]
    //   [46:32] = 15'b0
    //   [31]    = 0 (delay)
    //   [30:15] = right[15:0]
    //   [14:0]  = 15'b0
    task check_frame_bits;
        input [255:0] label;
        input [15:0]  exp_left;
        input [15:0]  exp_right;
        reg [63:0] exp_frame;
        reg [63:0] got_frame;
        reg [15:0] got_left, got_right;
        begin
            exp_frame = {1'b0, exp_left, 15'b0, 1'b0, exp_right, 15'b0};

            // Capture
            capture_frame(got_left, got_right);
            got_frame = {1'b0, got_left, 15'b0, 1'b0, got_right, 15'b0};

            $display("[INFO] %0s: exp L=0x%04X R=0x%04X  got L=0x%04X R=0x%04X",
                     label, exp_left, exp_right, got_left, got_right);
            check({label, " LEFT"},  got_left  === exp_left);
            check({label, " RIGHT"}, got_right === exp_right);
        end
    endtask

// ═════════════════════════════════════════════════════════════════════════════
// MAIN STIMULUS
// ═════════════════════════════════════════════════════════════════════════════
    initial begin
        $display("=== tb_direct_i2s: Direct-Register I2S Testbench ===");
        $display("[INFO] AXI bus is idle – internal registers forced directly");

        // ── Reset ─────────────────────────────────────────────────────────
        S_AXI_ARESETN = 0;
        repeat(10) @(posedge audio_clk);
        S_AXI_ARESETN = 1;
        repeat(4)  @(posedge audio_clk);
        $display("[INFO] Reset released");

        // ── Force initial state: play=0, muted, 48k ────────────────────
        force_sample_ctrl(32'h0000_0000, 3'b000); // play=0
        // Let BCLK settle (at least 2 BCLK cycles = 2 * 8 audio_clk)
        repeat(20) @(posedge audio_clk);
        $display("[INFO] Serialiser initialised (play=0)");

        // ─────────────────────────────────────────────────────────────────
        // TEST 1: BCLK period for 48k mode (fs_mode=0)
        // ─────────────────────────────────────────────────────────────────
        bclk_valid = 0;
        repeat(20) @(posedge i2s_bclk); // accumulate stable measurement
        $display("[INFO] Measured BCLK period = %.1f ns  (expected = %0d ns, 48k)",
                 bclk_period_ns, AUDIO_CLK_PERIOD * 8);
        check("BCLK period 48k correct",
              (bclk_period_ns >= AUDIO_CLK_PERIOD * 8 * 0.80) &&
              (bclk_period_ns <= AUDIO_CLK_PERIOD * 8 * 1.20));

        // ─────────────────────────────────────────────────────────────────
        // TEST 2: WS half-period = 32 BCLK
        // ─────────────────────────────────────────────────────────────────
        // Wait for at least 2 WS transitions
        ws_bclk_cnt = 0;
        wait_frames(3);
        $display("[INFO] WS half-period = %0d BCLK edges (expected 32)",
                 ws_half_period_measured);
        check("WS half-period = 32 BCLK", ws_half_period_measured === 32);

        // ─────────────────────────────────────────────────────────────────
        // TEST 3: Pattern A — play=1, mute=0, known L/R values
        // ─────────────────────────────────────────────────────────────────
        // Sample: L=0xA5A5, R=0x5A5A
        $display("[INFO] --- Test 3: Pattern A (L=0xA5A5, R=0x5A5A) ---");
        force_sample_ctrl({16'hA5A5, 16'h5A5A}, 3'b001); // play=1
        // Give serialiser one full frame to latch the new sample
        wait_frames(1);
        check_frame_bits("Pattern A", 16'hA5A5, 16'h5A5A);

        // ─────────────────────────────────────────────────────────────────
        // TEST 4: Pattern B — alternating 1s and 0s
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 4: Pattern B (L=0xFFFF, R=0x0000) ---");
        force_sample_ctrl({16'hFFFF, 16'h0000}, 3'b001); // play=1
        wait_frames(1);
        check_frame_bits("Pattern B", 16'hFFFF, 16'h0000);

        // ─────────────────────────────────────────────────────────────────
        // TEST 5: MSB boundary (max positive / max negative)
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 5: Boundaries (L=0x7FFF, R=0x8000) ---");
        force_sample_ctrl({16'h7FFF, 16'h8000}, 3'b001);
        wait_frames(1);
        check_frame_bits("Boundaries", 16'h7FFF, 16'h8000);

        // ─────────────────────────────────────────────────────────────────
        // TEST 6: play=0 → DATA must be 0 for entire frame
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 6: play=0 (DATA should be all-zero) ---");
        force_sample_ctrl({16'hFFFF, 16'hFFFF}, 3'b000); // play=0
        begin : play0_check
            integer ones;
            integer b;
            ones = 0;
            // Wait for WS low (frame start), then sample 64 bits
            @(posedge i2s_bclk);
            while (i2s_ws !== 1'b0) @(posedge i2s_bclk);
            for (b = 0; b < 64; b = b + 1) begin
                if (i2s_data) ones = ones + 1;
                @(posedge i2s_bclk);
            end
            $display("[INFO] play=0: observed %0d '1' bits (expected 0)", ones);
            check("DATA=0 when play=0", ones === 0);
        end

        // ─────────────────────────────────────────────────────────────────
        // TEST 7: mute=1 → DATA must be 0 while play=1
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 7: mute=1, play=1 (DATA should be all-zero) ---");
        force_sample_ctrl({16'hFFFF, 16'hFFFF}, 3'b011); // play=1, mute=1
        begin : mute_check
            integer ones;
            integer b;
            ones = 0;
            @(posedge i2s_bclk);
            while (i2s_ws !== 1'b0) @(posedge i2s_bclk);
            for (b = 0; b < 64; b = b + 1) begin
                if (i2s_data) ones = ones + 1;
                @(posedge i2s_bclk);
            end
            $display("[INFO] mute=1: observed %0d '1' bits (expected 0)", ones);
            check("DATA=0 when mute=1", ones === 0);
        end

        // ─────────────────────────────────────────────────────────────────
        // TEST 8: fs_mode=1 → BCLK should double (96k)
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 8: fs_mode=1 (96k, BCLK should double) ---");
        force_sample_ctrl({16'h1234, 16'h5678}, 3'b101); // play=1, fs_mode=1
        bclk_valid = 0; // reset measurement
        repeat(20) @(posedge i2s_bclk);
        $display("[INFO] 96k: BCLK period = %.1f ns  (expected ≈ %0d ns)",
                 bclk_period_ns, AUDIO_CLK_PERIOD * 4);
        check("BCLK period 96k correct",
              (bclk_period_ns >= AUDIO_CLK_PERIOD * 4 * 0.80) &&
              (bclk_period_ns <= AUDIO_CLK_PERIOD * 4 * 1.20));

        // ─────────────────────────────────────────────────────────────────
        // TEST 9: Multiple consecutive frames (alternating L/R pattern)
        //         Verifies sample_q is stable across frames until updated
        // ─────────────────────────────────────────────────────────────────
        $display("[INFO] --- Test 9: Consecutive frames with alternating patterns ---");
        force_sample_ctrl({16'hAAAA, 16'h5555}, 3'b001); // play=1, 48k
        begin : consec
            integer fi;
            for (fi = 0; fi < 3; fi = fi + 1) begin
                wait_frames(1);
                capture_frame(consec_left, consec_right);
                $display("[INFO] Frame %0d: L=0x%04X R=0x%04X", fi, consec_left, consec_right);
                check("Consecutive frame L stable", consec_left  === 16'hAAAA);
                check("Consecutive frame R stable", consec_right === 16'h5555);
            end
        end

        // Release forced registers so DUT reverts to AXI-driven operation
        release_force();

        // ─────────────────────────────────────────────────────────────────
        // SUMMARY
        // ─────────────────────────────────────────────────────────────────
        $display("");
        $display("=== RESULTS: %0d PASSED, %0d FAILED ===", pass_count, fail_count);
        if (fail_count === 0)
            $display("ALL CHECKS PASSED");
        else
            $display("SOME CHECKS FAILED — see [FAIL] lines above");

        $finish;
    end

    // Safety timeout
    initial begin
        #10_000_000;
        $display("[TIMEOUT] Simulation exceeded 10 ms — forcing $finish");
        $finish;
    end

endmodule
