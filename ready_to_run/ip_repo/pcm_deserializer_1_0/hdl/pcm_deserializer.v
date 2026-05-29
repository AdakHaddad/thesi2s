`timescale 1ns / 1ps

module pcm_deserializer (
    input  wire audio_48_clk,
    input  wire audio_44_clk,
    input  wire fs_family,
    input  wire fs_mode,
    input  wire i2s_bclk,
    input  wire i2s_ws,
    input  wire i2s_data,
    output reg  signed [31:0] sample_left_out,
    output reg  signed [31:0] sample_right_out,
    output reg                sample_valid
);

    // Create internal_mclk via BUFGMUX (same selection pattern)
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

    // Generate bclk enable from internal_mclk in same way as serializer
    reg mclk_q;
    reg [2:0] clock_div_q;
    reg [5:0] bit_count_q;
    reg [31:0] shift_left_q;
    reg [31:0] shift_right_q;

    always @(posedge internal_mclk) begin
        mclk_q      <= !mclk_q;
        clock_div_q <= clock_div_q + 3'd1;
    end

    wire bclk_en_w = fs_mode ? (clock_div_q[0]  == 1'b0)
                              : (clock_div_q[1:0] == 2'd0);

    // Sample the serial line on falling edge of bclk (as in original core)
    reg i2s_bclk_d;
    reg i2s_ws_d;
    reg i2s_data_d;

    always @(posedge internal_mclk) begin
        i2s_bclk_d <= i2s_bclk;
        i2s_ws_d   <= i2s_ws;
        i2s_data_d <= i2s_data;
    end

    // Reconstruct serial stream
    always @(posedge internal_mclk) begin
        if (!bclk_en_w) begin
            sample_valid <= 1'b0;
        end else begin
            if (i2s_bclk_d) begin
                // falling edge occurs: capture next serial bit
                // ws_d indicates current channel (0=left,1=right)
                if (i2s_ws_d == 1'b0) begin
                    // left channel
                    shift_left_q <= (shift_left_q << 1) | {31'd0, i2s_data_d};
                end else begin
                    // right channel
                    shift_right_q <= (shift_right_q << 1) | {31'd0, i2s_data_d};
                end
                bit_count_q <= bit_count_q + 6'd1;
                // When bit_count wraps (after 64 bits), produce valid at start of next frame
                if (bit_count_q == 6'd63) begin
                    // Completed a stereo frame; present samples next cycle
                    sample_left_out  <= shift_left_q;
                    sample_right_out <= shift_right_q;
                    sample_valid     <= 1'b1;
                end else begin
                    sample_valid <= 1'b0;
                end
            end else begin
                sample_valid <= 1'b0;
            end
        end
    end

endmodule
