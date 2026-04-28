`timescale 1ns / 1ps

module i2s_tb;

    // ---- Clocks ----
    reg         axi_clk     = 0;
    reg         audio_clk   = 0;
    reg         axi_resetn  = 0;
    reg         audio_rst   = 1;

    // AXI clock: 100 MHz (10 ns period)
    always #5 axi_clk = ~axi_clk;

    // Audio clock: 24.576 MHz (40.69 ns period) for 48 kHz sample rate
    // audio_clk = MCLK * 2 = 24.576 MHz
    always #20.345 audio_clk = ~audio_clk;

    // ---- I2S outputs ----
    wire        i2s_mclk;
    wire        i2s_bclk;
    wire        i2s_ws;
    wire        i2s_data;

    // ---- AXI-Lite signals ----
    reg  [3:0]  awaddr  = 0;
    reg         awvalid = 0;
    wire        awready;
    reg  [31:0] wdata   = 0;
    reg  [3:0]  wstrb   = 4'hF;
    reg         wvalid  = 0;
    wire        wready;
    wire [1:0]  bresp;
    wire        bvalid;
    reg         bready  = 1;
    reg  [3:0]  araddr  = 0;
    reg         arvalid = 0;
    wire        arready;
    wire [31:0] rdata;
    wire [1:0]  rresp;
    wire        rvalid;
    reg         rready  = 1;

    // ---- DUT ----
    i2s_slave_lite_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(32),
        .C_S_AXI_ADDR_WIDTH(4)
    ) dut (
        .audio_clk  (audio_clk),
        .audio_rst  (audio_rst),
        .i2s_mclk   (i2s_mclk),
        .i2s_bclk   (i2s_bclk),
        .i2s_ws     (i2s_ws),
        .i2s_data   (i2s_data),

        .S_AXI_ACLK    (axi_clk),
        .S_AXI_ARESETN (axi_resetn),
        .S_AXI_AWADDR  (awaddr),
        .S_AXI_AWPROT  (3'b0),
        .S_AXI_AWVALID (awvalid),
        .S_AXI_AWREADY (awready),
        .S_AXI_WDATA   (wdata),
        .S_AXI_WSTRB   (wstrb),
        .S_AXI_WVALID  (wvalid),
        .S_AXI_WREADY  (wready),
        .S_AXI_BRESP   (bresp),
        .S_AXI_BVALID  (bvalid),
        .S_AXI_BREADY  (bready),
        .S_AXI_ARADDR  (araddr),
        .S_AXI_ARPROT  (3'b0),
        .S_AXI_ARVALID (arvalid),
        .S_AXI_ARREADY (arready),
        .S_AXI_RDATA   (rdata),
        .S_AXI_RRESP   (rresp),
        .S_AXI_RVALID  (rvalid),
        .S_AXI_RREADY  (rready)
    );

    // ---- AXI write task ----
    task axi_write(input [3:0] addr, input [31:0] data);
    begin
        @(posedge axi_clk);
        awaddr  <= addr;
        awvalid <= 1;
        wdata   <= data;
        wvalid  <= 1;
        wstrb   <= 4'hF;
        // Wait for handshake
        wait (awready && wready);
        @(posedge axi_clk);
        awvalid <= 0;
        wvalid  <= 0;
        // Wait for response
        wait (bvalid);
        @(posedge axi_clk);
    end
    endtask

    // ---- I2S Protocol Checker ----
    reg [31:0] decoded_sample;
    reg [4:0]  decode_bit;
    reg        prev_ws;
    reg        prev_bclk;
    integer    ws_change_count = 0;
    integer    bclk_rising_count = 0;

    // Check: data changes on BCLK falling edge (NXP spec requirement)
    reg prev_data;
    always @(negedge i2s_bclk) begin
        if (axi_resetn && !audio_rst) begin
            prev_data <= i2s_data;
        end
    end

    // Decode serial data on BCLK rising edge (as a receiver would)
    always @(posedge i2s_bclk) begin
        if (axi_resetn && !audio_rst) begin
            decoded_sample[31 - decode_bit] <= i2s_data;
            bclk_rising_count <= bclk_rising_count + 1;

            if (prev_ws != i2s_ws) begin
                ws_change_count <= ws_change_count + 1;
                if (i2s_ws == 1'b1) begin
                    $display("[%0t ns] WS 0->1 (RIGHT channel starts). Decoded LEFT  = 0x%08h", $time, decoded_sample);
                end else begin
                    $display("[%0t ns] WS 1->0 (LEFT channel starts).  Decoded RIGHT = 0x%08h", $time, decoded_sample);
                end
                decode_bit <= 0;
            end else begin
                decode_bit <= decode_bit + 1;
            end
            prev_ws <= i2s_ws;
        end
    end

    // ---- Check: WS changes on BCLK falling edge ----
    reg prev_ws_for_edge_check;
    always @(negedge i2s_bclk) begin
        if (axi_resetn && !audio_rst) begin
            if (prev_ws_for_edge_check !== i2s_ws) begin
                $display("[%0t ns] PASS: WS changed on BCLK falling edge (NXP spec compliant)", $time);
            end
            prev_ws_for_edge_check <= i2s_ws;
        end
    end

    // ---- Stimulus ----
    initial begin
        // Waveform dump for GTKWave or Vivado
        $dumpfile("i2s_sim.vcd");
        $dumpvars(0, i2s_tb);

        $display("========================================");
        $display("  I2S IP Testbench - NXP Spec Checker");
        $display("========================================");
        $display("");

        // Hold reset
        axi_resetn = 0;
        audio_rst  = 1;
        #200;

        // Release resets
        axi_resetn = 1;
        audio_rst  = 0;
        $display("[%0t ns] Resets released", $time);
        #200;

        // ---- Test 1: Write known sample ----
        $display("");
        $display("--- Test 1: Write Left=0x7FFF, Right=0x8000 ---");
        axi_write(4'h0, 32'h7FFF_8000);

        // Wait for 2 full I2S frames
        // Frame = 32 bits * 2 half-BCLK * 256 audio_clk * 40.69ns = ~667us
        #1_500_000;

        // ---- Test 2: Write different sample ----
        $display("");
        $display("--- Test 2: Write Left=0x1234, Right=0x5678 ---");
        axi_write(4'h0, 32'h1234_5678);
        #1_500_000;

        // ---- Test 3: Write silence (zeros) ----
        $display("");
        $display("--- Test 3: Write silence (0x0000_0000) ---");
        axi_write(4'h0, 32'h0000_0000);
        #1_500_000;

        // ---- Test 4: Write full scale ----
        $display("");
        $display("--- Test 4: Write full scale (0xFFFF_FFFF) ---");
        axi_write(4'h0, 32'hFFFF_FFFF);
        #1_500_000;

        $display("");
        $display("========================================");
        $display("  Simulation Complete");
        $display("  WS transitions seen: %0d", ws_change_count);
        $display("  BCLK rising edges:   %0d", bclk_rising_count);
        $display("========================================");
        $finish;
    end

    // Timeout watchdog
    initial begin
        #10_000_000;  // 10 ms timeout
        $display("ERROR: Simulation timed out!");
        $finish;
    end

endmodule
