`timescale 1ns / 1ps

module sample_rate_switch (
    input  wire              clk,
    input  wire              resetn,
    input  wire signed [15:0] sample_in,
    input  wire              valid_in,
    input  wire [3:0]        rate_sel,
    output reg  signed [15:0] sample_out,
    output reg               valid_out
);

    reg [7:0] count_q;
    wire [7:0] div_now = decode_div(rate_sel);

    function [7:0] decode_div;
        input [3:0] sel;
        begin
            case (sel)
                4'd0:  decode_div = 8'd1;
                4'd1:  decode_div = 8'd2;
                4'd2:  decode_div = 8'd3;
                4'd3:  decode_div = 8'd4;
                4'd4:  decode_div = 8'd5;
                4'd5:  decode_div = 8'd6;
                4'd6:  decode_div = 8'd8;
                4'd7:  decode_div = 8'd10;
                4'd8:  decode_div = 8'd12;
                4'd9:  decode_div = 8'd16;
                4'd10: decode_div = 8'd20;
                4'd11: decode_div = 8'd24;
                4'd12: decode_div = 8'd32;
                4'd13: decode_div = 8'd48;
                4'd14: decode_div = 8'd64;
                default: decode_div = 8'd128;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (!resetn) begin
            count_q   <= 8'd0;
            sample_out <= 16'sd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                if (count_q == 8'd0) begin
                    sample_out <= sample_in;
                    valid_out  <= 1'b1;
                    count_q    <= (div_now <= 8'd1) ? 8'd0 : (div_now - 8'd1);
                end else begin
                    count_q <= count_q - 8'd1;
                end
            end
        end
    end

endmodule