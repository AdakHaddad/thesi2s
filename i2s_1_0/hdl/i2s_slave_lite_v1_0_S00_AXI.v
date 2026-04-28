
`timescale 1 ns / 1 ps

// ============================================================================
// I2S AXI4-Lite Register Documentation
// ============================================================================
//
// This RTL implements an I2S transmitter peripheral controlled through a
// compact AXI4-Lite register interface. The intended firmware contract is a
// 3-register map for the main datapath plus one reserved word for future use.
//
// Register Map
// ---------------------------------------------------------------------------
// Offset   Name         Function
// 0x00     DATA_LEFT    Left-channel audio sample payload
// 0x04     DATA_RIGHT   Right-channel audio sample payload
// 0x08     CONTROL      Enable, mute, sampling mode, and sample width
// 0x0C     RESERVED     Future expansion / status / debug
//
// DATA packing
// ---------------------------------------------------------------------------
// DATA_LEFT  : [31:SAMPLE_WIDTH] = 0, [SAMPLE_WIDTH-1:0] = left sample
// DATA_RIGHT : [31:SAMPLE_WIDTH] = 0, [SAMPLE_WIDTH-1:0] = right sample
//
// CONTROL bitfield
// ---------------------------------------------------------------------------
// Bit(s)   Field         Default  Description
// 0        ENABLE        0        1 = output active, 0 = output disabled
// 1        MUTE          0        1 = force audio data to zero
// 2        FS_MODE       0        0/1 = switch nominal Fs family
// 3        FS_FAMILY     0        0 = 48/96 kHz family, 1 = 44.1/88.2 kHz family
// 7:4      RESERVED      0        Reserved for future extensions
// 12:8     SAMPLE_WIDTH  24       Sample bit-width per channel (1..32)
// 31:13    RESERVED      0        Reserved
//
// Example firmware usage
// ---------------------------------------------------------------------------
//   I2S_REG(0x00) = sample_left  & ((1u << SAMPLE_WIDTH) - 1);
//   I2S_REG(0x04) = sample_right & ((1u << SAMPLE_WIDTH) - 1);
//   I2S_REG(0x08) = (1u << 0) | (1u << 2) | (24u << 8);
//
// Notes
// ---------------------------------------------------------------------------
// - The register map above is the documented programming model for the IP.
// - Reserved bits/registers are intentionally kept for future-proofing.
// - The firmware should write DATA_LEFT / DATA_RIGHT before enabling output.
//
// ============================================================================

	module i2s_slave_lite_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
input wire audio_48_clk,
input wire audio_44_clk,
		output wire i2s_mclk,
		output wire i2s_bclk,
		output wire i2s_ws,
		output wire i2s_data,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 1;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	//   0x00 DATA_LEFT, 0x04 DATA_RIGHT, 0x08 CONTROL, 0x0C RESERVED
	reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
	integer	 byte_index;

	localparam [1:0] REG_DATA_LEFT  = 2'h0;
	localparam [1:0] REG_DATA_RIGHT = 2'h1;
	localparam [1:0] REG_CONTROL    = 2'h2;
	localparam [1:0] REG_RESERVED   = 2'h3;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	 //state machine varibles 
	 reg [1:0] state_write;
	 reg [1:0] state_read;
	 //State machine local parameters
	 localparam Idle = 2'b00,Raddr = 2'b10,Rdata = 2'b11 ,Waddr = 2'b10,Wdata = 2'b11;
	// Implement Write state machine
	// Outstanding write transactions are not supported by the slave i.e., master should assert bready to receive response on or before it starts sending the new transaction
	always @(posedge S_AXI_ACLK)                                 
	  begin                                 
	     if (S_AXI_ARESETN == 1'b0)                                 
	       begin                                 
	         axi_awready <= 0;                                 
	         axi_wready <= 0;                                 
	         axi_bvalid <= 0;                                 
	         axi_bresp <= 0;                                 
	         axi_awaddr <= 0;                                 
	         state_write <= Idle;                                 
	       end                                 
	     else                                  
	       begin                                 
	         case(state_write)                                 
	           Idle:                                      
	             begin                                 
	               if(S_AXI_ARESETN == 1'b1)                                  
	                 begin                                 
	                   axi_awready <= 1'b1;                                 
	                   axi_wready <= 1'b1;                                 
	                   state_write <= Waddr;                                 
	                 end                                 
	               else state_write <= state_write;                                 
	             end                                 
	           Waddr:        //At this state, slave is ready to receive address along with corresponding control signals and first data packet. Response valid is also handled at this state                                 
	             begin                                 
	               if (S_AXI_AWVALID && S_AXI_AWREADY)                                 
	                  begin                                 
	                    axi_awaddr <= S_AXI_AWADDR;                                 
	                    if(S_AXI_WVALID)                                  
	                      begin                                   
	                        axi_awready <= 1'b1;                                 
	                        state_write <= Waddr;                                 
	                        axi_bvalid <= 1'b1;                                 
	                      end                                 
	                    else                                  
	                      begin                                 
	                        axi_awready <= 1'b0;                                 
	                        state_write <= Wdata;                                 
	                        if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                      end                                 
	                  end                                 
	               else                                  
	                  begin                                 
	                    state_write <= state_write;                                 
	                    if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                   end                                 
	             end                                 
	          Wdata:        //At this state, slave is ready to receive the data packets until the number of transfers is equal to burst length                                 
	             begin                                 
	               if (S_AXI_WVALID)                                 
	                 begin                                 
	                   state_write <= Waddr;                                 
	                   axi_bvalid <= 1'b1;                                 
	                   axi_awready <= 1'b1;                                 
	                 end                                 
	                else                                  
	                 begin                                 
	                   state_write <= state_write;                                 
	                   if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                 end                                              
	             end                                 
	          endcase                                 
	        end                                 
	      end                                 

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      slv_reg0 <= 0;  // DATA_LEFT
	      slv_reg1 <= 0;  // DATA_RIGHT
	      slv_reg2 <= 0;  // CONTROL
	      slv_reg3 <= 0;  // RESERVED
	    end 
	  else begin
	    if (S_AXI_WVALID)
	      begin
	        case ( (S_AXI_AWVALID) ? S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] : axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          REG_DATA_LEFT:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // DATA_LEFT
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          REG_DATA_RIGHT:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // DATA_RIGHT
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          REG_CONTROL:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // CONTROL
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          REG_RESERVED:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // RESERVED
	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          default : begin
	                      slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      slv_reg3 <= slv_reg3;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement read state machine
	  always @(posedge S_AXI_ACLK)                                       
	    begin                                       
	      if (S_AXI_ARESETN == 1'b0)                                       
	        begin                                       
	         //asserting initial values to all 0's during reset                                       
	         axi_arready <= 1'b0;                                       
	         axi_rvalid <= 1'b0;                                       
	         axi_rresp <= 1'b0;                                       
	         state_read <= Idle;                                       
	        end                                       
	      else                                       
	        begin                                       
	          case(state_read)                                       
	            Idle:     //Initial state inidicating reset is done and ready to receive read/write transactions                                       
	              begin                                                
	                if (S_AXI_ARESETN == 1'b1)                                        
	                  begin                                       
	                    state_read <= Raddr;                                       
	                    axi_arready <= 1'b1;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	            Raddr:        //At this state, slave is ready to receive address along with corresponding control signals                                       
	              begin                                       
	                if (S_AXI_ARVALID && S_AXI_ARREADY)                                       
	                  begin                                       
	                    state_read <= Rdata;                                       
	                    axi_araddr <= S_AXI_ARADDR;                                       
	                    axi_rvalid <= 1'b1;                                       
	                    axi_arready <= 1'b0;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	            Rdata:        //At this state, slave is ready to send the data packets until the number of transfers is equal to burst length                                       
	              begin                                           
	                if (S_AXI_RVALID && S_AXI_RREADY)                                       
	                  begin                                       
	                    axi_rvalid <= 1'b0;                                       
	                    axi_arready <= 1'b1;                                       
	                    state_read <= Raddr;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	           endcase                                       
	          end                                       
	        end                                         
	// Implement memory mapped register select and read logic generation
	  assign S_AXI_RDATA = (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h0) ? slv_reg0 : (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h1) ? slv_reg1 : (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h2) ? slv_reg2 : (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 2'h3) ? slv_reg3 : 0; 
	// Add user logic here
	// ----------------------------------------------------------------------------
// Pure RTL 2-stage synchronizer — replaces xpm_cdc_array_single
// (* ASYNC_REG = "TRUE" *) keeps both FFs placed together by the toolchain
// and prevents optimisation across the CDC boundary.
// ----------------------------------------------------------------------------

 // -------------------------------------------------------------------------
    // Registers
    // -------------------------------------------------------------------------
    reg [5:0]  bit_count_q;
    reg [31:0] sample_left_q;
    reg [31:0] sample_right_q;

// =================================================================
    // 1. SAKLAR MASTER CLOCK (BUFGMUX)
    // Sesuai tabel: FS_FAMILY (Bit 2) -> 0=44.1k, 1=48k
    // =================================================================
    wire reg_fs_family = slv_reg1[2]; 

    wire internal_mclk; // Inilah clock utama (pengganti audio_clk lama)

    BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) mclk_mux (
       .O(internal_mclk), 
       .I0(audio_44_clk), // Dipilih jika FS_FAMILY = 0 (44.1k)
       .I1(audio_48_clk), // Dipilih jika FS_FAMILY = 1 (48k)
       .S(reg_fs_family) 
    );

    // =================================================================
    // 2. CLOCK DOMAIN CROSSING (CDC)
    // Menyeberangkan data dari AXI (100MHz) ke internal_mclk (~24MHz)
    // =================================================================
    wire [31:0] ctrl_cdc_w;
    wire [31:0] sample_left_cdc_w;
    wire [31:0] sample_right_cdc_w;

    cdc_array_sync #(.WIDTH(32)) cdc_ctrl_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg2),
        .dest_out (ctrl_cdc_w)
    );

    cdc_array_sync #(.WIDTH(32)) cdc_left_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg0),
        .dest_out (sample_left_cdc_w)
    );

    cdc_array_sync #(.WIDTH(32)) cdc_right_inst (
        .dest_clk (internal_mclk),
        .src_in   (slv_reg1),
        .dest_out (sample_right_cdc_w)
    );

    // -------------------------------------------------------------------------
    // 3. DECODE REGISTER CONTROL (Sesuai Bit Mapping Baru)
    // -------------------------------------------------------------------------
    wire       enable_sync       = ctrl_cdc_w[0];
    wire       mute_sync         = ctrl_cdc_w[1];
    wire       fs_family_sync    = ctrl_cdc_w[2]; // Bit 2
    wire       fs_mode_sync      = ctrl_cdc_w[3]; // Bit 3
    wire [4:0] sample_width_sync = (ctrl_cdc_w[12:8] == 5'd0) ? 5'd32 : ctrl_cdc_w[12:8]; // Fix bit 32

    // Output flops
    reg mclk_q;
    reg bclk_q;
    reg ws_q;
    reg data_q;
    reg sample_req_q;

    wire [31:0] sample_for_i2s_left  = (enable_sync && !mute_sync) ? sample_left_q  : 32'd0;
    wire [31:0] sample_for_i2s_right = (enable_sync && !mute_sync) ? sample_right_q : 32'd0;

    // Internal power-on reset
    reg [3:0] audio_por_q = 4'b1111;
    always @(posedge internal_mclk)
        audio_por_q <= {audio_por_q[2:0], 1'b0};
    wire audio_rst = audio_por_q[3];

    // -------------------------------------------------------------------------
    // 4. CLOCK DIVIDER (MESIN LAMA ANDA YANG BEKERJA SEMPURNA)
    // -------------------------------------------------------------------------
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

    // Menggunakan Mode dari bit 3 (0 = Low Fs, 1 = High Fs)
    wire bclk_en_w = fs_mode_sync ? (clock_div_q[1:0] == 2'd0) : (clock_div_q == 3'd0);

    // -------------------------------------------------------------------------
    // 5. SERIALIZER I2S
    // -------------------------------------------------------------------------
    always @(posedge internal_mclk or posedge audio_rst) begin
        if (audio_rst) begin
            sample_left_q  <= 32'd0;
            sample_right_q <= 32'd0;
        end else if (bclk_en_w && !bclk_q && (bit_count_q == 6'd0)) begin
            sample_left_q  <= sample_left_cdc_w;
            sample_right_q <= sample_right_cdc_w;
        end
    end

    function i2s_next_serial_bit;
        input [31:0] left_samp;
        input [31:0] right_samp;
        input [5:0]  bc;
        input [4:0]  width;
        reg          in_left;
        reg  [4:0]   pos;
        reg  [4:0]   bit_idx;
        begin
            in_left = (bc < 6'd32);
            pos     = bc[4:0];
            if (width == 5'd0)
                i2s_next_serial_bit = 1'b0;
            else if (pos == 5'd0)
                i2s_next_serial_bit = 1'b0;
            else if (pos <= width) begin
                bit_idx = width - pos;
                if (in_left)
                    i2s_next_serial_bit = left_samp[bit_idx];
                else
                    i2s_next_serial_bit = right_samp[bit_idx];
            end else
                i2s_next_serial_bit = 1'b0;
        end
    endfunction

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
                    ws_q        <= bit_count_q[5]; // Logika toggle WS 32-bit Anda!
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

    // -------------------------------------------------------------------------
    // 6. OUTPUT ASSIGNMENT
    // -------------------------------------------------------------------------
    assign i2s_mclk = mclk_q; // Kita matikan MCLK (tetap low) karena DAC PCM5102A tidak butuh MCLK
    assign i2s_ws   = ws_q;
    assign i2s_bclk = bclk_q;
    assign i2s_data = data_q;

endmodule
module cdc_array_sync #(
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