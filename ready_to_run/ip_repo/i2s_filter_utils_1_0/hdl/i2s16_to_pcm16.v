`timescale 1ns / 1ps

module i2s16_to_pcm16 (
    input  wire clk,
    input  wire i2s_bclk,
    input  wire i2s_ws,
    input  wire i2s_data,
    output reg  signed [15:0] sample_left,
    output reg  signed [15:0] sample_right,
    output reg                 sample_valid
);

    (* ASYNC_REG = "TRUE" *) reg [2:0] bclk_sync = 3'b000;
    (* ASYNC_REG = "TRUE" *) reg [2:0] ws_sync   = 3'b000;
    (* ASYNC_REG = "TRUE" *) reg [2:0] data_sync = 3'b000;

    always @(posedge clk) begin
        bclk_sync <= {bclk_sync[1:0], i2s_bclk};
        ws_sync   <= {ws_sync[1:0],   i2s_ws};
        data_sync <= {data_sync[1:0], i2s_data};
    end

    wire bclk_fall = bclk_sync[2] & ~bclk_sync[1];
    wire ws_s      = ws_sync[2];
    wire data_s    = data_sync[2];

    reg ws_prev = 1'b0;
    reg [5:0] bit_pos = 6'd0;
    reg signed [15:0] left_shift = 16'sd0;
    reg signed [15:0] right_shift = 16'sd0;

    always @(posedge clk) begin
        sample_valid <= 1'b0;

        if (bclk_fall) begin
            if (ws_s != ws_prev) begin
                if (ws_prev && !ws_s) begin
                    sample_left  <= left_shift;
                    sample_right <= right_shift;
                    sample_valid <= 1'b1;
                end

                ws_prev <= ws_s;
                bit_pos <= 6'd0;

                if (ws_s)
                    right_shift <= 16'sd0;
                else
                    left_shift <= 16'sd0;
            end else begin
                if (bit_pos < 6'd16) begin
                    if (ws_s)
                        right_shift <= {right_shift[14:0], data_s};
                    else
                        left_shift <= {left_shift[14:0], data_s};
                end

                if (bit_pos != 6'd63)
                    bit_pos <= bit_pos + 6'd1;
            end
        end
    end

endmodule
