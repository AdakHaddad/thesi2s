`timescale 1ns / 1ps

module pcm_serializer (
    input  wire audio_48_clk,
    input  wire audio_44_clk,
    input  wire fs_family,
    input  wire fs_mode,
    input  wire enable,
    input  wire mute,
    input  wire [5:0] sample_width,
    input  wire signed [31:0] sample_left_in,
    input  wire signed [31:0] sample_right_in,
    output wire i2s_mclk,
    output wire i2s_bclk,
    output wire i2s_ws,
    output wire i2s_data
);

    // Create internal_mclk via BUFGMUX
    (* ASYNC_REG = "TRUE" *) reg fs_family_stage1_q;
    (* ASYNC_REG = "TRUE" *) reg fs_family_sync_q;
    always @(posedge audio_48_clk) begin
        fs_family_stage1_q <= fs_family;
        fs_family_sync_q   <= fs_family_stage1_q;
    end

    wire internal_mclk;
    BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) mclk_mux (
        .O  (internal_mclk),
        .I0 (audio_48_clk),
        .I1 (audio_44_clk),
        .S  (fs_family_sync_q)
    );

    // Clock divider and bclk enable generation (same as original core)
    reg mclk_q;
    reg [2:0] clock_div_q;
    reg [5:0] bit_count_q;
    reg data_q;
    reg ws_q;
    reg bclk_q;

    always @(posedge internal_mclk) begin
        mclk_q      <= !mclk_q;
        clock_div_q <= clock_div_q + 3'd1;
    end

    wire bclk_en_w = fs_mode ? (clock_div_q[0]  == 1'b0)
                              : (clock_div_q[1:0] == 2'd0);

    // i2s_next_serial_bit function (copied/adapted)
    function i2s_next_serial_bit;
        input [31:0] left_samp;
        input [31:0] right_samp;
        input [5:0]  bc;
        input [5:0]  width;
        reg          in_left;
        reg  [4:0]   pos;
        reg  [5:0]   bit_idx;
        begin
            in_left = (bc < 6'd32);
            pos     = bc[4:0];
            if (width == 6'd0)
                i2s_next_serial_bit = 1'b0;
            else if (pos == 5'd0)
                i2s_next_serial_bit = 1'b0;
            else if (pos <= width) begin
                bit_idx = width - {1'b0, pos};
                i2s_next_serial_bit = in_left ? left_samp[bit_idx[4:0]]
                                              : right_samp[bit_idx[4:0]];
            end else
                i2s_next_serial_bit = 1'b0;
        end
    endfunction

    // I2S output generator
    always @(posedge internal_mclk) begin
        if (!bclk_en_w) begin
            // nothing, keep state
        end else begin
            if (!enable) begin
                bit_count_q <= 6'd0;
                data_q      <= 1'b0;
                ws_q        <= 1'b0;
                bclk_q      <= 1'b0;
            end else begin
                if (bclk_q) begin
                    bclk_q      <= 1'b0;
                    data_q      <= i2s_next_serial_bit(
                                       (enable && !mute) ? sample_left_in  : 32'd0,
                                       (enable && !mute) ? sample_right_in : 32'd0,
                                       bit_count_q,
                                       sample_width);
                    ws_q        <= bit_count_q[5];
                    bit_count_q <= bit_count_q + 6'd1;
                end else begin
                    bclk_q <= 1'b1;
                end
            end
        end
    end

    assign i2s_mclk = mclk_q;
    assign i2s_ws   = ws_q;
    assign i2s_bclk = bclk_q;
    assign i2s_data = data_q;

endmodule
