`timescale 1 ns / 1 ps

// ============================================================================
// Module      : i2s_slave_lite_v1_0_S00_AXI
// Description : I2S transmitter peripheral with AXI4-Lite register interface.
//               Accepts stereo PCM samples and control parameters from a
//               MicroBlaze processor over AXI4-Lite, then serialises the
//               samples to a Philips I2S bitstream consumed by a PCM5102A DAC.
//
// Clock domains
// -------------
//   S_AXI_ACLK    : 100 MHz — AXI bus and register file
//   audio_48_clk  : 24.576 MHz — 48/96 kHz Fs family
//   audio_44_clk  : 22.579 MHz — 44.1/88.2 kHz Fs family
//   internal_mclk : selected audio clock, chosen by clk_mux below
//
// Clock family selection
// ----------------------
//   FS_FAMILY (CONTROL bit 2) selects internal_mclk at runtime:
//     0 -> audio_48_clk (48/96 kHz)
//     1 -> audio_44_clk (44.1/88.2 kHz)
//
//   The mux is implemented as a robust glitch-free clock multiplexer (clk_mux)
//   using negedge-synchronized enables. This ensures no glitches occur during
//   switching even if the clocks are asynchronous.
//
//   On Xilinx targets, a BUFG is automatically inserted after the fabric mux
//   to ensure the selected clock is distributed via the global clock network,
//   meeting timing for all internal sequential logic.
//
//   If the target device provides a dedicated glitch-free clock mux primitive
//   (like BUFGMUX on Xilinx or ALTCLKCTRL on Intel), it can be used instead
//   for even better performance.
//
// Register Map
// ------------
//   Offset   Name         Direction   Description
//   0x00     DATA_LEFT    W           Left-channel PCM sample
//   0x04     DATA_RIGHT   W           Right-channel PCM sample
//   0x08     CONTROL      R/W         Enable, mute, Fs selection, sample width
//   0x0C     RESERVED     R/W         bit[0] = latch status (read-only)
//
// DATA packing
// ------------
//   DATA_LEFT  : bits [SAMPLE_WIDTH-1:0] carry the left  sample, MSB-justified
//   DATA_RIGHT : bits [SAMPLE_WIDTH-1:0] carry the right sample, MSB-justified
//   Upper bits are ignored by the serialiser.
//
// CONTROL bitfield
// ----------------
//   Bit(s)   Field         Default   Description
//   0        ENABLE        0         1 = I2S output active; 0 = all outputs held low
//   1        MUTE          0         1 = force DATA line to zero; clocks continue
//   2        FS_FAMILY     0         0 = 48/96 kHz family; 1 = 44.1/88.2 kHz family
//   3        FS_MODE       0         0 = standard Fs; 1 = double Fs (x2)
//   7:4      RESERVED      0         Write ignored, reads as zero
//   12:8     SAMPLE_WIDTH  32        Payload bits per channel slot (1-32).
//                                    Writing 0 defaults to 32.
//   31:13    RESERVED      0         Write ignored, reads as zero
//
// Fs truth table (FS_FAMILY x FS_MODE)
// -------------------------------------
//   FS_FAMILY   FS_MODE   Nominal Fs
//   0           0         48   kHz
//   1           0         44.1 kHz
//   0           1         96   kHz
//   1           1         88.2 kHz
//
// Philips I2S timing contract
// ---------------------------
//   WS LOW  = left  channel slot (bit_count 0-31)
//   WS HIGH = right channel slot (bit_count 32-63)
//   Bit 0 after every WS edge is a mandatory one-cycle delay (outputs 0).
//   Data bits follow MSB-first for SAMPLE_WIDTH cycles, then zero-padded.
//   DATA is updated on the falling edge of BCLK and sampled by the DAC
//   on the rising edge of BCLK, satisfying the Philips I2S setup requirement.
//
// Firmware usage example
// ----------------------
//   I2S_REG(0x00) = left_sample  & ((1u << SAMPLE_WIDTH) - 1);
//   I2S_REG(0x04) = right_sample & ((1u << SAMPLE_WIDTH) - 1);
//   I2S_REG(0x08) = (1u << 0) | (1u << 3) | (24u << 8);
//   // ENABLE=1, FS_MODE=1 (96 kHz), SAMPLE_WIDTH=24
//
// ============================================================================

// ----------------------------------------------------------------------------
// clk_mux — robust glitch-free clock multiplexer
//
// Selects between two clock inputs without glitches on the output.
// This implementation uses a standard negedge-synchronized enable pattern
// that is portable across ASIC and FPGA flows while being glitch-free.
//
// Port map:
//   clk0   : clock input 0 (selected when sel = 0)
//   clk1   : clock input 1 (selected when sel = 1)
//   sel    : select signal (asynchronous to both clocks)
//   clk_o  : glitch-free clock output
// ----------------------------------------------------------------------------
module clk_mux (
    input  wire clk0,
    input  wire clk1,
    input  wire sel,
    output wire clk_o
);
    (* ASYNC_REG = "TRUE" *) reg q0_d1 = 1'b0, q0_d2 = 1'b0;
    (* ASYNC_REG = "TRUE" *) reg q1_d1 = 1'b0, q1_d2 = 1'b0;

    // Domain 0: enable only if sel=0 and domain 1 is disabled.
    // Use negedge to ensure clk0 is low when enable transitions, avoiding glitches.
    always @(negedge clk0) begin
        q0_d1 <= !sel & !q1_d2;
        q0_d2 <= q0_d1;
    end

    // Domain 1: enable only if sel=1 and domain 0 is disabled.
    // Use negedge to ensure clk1 is low when enable transitions, avoiding glitches.
    always @(negedge clk1) begin
        q1_d1 <= sel & !q0_d2;
        q1_d2 <= q1_d1;
    end

    // Output is a simple OR of the gated clocks.
    assign clk_o = (q0_d2 & clk0) | (q1_d2 & clk1);
endmodule


// ----------------------------------------------------------------------------
// cdc_sync — vendor-neutral two-stage synchroniser
//
// Transfers a multi-bit bus from one clock domain to another.
// ASYNC_REG is honoured by Vivado and Quartus for placement guidance and
// is safely ignored by toolchains that do not recognise it.
//
// Latency : 2 dest_clk cycles.
// ----------------------------------------------------------------------------
module cdc_sync #(
    parameter integer WIDTH = 32
) (
    input  wire             dest_clk,
    input  wire [WIDTH-1:0] src_in,
    output wire [WIDTH-1:0] dest_out
);
    (* ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] stage1_q;
    (* ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] stage2_q;

    always @(posedge dest_clk) begin
        stage1_q <= src_in;
        stage2_q <= stage1_q;
    end

    assign dest_out = stage2_q;
endmodule


// ----------------------------------------------------------------------------
// i2s_slave_lite_v1_0_S00_AXI — top-level I2S AXI4-Lite peripheral
// ----------------------------------------------------------------------------
module i2s_slave_lite_v1_0_S00_AXI #
(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)
(
    // Audio clock inputs — both must be stable before ENABLE is asserted.
    input  wire audio_48_clk,   // 24.576 MHz — 48/96 kHz Fs family
    input  wire audio_44_clk,   // 22.579 MHz — 44.1/88.2 kHz Fs family

    // I2S serial outputs — connect directly to PCM5102A PMOD pins.
    output wire i2s_mclk,
    output wire i2s_bclk,
    output wire i2s_ws,
    output wire i2s_data,

    // AXI4-Lite slave interface — standard Vivado port names, do not rename.
    input  wire                               S_AXI_ACLK,
    input  wire                               S_AXI_ARESETN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR,
    input  wire [2:0]                         S_AXI_AWPROT,
    input  wire                               S_AXI_AWVALID,
    output wire                               S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
    input  wire                               S_AXI_WVALID,
    output wire                               S_AXI_WREADY,
    output wire [1:0]                         S_AXI_BRESP,
    output wire                               S_AXI_BVALID,
    input  wire                               S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR,
    input  wire [2:0]                         S_AXI_ARPROT,
    input  wire                               S_AXI_ARVALID,
    output wire                               S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_RDATA,
    output wire [1:0]                         S_AXI_RRESP,
    output wire                               S_AXI_RVALID,
    input  wire                               S_AXI_RREADY
);

// ----------------------------------------------------------------------------
// AXI4-Lite internal handshake registers.
// ----------------------------------------------------------------------------
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr;
    reg  axi_awready;
    reg  axi_wready;
    reg [1:0] axi_bresp;
    reg  axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr;
    reg  axi_arready;
    reg [1:0] axi_rresp;
    reg  axi_rvalid;

    localparam integer ADDR_LSB          = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;

// ----------------------------------------------------------------------------
// Slave register file.
// ----------------------------------------------------------------------------
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;  // DATA_LEFT
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;  // DATA_RIGHT
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;  // CONTROL
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;  // RESERVED
    integer byte_index;

    localparam [1:0] REG_DATA_LEFT  = 2'h0;
    localparam [1:0] REG_DATA_RIGHT = 2'h1;
    localparam [1:0] REG_CONTROL    = 2'h2;
    localparam [1:0] REG_RESERVED   = 2'h3;

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    reg [1:0] state_write;
    reg [1:0] state_read;

    localparam Idle  = 2'b00;
    localparam Waddr = 2'b10;
    localparam Wdata = 2'b11;
    localparam Raddr = 2'b10;
    localparam Rdata = 2'b11;

// ----------------------------------------------------------------------------
// AXI4-Lite write state machine.
// ----------------------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awready <= 0;
            axi_wready  <= 0;
            axi_bvalid  <= 0;
            axi_bresp   <= 0;
            axi_awaddr  <= 0;
            state_write <= Idle;
        end else begin
            case (state_write)
                Idle: begin
                    if (S_AXI_ARESETN == 1'b1) begin
                        axi_awready <= 1'b1;
                        axi_wready  <= 1'b1;
                        state_write <= Waddr;
                    end else
                        state_write <= state_write;
                end
                Waddr: begin
                    if (S_AXI_AWVALID && S_AXI_AWREADY) begin
                        axi_awaddr <= S_AXI_AWADDR;
                        if (S_AXI_WVALID) begin
                            axi_awready <= 1'b1;
                            state_write <= Waddr;
                            axi_bvalid  <= 1'b1;
                        end else begin
                            axi_awready <= 1'b0;
                            state_write <= Wdata;
                            if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;
                        end
                    end else begin
                        state_write <= state_write;
                        if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;
                    end
                end
                Wdata: begin
                    if (S_AXI_WVALID) begin
                        state_write <= Waddr;
                        axi_bvalid  <= 1'b1;
                        axi_awready <= 1'b1;
                    end else begin
                        state_write <= state_write;
                        if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;
                    end
                end
            endcase
        end
    end

// ----------------------------------------------------------------------------
// Register write logic.
// slv_reg3[0] is read-only latch status — writes to that bit are ignored.
// ----------------------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;
            slv_reg2 <= 0;
            slv_reg3 <= 0;
        end else begin
            if (S_AXI_WVALID) begin
                case ((S_AXI_AWVALID) ?
                        S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] :
                        axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
                    REG_DATA_LEFT:
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                            if (S_AXI_WSTRB[byte_index])
                                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    REG_DATA_RIGHT:
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                            if (S_AXI_WSTRB[byte_index])
                                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    REG_CONTROL:
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                            if (S_AXI_WSTRB[byte_index])
                                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    REG_RESERVED:
                        for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                            if (S_AXI_WSTRB[byte_index]) begin
                                if (byte_index == 0)
                                    slv_reg3[7:1] <= S_AXI_WDATA[7:1];
                                else
                                    slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                            end
                    default: begin
                        slv_reg0 <= slv_reg0;
                        slv_reg1 <= slv_reg1;
                        slv_reg2 <= slv_reg2;
                        slv_reg3 <= slv_reg3;
                    end
                endcase
            end
        end
    end

// ----------------------------------------------------------------------------
// AXI4-Lite read state machine.
// slv_reg3[0] is overridden on readback with the live latch status bit.
// ----------------------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_arready <= 1'b0;
            axi_rvalid  <= 1'b0;
            axi_rresp   <= 1'b0;
            state_read  <= Idle;
        end else begin
            case (state_read)
                Idle: begin
                    if (S_AXI_ARESETN == 1'b1) begin
                        state_read  <= Raddr;
                        axi_arready <= 1'b1;
                    end else
                        state_read <= state_read;
                end
                Raddr: begin
                    if (S_AXI_ARVALID && S_AXI_ARREADY) begin
                        state_read  <= Rdata;
                        axi_araddr  <= S_AXI_ARADDR;
                        axi_rvalid  <= 1'b1;
                        axi_arready <= 1'b0;
                    end else
                        state_read <= state_read;
                end
                Rdata: begin
                    if (S_AXI_RVALID && S_AXI_RREADY) begin
                        axi_rvalid  <= 1'b0;
                        axi_arready <= 1'b1;
                        state_read  <= Raddr;
                    end else
                        state_read <= state_read;
                end
            endcase
        end
    end

    assign S_AXI_RDATA =
        (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h0) ? slv_reg0 :
        (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h1) ? slv_reg1 :
        (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h2) ? slv_reg2 :
        (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h3) ? {slv_reg3[31:1], current_latch_status} : 0;

// ============================================================================
// Audio datapath
// ============================================================================

    reg [5:0]  bit_count_q;
    reg [31:0] sample_left_q;
    reg [31:0] sample_right_q;

// ----------------------------------------------------------------------------
// Section 1 : Clock family selection (behavioral glitch-free mux)
//
// FS_FAMILY (CONTROL bit 2) selects internal_mclk at runtime.
// The raw register bit is used directly as the mux select because the
// clk_mux module guarantees a glitch-free transition — no CDC is needed
// on the select line for this path.
//
//   reg_fs_family = 0 -> audio_48_clk (24.576 MHz) -> 48/96 kHz
//   reg_fs_family = 1 -> audio_44_clk (22.579 MHz) -> 44.1/88.2 kHz
// ----------------------------------------------------------------------------
    wire reg_fs_family  = slv_reg2[2];
    wire internal_mclk_unbuf;
    wire internal_mclk;

`ifdef XILINX
    // On Xilinx, we can either use BUFGMUX for best performance
    // or use our fabric clk_mux followed by a BUFG.
    // To remain "independent", we use clk_mux + BUFG here.
    clk_mux mclk_mux_inst (
        .clk0  (audio_48_clk),
        .clk1  (audio_44_clk),
        .sel   (reg_fs_family),
        .clk_o (internal_mclk_unbuf)
    );

    BUFG mclk_bufg_inst (
        .I(internal_mclk_unbuf),
        .O(internal_mclk)
    );
