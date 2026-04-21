// =============================================================================
// i2s_slave_lite_v1_0_S00_AXI.v
//
// I2S Transmitter AXI4-Lite Slave — v1
//
// Description:
//   AXI4-Lite peripheral that serialises stereo PCM samples to the Philips
//   I2S bus.  Implements 16-bit samples (in 32-bit slots) driven from a
//   single "packed sample" register (slv_reg0) plus a simple control
//   register (slv_reg1).
//
// Register Map (byte offsets):
//   0x00  slv_reg0  DATA    RW   [31:16]=L sample, [15:0]=R sample
//   0x04  slv_reg1  CTRL    RW   [0]=play, [1]=mute, [2]=fs_mode
//                                  fs_mode=0 → BCLK=audio_clk/8  (~48 kHz WS)
//                                  fs_mode=1 → BCLK=audio_clk/4  (~96 kHz WS)
//   0x08  slv_reg2  STATUS  RO   [0]=serializer_active, [1]=frame_start pulse
//   0x0C  slv_reg3  ID      RO   0x49325301  ('I','2','S',1)
//
// I2S Output Format (Philips standard, 32-bit slot):
//   • 64 BCLK per stereo frame (32 left + 32 right)
//   • MSB-first; first data bit follows WS edge by 1 BCLK (standard delay)
//   • Slot: [31:16] = 16-bit sample, [15:0] = 0 (padding)
//   • WS=0 → LEFT channel, WS=1 → RIGHT channel
//
// Clock domains:
//   S_AXI_ACLK  — AXI bus (register file, write/read FSM)
//   audio_clk   — I2S serialiser (BCLK generator, WS, DATA)
//
// CDC strategy (simulation-grade):
//   • Control bits (slv_reg1[2:0]) are double-synchronised to audio_clk.
//   • Sample data (slv_reg0) is latched into sample_q in audio_clk domain
//     at every frame boundary (bit_cnt==0 on a BCLK rising edge).
//
// =============================================================================
`timescale 1ns / 1ps

module i2s_slave_lite_v1_0_S00_AXI #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)(
    // ── I2S outputs ──────────────────────────────────────────────────────────
    output wire  i2s_bclk,
    output wire  i2s_ws,
    output wire  i2s_data,
    output wire  i2s_mclk,   // Not driven (tied low); PCM5102A does not need it

    // ── Audio clock (from MMCM / Clocking Wizard) ────────────────────────────
    input  wire  audio_clk,  // 24.56897 MHz nominal

    // ── AXI4-Lite slave interface ─────────────────────────────────────────────
    input  wire                                S_AXI_ACLK,
    input  wire                                S_AXI_ARESETN,
    // Write address channel
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]      S_AXI_AWADDR,
    input  wire [2:0]                          S_AXI_AWPROT,
    input  wire                                S_AXI_AWVALID,
    output wire                                S_AXI_AWREADY,
    // Write data channel
    input  wire [C_S_AXI_DATA_WIDTH-1:0]      S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]  S_AXI_WSTRB,
    input  wire                                S_AXI_WVALID,
    output wire                                S_AXI_WREADY,
    // Write response channel
    output wire [1:0]                          S_AXI_BRESP,
    output wire                                S_AXI_BVALID,
    input  wire                                S_AXI_BREADY,
    // Read address channel
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]      S_AXI_ARADDR,
    input  wire [2:0]                          S_AXI_ARPROT,
    input  wire                                S_AXI_ARVALID,
    output wire                                S_AXI_ARREADY,
    // Read data channel
    output wire [C_S_AXI_DATA_WIDTH-1:0]      S_AXI_RDATA,
    output wire [1:0]                          S_AXI_RRESP,
    output wire                                S_AXI_RVALID,
    input  wire                                S_AXI_RREADY
);

// ============================================================================
// AXI4-Lite Register File (S_AXI_ACLK domain)
// ============================================================================
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;  // DATA:   [31:16]=L, [15:0]=R
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;  // CTRL:   [2:0]
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;  // STATUS: RO (driven from audio domain)
    // slv_reg3 = ID, read-only constant

    localparam ID_VALUE = 32'h49325301; // 'I','2','S', version 1

    // -- AXI handshake state --------------------------------------------------
    reg  axi_awready, axi_wready, axi_bvalid;
    reg  axi_arready, axi_rvalid;
    reg  [1:0] axi_bresp, axi_rresp;
    reg  [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;

    wire aw_en = S_AXI_AWVALID && S_AXI_WVALID && (!axi_bvalid || S_AXI_BREADY) &&
                 (!axi_awready);
    wire  w_en = S_AXI_AWVALID && S_AXI_WVALID && (!axi_bvalid || S_AXI_BREADY) &&
                 (!axi_wready);

    // Write address ready
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN)  axi_awready <= 1'b0;
        else                 axi_awready <= aw_en;
    end

    // Write data ready
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN)  axi_wready <= 1'b0;
        else                 axi_wready <= w_en;
    end

    // Write response
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else if (axi_awready && S_AXI_AWVALID && axi_wready && S_AXI_WVALID) begin
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b00; // OKAY
        end else if (S_AXI_BREADY && axi_bvalid) begin
            axi_bvalid <= 1'b0;
        end
    end

    // Register write logic (byte-enable aware)
    wire [1:0] wr_addr = S_AXI_AWADDR[3:2]; // word index
    integer byte_index;
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            slv_reg0 <= 32'd0;
            slv_reg1 <= 32'd0;
        end else if (axi_awready && S_AXI_AWVALID && axi_wready && S_AXI_WVALID) begin
            case (wr_addr)
                2'd0: for (byte_index=0; byte_index<=3; byte_index=byte_index+1)
                          if (S_AXI_WSTRB[byte_index])
                              slv_reg0[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];
                2'd1: for (byte_index=0; byte_index<=3; byte_index=byte_index+1)
                          if (S_AXI_WSTRB[byte_index])
                              slv_reg1[(byte_index*8)+:8] <= S_AXI_WDATA[(byte_index*8)+:8];
                // 2'd2 and 2'd3 are read-only; writes silently ignored
                default: ;
            endcase
        end
    end

    // Read address ready
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN)  axi_arready <= 1'b0;
        else                 axi_arready <= ~axi_arready && S_AXI_ARVALID;
    end

    // Read data
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
        end else if (axi_arready && S_AXI_ARVALID && !axi_rvalid) begin
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b00;
        end else if (axi_rvalid && S_AXI_RREADY) begin
            axi_rvalid <= 1'b0;
        end
    end

    wire [1:0] rd_addr = S_AXI_ARADDR[3:2];
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rdata <= 32'd0;
        end else if (axi_arready && S_AXI_ARVALID && !axi_rvalid) begin
            case (rd_addr)
                2'd0:    axi_rdata <= slv_reg0;
                2'd1:    axi_rdata <= slv_reg1;
                2'd2:    axi_rdata <= slv_reg2;   // STATUS
                2'd3:    axi_rdata <= ID_VALUE;   // ID
                default: axi_rdata <= 32'd0;
            endcase
        end
    end

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

// ============================================================================
// Cross-Domain Synchronisers (AXI domain → audio_clk domain)
// ============================================================================
    // Double-synchroniser for control bits [2:0]
    reg [2:0] ctrl_meta, ctrl_sync_b;  // ctrl_sync_b exposed for direct-drive TB
    always @(posedge audio_clk) begin
        ctrl_meta   <= slv_reg1[2:0];
        ctrl_sync_b <= ctrl_meta;
    end

    // slv_reg0 is latched at frame boundaries (see serialiser below)

// ============================================================================
// I2S Serialiser (audio_clk domain)
// ============================================================================
    // ── BCLK generator ───────────────────────────────────────────────────────
    // fs_mode=0: DIV=4 → BCLK=audio_clk/8  ≈ 3.071 MHz → WS ≈ 47.99 kHz
    // fs_mode=1: DIV=2 → BCLK=audio_clk/4  ≈ 6.142 MHz → WS ≈ 95.97 kHz
    reg [2:0] bclk_cnt;
    reg       bclk_r;

    wire [2:0] bclk_div = ctrl_sync_b[2] ? 3'd2 : 3'd4;

    // Detect BCLK rising / falling edge (one audio_clk cycle before the toggle)
    wire bclk_rise = (bclk_cnt == bclk_div - 1) && !bclk_r;
    wire bclk_fall = (bclk_cnt == bclk_div - 1) &&  bclk_r;

    always @(posedge audio_clk) begin
        if (!S_AXI_ARESETN) begin
            bclk_cnt <= 3'd0;
            bclk_r   <= 1'b0;
        end else begin
            if (bclk_cnt == bclk_div - 1) begin
                bclk_cnt <= 3'd0;
                bclk_r   <= ~bclk_r;
            end else begin
                bclk_cnt <= bclk_cnt + 1'b1;
            end
        end
    end

    // ── Bit counter (advances on BCLK rising edge) ────────────────────────────
    reg [5:0] bit_cnt;   // 0..63 within one stereo frame

    always @(posedge audio_clk) begin
        if (!S_AXI_ARESETN) begin
            bit_cnt <= 6'd0;
        end else if (bclk_rise) begin
            bit_cnt <= bit_cnt + 1'b1;  // wraps 63 → 0
        end
    end

    // ── Sample latch: capture slv_reg0 at the START of each new frame ─────────
    reg [31:0] sample_q;  // [31:16]=L, [15:0]=R  (audio_clk domain)

    always @(posedge audio_clk) begin
        if (!S_AXI_ARESETN) begin
            sample_q <= 32'd0;
        end else if (bclk_rise && (bit_cnt == 6'd0)) begin
            // Latch fresh sample at frame start
            // Note: simple CDC - acceptable for v1 "single register" design
            sample_q <= slv_reg0;
        end
    end

    // ── WS (Word Select / LRCK) ──────────────────────────────────────────────
    // WS=0 during LEFT slot (bit_cnt 0..31), WS=1 during RIGHT slot (32..63).
    // Per Philips I2S: WS transitions on the BCLK falling edge,
    // one BCLK before the first bit of the new channel.
    reg ws_r;

    always @(posedge audio_clk) begin
        if (!S_AXI_ARESETN) begin
            ws_r <= 1'b0;
        end else if (bclk_fall) begin
            // Transition WS at the boundary bits (31→32 and 63→0)
            if (bit_cnt == 6'd31 || bit_cnt == 6'd63)
                ws_r <= ~ws_r;
        end
    end

    // ── Serial DATA output ────────────────────────────────────────────────────
    // Philips I2S: data changes on BCLK falling edge; receiver samples on rising.
    // Slot layout (32 bits per channel):
    //   Bit 0 after WS edge : 0  (1-bit delay / dummy)
    //   Bits 1..16           : sample MSB-first
    //   Bits 17..31          : 0 (padding)
    //
    // bit_cnt[5]=0 → left slot,  sample bits come from sample_q[31:16]
    // bit_cnt[5]=1 → right slot, sample bits come from sample_q[15:0]
    //
    // Within the slot, position 0 is the "delay" bit; position 1 is MSB.
    // bit_cnt[4:0] gives position within the 32-bit slot.
    reg data_r;

    wire [4:0] slot_pos = bit_cnt[4:0];   // 0..31 within current channel slot
    wire       is_right = bit_cnt[5];

    always @(posedge audio_clk) begin
        if (!S_AXI_ARESETN) begin
            data_r <= 1'b0;
        end else if (bclk_fall) begin
            if (!ctrl_sync_b[0] || ctrl_sync_b[1]) begin
                // Not playing OR muted → send silence
                data_r <= 1'b0;
            end else begin
                // slot_pos==0 : 1-bit Philips delay (output 0)
                // slot_pos 1..16 : sample data MSB-first
                // slot_pos 17..31: padding zeros
                if (slot_pos >= 5'd1 && slot_pos <= 5'd16) begin
                    // Sample bit index: 15 - (slot_pos - 1) = 16 - slot_pos
                    if (!is_right)
                        data_r <= sample_q[16 - slot_pos + 16]; // L: sample_q[31:16]
                    else
                        data_r <= sample_q[16 - slot_pos];       // R: sample_q[15:0]
                end else begin
                    data_r <= 1'b0;
                end
            end
        end
    end

    // ── Output assignments ────────────────────────────────────────────────────
    assign i2s_bclk = bclk_r;
    assign i2s_ws   = ws_r;
    assign i2s_data = data_r;
    assign i2s_mclk = 1'b0;  // Not required for PCM5102A in this design

    // ── STATUS register feedback to AXI domain (async read, informational) ───
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN)
            slv_reg2 <= 32'd0;
        else
            slv_reg2[0] <= ctrl_sync_b[0]; // serializer active
    end

endmodule
