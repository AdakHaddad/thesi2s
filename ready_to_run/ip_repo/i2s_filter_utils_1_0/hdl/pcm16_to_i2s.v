`timescale 1ns / 1ps

module pcm16_to_i2s (
    input  wire clk,
    input  wire enable,
    input  wire mute,
    input  wire signed [15:0] sample_left_in,
    input  wire signed [15:0] sample_right_in,
    output wire i2s_mclk,
    output wire i2s_bclk,
    output wire i2s_ws,
    output wire i2s_data
);

    reg [3:0] por_q = 4'b1111;
    always @(posedge clk)
        por_q <= {por_q[2:0], 1'b0};

    wire rst = por_q[3];

    reg mclk_q = 1'b0;
    reg bclk_q = 1'b0;
    reg ws_q = 1'b0;
    reg data_q = 1'b0;
    reg [2:0] clock_div_q = 3'd0;
    reg [5:0] bit_count_q = 6'd0;
    reg signed [15:0] left_q = 16'sd0;
    reg signed [15:0] right_q = 16'sd0;

    function next_i2s_bit;
        input signed [15:0] left_samp;
        input signed [15:0] right_samp;
        input [5:0] bc;
        reg in_left;
        reg [4:0] pos;
        begin
            in_left = (bc < 6'd32);
            pos = bc[4:0];

            if (pos == 5'd0)
                next_i2s_bit = 1'b0;
            else if (pos <= 5'd16)
                next_i2s_bit = in_left ? left_samp[5'd16 - pos]
                                       : right_samp[5'd16 - pos];
            else
                next_i2s_bit = 1'b0;
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            mclk_q      <= 1'b0;
            bclk_q      <= 1'b0;
            ws_q        <= 1'b0;
            data_q      <= 1'b0;
            clock_div_q <= 3'd0;
            bit_count_q <= 6'd0;
            left_q      <= 16'sd0;
            right_q     <= 16'sd0;
        end else begin
            mclk_q      <= !mclk_q;
            clock_div_q <= clock_div_q + 3'd1;

            if (clock_div_q[1:0] == 2'd0) begin
                if (!enable) begin
                    bclk_q      <= 1'b0;
                    ws_q        <= 1'b0;
                    data_q      <= 1'b0;
                    bit_count_q <= 6'd0;
                end else begin
                    if (!bclk_q && (bit_count_q == 6'd0)) begin
                        left_q  <= mute ? 16'sd0 : sample_left_in;
                        right_q <= mute ? 16'sd0 : sample_right_in;
                    end

                    if (bclk_q) begin
                        bclk_q      <= 1'b0;
                        data_q      <= next_i2s_bit(left_q, right_q, bit_count_q);
                        ws_q        <= bit_count_q[5];
                        bit_count_q <= bit_count_q + 6'd1;
                    end else begin
                        bclk_q <= 1'b1;
                    end
                end
            end
        end
    end

    assign i2s_mclk = mclk_q;
    assign i2s_bclk = bclk_q;
    assign i2s_ws   = ws_q;
    assign i2s_data = data_q;

endmodule
