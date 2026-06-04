`timescale 1ns / 1ps

module filter_clock_divider (
    input  wire clk_in,
    input  wire resetn,
    output wire clk_out
);

    reg clk_q = 1'b0;

    always @(posedge clk_in or negedge resetn) begin
        if (!resetn)
            clk_q <= 1'b0;
        else
            clk_q <= ~clk_q;
    end

    assign clk_out = clk_q;

endmodule