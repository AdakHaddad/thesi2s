
`timescale 1 ns / 1 ps

module axi_7seg_v1_0_S00_AXI #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)(
    // 7-segment outputs
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an,

    // AXI Lite Slave Interface
    input  wire                                S_AXI_ACLK,
    input  wire                                S_AXI_ARESETN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       S_AXI_AWADDR,
    input  wire [2:0]                          S_AXI_AWPROT,
    input  wire                                S_AXI_AWVALID,
    output wire                                S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0]       S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]   S_AXI_WSTRB,
    input  wire                                S_AXI_WVALID,
    output wire                                S_AXI_WREADY,
    output wire [1:0]                          S_AXI_BRESP,
    output wire                                S_AXI_BVALID,
    input  wire                                S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       S_AXI_ARADDR,
    input  wire [2:0]                          S_AXI_ARPROT,
    input  wire                                S_AXI_ARVALID,
    output wire                                S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0]       S_AXI_RDATA,
    output wire [1:0]                          S_AXI_RRESP,
    output wire                                S_AXI_RVALID,
    input  wire                                S_AXI_RREADY
);

    // AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr;
    reg        axi_awready;
    reg        axi_wready;
    reg [1:0]  axi_bresp;
    reg        axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr;
    reg        axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
    reg [1:0]  axi_rresp;
    reg        axi_rvalid;

    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;

    // Slave registers
    // slv_reg0[15:0] = 16-bit hex display value (4 nibbles = 4 digits)
    // slv_reg1[0]    = display enable
    // slv_reg1[7:4]  = decimal point select (1 bit per digit)
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
    wire slv_reg_wren;
    wire slv_reg_rden;
    reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // ========================================================
    // Write address handshake
    // ========================================================
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awready <= 1'b0;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
                axi_awready <= 1'b1;
            else
                axi_awready <= 1'b0;
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_awaddr <= 0;
        else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            axi_awaddr <= S_AXI_AWADDR;
    end

    // ========================================================
    // Write data handshake
    // ========================================================
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_wready <= 1'b0;
        else if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end

    // ========================================================
    // Write register logic
    // ========================================================
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;
            slv_reg2 <= 0;
            slv_reg3 <= 0;
        end else if (slv_reg_wren) begin
            case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
                2'h0:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h1:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h2:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                2'h3:
                    for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
                        if (S_AXI_WSTRB[byte_index] == 1)
                            slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                default: begin
                    slv_reg0 <= slv_reg0;
                    slv_reg1 <= slv_reg1;
                    slv_reg2 <= slv_reg2;
                    slv_reg3 <= slv_reg3;
                end
            endcase
        end
    end

    // ========================================================
    // Write response
    // ========================================================
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_bvalid <= 0;
            axi_bresp  <= 2'b0;
        end else begin
            if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0;
            end else if (S_AXI_BREADY && axi_bvalid)
                axi_bvalid <= 1'b0;
        end
    end

    // ========================================================
    // Read address handshake
    // ========================================================
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 0;
        end else begin
            if (~axi_arready && S_AXI_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr  <= S_AXI_ARADDR;
            end else
                axi_arready <= 1'b0;
        end
    end

    // ========================================================
    // Read data
    // ========================================================
    always @(*) begin
        case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
            2'h0: reg_data_out = slv_reg0;
            2'h1: reg_data_out = slv_reg1;
            2'h2: reg_data_out = slv_reg2;
            2'h3: reg_data_out = slv_reg3;
            default: reg_data_out = 0;
        endcase
    end

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end else begin
            if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0;
            end else if (axi_rvalid && S_AXI_RREADY)
                axi_rvalid <= 1'b0;
        end
    end

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            axi_rdata <= 0;
        else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            axi_rdata <= reg_data_out;
    end

    // ========================================================
    // USER LOGIC: 7-Segment Display Controller
    // ========================================================

    wire        display_en = slv_reg1[0];
    wire [3:0]  dp_sel     = slv_reg1[7:4];
    wire [15:0] hex_data   = slv_reg0[15:0];

    // Refresh counter for digit multiplexing
    // At 100MHz, 18-bit counter gives ~381Hz refresh per digit (~1.5kHz total)
    reg [17:0] refresh_counter;
    wire [1:0] digit_sel = refresh_counter[17:16];

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // Select which nibble to display based on active digit
    reg [3:0] current_nibble;
    reg [3:0] anode_reg;
    reg       dp_reg;

    always @(*) begin
        case (digit_sel)
            2'b00: begin
                current_nibble = hex_data[3:0];
                anode_reg      = 4'b1110;
                dp_reg         = ~dp_sel[0];
            end
            2'b01: begin
                current_nibble = hex_data[7:4];
                anode_reg      = 4'b1101;
                dp_reg         = ~dp_sel[1];
            end
            2'b10: begin
                current_nibble = hex_data[11:8];
                anode_reg      = 4'b1011;
                dp_reg         = ~dp_sel[2];
            end
            2'b11: begin
                current_nibble = hex_data[15:12];
                anode_reg      = 4'b0111;
                dp_reg         = ~dp_sel[3];
            end
        endcase
    end

    // Hex to 7-segment decoder (active LOW, common anode)
    //   seg[0]=a, seg[1]=b, seg[2]=c, seg[3]=d,
    //   seg[4]=e, seg[5]=f, seg[6]=g
    reg [6:0] seg_reg;

    always @(*) begin
        case (current_nibble)
            4'h0: seg_reg = 7'b1000000; // 0
            4'h1: seg_reg = 7'b1111001; // 1
            4'h2: seg_reg = 7'b0100100; // 2
            4'h3: seg_reg = 7'b0110000; // 3
            4'h4: seg_reg = 7'b0011001; // 4
            4'h5: seg_reg = 7'b0010010; // 5
            4'h6: seg_reg = 7'b0000010; // 6
            4'h7: seg_reg = 7'b1111000; // 7
            4'h8: seg_reg = 7'b0000000; // 8
            4'h9: seg_reg = 7'b0010000; // 9
            4'hA: seg_reg = 7'b0001000; // A
            4'hB: seg_reg = 7'b0000011; // b
            4'hC: seg_reg = 7'b1000110; // C
            4'hD: seg_reg = 7'b0100001; // d
            4'hE: seg_reg = 7'b0000110; // E
            4'hF: seg_reg = 7'b0001110; // F
            default: seg_reg = 7'b1111111;
        endcase
    end

    // Output: display enabled or all OFF
    assign seg = display_en ? seg_reg : 7'b1111111;
    assign dp  = display_en ? dp_reg  : 1'b1;
    assign an  = display_en ? anode_reg : 4'b1111;

endmodule
