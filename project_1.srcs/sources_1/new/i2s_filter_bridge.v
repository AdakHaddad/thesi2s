`timescale 1ns / 1ps

// I2S/parallel adapter used to place the existing 16-bit filter_coeff RTL
// after the existing AXI I2S transmitter without modifying either block.
//
// The incoming stream is Philips I2S with one delay bit and 32 BCLK slots per
// channel.  The first 16 payload bits are filtered; the remaining slot bits
// are emitted as zero.  Filtered audio is delayed by one stereo frame.
module i2s_filter_bridge (
    input  wire               clk,
    input  wire               resetn,

    input  wire [2:0]         filter_sw_in,
    output wire [2:0]         filter_sw_out,

    input  wire               i2s_mclk_in,
    input  wire               i2s_bclk_in,
    input  wire               i2s_ws_in,
    input  wire               i2s_data_in,

    output wire               i2s_mclk_out,
    output wire               i2s_bclk_out,
    output wire               i2s_ws_out,
    output reg                i2s_data_out,

    output reg                left_valid,
    output reg  signed [15:0] left_sample,
    input  wire signed [15:0] left_filtered,

    output reg                right_valid,
    output reg  signed [15:0] right_sample,
    input  wire signed [15:0] right_filtered
);

    // The clocks are not regenerated.  Only SDATA passes through the adapter.
    assign i2s_mclk_out = i2s_mclk_in;
    assign i2s_bclk_out = i2s_bclk_in;
    assign i2s_ws_out   = i2s_ws_in;

    // Physical switches are asynchronous to clk.  The filters only observe
    // the synchronized value on a sample-valid pulse.
    (* ASYNC_REG = "TRUE" *) reg [2:0] filter_sw_meta;
    (* ASYNC_REG = "TRUE" *) reg [2:0] filter_sw_sync;
    assign filter_sw_out = filter_sw_sync;

    reg bclk_d;
    reg rx_ws;
    reg tx_ws;
    reg rx_initial_gap;
    reg tx_initial_gap;
    reg [5:0] rx_bit_pos;
    reg [5:0] tx_bit_pos;
    reg [15:0] rx_shift;

    reg signed [15:0] tx_left;
    reg signed [15:0] tx_right;
    reg left_result_d1;
    reg left_result_d2;
    reg right_result_d1;
    reg right_result_d2;
    reg filters_primed;

    wire bclk_rise =  i2s_bclk_in & ~bclk_d;
    wire bclk_fall = ~i2s_bclk_in &  bclk_d;

    always @(posedge clk) begin
        if (!resetn) begin
            filter_sw_meta     <= 3'd0;
            filter_sw_sync     <= 3'd0;
            bclk_d             <= 1'b0;
            rx_ws              <= 1'b0;
            tx_ws              <= 1'b0;
            rx_initial_gap     <= 1'b1;
            tx_initial_gap     <= 1'b1;
            rx_bit_pos         <= 6'd0;
            tx_bit_pos         <= 6'd0;
            rx_shift           <= 16'd0;
            left_sample        <= 16'sd0;
            right_sample       <= 16'sd0;
            left_valid         <= 1'b0;
            right_valid        <= 1'b0;
            tx_left            <= 16'sd0;
            tx_right           <= 16'sd0;
            left_result_d1      <= 1'b0;
            left_result_d2      <= 1'b0;
            right_result_d1     <= 1'b0;
            right_result_d2     <= 1'b0;
            filters_primed     <= 1'b0;
            i2s_data_out       <= 1'b0;
        end else begin
            filter_sw_meta <= filter_sw_in;
            filter_sw_sync <= filter_sw_meta;
            bclk_d         <= i2s_bclk_in;

            left_valid  <= 1'b0;
            right_valid <= 1'b0;
            left_result_d2  <= left_result_d1;
            left_result_d1  <= 1'b0;
            right_result_d2 <= right_result_d1;
            right_result_d1 <= 1'b0;

            // Give coefficient registers a deterministic selection before
            // the first real sample reaches either existing filter instance.
            if (!filters_primed) begin
                left_valid     <= 1'b1;
                right_valid    <= 1'b1;
                left_sample    <= 16'sd0;
                right_sample   <= 16'sd0;
                filters_primed <= 1'b1;
            end

            // filter_coeff updates y_out on the valid clock edge.  Capture it
            // one clk later, leaving ample time before the next stereo frame.
            if (left_result_d2) begin
                tx_left <= left_filtered;
            end
            if (right_result_d2) begin
                tx_right <= right_filtered;
            end

            // Receive the source I2S stream on BCLK rising edges.  A WS
            // transition marks the I2S delay bit, which is deliberately skipped.
            if (bclk_rise) begin
                if (i2s_ws_in != rx_ws) begin
                    rx_ws          <= i2s_ws_in;
                    rx_bit_pos     <= 6'd0;
                    rx_initial_gap <= 1'b0;
                end else if (rx_initial_gap) begin
                    rx_initial_gap <= 1'b0;
                    rx_bit_pos     <= 6'd0;
                end else if (rx_bit_pos < 6'd16) begin
                    rx_shift   <= {rx_shift[14:0], i2s_data_in};
                    rx_bit_pos <= rx_bit_pos + 6'd1;

                    if (rx_bit_pos == 6'd15) begin
                        if (!i2s_ws_in) begin
                            left_sample         <= {rx_shift[14:0], i2s_data_in};
                            left_valid          <= 1'b1;
                            left_result_d1      <= 1'b1;
                        end else begin
                            right_sample         <= {rx_shift[14:0], i2s_data_in};
                            right_valid          <= 1'b1;
                            right_result_d1      <= 1'b1;
                        end
                    end
                end
            end

            // Set filtered SDATA after each BCLK falling edge.  It remains
            // stable for the receiver's following rising edge.
            if (bclk_fall) begin
                if (i2s_ws_in != tx_ws) begin
                    tx_ws          <= i2s_ws_in;
                    tx_bit_pos     <= 6'd0;
                    tx_initial_gap <= 1'b0;
                    i2s_data_out   <= 1'b0;
                end else if (tx_initial_gap) begin
                    tx_initial_gap <= 1'b0;
                    tx_bit_pos     <= 6'd0;
                    i2s_data_out   <= 1'b0;
                end else if (tx_bit_pos < 6'd16) begin
                    i2s_data_out <= i2s_ws_in
                                  ? tx_right[15 - tx_bit_pos]
                                  : tx_left[15 - tx_bit_pos];
                    tx_bit_pos   <= tx_bit_pos + 6'd1;
                end else begin
                    i2s_data_out <= 1'b0;
                end
            end
        end
    end

endmodule
