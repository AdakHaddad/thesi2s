`timescale 1ns / 1ps

// Self-checking AXI4-Lite and I2S protocol testbench.
// Run as the Vivado simulation top: tb_i2s_axi_lite.
module tb_i2s_axi_lite;

    localparam integer CLK_PERIOD_NS = 10;
    localparam [3:0] ADDR_DATA_LEFT  = 4'h0;
    localparam [3:0] ADDR_DATA_RIGHT = 4'h4;
    localparam [3:0] ADDR_CONTROL    = 4'h8;
    localparam [3:0] ADDR_STATUS     = 4'hC;
    localparam [31:0] LEFT_SAMPLE    = 32'h00A5_C31E;
    localparam [31:0] RIGHT_SAMPLE   = 32'h005A_3CE1;
    localparam [31:0] CTRL_24_48K    = (32'd96000 << 7) | (32'd24 << 2) | 32'h1;
    localparam [31:0] CTRL_MUTE_24_48K = CTRL_24_48K | 32'h2;

    reg aclk = 1'b0;
    reg aresetn = 1'b0;
    always #(CLK_PERIOD_NS/2) aclk = ~aclk;

    reg [3:0] awaddr = 4'd0;
    reg [2:0] awprot = 3'd0;
    reg awvalid = 1'b0;
    wire awready;
    reg [31:0] wdata = 32'd0;
    reg [3:0] wstrb = 4'hF;
    reg wvalid = 1'b0;
    wire wready;
    wire [1:0] bresp;
    wire bvalid;
    reg bready = 1'b1;
    reg [3:0] araddr = 4'd0;
    reg [2:0] arprot = 3'd0;
    reg arvalid = 1'b0;
    wire arready;
    wire [31:0] rdata;
    wire [1:0] rresp;
    wire rvalid;
    reg rready = 1'b1;

    wire i2s_mclk;
    wire i2s_bclk;
    wire i2s_ws;
    wire i2s_data;
    wire i2s_enabled =
        dut.i2s_slave_lite_v1_0_S00_AXI_inst.slv_reg2[0];
    integer errors = 0;
    integer i;
    integer bclk_edges_since_ws = 0;
    reg ws_monitor_armed = 1'b0;
    reg [31:0] read_value;

    i2s #(
        .C_S00_AXI_DATA_WIDTH(32),
        .C_S00_AXI_ADDR_WIDTH(4)
    ) dut (
        .audio_clk(aclk),
        .i2s_mclk(i2s_mclk), .i2s_bclk(i2s_bclk),
        .i2s_ws(i2s_ws), .i2s_data(i2s_data),
        .s00_axi_aclk(aclk), .s00_axi_aresetn(aresetn),
        .s00_axi_awaddr(awaddr), .s00_axi_awprot(awprot),
        .s00_axi_awvalid(awvalid), .s00_axi_awready(awready),
        .s00_axi_wdata(wdata), .s00_axi_wstrb(wstrb),
        .s00_axi_wvalid(wvalid), .s00_axi_wready(wready),
        .s00_axi_bresp(bresp), .s00_axi_bvalid(bvalid), .s00_axi_bready(bready),
        .s00_axi_araddr(araddr), .s00_axi_arprot(arprot),
        .s00_axi_arvalid(arvalid), .s00_axi_arready(arready),
        .s00_axi_rdata(rdata), .s00_axi_rresp(rresp),
        .s00_axi_rvalid(rvalid), .s00_axi_rready(rready)
    );

    // A stereo frame has two 32-BCLK channel slots.  The first WS
    // transition arms the monitor; each following transition must occur
    // after exactly 32 receiver sampling edges.
    always @(posedge i2s_bclk)
        if (aresetn && i2s_enabled)
            bclk_edges_since_ws = bclk_edges_since_ws + 1;

    always @(i2s_ws) begin
        if (!aresetn || !i2s_enabled) begin
            bclk_edges_since_ws = 0;
            ws_monitor_armed = 1'b0;
        end else if (ws_monitor_armed) begin
            if (bclk_edges_since_ws != 32) begin
                $display("ERROR: WS changed after %0d BCLK edges, expected 32",
                         bclk_edges_since_ws);
                errors = errors + 1;
            end
            bclk_edges_since_ws = 0;
        end else begin
            ws_monitor_armed = 1'b1;
            bclk_edges_since_ws = 0;
        end
    end

    task axi_write;
        input [3:0] address;
        input [31:0] value;
        begin
            @(negedge aclk);
            awaddr = address;
            wdata = value;
            wstrb = 4'hF;
            awvalid = 1'b1;
            wvalid = 1'b1;
            while (!(awready && wready)) @(posedge aclk);
            @(negedge aclk);
            awvalid = 1'b0;
            wvalid = 1'b0;
            while (!bvalid) @(posedge aclk);
            if (bresp !== 2'b00) begin
                $display("ERROR: AXI write response at address 0x%0h was %b", address, bresp);
                errors = errors + 1;
            end
            @(posedge aclk);
        end
    endtask

    task axi_read;
        input [3:0] address;
        output [31:0] value;
        begin
            @(negedge aclk);
            araddr = address;
            arvalid = 1'b1;
            while (!arready) @(posedge aclk);
            @(negedge aclk);
            arvalid = 1'b0;
            while (!rvalid) @(posedge aclk);
            value = rdata;
            if (rresp !== 2'b00) begin
                $display("ERROR: AXI read response at address 0x%0h was %b", address, rresp);
                errors = errors + 1;
            end
            @(posedge aclk);
        end
    endtask

    // Check one I2S channel after its WS transition.  The first BCLK rising
    // edge is the Philips I2S one-bit delay; payload is then MSB-first.
    task check_channel;
        input expected_ws;
        input [23:0] expected_sample;
        begin
            if (expected_ws)
                @(posedge i2s_ws);
            else
                @(negedge i2s_ws);

            @(posedge i2s_bclk);
            #1;
            if (i2s_data !== 1'b0) begin
                $display("ERROR: I2S WS=%0b did not provide the required one-bit delay", expected_ws);
                errors = errors + 1;
            end

            for (i = 23; i >= 0; i = i - 1) begin
                @(posedge i2s_bclk);
                #1;
                if (i2s_ws !== expected_ws || i2s_data !== expected_sample[i]) begin
                    $display("ERROR: I2S WS=%0b bit %0d expected %b, got WS=%b DATA=%b",
                             expected_ws, i, expected_sample[i], i2s_ws, i2s_data);
                    errors = errors + 1;
                end
            end

            // 24-bit audio occupies the remaining seven positions of the
            // fixed 32-BCLK channel slot with zero padding.
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge i2s_bclk);
                #1;
                if (i2s_ws !== expected_ws || i2s_data !== 1'b0) begin
                    $display("ERROR: I2S WS=%0b padding bit %0d was not zero", expected_ws, i);
                    errors = errors + 1;
                end
            end
        end
    endtask

    // Time complete WS periods rather than estimating frequency from a
    // screenshot. Sixteen frames keep the 10 ns simulation quantisation
    // error well below the 0.1 percent acceptance limit.
    task check_sample_rate;
        input [19:0] target_hz;
        reg [31:0] control_value;
        real start_time_ns;
        real end_time_ns;
        real measured_hz;
        real error_percent;
        integer frame;
        begin
            control_value = {5'd0, target_hz, 7'd0} |
                            (32'd24 << 2) | 32'h1;
            axi_write(ADDR_CONTROL, control_value);

            @(posedge i2s_ws);
            start_time_ns = $realtime;
            for (frame = 0; frame < 16; frame = frame + 1)
                @(posedge i2s_ws);
            end_time_ns = $realtime;

            measured_hz = 16.0e9 / (end_time_ns - start_time_ns);
            error_percent = 100.0 * (measured_hz - target_hz) / target_hz;
            $display("SAMPLE_RATE: target=%0d Hz measured=%0.3f Hz error=%0.5f%%",
                     target_hz, measured_hz, error_percent);
            if (error_percent > 0.1 || error_percent < -0.1) begin
                $display("ERROR: sample-rate error exceeds 0.1%% for %0d Hz",
                         target_hz);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_i2s_axi_lite.vcd");
        $dumpvars(0, tb_i2s_axi_lite);

        repeat (5) @(posedge aclk);
        aresetn = 1'b1;
        repeat (3) @(posedge aclk);

        // Disabled IP must be quiet after reset.
        if ({i2s_mclk, i2s_bclk, i2s_ws, i2s_data} !== 4'b0000) begin
            $display("ERROR: I2S outputs are not low while disabled");
            errors = errors + 1;
        end

        axi_read(ADDR_CONTROL, read_value);
        if (read_value !== (32'd48000 << 7)) begin
            $display("ERROR: reset CONTROL expected 0x%08h, got 0x%08h", (32'd48000 << 7), read_value);
            errors = errors + 1;
        end

        axi_write(ADDR_DATA_LEFT, LEFT_SAMPLE);
        axi_write(ADDR_DATA_RIGHT, RIGHT_SAMPLE);
        axi_read(ADDR_DATA_LEFT, read_value);
        if (read_value !== LEFT_SAMPLE) begin
            $display("ERROR: DATA_LEFT readback mismatch: 0x%08h", read_value);
            errors = errors + 1;
        end
        axi_read(ADDR_DATA_RIGHT, read_value);
        if (read_value !== RIGHT_SAMPLE) begin
            $display("ERROR: DATA_RIGHT readback mismatch: 0x%08h", read_value);
            errors = errors + 1;
        end

        axi_write(ADDR_CONTROL, CTRL_24_48K);
        axi_read(ADDR_CONTROL, read_value);
        if (read_value !== CTRL_24_48K) begin
            $display("ERROR: CONTROL readback mismatch: 0x%08h", read_value);
            errors = errors + 1;
        end

        // Check right then left.  The first left WS transition occurs only
        // after the initial right half-frame has completed.
        check_channel(1'b1, RIGHT_SAMPLE[23:0]);
        check_channel(1'b0, LEFT_SAMPLE[23:0]);

        axi_read(ADDR_STATUS, read_value);
        if (^read_value[0] === 1'bx) begin
            $display("ERROR: STATUS[0] is unknown after frame latching");
            errors = errors + 1;
        end

        // Mute preserves clocks and WS but must transmit zero data.
        axi_write(ADDR_CONTROL, CTRL_MUTE_24_48K);
        check_channel(1'b1, 24'd0);

        // Standard and non-standard rates are measured from elapsed WS time.
        check_sample_rate(20'd44100);
        check_sample_rate(20'd48000);
        check_sample_rate(20'd88200);
        check_sample_rate(20'd96000);
        check_sample_rate(20'd10000);
        check_sample_rate(20'd12345);

        axi_write(ADDR_CONTROL, 32'd48000 << 7);
        repeat (4) @(posedge aclk);
        if ({i2s_mclk, i2s_bclk, i2s_ws, i2s_data} !== 4'b0000) begin
            $display("ERROR: I2S outputs did not return low after ENABLE=0");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: AXI access, I2S serialization, and sample-rate checks verified.");
        else
            $display("FAIL: %0d testbench check(s) failed.", errors);
        $finish;
    end

    initial begin
        #(5_000_000);
        $display("FAIL: simulation timeout");
        $finish;
    end
endmodule
