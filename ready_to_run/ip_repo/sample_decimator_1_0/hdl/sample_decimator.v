`timescale 1ns / 1ps

module sample_decimator #(
    parameter DIV = 5
)(
    input  wire             clk,
    input  wire signed [15:0] sample_in,
    input  wire             valid_in,
    output reg  signed [15:0] sample_out,
    output reg              valid_out
);

    integer count_q = 0;

    always @(posedge clk) begin
        valid_out <= 1'b0;
        if (valid_in) begin
            if (count_q == 0) begin
                sample_out <= sample_in;
                valid_out  <= 1'b1;
                count_q <= (DIV == 0) ? 0 : (DIV - 1);
            end else begin
                count_q <= count_q - 1;
            end
        end
    end

endmodule
