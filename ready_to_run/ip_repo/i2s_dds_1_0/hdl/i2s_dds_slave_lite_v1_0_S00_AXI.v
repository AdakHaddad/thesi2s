`timescale 1 ns / 1 ps

// ============================================================================
// Module      : i2s_dds_slave_lite_v1_0_S00_AXI
// Description : AXI4-Lite controlled I2S transmitter.
//
// The RTL contains no DDS/waveform generator. Firmware writes PCM samples to
// DATA_LEFT/DATA_RIGHT and controls only enable, mute, sample width, and sample
// rate. The legacy IP name and audio_48_clk/audio_44_clk ports are retained for
// existing block-design compatibility.
//
// Register map
// ------------
//   Offset   Name         Direction   Description
//   0x00     DATA_LEFT    R/W         Left-channel PCM sample
//   0x04     DATA_RIGHT   R/W         Right-channel PCM sample
//   0x08     CONTROL      R/W         Bit fields below
//   0x0C     STATUS       R/W         bit0 toggles each stereo frame latch
//
// CONTROL bitfield
// ----------------
//   Bit(s)   Field            Description
//   0        ENABLE           1 = transmit I2S; 0 = hold outputs low
//   1        MUTE             1 = transmit zero data while clocks continue
//   6:2      SAMPLE_WIDTH     Audio payload width. Values 1-31 are literal;
//                             0 encodes 32 bits because the field is 5 bits.
//   26:7     SAMPLE_RATE_HZ   Target sample rate in Hz
//   31:27    RESERVED         Ignored on write, read as zero
// ============================================================================

module i2s_dds_slave_lite_v1_0_S00_AXI #
(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)
(
    input  wire audio_48_clk,
    input  wire audio_44_clk,

    output wire i2s_mclk,
    output wire i2s_bclk,
    output wire i2s_ws,
    output wire i2s_data,

    input  wire                                      S_AXI_ACLK,
    input  wire                                      S_AXI_ARESETN,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]           S_AXI_AWADDR,
    input  wire [2:0]                                S_AXI_AWPROT,
    input  wire                                      S_AXI_AWVALID,
    output wire                                      S_AXI_AWREADY,
    input  wire [C_S00_AXI_DATA_WIDTH-1:0]           S_AXI_WDATA,
    input  wire [(C_S00_AXI_DATA_WIDTH/8)-1:0]       S_AXI_WSTRB,
    input  wire                                      S_AXI_WVALID,
    output wire                                      S_AXI_WREADY,
    output wire [1:0]                                S_AXI_BRESP,
    output wire                                      S_AXI_BVALID,
    input  wire                                      S_AXI_BREADY,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]           S_AXI_ARADDR,
    input  wire [2:0]                                S_AXI_ARPROT,
    input  wire                                      S_AXI_ARVALID,
    output wire                                      S_AXI_ARREADY,
    output wire [C_S00_AXI_DATA_WIDTH-1:0]           S_AXI_RDATA,
    output wire [1:0]                                S_AXI_RRESP,
    output wire                                      S_AXI_RVALID,
    input  wire                                      S_AXI_RREADY
);

    localparam integer ADDR_LSB          = (C_S00_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;

    localparam [1:0] REG_DATA_LEFT  = 2'h0;
    localparam [1:0] REG_DATA_RIGHT = 2'h1;
    localparam [1:0] REG_CONTROL    = 2'h2;
    localparam [1:0] REG_STATUS     = 2'h3;

    localparam [31:0] CONTROL_MASK    = 32'h07FF_FFFF;
    localparam [31:0] DEFAULT_CONTROL = (32'd48000 << 7);

    reg [C_S00_AXI_ADDR_WIDTH-1:0] axi_awaddr;
    reg [C_S00_AXI_ADDR_WIDTH-1:0] axi_araddr;
    reg [C_S00_AXI_DATA_WIDTH-1:0] axi_rdata;
    reg axi_awready;
    reg axi_wready;
    reg [1:0] axi_bresp;
    reg axi_bvalid;
    reg axi_arready;
    reg [1:0] axi_rresp;
    reg axi_rvalid;
    reg aw_en;

    reg [C_S00_AXI_DATA_WIDTH-1:0] slv_reg0;
    reg [C_S00_AXI_DATA_WIDTH-1:0] slv_reg1;
    reg [C_S00_AXI_DATA_WIDTH-1:0] slv_reg2;
    reg [C_S00_AXI_DATA_WIDTH-1:0] slv_reg3;
    integer byte_index;

    wire slv_reg_wren;
    wire slv_reg_rden;
    reg [C_S00_AXI_DATA_WIDTH-1:0] reg_data_out;
    wire [1:0] write_addr = axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
    wire [1:0] read_addr  = axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
    assign slv_reg_rden = axi_arready && S_AXI_ARVALID && !axi_rvalid;

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_awready <= 1'b0;
            aw_en       <= 1'b1;
        end else begin
            if (!axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
                axi_awready <= 1'b1;
                axi_awaddr  <= S_AXI_AWADDR;
                aw_en       <= 1'b0;
            end else if (S_AXI_BREADY && axi_bvalid) begin
                aw_en       <= 1'b1;
                axi_awready <= 1'b0;
            end else begin
                axi_awready <= 1'b0;
            end
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_wready <= 1'b0;
        end else begin
            if (!axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en)
                axi_wready <= 1'b1;
            else
                axi_wready <= 1'b0;
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            slv_reg0 <= 32'd0;
            slv_reg1 <= 32'd0;
            slv_reg2 <= DEFAULT_CONTROL;
            slv_reg3 <= 32'd0;
        end else if (slv_reg_wren) begin
            case (write_addr)
                REG_DATA_LEFT:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1)
                        if (S_AXI_WSTRB[byte_index])
                            slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];

                REG_DATA_RIGHT:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1)
                        if (S_AXI_WSTRB[byte_index])
                            slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];

                REG_CONTROL: begin
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1)
                        if (S_AXI_WSTRB[byte_index])
                            slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    slv_reg2[31:27] <= 5'd0;
                end

                REG_STATUS:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1)
                        if (S_AXI_WSTRB[byte_index])
                            slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
            endcase
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else begin
            if (slv_reg_wren && !axi_bvalid) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00;
            end else if (S_AXI_BREADY && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_arready <= 1'b0;
            axi_araddr  <= {C_S00_AXI_ADDR_WIDTH{1'b0}};
        end else begin
            if (!axi_arready && S_AXI_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr  <= S_AXI_ARADDR;
            end else begin
                axi_arready <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (read_addr)
            REG_DATA_LEFT:  reg_data_out = slv_reg0;
            REG_DATA_RIGHT: reg_data_out = slv_reg1;
            REG_CONTROL:    reg_data_out = slv_reg2 & CONTROL_MASK;
            REG_STATUS:     reg_data_out = {slv_reg3[31:1], current_latch_status_q};
            default:        reg_data_out = 32'd0;
        endcase
    end

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
            axi_rdata  <= 32'd0;
        end else begin
            if (slv_reg_rden) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00;
                axi_rdata  <= reg_data_out;
            end else if (axi_rvalid && S_AXI_RREADY) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

    localparam [31:0] AXI_CLK_HZ             = 32'd100_000_000;
    localparam [19:0] DEFAULT_SAMPLE_RATE_HZ = 20'd48000;
    localparam [19:0] MAX_SAFE_FS_HZ         = 20'd195312;

    wire        enable_sync       = slv_reg2[0];
    wire        mute_sync         = slv_reg2[1];
    wire [4:0]  sample_width_raw  = slv_reg2[6:2];
    wire [19:0] sample_rate_raw   = slv_reg2[26:7];
    wire [5:0]  sample_width_sync = (sample_width_raw == 5'd0) ? 6'd32
                                                               : {1'b0, sample_width_raw};
    wire [19:0] sample_rate_nonzero = (sample_rate_raw == 20'd0) ? DEFAULT_SAMPLE_RATE_HZ
                                                                 : sample_rate_raw;
    wire [19:0] sample_rate_sync = (sample_rate_nonzero > MAX_SAFE_FS_HZ)
                                 ? MAX_SAFE_FS_HZ
                                 : sample_rate_nonzero;

    wire [31:0] bclk_toggle_rate_hz = {sample_rate_sync, 7'b0};
    wire [31:0] mclk_toggle_rate_hz = {sample_rate_sync, 9'b0};
    wire [31:0] bclk_phase_sum      = bclk_phase_acc_q + bclk_toggle_rate_hz;
    wire [31:0] mclk_phase_sum      = mclk_phase_acc_q + mclk_toggle_rate_hz;
    wire        bclk_phase_wrap     = (bclk_phase_sum >= AXI_CLK_HZ);
    wire        mclk_phase_wrap     = (mclk_phase_sum >= AXI_CLK_HZ);

    reg [31:0] bclk_phase_acc_q;
    reg [31:0] mclk_phase_acc_q;
    reg [5:0]  bit_count_q;
    reg [31:0] sample_left_q;
    reg [31:0] sample_right_q;
    reg        mclk_q;
    reg        bclk_q;
    reg        ws_q;
    reg        data_q;
    reg        current_latch_status_q;

    wire [31:0] sample_for_i2s_left  = mute_sync ? 32'd0 : sample_left_q;
    wire [31:0] sample_for_i2s_right = mute_sync ? 32'd0 : sample_right_q;

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
            if (pos == 5'd0) begin
                i2s_next_serial_bit = 1'b0;
            end else if (pos <= width) begin
                bit_idx = width - {1'b0, pos};
                i2s_next_serial_bit = in_left ? left_samp[bit_idx[4:0]]
                                              : right_samp[bit_idx[4:0]];
            end else begin
                i2s_next_serial_bit = 1'b0;
            end
        end
    endfunction

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            bclk_phase_acc_q       <= 32'd0;
            mclk_phase_acc_q       <= 32'd0;
            bit_count_q            <= 6'd0;
            sample_left_q          <= 32'd0;
            sample_right_q         <= 32'd0;
            mclk_q                 <= 1'b0;
            bclk_q                 <= 1'b0;
            ws_q                   <= 1'b0;
            data_q                 <= 1'b0;
            current_latch_status_q <= 1'b0;
        end else if (!enable_sync) begin
            bclk_phase_acc_q <= 32'd0;
            mclk_phase_acc_q <= 32'd0;
            bit_count_q      <= 6'd0;
            mclk_q           <= 1'b0;
            bclk_q           <= 1'b0;
            ws_q             <= 1'b0;
            data_q           <= 1'b0;
        end else begin
            if (mclk_phase_wrap) begin
                mclk_phase_acc_q <= mclk_phase_sum - AXI_CLK_HZ;
                mclk_q           <= !mclk_q;
            end else begin
                mclk_phase_acc_q <= mclk_phase_sum;
            end

            if (bclk_phase_wrap) begin
                bclk_phase_acc_q <= bclk_phase_sum - AXI_CLK_HZ;

                if (bclk_q) begin
                    bclk_q      <= 1'b0;
                    data_q      <= i2s_next_serial_bit(
                                       sample_for_i2s_left,
                                       sample_for_i2s_right,
                                       bit_count_q,
                                       sample_width_sync);
                    ws_q        <= bit_count_q[5];
                    bit_count_q <= bit_count_q + 6'd1;
                end else begin
                    bclk_q <= 1'b1;
                    if (bit_count_q == 6'd0) begin
                        sample_left_q          <= slv_reg0;
                        sample_right_q         <= slv_reg1;
                        current_latch_status_q <= !current_latch_status_q;
                    end
                end
            end else begin
                bclk_phase_acc_q <= bclk_phase_sum;
            end
        end
    end

    assign i2s_mclk = mclk_q;
    assign i2s_ws   = ws_q;
    assign i2s_bclk = bclk_q;
    assign i2s_data = data_q;

    wire _unused_inputs = audio_48_clk ^ audio_44_clk ^ S_AXI_AWPROT[0] ^
                          S_AXI_AWPROT[1] ^ S_AXI_AWPROT[2] ^
                          S_AXI_ARPROT[0] ^ S_AXI_ARPROT[1] ^
                          S_AXI_ARPROT[2];

endmodule
