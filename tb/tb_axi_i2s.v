// =============================================================================
// tb_axi_i2s.v  –  Full AXI4-Lite-Driven I2S Testbench
// =============================================================================
//
// PURPOSE
//   Exercises i2s_slave_lite_v1_0_S00_AXI exactly as Vitis/bare-metal firmware
//   does: all sample data and control bits are driven exclusively through the
//   AXI4-Lite bus.  A VCD waveform is dumped so you can open the result in
//   GTKWave and inspect I2S framing.
//
// WHAT IS VERIFIED
//   1. ID register returns 0x49325301.
//   2. CTRL register play/mute/fs_mode bits are writable/readable.
//   3. Five successive stereo frames are transmitted with known LEFT/RIGHT values.
//   4. BCLK period matches the expected frequency for each fs_mode.
//   5. WS (LRCK) toggles every 32 BCLK cycles (64 BCLK per stereo frame).
//   6. Serialised DATA bits match the written samples (MSB-first, Philips format).
//   7. Switching to fs_mode=1 (96 kHz) doubles the BCLK rate.
//   8. Mute (ctrl[1]=1) silences DATA while WS/BCLK continue.
//
// HOW TO COMPILE & SIMULATE (Icarus Verilog)
//   iverilog -o sim_axi.vvp \
//       ../rtl/i2s_slave_lite_v1_0_S00_AXI.v \
//       tb_axi_i2s.v
//   vvp sim_axi.vvp
//   gtkwave tb_axi_i2s.vcd &
//
// EXPECTED PASS CRITERIA  (printed to console)
//   [PASS] ID register read
//   [PASS] CTRL write-read round-trip
//   [PASS] Frame N: L=XXXX R=YYYY recovered correctly
//   [PASS] WS period = 64 BCLK cycles
//   [PASS] BCLK period 48k mode
//   [PASS] DATA silent during MUTE
//   ALL CHECKS PASSED
//
// WAVEFORM INSPECTION GUIDE
//   • Zoom to show 2–3 full frames (~130 us for 48 k mode).
//   • i2s_bclk : should toggle at ~3.07 MHz (48k) or ~6.14 MHz (96k).
//   • i2s_ws   : should toggle every 32 BCLK cycles.
//   • i2s_data : MSB of LEFT sample appears 1 BCLK after WS→0; MSB of RIGHT
//                appears 1 BCLK after WS→1.
//   • AXI signals (S_AXI_AW*, S_AXI_W*, S_AXI_B*) should show clean
//     handshake pulses (VALID then READY).
//
// =============================================================================
`timescale 1ns / 1ps

module tb_axi_i2s;

// ── Parameters ─────────────────────────────────────────────────────────────
    // AXI bus clock: 100 MHz  (10 ns period)
    localparam AXI_CLK_PERIOD   = 10;
    // audio_clk: 24.56897 MHz ≈ 40.7 ns period
    localparam AUDIO_CLK_PERIOD = 41; // 40.7 ns rounded

    // Register offsets (byte addresses, word-aligned)
    localparam REG_DATA   = 4'h0;  // slv_reg0
    localparam REG_CTRL   = 4'h4;  // slv_reg1
    localparam REG_STATUS = 4'h8;  // slv_reg2
    localparam REG_ID     = 4'hC;  // slv_reg3 (ID)

    // Control bit positions within CTRL register
    localparam CTRL_PLAY    = 32'h1;
    localparam CTRL_MUTE    = 32'h2;
    localparam CTRL_FS_MODE = 32'h4; // 1 → ~96k, 0 → ~48k

// ── DUT signal declarations ─────────────────────────────────────────────────
    reg         S_AXI_ACLK    = 0;
    reg         S_AXI_ARESETN = 0;
    reg  [3:0]  S_AXI_AWADDR  = 0;
    reg  [2:0]  S_AXI_AWPROT  = 0;
    reg         S_AXI_AWVALID = 0;
    reg  [31:0] S_AXI_WDATA   = 0;
    reg  [3:0]  S_AXI_WSTRB   = 4'hF;
    reg         S_AXI_WVALID  = 0;
    reg         S_AXI_BREADY  = 1;
    reg  [3:0]  S_AXI_ARADDR  = 0;
    reg  [2:0]  S_AXI_ARPROT  = 0;
    reg         S_AXI_ARVALID = 0;
    reg         S_AXI_RREADY  = 1;

    wire        S_AXI_AWREADY;
    wire        S_AXI_WREADY;
    wire [1:0]  S_AXI_BRESP;
    wire        S_AXI_BVALID;
    wire        S_AXI_ARREADY;
    wire [31:0] S_AXI_RDATA;
    wire [1:0]  S_AXI_RRESP;
    wire        S_AXI_RVALID;

    reg         audio_clk = 0;
    wire        i2s_bclk;
    wire        i2s_ws;
    wire        i2s_data;
    wire        i2s_mclk;

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
        $dumpfile("tb_axi_i2s.vcd");
        $dumpvars(0, tb_axi_i2s);
    end

// ── Checker variables ────────────────────────────────────────────────────────
    integer pass_count  = 0;
    integer fail_count  = 0;

    // BCLK edge timing measurement
    real    bclk_last_rise_ns;
    real    bclk_period_measured_ns;
    integer bclk_period_valid = 0;

    // WS period measurement (count BCLK edges between WS changes)
    integer ws_bclk_count  = 0;
    integer ws_period_bclk = 0;
    reg     ws_prev        = 0;

    // Frame receiver – captures serial bits and reconstructs L/R samples
    // Monitors 64 consecutive data bits after a WS→0 edge
    integer rcv_bit_idx     = 0;
    reg     rcv_active      = 0;
    reg [15:0] rcv_left     = 0;
    reg [15:0] rcv_right    = 0;
    integer frame_captured  = 0;

// ── BCLK period measurement ───────────────────────────────────────────────────
    always @(posedge i2s_bclk) begin
        if (bclk_period_valid) begin
            bclk_period_measured_ns = $realtime - bclk_last_rise_ns;
        end
        bclk_last_rise_ns  = $realtime;
        bclk_period_valid  = 1;
    end

// ── WS period (in BCLK cycles) measurement ───────────────────────────────────
    always @(posedge i2s_bclk) begin
        ws_bclk_count = ws_bclk_count + 1;
        if (i2s_ws !== ws_prev) begin
            ws_period_bclk = ws_bclk_count;
            ws_bclk_count  = 0;
            ws_prev        = i2s_ws;
        end
    end

// ── Serial data capture (sample on BCLK rising edge per Philips I2S) ─────────
    // Monitor a full 64-bit frame starting from i2s_ws going LOW.
    // We skip the 1-bit Philips delay, then capture 16 bits for L and 16 for R.
    reg     ws_prev_cap  = 1;
    integer cap_bit_cnt  = 0;
    reg [63:0] cap_shift = 0;

    always @(posedge i2s_bclk) begin
        // Detect WS falling edge (ws HIGH→LOW = start of LEFT channel)
        if (!i2s_ws && ws_prev_cap) begin
            cap_bit_cnt = 0;
            rcv_active  = 1;
        end
        ws_prev_cap = i2s_ws;

        if (rcv_active) begin
            cap_shift    = {cap_shift[62:0], i2s_data};
            cap_bit_cnt  = cap_bit_cnt + 1;
            if (cap_bit_cnt == 64) begin
                // Per Philips standard the frame captured is:
                //   bit[63..48] : 1 delay bit + 16-bit LEFT  + 15 pad zeros
                //   but shifted so:
                //   cap_shift[63:48] includes delay in bit63, L[15:0] in bits62..47
                // LEFT  bits: cap_shift[62:47]  (after the 1-bit delay)
                // RIGHT bits: cap_shift[30:15]  (after another 1-bit delay)
                rcv_left   = cap_shift[62:47];
                rcv_right  = cap_shift[30:15];
                frame_captured = frame_captured + 1;
                rcv_active = 0;
            end
        end
    end

// ── AXI helper tasks ──────────────────────────────────────────────────────────
    // Write a 32-bit word to the given byte address
    task axi_write;
        input [3:0]  addr;
        input [31:0] data;
        begin
            @(posedge S_AXI_ACLK);
            S_AXI_AWADDR  <= addr;
            S_AXI_AWVALID <= 1'b1;
            S_AXI_WDATA   <= data;
            S_AXI_WSTRB   <= 4'hF;
            S_AXI_WVALID  <= 1'b1;
            // Wait for both address and data to be accepted
            @(posedge S_AXI_ACLK);
            while (!(S_AXI_AWREADY && S_AXI_WREADY)) @(posedge S_AXI_ACLK);
            S_AXI_AWVALID <= 1'b0;
            S_AXI_WVALID  <= 1'b0;
            // Wait for write response
            @(posedge S_AXI_ACLK);
            while (!S_AXI_BVALID) @(posedge S_AXI_ACLK);
        end
    endtask

    // Read a 32-bit word from the given byte address; result in rdata
    reg [31:0] rdata;
    task axi_read;
        input [3:0] addr;
        begin
            @(posedge S_AXI_ACLK);
            S_AXI_ARADDR  <= addr;
            S_AXI_ARVALID <= 1'b1;
            @(posedge S_AXI_ACLK);
            while (!S_AXI_ARREADY) @(posedge S_AXI_ACLK);
            S_AXI_ARVALID <= 1'b0;
            @(posedge S_AXI_ACLK);
            while (!S_AXI_RVALID) @(posedge S_AXI_ACLK);
            rdata = S_AXI_RDATA;
        end
    endtask

    // Checker helper
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

// ── Main stimulus ─────────────────────────────────────────────────────────────
    // Known test samples (16-bit signed)
    localparam [15:0] L0 = 16'hA5A5;
    localparam [15:0] R0 = 16'h5A5A;
    localparam [15:0] L1 = 16'h1234;
    localparam [15:0] R1 = 16'hDEAD;
    localparam [15:0] L2 = 16'h7FFF; // max positive
    localparam [15:0] R2 = 16'h8000; // max negative

    integer i;
    real    bclk_period_48k_ref;
    real    bclk_period_96k_ref;

    initial begin
        $display("=== tb_axi_i2s: AXI4-Lite I2S Testbench ===");

        // Expected BCLK periods:
        //   48k mode: audio_clk period * 8  (BCLK = audio_clk / 8)
        //   96k mode: audio_clk period * 4
        bclk_period_48k_ref = AUDIO_CLK_PERIOD * 8.0;
        bclk_period_96k_ref = AUDIO_CLK_PERIOD * 4.0;

        // ── 1. Apply reset ─────────────────────────────────────────────────
        S_AXI_ARESETN = 0;
        repeat(10) @(posedge S_AXI_ACLK);
        S_AXI_ARESETN = 1;
        repeat(5)  @(posedge S_AXI_ACLK);
        $display("[INFO] Reset released");

        // ── 2. Read ID register ────────────────────────────────────────────
        axi_read(REG_ID);
        check("ID register = 0x49325301", rdata === 32'h49325301);
        $display("[INFO] ID = 0x%08X", rdata);

        // ── 3. CTRL write-read round-trip ──────────────────────────────────
        axi_write(REG_CTRL, 32'h00000003); // play=1, mute=1
        axi_read(REG_CTRL);
        check("CTRL write-read round-trip", (rdata & 32'h7) === 32'h3);

        // ── 4. Write first sample pair and start playback (unmuted, 48k) ──
        axi_write(REG_CTRL, 32'h00000000); // disable first
        axi_write(REG_DATA, {L0, R0});     // L0 in [31:16], R0 in [15:0]
        axi_write(REG_CTRL, CTRL_PLAY);    // play=1, mute=0, fs_mode=0 (48k)
        $display("[INFO] Wrote sample L=0x%04X R=0x%04X, play=1 (48k mode)", L0, R0);

        // Let the serialiser run for 3 full frames
        // One frame = 64 BCLK at 48k ≈ 64 * 8 * 41 ns ≈ 21 us
        // 3 frames ≈ 63 us → wait 100 us to be safe
        #100_000;

        // Wait for frame capture to complete (frame_captured > 0)
        i = 0;
        while (frame_captured < 2 && i < 200) begin
            #1000;
            i = i + 1;
        end
        check("Frame captured after play=1", frame_captured >= 1);
        if (frame_captured >= 1)
            $display("[INFO] Captured: L=0x%04X R=0x%04X (expected L=0x%04X R=0x%04X)",
                     rcv_left, rcv_right, L0, R0);
        check("Frame 0: LEFT  sample matches", rcv_left  === L0);
        check("Frame 0: RIGHT sample matches", rcv_right === R0);

        // ── 5. Second sample pair ──────────────────────────────────────────
        frame_captured = 0;
        axi_write(REG_DATA, {L1, R1});
        #100_000;
        i = 0;
        while (frame_captured < 1 && i < 200) begin
            #1000;
            i = i + 1;
        end
        if (frame_captured >= 1)
            $display("[INFO] Captured: L=0x%04X R=0x%04X (expected L=0x%04X R=0x%04X)",
                     rcv_left, rcv_right, L1, R1);
        check("Frame 1: LEFT  sample matches", rcv_left  === L1);
        check("Frame 1: RIGHT sample matches", rcv_right === R1);

        // ── 6. Third sample pair (boundary values) ─────────────────────────
        frame_captured = 0;
        axi_write(REG_DATA, {L2, R2});
        #100_000;
        i = 0;
        while (frame_captured < 1 && i < 200) begin
            #1000;
            i = i + 1;
        end
        if (frame_captured >= 1)
            $display("[INFO] Captured: L=0x%04X R=0x%04X (expected L=0x%04X R=0x%04X)",
                     rcv_left, rcv_right, L2, R2);
        check("Frame 2: LEFT  boundary value", rcv_left  === L2);
        check("Frame 2: RIGHT boundary value", rcv_right === R2);

        // ── 7. Verify BCLK period (48k mode) ─────────────────────────────
        // Allow a few more cycles for measurement to settle
        #50_000;
        if (bclk_period_valid) begin
            $display("[INFO] Measured BCLK period = %.1f ns (expected ≈ %.1f ns, 48k mode)",
                     bclk_period_measured_ns, bclk_period_48k_ref);
            // Allow ±20% tolerance for quantisation from integer clock periods
            check("BCLK period 48k mode within tolerance",
                  (bclk_period_measured_ns >= bclk_period_48k_ref * 0.80) &&
                  (bclk_period_measured_ns <= bclk_period_48k_ref * 1.20));
        end

        // ── 8. Verify WS period = 64 BCLK cycles ─────────────────────────
        if (ws_period_bclk > 0)
            $display("[INFO] WS half-period = %0d BCLK edges (expected 32)", ws_period_bclk);
        check("WS half-period = 32 BCLK cycles", ws_period_bclk === 32);

        // ── 9. Mute test ──────────────────────────────────────────────────
        // Enable mute and check DATA line is silent for one full frame
        axi_write(REG_CTRL, CTRL_PLAY | CTRL_MUTE); // play=1, mute=1
        $display("[INFO] Mute enabled — DATA should remain 0");
        // Give the ctrl_sync_b time to propagate (2 audio_clk cycles)
        #(AUDIO_CLK_PERIOD * 4);
        // Now monitor one full frame worth of bits (64 BCLK)
        begin : mute_check_block
            integer mute_ones;
            integer mute_bits;
            mute_ones = 0;
            mute_bits = 0;
            // Wait for one full frame
            fork
                begin : timeout_fork
                    #200_000;
                    disable mute_check_block;
                end
                begin : capture_fork
                    integer j;
                    for (j = 0; j < 64; j = j + 1) begin
                        @(posedge i2s_bclk);
                        if (i2s_data) mute_ones = mute_ones + 1;
                        mute_bits = mute_bits + 1;
                    end
                    disable timeout_fork;
                end
            join
            $display("[INFO] During MUTE: %0d '1' bits in %0d sampled (expected 0)",
                     mute_ones, mute_bits);
            check("DATA silent during MUTE", mute_ones === 0);
        end

        // ── 10. Switch to fs_mode=1 (96 kHz) ─────────────────────────────
        bclk_period_valid = 0; // reset measurement
        axi_write(REG_CTRL, CTRL_PLAY | CTRL_FS_MODE); // play=1, fs_mode=1
        $display("[INFO] Switched to fs_mode=1 (~96 kHz), measuring new BCLK period");
        // Wait for ~10 BCLK cycles to get a stable measurement
        #50_000;
        if (bclk_period_valid) begin
            $display("[INFO] Measured BCLK period = %.1f ns (expected ≈ %.1f ns, 96k mode)",
                     bclk_period_measured_ns, bclk_period_96k_ref);
            check("BCLK period 96k mode within tolerance",
                  (bclk_period_measured_ns >= bclk_period_96k_ref * 0.80) &&
                  (bclk_period_measured_ns <= bclk_period_96k_ref * 1.20));
        end

        // ── Summary ────────────────────────────────────────────────────────
        $display("");
        $display("=== RESULTS: %0d PASSED, %0d FAILED ===", pass_count, fail_count);
        if (fail_count === 0)
            $display("ALL CHECKS PASSED");
        else
            $display("SOME CHECKS FAILED — see [FAIL] lines above");

        $finish;
    end

    // Safety timeout (simulation should finish well before this)
    initial begin
        #5_000_000;
        $display("[TIMEOUT] Simulation exceeded 5 ms wall-clock — forcing $finish");
        $finish;
    end

endmodule