`else
    // Fabric-friendly behavioral mux for open-source flows
    clk_mux mclk_mux_inst (
        .clk0  (audio_48_clk),
        .clk1  (audio_44_clk),
        .sel   (reg_fs_family),
        .clk_o (internal_mclk)
    );
`endif

// ----------------------------------------------------------------------------
// Section 2 : Clock domain crossing — AXI -> audio (vendor-neutral)
//
// Three independent two-stage synchronisers transfer the slave registers
// into the internal_mclk domain.  cdc_sync uses only behavioural flip-flops
// and the ASYNC_REG attribute, making it portable across all toolchains.
// ----------------------------------------------------------------------------
    wire [31:0] ctrl_cdc_w;
    wire [31:0] sample_left_cdc_w;
    wire [31:0] sample_right_cdc_w;

    cdc_sync #(.WIDTH(32)) cdc_ctrl_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg2),
        .dest_out (ctrl_cdc_w)
    );

    cdc_sync #(.WIDTH(32)) cdc_left_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg0),
        .dest_out (sample_left_cdc_w)
    );

    cdc_sync #(.WIDTH(32)) cdc_right_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg1),
        .dest_out (sample_right_cdc_w)
    );

// ----------------------------------------------------------------------------
// Section 3 : Control field extraction
//
// All control signals are derived from the CDC-synchronised control word.
// FS_FAMILY (bit 2) is consumed by the clk_mux select above and is not
// decoded here as an audio-domain signal.
// sample_width_sync defaults to 32 when firmware writes zero.
// ----------------------------------------------------------------------------
    wire       enable_sync       = ctrl_cdc_w[0];
    wire       mute_sync         = ctrl_cdc_w[1];
    wire       fs_mode_sync      = ctrl_cdc_w[3];
    wire [5:0] sample_width_sync = (ctrl_cdc_w[12:8] == 5'd0) ? 6'd32
                                                               : {1'b0, ctrl_cdc_w[12:8]};

    reg mclk_q;
    reg bclk_q;
    reg ws_q;
    reg data_q;
    reg sample_req_q;

// ----------------------------------------------------------------------------
// Mute and enable gating.
// ENABLE=0 holds all outputs low and resets bit_count_q.
// MUTE=1 forces sample data to zero while clocks continue.
// ----------------------------------------------------------------------------
    wire [31:0] sample_for_i2s_left  = (enable_sync && !mute_sync) ? sample_left_q  : 32'd0;
    wire [31:0] sample_for_i2s_right = (enable_sync && !mute_sync) ? sample_right_q : 32'd0;

// ----------------------------------------------------------------------------
// Section 4 : Power-on reset for the audio clock domain
//
// A four-bit shift register initialised to 1111 releases audio_rst after
// four internal_mclk cycles.  Self-timed — no dependency on S_AXI_ARESETN.
// ----------------------------------------------------------------------------
    reg [3:0] audio_por_q = 4'b1111;
    always @(posedge internal_mclk)
        audio_por_q <= {audio_por_q[2:0], 1'b0};
    wire audio_rst = audio_por_q[3];

// ----------------------------------------------------------------------------
// Section 5 : Clock divider and BCLK enable
//
//   FS_MODE = 0 : bclk_en_w every 4 cycles -> BCLK = mclk/8 -> WS = 48/44.1 kHz
//   FS_MODE = 1 : bclk_en_w every 2 cycles -> BCLK = mclk/4 -> WS = 96/88.2 kHz
//
// mclk_q toggles every cycle producing MCLK = internal_mclk / 2.
// ----------------------------------------------------------------------------
    reg [2:0] clock_div_q;

    always @(posedge internal_mclk or posedge audio_rst) begin
        if (audio_rst) begin
            mclk_q      <= 1'b0;
            clock_div_q <= 3'b0;
        end else begin
            mclk_q      <= !mclk_q;
            clock_div_q <= clock_div_q + 3'd1;
        end
    end

    wire bclk_en_w = fs_mode_sync ? (clock_div_q[0]  == 1'b0)
                                  : (clock_div_q[1:0] == 2'd0);

// ----------------------------------------------------------------------------
// Section 6 : Sample latch
//
// New PCM values are captured at the start of each stereo frame
// (bit_count_q = 0, falling BCLK edge) to prevent mid-word corruption.
// mclk_latch_toggle_q toggles on every latch event and is synchronised
// back to the AXI domain so firmware can poll REG_RESERVED[0] for confirmation.
// ----------------------------------------------------------------------------
    reg mclk_latch_toggle_q = 1'b0;

    always @(posedge internal_mclk or posedge audio_rst) begin
        if (audio_rst) begin
            sample_left_q       <= 32'd0;
            sample_right_q      <= 32'd0;
            mclk_latch_toggle_q <= 1'b0;
        end else if (bclk_en_w && !bclk_q && (bit_count_q == 6'd0)) begin
            sample_left_q       <= sample_left_cdc_w;
            sample_right_q      <= sample_right_cdc_w;
            mclk_latch_toggle_q <= !mclk_latch_toggle_q;
        end
    end

    (* ASYNC_REG = "TRUE" *) reg [2:0] axi_latch_sync_q;
    always @(posedge S_AXI_ACLK)
        axi_latch_sync_q <= {axi_latch_sync_q[1:0], mclk_latch_toggle_q};

    wire current_latch_status = axi_latch_sync_q[2];

// ----------------------------------------------------------------------------
// Section 7 : Philips I2S serialiser function
//
//   bit_count 0-31  : left  channel slot (WS LOW)
//   bit_count 32-63 : right channel slot (WS HIGH)
//   pos 0           : delay bit = 0 (mandatory Philips one-cycle delay)
//   pos 1           : MSB of sample
//   pos 2..width    : remaining bits MSB-first
//   pos > width     : zero padding
// ----------------------------------------------------------------------------
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

// ----------------------------------------------------------------------------
// Section 8 : I2S output generator
//
// Falling edge : update DATA and WS, increment bit_count
// Rising edge  : assert BCLK (DAC samples DATA here); pulse sample_req at
//                bit_count = 0 to signal a new stereo frame
// ENABLE = 0   : hold all outputs low, reset bit_count to 0
// ----------------------------------------------------------------------------
    always @(posedge internal_mclk or posedge audio_rst) begin
        if (audio_rst) begin
            bit_count_q  <= 6'd0;
            data_q       <= 1'b0;
            ws_q         <= 1'b0;
            bclk_q       <= 1'b0;
            sample_req_q <= 1'b0;
        end else if (bclk_en_w) begin
            if (!enable_sync) begin
                bit_count_q  <= 6'd0;
                data_q       <= 1'b0;
                ws_q         <= 1'b0;
                bclk_q       <= 1'b0;
                sample_req_q <= 1'b0;
            end else begin
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
                    if (bit_count_q == 6'd0)
                        sample_req_q <= 1'b1;
                end
            end
        end else
            sample_req_q <= 1'b0;
    end

// ----------------------------------------------------------------------------
// Section 9 : Output assignments
//
// All signals driven from registered sources for glitch-free PMOD output
// and safe ILA probing without IOB register conflicts.
// ----------------------------------------------------------------------------
    assign i2s_mclk = mclk_q;
    assign i2s_ws   = ws_q;
    assign i2s_bclk = bclk_q;
    assign i2s_data = data_q;

endmodule