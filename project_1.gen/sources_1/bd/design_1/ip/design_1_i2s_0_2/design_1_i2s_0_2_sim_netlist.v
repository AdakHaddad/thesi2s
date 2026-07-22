// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Fri Jul 17 14:55:01 2026
// Host        : DESKTOP-HTVV1N1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/fixi2s/freshi2s/project_1.gen/sources_1/bd/design_1/ip/design_1_i2s_0_2/design_1_i2s_0_2_sim_netlist.v
// Design      : design_1_i2s_0_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_i2s_0_2,i2s,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "i2s,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module design_1_i2s_0_2
   (audio_clk,
    i2s_mclk,
    i2s_bclk,
    i2s_ws,
    i2s_data,
    s00_axi_aclk,
    s00_axi_aresetn,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 audio_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME audio_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input audio_clk;
  output i2s_mclk;
  output i2s_bclk;
  output i2s_ws;
  output i2s_data;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s00_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [3:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [3:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) input s00_axi_rready;

  wire \<const0> ;
  wire audio_clk;
  wire i2s_bclk;
  wire i2s_data;
  wire i2s_mclk;
  wire i2s_ws;
  wire [3:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [3:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  design_1_i2s_0_2_i2s inst
       (.S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WREADY(s00_axi_wready),
        .audio_clk(audio_clk),
        .bclk_q_reg(i2s_bclk),
        .i2s_data(i2s_data),
        .i2s_mclk(i2s_mclk),
        .i2s_ws(i2s_ws),
        .s00_axi_araddr(s00_axi_araddr[3:2]),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[3:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "i2s" *) 
module design_1_i2s_0_2_i2s
   (S_AXI_AWREADY,
    S_AXI_WREADY,
    i2s_ws,
    i2s_data,
    S_AXI_ARREADY,
    s00_axi_rdata,
    bclk_q_reg,
    s00_axi_rvalid,
    s00_axi_bvalid,
    i2s_mclk,
    s00_axi_wstrb,
    audio_clk,
    s00_axi_awaddr,
    s00_axi_aresetn,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output i2s_ws;
  output i2s_data;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output bclk_q_reg;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  output i2s_mclk;
  input [3:0]s00_axi_wstrb;
  input audio_clk;
  input [1:0]s00_axi_awaddr;
  input s00_axi_aresetn;
  input [31:0]s00_axi_wdata;
  input [1:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire audio_clk;
  wire bclk_q_reg;
  wire i2s_data;
  wire i2s_mclk;
  wire i2s_ws;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  design_1_i2s_0_2_i2s_slave_lite_v1_0_S00_AXI i2s_slave_lite_v1_0_S00_AXI_inst
       (.S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WREADY(S_AXI_WREADY),
        .audio_clk(audio_clk),
        .bclk_q_reg_0(bclk_q_reg),
        .i2s_data(i2s_data),
        .i2s_mclk(i2s_mclk),
        .i2s_ws(i2s_ws),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "i2s_slave_lite_v1_0_S00_AXI" *) 
module design_1_i2s_0_2_i2s_slave_lite_v1_0_S00_AXI
   (S_AXI_AWREADY,
    S_AXI_WREADY,
    i2s_ws,
    i2s_data,
    S_AXI_ARREADY,
    s00_axi_rdata,
    bclk_q_reg_0,
    s00_axi_rvalid,
    s00_axi_bvalid,
    i2s_mclk,
    s00_axi_wstrb,
    audio_clk,
    s00_axi_awaddr,
    s00_axi_aresetn,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output i2s_ws;
  output i2s_data;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output bclk_q_reg_0;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  output i2s_mclk;
  input [3:0]s00_axi_wstrb;
  input audio_clk;
  input [1:0]s00_axi_awaddr;
  input s00_axi_aresetn;
  input [31:0]s00_axi_wdata;
  input [1:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire audio_clk;
  wire aw_en_i_1_n_0;
  wire aw_en_reg_n_0;
  wire [3:2]axi_araddr;
  wire \axi_araddr[2]_i_1_n_0 ;
  wire \axi_araddr[3]_i_1_n_0 ;
  wire axi_arready0;
  wire \axi_awaddr[2]_i_1_n_0 ;
  wire \axi_awaddr[3]_i_1_n_0 ;
  wire axi_awready0;
  wire axi_bvalid_i_1_n_0;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready0;
  wire [31:7]bclk_phase_acc_q;
  wire [31:7]bclk_phase_acc_q0;
  wire bclk_phase_acc_q0_carry__0_n_0;
  wire bclk_phase_acc_q0_carry__0_n_1;
  wire bclk_phase_acc_q0_carry__0_n_2;
  wire bclk_phase_acc_q0_carry__0_n_3;
  wire bclk_phase_acc_q0_carry__1_n_0;
  wire bclk_phase_acc_q0_carry__1_n_1;
  wire bclk_phase_acc_q0_carry__1_n_2;
  wire bclk_phase_acc_q0_carry__1_n_3;
  wire bclk_phase_acc_q0_carry__2_n_0;
  wire bclk_phase_acc_q0_carry__2_n_1;
  wire bclk_phase_acc_q0_carry__2_n_2;
  wire bclk_phase_acc_q0_carry__2_n_3;
  wire bclk_phase_acc_q0_carry__3_n_0;
  wire bclk_phase_acc_q0_carry__3_n_1;
  wire bclk_phase_acc_q0_carry__3_n_2;
  wire bclk_phase_acc_q0_carry__3_n_3;
  wire bclk_phase_acc_q0_carry__4_n_0;
  wire bclk_phase_acc_q0_carry__4_n_1;
  wire bclk_phase_acc_q0_carry__4_n_2;
  wire bclk_phase_acc_q0_carry__4_n_3;
  wire bclk_phase_acc_q0_carry_i_10_n_0;
  wire bclk_phase_acc_q0_carry_i_11_n_0;
  wire bclk_phase_acc_q0_carry_i_12_n_0;
  wire bclk_phase_acc_q0_carry_i_1__0_n_0;
  wire bclk_phase_acc_q0_carry_i_1__0_n_1;
  wire bclk_phase_acc_q0_carry_i_1__0_n_2;
  wire bclk_phase_acc_q0_carry_i_1__0_n_3;
  wire bclk_phase_acc_q0_carry_i_1__1_n_0;
  wire bclk_phase_acc_q0_carry_i_1__1_n_1;
  wire bclk_phase_acc_q0_carry_i_1__1_n_2;
  wire bclk_phase_acc_q0_carry_i_1__1_n_3;
  wire bclk_phase_acc_q0_carry_i_1__2_n_0;
  wire bclk_phase_acc_q0_carry_i_1__2_n_1;
  wire bclk_phase_acc_q0_carry_i_1__2_n_2;
  wire bclk_phase_acc_q0_carry_i_1__2_n_3;
  wire bclk_phase_acc_q0_carry_i_1__3_n_0;
  wire bclk_phase_acc_q0_carry_i_1__3_n_1;
  wire bclk_phase_acc_q0_carry_i_1__3_n_2;
  wire bclk_phase_acc_q0_carry_i_1__3_n_3;
  wire bclk_phase_acc_q0_carry_i_1__4_n_0;
  wire bclk_phase_acc_q0_carry_i_1__4_n_1;
  wire bclk_phase_acc_q0_carry_i_1__4_n_2;
  wire bclk_phase_acc_q0_carry_i_1__4_n_3;
  wire bclk_phase_acc_q0_carry_i_1__5_n_3;
  wire bclk_phase_acc_q0_carry_i_1_n_0;
  wire bclk_phase_acc_q0_carry_i_2__0_n_0;
  wire bclk_phase_acc_q0_carry_i_2__1_n_0;
  wire bclk_phase_acc_q0_carry_i_2__2_n_0;
  wire bclk_phase_acc_q0_carry_i_2__3_n_0;
  wire bclk_phase_acc_q0_carry_i_2__4_n_0;
  wire bclk_phase_acc_q0_carry_i_2__4_n_1;
  wire bclk_phase_acc_q0_carry_i_2__4_n_2;
  wire bclk_phase_acc_q0_carry_i_2__4_n_3;
  wire bclk_phase_acc_q0_carry_i_2_n_0;
  wire bclk_phase_acc_q0_carry_i_3__0__0_n_0;
  wire bclk_phase_acc_q0_carry_i_3__0_n_0;
  wire bclk_phase_acc_q0_carry_i_3__1__0_n_0;
  wire bclk_phase_acc_q0_carry_i_3__1_n_0;
  wire bclk_phase_acc_q0_carry_i_3_n_0;
  wire bclk_phase_acc_q0_carry_i_4__0__0_n_0;
  wire bclk_phase_acc_q0_carry_i_4__0_n_0;
  wire bclk_phase_acc_q0_carry_i_4__1_n_0;
  wire bclk_phase_acc_q0_carry_i_4__2_n_0;
  wire bclk_phase_acc_q0_carry_i_4_n_0;
  wire bclk_phase_acc_q0_carry_i_5__0_n_0;
  wire bclk_phase_acc_q0_carry_i_5__1_n_0;
  wire bclk_phase_acc_q0_carry_i_5__2_n_0;
  wire bclk_phase_acc_q0_carry_i_5__3_n_0;
  wire bclk_phase_acc_q0_carry_i_5_n_0;
  wire bclk_phase_acc_q0_carry_i_6__0_n_0;
  wire bclk_phase_acc_q0_carry_i_6__1_n_0;
  wire bclk_phase_acc_q0_carry_i_6_n_0;
  wire bclk_phase_acc_q0_carry_i_7__0_n_0;
  wire bclk_phase_acc_q0_carry_i_7_n_0;
  wire bclk_phase_acc_q0_carry_i_8_n_0;
  wire bclk_phase_acc_q0_carry_i_9_n_0;
  wire bclk_phase_acc_q0_carry_n_0;
  wire bclk_phase_acc_q0_carry_n_1;
  wire bclk_phase_acc_q0_carry_n_2;
  wire bclk_phase_acc_q0_carry_n_3;
  wire \bclk_phase_acc_q[10]_i_1_n_0 ;
  wire \bclk_phase_acc_q[11]_i_1_n_0 ;
  wire \bclk_phase_acc_q[12]_i_1_n_0 ;
  wire \bclk_phase_acc_q[13]_i_1_n_0 ;
  wire \bclk_phase_acc_q[14]_i_1_n_0 ;
  wire \bclk_phase_acc_q[15]_i_1_n_0 ;
  wire \bclk_phase_acc_q[16]_i_1_n_0 ;
  wire \bclk_phase_acc_q[17]_i_1_n_0 ;
  wire \bclk_phase_acc_q[18]_i_1_n_0 ;
  wire \bclk_phase_acc_q[19]_i_1_n_0 ;
  wire \bclk_phase_acc_q[20]_i_1_n_0 ;
  wire \bclk_phase_acc_q[21]_i_1_n_0 ;
  wire \bclk_phase_acc_q[22]_i_1_n_0 ;
  wire \bclk_phase_acc_q[23]_i_1_n_0 ;
  wire \bclk_phase_acc_q[24]_i_1_n_0 ;
  wire \bclk_phase_acc_q[25]_i_1_n_0 ;
  wire \bclk_phase_acc_q[26]_i_1_n_0 ;
  wire \bclk_phase_acc_q[27]_i_1_n_0 ;
  wire \bclk_phase_acc_q[28]_i_1_n_0 ;
  wire \bclk_phase_acc_q[29]_i_1_n_0 ;
  wire \bclk_phase_acc_q[30]_i_1_n_0 ;
  wire \bclk_phase_acc_q[31]_i_1_n_0 ;
  wire \bclk_phase_acc_q[7]_i_1_n_0 ;
  wire \bclk_phase_acc_q[8]_i_1_n_0 ;
  wire \bclk_phase_acc_q[9]_i_1_n_0 ;
  wire [31:7]bclk_phase_sum;
  wire bclk_q_i_1_n_0;
  wire bclk_q_i_2_n_0;
  wire bclk_q_i_3_n_0;
  wire bclk_q_i_4_n_0;
  wire bclk_q_i_5_n_0;
  wire bclk_q_i_6_n_0;
  wire bclk_q_i_7_n_0;
  wire bclk_q_reg_0;
  wire \bit_count_q[1]_i_1_n_0 ;
  wire \bit_count_q[5]_i_2_n_0 ;
  wire current_latch_status_q;
  wire current_latch_status_q_i_1_n_0;
  wire data_q;
  wire data_q_i_10_n_0;
  wire data_q_i_11_n_0;
  wire data_q_i_12_n_0;
  wire data_q_i_13_n_0;
  wire data_q_i_14_n_0;
  wire data_q_i_15_n_0;
  wire data_q_i_16_n_0;
  wire data_q_i_17_n_0;
  wire data_q_i_18_n_0;
  wire data_q_i_19_n_0;
  wire data_q_i_1_n_0;
  wire data_q_i_20_n_0;
  wire data_q_i_21_n_0;
  wire data_q_i_22_n_0;
  wire data_q_i_23_n_0;
  wire data_q_i_24_n_0;
  wire data_q_i_25_n_0;
  wire data_q_i_26_n_0;
  wire data_q_i_27_n_0;
  wire data_q_i_28_n_0;
  wire data_q_i_29_n_0;
  wire data_q_i_2_n_0;
  wire data_q_i_30_n_0;
  wire data_q_i_31_n_0;
  wire data_q_i_32_n_0;
  wire data_q_i_33_n_0;
  wire data_q_i_34_n_0;
  wire data_q_i_35_n_0;
  wire data_q_i_36_n_0;
  wire data_q_i_37_n_0;
  wire data_q_i_38_n_0;
  wire data_q_i_39_n_0;
  wire data_q_i_3_n_0;
  wire data_q_i_40_n_0;
  wire data_q_i_41_n_0;
  wire data_q_i_42_n_0;
  wire data_q_i_43_n_0;
  wire data_q_i_44_n_0;
  wire data_q_i_4_n_0;
  wire data_q_i_5_n_0;
  wire data_q_i_6_n_0;
  wire data_q_i_7_n_0;
  wire data_q_i_8_n_0;
  wire data_q_i_9_n_0;
  wire i2s_data;
  wire i2s_mclk;
  wire i2s_ws;
  wire [31:8]mclk_phase_acc_q;
  wire [31:8]mclk_phase_acc_q0;
  wire mclk_phase_acc_q0_carry__0_i_1_n_0;
  wire mclk_phase_acc_q0_carry__0_i_1_n_1;
  wire mclk_phase_acc_q0_carry__0_i_1_n_2;
  wire mclk_phase_acc_q0_carry__0_i_1_n_3;
  wire mclk_phase_acc_q0_carry__0_i_2_n_0;
  wire mclk_phase_acc_q0_carry__0_i_3_n_0;
  wire mclk_phase_acc_q0_carry__0_i_4_n_0;
  wire mclk_phase_acc_q0_carry__0_i_5_n_0;
  wire mclk_phase_acc_q0_carry__0_i_6_n_0;
  wire mclk_phase_acc_q0_carry__0_i_7_n_0;
  wire mclk_phase_acc_q0_carry__0_n_0;
  wire mclk_phase_acc_q0_carry__0_n_1;
  wire mclk_phase_acc_q0_carry__0_n_2;
  wire mclk_phase_acc_q0_carry__0_n_3;
  wire mclk_phase_acc_q0_carry__1_i_10_n_0;
  wire mclk_phase_acc_q0_carry__1_i_11_n_0;
  wire mclk_phase_acc_q0_carry__1_i_12_n_0;
  wire mclk_phase_acc_q0_carry__1_i_13_n_0;
  wire mclk_phase_acc_q0_carry__1_i_1_n_0;
  wire mclk_phase_acc_q0_carry__1_i_1_n_1;
  wire mclk_phase_acc_q0_carry__1_i_1_n_2;
  wire mclk_phase_acc_q0_carry__1_i_1_n_3;
  wire mclk_phase_acc_q0_carry__1_i_2_n_0;
  wire mclk_phase_acc_q0_carry__1_i_3_n_0;
  wire mclk_phase_acc_q0_carry__1_i_4_n_0;
  wire mclk_phase_acc_q0_carry__1_i_5_n_0;
  wire mclk_phase_acc_q0_carry__1_i_6_n_0;
  wire mclk_phase_acc_q0_carry__1_i_7_n_0;
  wire mclk_phase_acc_q0_carry__1_i_8_n_0;
  wire mclk_phase_acc_q0_carry__1_i_9_n_0;
  wire mclk_phase_acc_q0_carry__1_n_0;
  wire mclk_phase_acc_q0_carry__1_n_1;
  wire mclk_phase_acc_q0_carry__1_n_2;
  wire mclk_phase_acc_q0_carry__1_n_3;
  wire mclk_phase_acc_q0_carry__2_i_1_n_0;
  wire mclk_phase_acc_q0_carry__2_i_1_n_1;
  wire mclk_phase_acc_q0_carry__2_i_1_n_2;
  wire mclk_phase_acc_q0_carry__2_i_1_n_3;
  wire mclk_phase_acc_q0_carry__2_i_2_n_0;
  wire mclk_phase_acc_q0_carry__2_i_3_n_0;
  wire mclk_phase_acc_q0_carry__2_i_4_n_0;
  wire mclk_phase_acc_q0_carry__2_i_5_n_0;
  wire mclk_phase_acc_q0_carry__2_i_6_n_0;
  wire mclk_phase_acc_q0_carry__2_n_0;
  wire mclk_phase_acc_q0_carry__2_n_1;
  wire mclk_phase_acc_q0_carry__2_n_2;
  wire mclk_phase_acc_q0_carry__2_n_3;
  wire mclk_phase_acc_q0_carry__3_i_1_n_0;
  wire mclk_phase_acc_q0_carry__3_i_1_n_1;
  wire mclk_phase_acc_q0_carry__3_i_1_n_2;
  wire mclk_phase_acc_q0_carry__3_i_1_n_3;
  wire mclk_phase_acc_q0_carry__3_i_2_n_0;
  wire mclk_phase_acc_q0_carry__3_i_3_n_0;
  wire mclk_phase_acc_q0_carry__3_i_4_n_0;
  wire mclk_phase_acc_q0_carry__3_i_5_n_0;
  wire mclk_phase_acc_q0_carry__3_n_0;
  wire mclk_phase_acc_q0_carry__3_n_1;
  wire mclk_phase_acc_q0_carry__3_n_2;
  wire mclk_phase_acc_q0_carry__3_n_3;
  wire mclk_phase_acc_q0_carry__4_i_1_n_1;
  wire mclk_phase_acc_q0_carry__4_i_1_n_2;
  wire mclk_phase_acc_q0_carry__4_i_1_n_3;
  wire mclk_phase_acc_q0_carry__4_i_2_n_0;
  wire mclk_phase_acc_q0_carry__4_i_3_n_0;
  wire mclk_phase_acc_q0_carry__4_i_4_n_0;
  wire mclk_phase_acc_q0_carry__4_i_5_n_0;
  wire mclk_phase_acc_q0_carry__4_n_0;
  wire mclk_phase_acc_q0_carry__4_n_1;
  wire mclk_phase_acc_q0_carry__4_n_2;
  wire mclk_phase_acc_q0_carry__4_n_3;
  wire mclk_phase_acc_q0_carry__5_i_1_n_0;
  wire mclk_phase_acc_q0_carry_i_10_n_0;
  wire mclk_phase_acc_q0_carry_i_11_n_0;
  wire mclk_phase_acc_q0_carry_i_1_n_0;
  wire mclk_phase_acc_q0_carry_i_1_n_1;
  wire mclk_phase_acc_q0_carry_i_1_n_2;
  wire mclk_phase_acc_q0_carry_i_1_n_3;
  wire mclk_phase_acc_q0_carry_i_2_n_0;
  wire mclk_phase_acc_q0_carry_i_3_n_0;
  wire mclk_phase_acc_q0_carry_i_4_n_0;
  wire mclk_phase_acc_q0_carry_i_5_n_0;
  wire mclk_phase_acc_q0_carry_i_6_n_0;
  wire mclk_phase_acc_q0_carry_i_7_n_0;
  wire mclk_phase_acc_q0_carry_i_8_n_0;
  wire mclk_phase_acc_q0_carry_i_9_n_0;
  wire mclk_phase_acc_q0_carry_n_0;
  wire mclk_phase_acc_q0_carry_n_1;
  wire mclk_phase_acc_q0_carry_n_2;
  wire mclk_phase_acc_q0_carry_n_3;
  wire \mclk_phase_acc_q[10]_i_1_n_0 ;
  wire \mclk_phase_acc_q[11]_i_1_n_0 ;
  wire \mclk_phase_acc_q[12]_i_1_n_0 ;
  wire \mclk_phase_acc_q[13]_i_1_n_0 ;
  wire \mclk_phase_acc_q[14]_i_1_n_0 ;
  wire \mclk_phase_acc_q[15]_i_1_n_0 ;
  wire \mclk_phase_acc_q[16]_i_1_n_0 ;
  wire \mclk_phase_acc_q[17]_i_1_n_0 ;
  wire \mclk_phase_acc_q[18]_i_1_n_0 ;
  wire \mclk_phase_acc_q[19]_i_1_n_0 ;
  wire \mclk_phase_acc_q[20]_i_1_n_0 ;
  wire \mclk_phase_acc_q[21]_i_1_n_0 ;
  wire \mclk_phase_acc_q[22]_i_1_n_0 ;
  wire \mclk_phase_acc_q[23]_i_1_n_0 ;
  wire \mclk_phase_acc_q[24]_i_1_n_0 ;
  wire \mclk_phase_acc_q[25]_i_1_n_0 ;
  wire \mclk_phase_acc_q[26]_i_1_n_0 ;
  wire \mclk_phase_acc_q[27]_i_1_n_0 ;
  wire \mclk_phase_acc_q[28]_i_1_n_0 ;
  wire \mclk_phase_acc_q[29]_i_1_n_0 ;
  wire \mclk_phase_acc_q[30]_i_1_n_0 ;
  wire \mclk_phase_acc_q[31]_i_1_n_0 ;
  wire \mclk_phase_acc_q[8]_i_1_n_0 ;
  wire \mclk_phase_acc_q[9]_i_1_n_0 ;
  wire [31:8]mclk_phase_sum;
  wire mclk_q_i_1_n_0;
  wire mclk_q_i_2_n_0;
  wire mclk_q_i_3_n_0;
  wire mclk_q_i_4_n_0;
  wire mclk_q_i_5_n_0;
  wire mclk_q_i_6_n_0;
  wire mclk_q_i_7_n_0;
  wire mclk_q_i_8_n_0;
  wire mute_sync;
  wire [4:0]p_0_in;
  wire p_0_in2_in;
  wire [5:0]p_0_in__0;
  wire [23:7]p_1_in;
  wire [31:0]reg_data_out;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire [31:0]sample_left_q;
  wire [0:0]sample_left_q_0;
  wire [31:0]sample_right_q;
  wire [4:0]sample_width_raw;
  wire [19:0]sel0;
  wire [31:0]slv_reg0;
  wire \slv_reg0[15]_i_1_n_0 ;
  wire \slv_reg0[23]_i_1_n_0 ;
  wire \slv_reg0[31]_i_1_n_0 ;
  wire \slv_reg0[7]_i_1_n_0 ;
  wire [31:0]slv_reg1;
  wire \slv_reg1[15]_i_1_n_0 ;
  wire \slv_reg1[23]_i_1_n_0 ;
  wire \slv_reg1[31]_i_1_n_0 ;
  wire \slv_reg1[31]_i_2_n_0 ;
  wire \slv_reg1[7]_i_1_n_0 ;
  wire \slv_reg2[23]_i_2_n_0 ;
  wire \slv_reg2[24]_i_1_n_0 ;
  wire \slv_reg2[25]_i_1_n_0 ;
  wire \slv_reg2[26]_i_1_n_0 ;
  wire \slv_reg2_reg_n_0_[0] ;
  wire [31:1]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[7]_i_1_n_0 ;
  wire slv_reg_rden__0;
  wire [1:0]write_addr;
  wire ws_q;
  wire [3:0]NLW_bclk_phase_acc_q0_carry__5_CO_UNCONNECTED;
  wire [3:1]NLW_bclk_phase_acc_q0_carry__5_O_UNCONNECTED;
  wire [3:1]NLW_bclk_phase_acc_q0_carry_i_1__5_CO_UNCONNECTED;
  wire [3:2]NLW_bclk_phase_acc_q0_carry_i_1__5_O_UNCONNECTED;
  wire [0:0]NLW_bclk_phase_acc_q0_carry_i_2__4_O_UNCONNECTED;
  wire [0:0]NLW_mclk_phase_acc_q0_carry_O_UNCONNECTED;
  wire [3:3]NLW_mclk_phase_acc_q0_carry__4_i_1_CO_UNCONNECTED;
  wire [3:0]NLW_mclk_phase_acc_q0_carry__5_CO_UNCONNECTED;
  wire [3:1]NLW_mclk_phase_acc_q0_carry__5_O_UNCONNECTED;

  LUT6 #(
    .INIT(64'hFFFF88880FFF8888)) 
    aw_en_i_1
       (.I0(s00_axi_bready),
        .I1(s00_axi_bvalid),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .I4(aw_en_reg_n_0),
        .I5(S_AXI_AWREADY),
        .O(aw_en_i_1_n_0));
  FDSE aw_en_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(aw_en_i_1_n_0),
        .Q(aw_en_reg_n_0),
        .S(mclk_q_i_2_n_0));
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[2]_i_1 
       (.I0(s00_axi_araddr[0]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[2]),
        .O(\axi_araddr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[3]_i_1 
       (.I0(s00_axi_araddr[1]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[3]),
        .O(\axi_araddr[3]_i_1_n_0 ));
  FDRE \axi_araddr_reg[2] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\axi_araddr[2]_i_1_n_0 ),
        .Q(axi_araddr[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_araddr_reg[3] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\axi_araddr[3]_i_1_n_0 ),
        .Q(axi_araddr[3]),
        .R(mclk_q_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready0));
  FDRE axi_arready_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(axi_arready0),
        .Q(S_AXI_ARREADY),
        .R(mclk_q_i_2_n_0));
  LUT4 #(
    .INIT(16'hBF80)) 
    \axi_awaddr[2]_i_1 
       (.I0(s00_axi_awaddr[0]),
        .I1(axi_awready0),
        .I2(s00_axi_aresetn),
        .I3(write_addr[0]),
        .O(\axi_awaddr[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hBF80)) 
    \axi_awaddr[3]_i_1 
       (.I0(s00_axi_awaddr[1]),
        .I1(axi_awready0),
        .I2(s00_axi_aresetn),
        .I3(write_addr[1]),
        .O(\axi_awaddr[3]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[2] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\axi_awaddr[2]_i_1_n_0 ),
        .Q(write_addr[0]),
        .R(1'b0));
  FDRE \axi_awaddr_reg[3] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\axi_awaddr[3]_i_1_n_0 ),
        .Q(write_addr[1]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    axi_awready_i_1
       (.I0(S_AXI_AWREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .O(axi_awready0));
  FDRE axi_awready_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(axi_awready0),
        .Q(S_AXI_AWREADY),
        .R(mclk_q_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000FFFF80008000)) 
    axi_bvalid_i_1
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(S_AXI_WREADY),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(mclk_q_i_2_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[0]_i_1 
       (.I0(current_latch_status_q),
        .I1(slv_reg1[0]),
        .I2(axi_araddr[2]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[0]),
        .O(reg_data_out[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[10]_i_1 
       (.I0(slv_reg3[10]),
        .I1(slv_reg1[10]),
        .I2(axi_araddr[2]),
        .I3(sel0[3]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[10]),
        .O(reg_data_out[10]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[11]_i_1 
       (.I0(slv_reg3[11]),
        .I1(slv_reg1[11]),
        .I2(axi_araddr[2]),
        .I3(sel0[4]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[11]),
        .O(reg_data_out[11]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[12]_i_1 
       (.I0(slv_reg3[12]),
        .I1(slv_reg1[12]),
        .I2(axi_araddr[2]),
        .I3(sel0[5]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[12]),
        .O(reg_data_out[12]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[13]_i_1 
       (.I0(slv_reg3[13]),
        .I1(slv_reg1[13]),
        .I2(axi_araddr[2]),
        .I3(sel0[6]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[13]),
        .O(reg_data_out[13]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[14]_i_1 
       (.I0(slv_reg3[14]),
        .I1(slv_reg1[14]),
        .I2(axi_araddr[2]),
        .I3(sel0[7]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[14]),
        .O(reg_data_out[14]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[15]_i_1 
       (.I0(slv_reg3[15]),
        .I1(slv_reg1[15]),
        .I2(axi_araddr[2]),
        .I3(sel0[8]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[15]),
        .O(reg_data_out[15]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[16]_i_1 
       (.I0(slv_reg3[16]),
        .I1(slv_reg1[16]),
        .I2(axi_araddr[2]),
        .I3(sel0[9]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[16]),
        .O(reg_data_out[16]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[17]_i_1 
       (.I0(slv_reg3[17]),
        .I1(slv_reg1[17]),
        .I2(axi_araddr[2]),
        .I3(sel0[10]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[17]),
        .O(reg_data_out[17]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[18]_i_1 
       (.I0(slv_reg3[18]),
        .I1(slv_reg1[18]),
        .I2(axi_araddr[2]),
        .I3(sel0[11]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[18]),
        .O(reg_data_out[18]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[19]_i_1 
       (.I0(slv_reg3[19]),
        .I1(slv_reg1[19]),
        .I2(axi_araddr[2]),
        .I3(sel0[12]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[19]),
        .O(reg_data_out[19]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[1]_i_1 
       (.I0(slv_reg3[1]),
        .I1(slv_reg1[1]),
        .I2(axi_araddr[2]),
        .I3(mute_sync),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[1]),
        .O(reg_data_out[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[20]_i_1 
       (.I0(slv_reg3[20]),
        .I1(slv_reg1[20]),
        .I2(axi_araddr[2]),
        .I3(sel0[13]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[20]),
        .O(reg_data_out[20]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[21]_i_1 
       (.I0(slv_reg3[21]),
        .I1(slv_reg1[21]),
        .I2(axi_araddr[2]),
        .I3(sel0[14]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[21]),
        .O(reg_data_out[21]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[22]_i_1 
       (.I0(slv_reg3[22]),
        .I1(slv_reg1[22]),
        .I2(axi_araddr[2]),
        .I3(sel0[15]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[22]),
        .O(reg_data_out[22]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[23]_i_1 
       (.I0(slv_reg3[23]),
        .I1(slv_reg1[23]),
        .I2(axi_araddr[2]),
        .I3(sel0[16]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[23]),
        .O(reg_data_out[23]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[24]_i_1 
       (.I0(slv_reg3[24]),
        .I1(slv_reg1[24]),
        .I2(axi_araddr[2]),
        .I3(sel0[17]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[24]),
        .O(reg_data_out[24]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[25]_i_1 
       (.I0(slv_reg3[25]),
        .I1(slv_reg1[25]),
        .I2(axi_araddr[2]),
        .I3(sel0[18]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[25]),
        .O(reg_data_out[25]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[26]_i_1 
       (.I0(slv_reg3[26]),
        .I1(slv_reg1[26]),
        .I2(axi_araddr[2]),
        .I3(sel0[19]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[26]),
        .O(reg_data_out[26]));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \axi_rdata[27]_i_1 
       (.I0(slv_reg3[27]),
        .I1(slv_reg1[27]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[27]),
        .I4(axi_araddr[3]),
        .O(reg_data_out[27]));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \axi_rdata[28]_i_1 
       (.I0(slv_reg3[28]),
        .I1(slv_reg1[28]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[28]),
        .I4(axi_araddr[3]),
        .O(reg_data_out[28]));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \axi_rdata[29]_i_1 
       (.I0(slv_reg3[29]),
        .I1(slv_reg1[29]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[29]),
        .I4(axi_araddr[3]),
        .O(reg_data_out[29]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[2]_i_1 
       (.I0(slv_reg3[2]),
        .I1(slv_reg1[2]),
        .I2(axi_araddr[2]),
        .I3(sample_width_raw[0]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[2]),
        .O(reg_data_out[2]));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \axi_rdata[30]_i_1 
       (.I0(slv_reg3[30]),
        .I1(slv_reg1[30]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[30]),
        .I4(axi_araddr[3]),
        .O(reg_data_out[30]));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \axi_rdata[31]_i_1 
       (.I0(slv_reg3[31]),
        .I1(slv_reg1[31]),
        .I2(axi_araddr[2]),
        .I3(slv_reg0[31]),
        .I4(axi_araddr[3]),
        .O(reg_data_out[31]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[3]_i_1 
       (.I0(slv_reg3[3]),
        .I1(slv_reg1[3]),
        .I2(axi_araddr[2]),
        .I3(sample_width_raw[1]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[3]),
        .O(reg_data_out[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[4]_i_1 
       (.I0(slv_reg3[4]),
        .I1(slv_reg1[4]),
        .I2(axi_araddr[2]),
        .I3(sample_width_raw[2]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[4]),
        .O(reg_data_out[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[5]_i_1 
       (.I0(slv_reg3[5]),
        .I1(slv_reg1[5]),
        .I2(axi_araddr[2]),
        .I3(sample_width_raw[3]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[5]),
        .O(reg_data_out[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[6]_i_1 
       (.I0(slv_reg3[6]),
        .I1(slv_reg1[6]),
        .I2(axi_araddr[2]),
        .I3(sample_width_raw[4]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[6]),
        .O(reg_data_out[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[7]_i_1 
       (.I0(slv_reg3[7]),
        .I1(slv_reg1[7]),
        .I2(axi_araddr[2]),
        .I3(sel0[0]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[7]),
        .O(reg_data_out[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[8]_i_1 
       (.I0(slv_reg3[8]),
        .I1(slv_reg1[8]),
        .I2(axi_araddr[2]),
        .I3(sel0[1]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[8]),
        .O(reg_data_out[8]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \axi_rdata[9]_i_1 
       (.I0(slv_reg3[9]),
        .I1(slv_reg1[9]),
        .I2(axi_araddr[2]),
        .I3(sel0[2]),
        .I4(axi_araddr[3]),
        .I5(slv_reg0[9]),
        .O(reg_data_out[9]));
  FDRE \axi_rdata_reg[0] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[0]),
        .Q(s00_axi_rdata[0]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[10] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[10]),
        .Q(s00_axi_rdata[10]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[11] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[11]),
        .Q(s00_axi_rdata[11]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[12] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[12]),
        .Q(s00_axi_rdata[12]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[13] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[13]),
        .Q(s00_axi_rdata[13]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[14] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[14]),
        .Q(s00_axi_rdata[14]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[15] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[15]),
        .Q(s00_axi_rdata[15]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[16] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[16]),
        .Q(s00_axi_rdata[16]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[17] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[17]),
        .Q(s00_axi_rdata[17]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[18] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[18]),
        .Q(s00_axi_rdata[18]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[19] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[19]),
        .Q(s00_axi_rdata[19]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[1] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[1]),
        .Q(s00_axi_rdata[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[20] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[20]),
        .Q(s00_axi_rdata[20]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[21] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[21]),
        .Q(s00_axi_rdata[21]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[22] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[22]),
        .Q(s00_axi_rdata[22]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[23] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[23]),
        .Q(s00_axi_rdata[23]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[24] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[24]),
        .Q(s00_axi_rdata[24]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[25] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[25]),
        .Q(s00_axi_rdata[25]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[26] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[26]),
        .Q(s00_axi_rdata[26]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[27] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[27]),
        .Q(s00_axi_rdata[27]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[28] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[28]),
        .Q(s00_axi_rdata[28]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[29] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[29]),
        .Q(s00_axi_rdata[29]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[2] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[2]),
        .Q(s00_axi_rdata[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[30] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[30]),
        .Q(s00_axi_rdata[30]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[31] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[31]),
        .Q(s00_axi_rdata[31]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[3] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[3]),
        .Q(s00_axi_rdata[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[4] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[4]),
        .Q(s00_axi_rdata[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[5] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[5]),
        .Q(s00_axi_rdata[5]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[6] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[6]),
        .Q(s00_axi_rdata[6]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[7] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[7]),
        .Q(s00_axi_rdata[7]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[8] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[8]),
        .Q(s00_axi_rdata[8]),
        .R(mclk_q_i_2_n_0));
  FDRE \axi_rdata_reg[9] 
       (.C(audio_clk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[9]),
        .Q(s00_axi_rdata[9]),
        .R(mclk_q_i_2_n_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(S_AXI_ARREADY),
        .I1(s00_axi_arvalid),
        .I2(s00_axi_rvalid),
        .I3(s00_axi_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(s00_axi_rvalid),
        .R(mclk_q_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    axi_wready_i_1
       (.I0(S_AXI_WREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .O(axi_wready0));
  FDRE axi_wready_reg
       (.C(audio_clk),
        .CE(1'b1),
        .D(axi_wready0),
        .Q(S_AXI_WREADY),
        .R(mclk_q_i_2_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry
       (.CI(1'b0),
        .CO({bclk_phase_acc_q0_carry_n_0,bclk_phase_acc_q0_carry_n_1,bclk_phase_acc_q0_carry_n_2,bclk_phase_acc_q0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({bclk_phase_sum[10:8],1'b0}),
        .O(bclk_phase_acc_q0[10:7]),
        .S({bclk_phase_acc_q0_carry_i_3__1_n_0,bclk_phase_acc_q0_carry_i_4__2_n_0,bclk_phase_acc_q0_carry_i_5_n_0,bclk_phase_sum[7]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__0
       (.CI(bclk_phase_acc_q0_carry_n_0),
        .CO({bclk_phase_acc_q0_carry__0_n_0,bclk_phase_acc_q0_carry__0_n_1,bclk_phase_acc_q0_carry__0_n_2,bclk_phase_acc_q0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,bclk_phase_sum[12:11]}),
        .O(bclk_phase_acc_q0[14:11]),
        .S({bclk_phase_sum[14:13],bclk_phase_acc_q0_carry_i_2_n_0,bclk_phase_acc_q0_carry_i_3__0__0_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__1
       (.CI(bclk_phase_acc_q0_carry__0_n_0),
        .CO({bclk_phase_acc_q0_carry__1_n_0,bclk_phase_acc_q0_carry__1_n_1,bclk_phase_acc_q0_carry__1_n_2,bclk_phase_acc_q0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,bclk_phase_sum[17],1'b0,1'b0}),
        .O(bclk_phase_acc_q0[18:15]),
        .S({bclk_phase_sum[18],bclk_phase_acc_q0_carry_i_2__0_n_0,bclk_phase_sum[16:15]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__2
       (.CI(bclk_phase_acc_q0_carry__1_n_0),
        .CO({bclk_phase_acc_q0_carry__2_n_0,bclk_phase_acc_q0_carry__2_n_1,bclk_phase_acc_q0_carry__2_n_2,bclk_phase_acc_q0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,bclk_phase_sum[19]}),
        .O(bclk_phase_acc_q0[22:19]),
        .S({bclk_phase_sum[22:20],bclk_phase_acc_q0_carry_i_2__1_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__3
       (.CI(bclk_phase_acc_q0_carry__2_n_0),
        .CO({bclk_phase_acc_q0_carry__3_n_0,bclk_phase_acc_q0_carry__3_n_1,bclk_phase_acc_q0_carry__3_n_2,bclk_phase_acc_q0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,bclk_phase_sum[25],1'b0,1'b0}),
        .O(bclk_phase_acc_q0[26:23]),
        .S({bclk_phase_sum[26],bclk_phase_acc_q0_carry_i_2__2_n_0,bclk_phase_sum[24:23]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__4
       (.CI(bclk_phase_acc_q0_carry__3_n_0),
        .CO({bclk_phase_acc_q0_carry__4_n_0,bclk_phase_acc_q0_carry__4_n_1,bclk_phase_acc_q0_carry__4_n_2,bclk_phase_acc_q0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(bclk_phase_sum[30:27]),
        .O(bclk_phase_acc_q0[30:27]),
        .S({bclk_phase_acc_q0_carry_i_2__3_n_0,bclk_phase_acc_q0_carry_i_3__1__0_n_0,bclk_phase_acc_q0_carry_i_4__0__0_n_0,bclk_phase_acc_q0_carry_i_5__0_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry__5
       (.CI(bclk_phase_acc_q0_carry__4_n_0),
        .CO(NLW_bclk_phase_acc_q0_carry__5_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_bclk_phase_acc_q0_carry__5_O_UNCONNECTED[3:1],bclk_phase_acc_q0[31]}),
        .S({1'b0,1'b0,1'b0,bclk_phase_acc_q0_carry_i_1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_1
       (.I0(bclk_phase_sum[31]),
        .O(bclk_phase_acc_q0_carry_i_1_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    bclk_phase_acc_q0_carry_i_10
       (.I0(bclk_phase_acc_q[9]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[2]),
        .O(bclk_phase_acc_q0_carry_i_10_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    bclk_phase_acc_q0_carry_i_11
       (.I0(bclk_phase_acc_q[8]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[1]),
        .O(bclk_phase_acc_q0_carry_i_11_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    bclk_phase_acc_q0_carry_i_12
       (.I0(bclk_phase_acc_q[7]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[0]),
        .O(bclk_phase_acc_q0_carry_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__0
       (.CI(bclk_phase_acc_q0_carry_i_2__4_n_0),
        .CO({bclk_phase_acc_q0_carry_i_1__0_n_0,bclk_phase_acc_q0_carry_i_1__0_n_1,bclk_phase_acc_q0_carry_i_1__0_n_2,bclk_phase_acc_q0_carry_i_1__0_n_3}),
        .CYINIT(1'b0),
        .DI(bclk_phase_acc_q[13:10]),
        .O(bclk_phase_sum[13:10]),
        .S({bclk_phase_acc_q0_carry_i_6__1_n_0,bclk_phase_acc_q0_carry_i_7_n_0,bclk_phase_acc_q0_carry_i_8_n_0,bclk_phase_acc_q0_carry_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__1
       (.CI(bclk_phase_acc_q0_carry_i_1__0_n_0),
        .CO({bclk_phase_acc_q0_carry_i_1__1_n_0,bclk_phase_acc_q0_carry_i_1__1_n_1,bclk_phase_acc_q0_carry_i_1__1_n_2,bclk_phase_acc_q0_carry_i_1__1_n_3}),
        .CYINIT(1'b0),
        .DI(bclk_phase_acc_q[17:14]),
        .O(bclk_phase_sum[17:14]),
        .S({bclk_phase_acc_q0_carry_i_4_n_0,bclk_phase_acc_q0_carry_i_5__2_n_0,bclk_phase_acc_q0_carry_i_6__0_n_0,bclk_phase_acc_q0_carry_i_7__0_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__2
       (.CI(bclk_phase_acc_q0_carry_i_1__1_n_0),
        .CO({bclk_phase_acc_q0_carry_i_1__2_n_0,bclk_phase_acc_q0_carry_i_1__2_n_1,bclk_phase_acc_q0_carry_i_1__2_n_2,bclk_phase_acc_q0_carry_i_1__2_n_3}),
        .CYINIT(1'b0),
        .DI(bclk_phase_acc_q[21:18]),
        .O(bclk_phase_sum[21:18]),
        .S({bclk_phase_acc_q0_carry_i_3_n_0,bclk_phase_acc_q0_carry_i_4__1_n_0,bclk_phase_acc_q0_carry_i_5__1_n_0,bclk_phase_acc_q0_carry_i_6_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__3
       (.CI(bclk_phase_acc_q0_carry_i_1__2_n_0),
        .CO({bclk_phase_acc_q0_carry_i_1__3_n_0,bclk_phase_acc_q0_carry_i_1__3_n_1,bclk_phase_acc_q0_carry_i_1__3_n_2,bclk_phase_acc_q0_carry_i_1__3_n_3}),
        .CYINIT(1'b0),
        .DI(bclk_phase_acc_q[25:22]),
        .O(bclk_phase_sum[25:22]),
        .S({bclk_phase_acc_q[25],bclk_phase_acc_q0_carry_i_3__0_n_0,bclk_phase_acc_q0_carry_i_4__0_n_0,bclk_phase_acc_q0_carry_i_5__3_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__4
       (.CI(bclk_phase_acc_q0_carry_i_1__3_n_0),
        .CO({bclk_phase_acc_q0_carry_i_1__4_n_0,bclk_phase_acc_q0_carry_i_1__4_n_1,bclk_phase_acc_q0_carry_i_1__4_n_2,bclk_phase_acc_q0_carry_i_1__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,bclk_phase_acc_q[26]}),
        .O(bclk_phase_sum[29:26]),
        .S(bclk_phase_acc_q[29:26]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_1__5
       (.CI(bclk_phase_acc_q0_carry_i_1__4_n_0),
        .CO({NLW_bclk_phase_acc_q0_carry_i_1__5_CO_UNCONNECTED[3:1],bclk_phase_acc_q0_carry_i_1__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_bclk_phase_acc_q0_carry_i_1__5_O_UNCONNECTED[3:2],bclk_phase_sum[31:30]}),
        .S({1'b0,1'b0,bclk_phase_acc_q[31:30]}));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_2
       (.I0(bclk_phase_sum[12]),
        .O(bclk_phase_acc_q0_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_2__0
       (.I0(bclk_phase_sum[17]),
        .O(bclk_phase_acc_q0_carry_i_2__0_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_2__1
       (.I0(bclk_phase_sum[19]),
        .O(bclk_phase_acc_q0_carry_i_2__1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_2__2
       (.I0(bclk_phase_sum[25]),
        .O(bclk_phase_acc_q0_carry_i_2__2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_2__3
       (.I0(bclk_phase_sum[30]),
        .O(bclk_phase_acc_q0_carry_i_2__3_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 bclk_phase_acc_q0_carry_i_2__4
       (.CI(1'b0),
        .CO({bclk_phase_acc_q0_carry_i_2__4_n_0,bclk_phase_acc_q0_carry_i_2__4_n_1,bclk_phase_acc_q0_carry_i_2__4_n_2,bclk_phase_acc_q0_carry_i_2__4_n_3}),
        .CYINIT(1'b0),
        .DI({bclk_phase_acc_q[9:7],1'b0}),
        .O({bclk_phase_sum[9:7],NLW_bclk_phase_acc_q0_carry_i_2__4_O_UNCONNECTED[0]}),
        .S({bclk_phase_acc_q0_carry_i_10_n_0,bclk_phase_acc_q0_carry_i_11_n_0,bclk_phase_acc_q0_carry_i_12_n_0,1'b0}));
  LUT3 #(
    .INIT(8'h56)) 
    bclk_phase_acc_q0_carry_i_3
       (.I0(bclk_phase_acc_q[21]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[14]),
        .O(bclk_phase_acc_q0_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h5556)) 
    bclk_phase_acc_q0_carry_i_3__0
       (.I0(bclk_phase_acc_q[24]),
        .I1(sel0[19]),
        .I2(sel0[18]),
        .I3(sel0[17]),
        .O(bclk_phase_acc_q0_carry_i_3__0_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_3__0__0
       (.I0(bclk_phase_sum[11]),
        .O(bclk_phase_acc_q0_carry_i_3__0__0_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_3__1
       (.I0(bclk_phase_sum[10]),
        .O(bclk_phase_acc_q0_carry_i_3__1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_3__1__0
       (.I0(bclk_phase_sum[29]),
        .O(bclk_phase_acc_q0_carry_i_3__1__0_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    bclk_phase_acc_q0_carry_i_4
       (.I0(bclk_phase_acc_q[17]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[10]),
        .O(bclk_phase_acc_q0_carry_i_4_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    bclk_phase_acc_q0_carry_i_4__0
       (.I0(bclk_phase_acc_q[23]),
        .I1(sel0[17]),
        .I2(sel0[18]),
        .I3(sel0[19]),
        .I4(sel0[16]),
        .O(bclk_phase_acc_q0_carry_i_4__0_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_4__0__0
       (.I0(bclk_phase_sum[28]),
        .O(bclk_phase_acc_q0_carry_i_4__0__0_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    bclk_phase_acc_q0_carry_i_4__1
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(bclk_phase_acc_q[20]),
        .I3(sel0[13]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_4__1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_4__2
       (.I0(bclk_phase_sum[9]),
        .O(bclk_phase_acc_q0_carry_i_4__2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_5
       (.I0(bclk_phase_sum[8]),
        .O(bclk_phase_acc_q0_carry_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    bclk_phase_acc_q0_carry_i_5__0
       (.I0(bclk_phase_sum[27]),
        .O(bclk_phase_acc_q0_carry_i_5__0_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    bclk_phase_acc_q0_carry_i_5__1
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(bclk_phase_acc_q[19]),
        .I3(sel0[12]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_5__1_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    bclk_phase_acc_q0_carry_i_5__2
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(bclk_phase_acc_q[16]),
        .I3(sel0[9]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_5__2_n_0));
  LUT4 #(
    .INIT(16'h0F1E)) 
    bclk_phase_acc_q0_carry_i_5__3
       (.I0(sel0[15]),
        .I1(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I2(bclk_phase_acc_q[22]),
        .I3(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_5__3_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    bclk_phase_acc_q0_carry_i_6
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(bclk_phase_acc_q[18]),
        .I3(sel0[11]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_6_n_0));
  LUT5 #(
    .INIT(32'hF00FF0D2)) 
    bclk_phase_acc_q0_carry_i_6__0
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(bclk_phase_acc_q[15]),
        .I3(mclk_phase_acc_q0_carry_i_8_n_0),
        .I4(sel0[8]),
        .O(bclk_phase_acc_q0_carry_i_6__0_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    bclk_phase_acc_q0_carry_i_6__1
       (.I0(bclk_phase_acc_q[13]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[6]),
        .O(bclk_phase_acc_q0_carry_i_6__1_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    bclk_phase_acc_q0_carry_i_7
       (.I0(bclk_phase_acc_q[12]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[5]),
        .O(bclk_phase_acc_q0_carry_i_7_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    bclk_phase_acc_q0_carry_i_7__0
       (.I0(bclk_phase_acc_q[14]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(mclk_phase_acc_q0_carry__1_i_8_n_0),
        .O(bclk_phase_acc_q0_carry_i_7__0_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    bclk_phase_acc_q0_carry_i_8
       (.I0(bclk_phase_acc_q[11]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[4]),
        .O(bclk_phase_acc_q0_carry_i_8_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    bclk_phase_acc_q0_carry_i_9
       (.I0(bclk_phase_acc_q[10]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[3]),
        .O(bclk_phase_acc_q0_carry_i_9_n_0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[10]_i_1 
       (.I0(bclk_phase_acc_q0[10]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[10]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[11]_i_1 
       (.I0(bclk_phase_acc_q0[11]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[11]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[12]_i_1 
       (.I0(bclk_phase_acc_q0[12]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[12]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[12]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[13]_i_1 
       (.I0(bclk_phase_acc_q0[13]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[13]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[13]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[14]_i_1 
       (.I0(bclk_phase_acc_q0[14]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[14]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[14]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[15]_i_1 
       (.I0(bclk_phase_acc_q0[15]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[15]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[16]_i_1 
       (.I0(bclk_phase_acc_q0[16]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[16]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[16]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[17]_i_1 
       (.I0(bclk_phase_acc_q0[17]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[17]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[17]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[18]_i_1 
       (.I0(bclk_phase_acc_q0[18]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[18]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[18]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[19]_i_1 
       (.I0(bclk_phase_acc_q0[19]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[19]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[19]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[20]_i_1 
       (.I0(bclk_phase_acc_q0[20]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[20]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[20]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[21]_i_1 
       (.I0(bclk_phase_acc_q0[21]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[21]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[21]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[22]_i_1 
       (.I0(bclk_phase_acc_q0[22]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[22]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[22]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[23]_i_1 
       (.I0(bclk_phase_acc_q0[23]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[23]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[24]_i_1 
       (.I0(bclk_phase_acc_q0[24]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[24]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[24]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[25]_i_1 
       (.I0(bclk_phase_acc_q0[25]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[25]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[25]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[26]_i_1 
       (.I0(bclk_phase_acc_q0[26]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[26]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bclk_phase_acc_q[27]_i_1 
       (.I0(bclk_phase_acc_q0[27]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(bclk_q_i_2_n_0),
        .O(\bclk_phase_acc_q[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bclk_phase_acc_q[28]_i_1 
       (.I0(bclk_phase_acc_q0[28]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(bclk_q_i_2_n_0),
        .O(\bclk_phase_acc_q[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bclk_phase_acc_q[29]_i_1 
       (.I0(bclk_phase_acc_q0[29]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(bclk_q_i_2_n_0),
        .O(\bclk_phase_acc_q[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bclk_phase_acc_q[30]_i_1 
       (.I0(bclk_phase_acc_q0[30]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(bclk_q_i_2_n_0),
        .O(\bclk_phase_acc_q[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bclk_phase_acc_q[31]_i_1 
       (.I0(bclk_phase_acc_q0[31]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(bclk_q_i_2_n_0),
        .O(\bclk_phase_acc_q[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[7]_i_1 
       (.I0(bclk_phase_acc_q0[7]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[7]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[8]_i_1 
       (.I0(bclk_phase_acc_q0[8]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[8]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \bclk_phase_acc_q[9]_i_1 
       (.I0(bclk_phase_acc_q0[9]),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_phase_sum[9]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\bclk_phase_acc_q[9]_i_1_n_0 ));
  FDCE \bclk_phase_acc_q_reg[10] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[10]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[10]));
  FDCE \bclk_phase_acc_q_reg[11] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[11]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[11]));
  FDCE \bclk_phase_acc_q_reg[12] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[12]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[12]));
  FDCE \bclk_phase_acc_q_reg[13] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[13]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[13]));
  FDCE \bclk_phase_acc_q_reg[14] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[14]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[14]));
  FDCE \bclk_phase_acc_q_reg[15] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[15]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[15]));
  FDCE \bclk_phase_acc_q_reg[16] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[16]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[16]));
  FDCE \bclk_phase_acc_q_reg[17] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[17]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[17]));
  FDCE \bclk_phase_acc_q_reg[18] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[18]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[18]));
  FDCE \bclk_phase_acc_q_reg[19] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[19]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[19]));
  FDCE \bclk_phase_acc_q_reg[20] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[20]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[20]));
  FDCE \bclk_phase_acc_q_reg[21] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[21]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[21]));
  FDCE \bclk_phase_acc_q_reg[22] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[22]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[22]));
  FDCE \bclk_phase_acc_q_reg[23] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[23]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[23]));
  FDCE \bclk_phase_acc_q_reg[24] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[24]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[24]));
  FDCE \bclk_phase_acc_q_reg[25] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[25]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[25]));
  FDCE \bclk_phase_acc_q_reg[26] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[26]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[26]));
  FDCE \bclk_phase_acc_q_reg[27] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[27]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[27]));
  FDCE \bclk_phase_acc_q_reg[28] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[28]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[28]));
  FDCE \bclk_phase_acc_q_reg[29] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[29]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[29]));
  FDCE \bclk_phase_acc_q_reg[30] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[30]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[30]));
  FDCE \bclk_phase_acc_q_reg[31] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[31]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[31]));
  FDCE \bclk_phase_acc_q_reg[7] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[7]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[7]));
  FDCE \bclk_phase_acc_q_reg[8] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[8]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[8]));
  FDCE \bclk_phase_acc_q_reg[9] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\bclk_phase_acc_q[9]_i_1_n_0 ),
        .Q(bclk_phase_acc_q[9]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h82)) 
    bclk_q_i_1
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(bclk_q_i_2_n_0),
        .I2(bclk_q_reg_0),
        .O(bclk_q_i_1_n_0));
  LUT4 #(
    .INIT(16'h001F)) 
    bclk_q_i_2
       (.I0(bclk_phase_sum[25]),
        .I1(bclk_q_i_3_n_0),
        .I2(bclk_phase_sum[26]),
        .I3(bclk_q_i_4_n_0),
        .O(bclk_q_i_2_n_0));
  LUT6 #(
    .INIT(64'h00000000FFFFAA08)) 
    bclk_q_i_3
       (.I0(bclk_phase_sum[18]),
        .I1(bclk_q_i_5_n_0),
        .I2(bclk_q_i_6_n_0),
        .I3(bclk_phase_sum[17]),
        .I4(bclk_phase_sum[19]),
        .I5(bclk_q_i_7_n_0),
        .O(bclk_q_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    bclk_q_i_4
       (.I0(bclk_phase_sum[31]),
        .I1(bclk_phase_sum[27]),
        .I2(bclk_phase_sum[29]),
        .I3(bclk_phase_sum[30]),
        .I4(bclk_phase_sum[28]),
        .O(bclk_q_i_4_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    bclk_q_i_5
       (.I0(bclk_phase_sum[12]),
        .I1(bclk_phase_sum[10]),
        .I2(bclk_phase_sum[8]),
        .I3(bclk_phase_sum[9]),
        .I4(bclk_phase_sum[11]),
        .O(bclk_q_i_5_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    bclk_q_i_6
       (.I0(bclk_phase_sum[15]),
        .I1(bclk_phase_sum[14]),
        .I2(bclk_phase_sum[16]),
        .I3(bclk_phase_sum[13]),
        .O(bclk_q_i_6_n_0));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    bclk_q_i_7
       (.I0(bclk_phase_sum[23]),
        .I1(bclk_phase_sum[21]),
        .I2(bclk_phase_sum[20]),
        .I3(bclk_phase_sum[22]),
        .I4(bclk_phase_sum[24]),
        .O(bclk_q_i_7_n_0));
  FDCE bclk_q_reg
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(bclk_q_i_1_n_0),
        .Q(bclk_q_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \bit_count_q[0]_i_1 
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(p_0_in[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \bit_count_q[1]_i_1 
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .I2(\slv_reg2_reg_n_0_[0] ),
        .O(\bit_count_q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \bit_count_q[2]_i_1 
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(p_0_in[2]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \bit_count_q[3]_i_1 
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .I3(p_0_in[2]),
        .I4(p_0_in[3]),
        .O(p_0_in__0[3]));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \bit_count_q[4]_i_1 
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(p_0_in[2]),
        .I2(p_0_in[1]),
        .I3(p_0_in[0]),
        .I4(p_0_in[3]),
        .I5(p_0_in[4]),
        .O(p_0_in__0[4]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \bit_count_q[5]_i_1 
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(\bit_count_q[5]_i_2_n_0 ),
        .I2(p_0_in[4]),
        .I3(p_0_in2_in),
        .O(p_0_in__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \bit_count_q[5]_i_2 
       (.I0(p_0_in[2]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .I3(p_0_in[3]),
        .O(\bit_count_q[5]_i_2_n_0 ));
  FDCE \bit_count_q_reg[0] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(p_0_in__0[0]),
        .Q(p_0_in[0]));
  FDCE \bit_count_q_reg[1] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(\bit_count_q[1]_i_1_n_0 ),
        .Q(p_0_in[1]));
  FDCE \bit_count_q_reg[2] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(p_0_in__0[2]),
        .Q(p_0_in[2]));
  FDCE \bit_count_q_reg[3] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(p_0_in__0[3]),
        .Q(p_0_in[3]));
  FDCE \bit_count_q_reg[4] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(p_0_in__0[4]),
        .Q(p_0_in[4]));
  FDCE \bit_count_q_reg[5] 
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(p_0_in__0[5]),
        .Q(p_0_in2_in));
  LUT6 #(
    .INIT(64'hFFFFFBFF00000400)) 
    current_latch_status_q_i_1
       (.I0(bclk_q_i_2_n_0),
        .I1(data_q_i_4_n_0),
        .I2(p_0_in2_in),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .I4(bclk_q_reg_0),
        .I5(current_latch_status_q),
        .O(current_latch_status_q_i_1_n_0));
  FDCE current_latch_status_q_reg
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(current_latch_status_q_i_1_n_0),
        .Q(current_latch_status_q));
  LUT6 #(
    .INIT(64'h0000000000000200)) 
    data_q_i_1
       (.I0(data_q_i_2_n_0),
        .I1(data_q_i_3_n_0),
        .I2(mute_sync),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .I4(data_q_i_4_n_0),
        .I5(data_q_i_5_n_0),
        .O(data_q_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h96996696)) 
    data_q_i_10
       (.I0(sample_width_raw[4]),
        .I1(p_0_in[4]),
        .I2(sample_width_raw[3]),
        .I3(p_0_in[3]),
        .I4(data_q_i_12_n_0),
        .O(data_q_i_10_n_0));
  LUT6 #(
    .INIT(64'hBBBBBBBBBBBBBBB8)) 
    data_q_i_11
       (.I0(p_0_in[4]),
        .I1(sample_width_raw[4]),
        .I2(sample_width_raw[3]),
        .I3(sample_width_raw[1]),
        .I4(sample_width_raw[2]),
        .I5(sample_width_raw[0]),
        .O(data_q_i_11_n_0));
  LUT6 #(
    .INIT(64'hBB2B2B22BB2BBB2B)) 
    data_q_i_12
       (.I0(sample_width_raw[2]),
        .I1(p_0_in[2]),
        .I2(p_0_in[1]),
        .I3(sample_width_raw[1]),
        .I4(sample_width_raw[0]),
        .I5(p_0_in[0]),
        .O(data_q_i_12_n_0));
  LUT6 #(
    .INIT(64'hBBBBBBABABABBBAB)) 
    data_q_i_13
       (.I0(data_q_i_30_n_0),
        .I1(data_q_i_31_n_0),
        .I2(data_q_i_24_n_0),
        .I3(sample_left_q[4]),
        .I4(data_q_i_23_n_0),
        .I5(sample_left_q[5]),
        .O(data_q_i_13_n_0));
  LUT5 #(
    .INIT(32'h0000DD0F)) 
    data_q_i_14
       (.I0(data_q_i_32_n_0),
        .I1(data_q_i_33_n_0),
        .I2(data_q_i_34_n_0),
        .I3(data_q_i_19_n_0),
        .I4(data_q_i_18_n_0),
        .O(data_q_i_14_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF54045555)) 
    data_q_i_15
       (.I0(data_q_i_35_n_0),
        .I1(sample_left_q[20]),
        .I2(data_q_i_23_n_0),
        .I3(sample_left_q[21]),
        .I4(data_q_i_24_n_0),
        .I5(data_q_i_36_n_0),
        .O(data_q_i_15_n_0));
  LUT6 #(
    .INIT(64'h00000000AAABBBAB)) 
    data_q_i_16
       (.I0(data_q_i_37_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_left_q[26]),
        .I3(data_q_i_23_n_0),
        .I4(sample_left_q[27]),
        .I5(data_q_i_38_n_0),
        .O(data_q_i_16_n_0));
  LUT6 #(
    .INIT(64'h505F3030505F3F3F)) 
    data_q_i_17
       (.I0(sample_right_q[13]),
        .I1(sample_right_q[12]),
        .I2(data_q_i_24_n_0),
        .I3(sample_right_q[15]),
        .I4(data_q_i_23_n_0),
        .I5(sample_right_q[14]),
        .O(data_q_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h96)) 
    data_q_i_18
       (.I0(sample_width_raw[3]),
        .I1(p_0_in[3]),
        .I2(data_q_i_12_n_0),
        .O(data_q_i_18_n_0));
  LUT6 #(
    .INIT(64'h9969666699999969)) 
    data_q_i_19
       (.I0(sample_width_raw[2]),
        .I1(p_0_in[2]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_width_raw[1]),
        .I5(p_0_in[1]),
        .O(data_q_i_19_n_0));
  LUT6 #(
    .INIT(64'h8F8F8F8F0F0FFF0F)) 
    data_q_i_2
       (.I0(data_q_i_6_n_0),
        .I1(data_q_i_7_n_0),
        .I2(p_0_in2_in),
        .I3(data_q_i_8_n_0),
        .I4(data_q_i_9_n_0),
        .I5(data_q_i_10_n_0),
        .O(data_q_i_2_n_0));
  LUT6 #(
    .INIT(64'hF9FFFFF9F96699F9)) 
    data_q_i_20
       (.I0(p_0_in[1]),
        .I1(sample_width_raw[1]),
        .I2(sample_right_q[10]),
        .I3(sample_width_raw[0]),
        .I4(p_0_in[0]),
        .I5(sample_right_q[11]),
        .O(data_q_i_20_n_0));
  LUT6 #(
    .INIT(64'h0900000909669909)) 
    data_q_i_21
       (.I0(p_0_in[1]),
        .I1(sample_width_raw[1]),
        .I2(sample_right_q[8]),
        .I3(sample_width_raw[0]),
        .I4(p_0_in[0]),
        .I5(sample_right_q[9]),
        .O(data_q_i_21_n_0));
  LUT6 #(
    .INIT(64'h555555555775F77F)) 
    data_q_i_22
       (.I0(data_q_i_19_n_0),
        .I1(sample_right_q[3]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_right_q[2]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_22_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    data_q_i_23
       (.I0(p_0_in[0]),
        .I1(sample_width_raw[0]),
        .O(data_q_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'hD22D)) 
    data_q_i_24
       (.I0(p_0_in[0]),
        .I1(sample_width_raw[0]),
        .I2(sample_width_raw[1]),
        .I3(p_0_in[1]),
        .O(data_q_i_24_n_0));
  LUT6 #(
    .INIT(64'h55555555FD5DFFFF)) 
    data_q_i_25
       (.I0(data_q_i_18_n_0),
        .I1(sample_right_q[4]),
        .I2(data_q_i_23_n_0),
        .I3(sample_right_q[5]),
        .I4(data_q_i_24_n_0),
        .I5(data_q_i_39_n_0),
        .O(data_q_i_25_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_26
       (.I0(data_q_i_19_n_0),
        .I1(sample_right_q[23]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_right_q[22]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_26_n_0));
  LUT6 #(
    .INIT(64'h55555555FFFDDDFD)) 
    data_q_i_27
       (.I0(data_q_i_18_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_right_q[18]),
        .I3(data_q_i_23_n_0),
        .I4(sample_right_q[19]),
        .I5(data_q_i_40_n_0),
        .O(data_q_i_27_n_0));
  LUT6 #(
    .INIT(64'h555555555775F77F)) 
    data_q_i_28
       (.I0(data_q_i_19_n_0),
        .I1(sample_right_q[27]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_right_q[26]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_28_n_0));
  LUT6 #(
    .INIT(64'hBBBAAABABBBBBBBB)) 
    data_q_i_29
       (.I0(data_q_i_18_n_0),
        .I1(data_q_i_41_n_0),
        .I2(sample_right_q[28]),
        .I3(data_q_i_23_n_0),
        .I4(sample_right_q[29]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_29_n_0));
  LUT6 #(
    .INIT(64'h28AA2828AAAA28AA)) 
    data_q_i_3
       (.I0(data_q_i_11_n_0),
        .I1(p_0_in[4]),
        .I2(sample_width_raw[4]),
        .I3(data_q_i_12_n_0),
        .I4(p_0_in[3]),
        .I5(sample_width_raw[3]),
        .O(data_q_i_3_n_0));
  LUT6 #(
    .INIT(64'h55555555FFFDDDFD)) 
    data_q_i_30
       (.I0(data_q_i_18_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_left_q[2]),
        .I3(data_q_i_23_n_0),
        .I4(sample_left_q[3]),
        .I5(data_q_i_42_n_0),
        .O(data_q_i_30_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_31
       (.I0(data_q_i_19_n_0),
        .I1(sample_left_q[7]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_left_q[6]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_31_n_0));
  LUT6 #(
    .INIT(64'hF9FFFFF9F96699F9)) 
    data_q_i_32
       (.I0(p_0_in[1]),
        .I1(sample_width_raw[1]),
        .I2(sample_left_q[10]),
        .I3(sample_width_raw[0]),
        .I4(p_0_in[0]),
        .I5(sample_left_q[11]),
        .O(data_q_i_32_n_0));
  LUT6 #(
    .INIT(64'h0900000909669909)) 
    data_q_i_33
       (.I0(p_0_in[1]),
        .I1(sample_width_raw[1]),
        .I2(sample_left_q[8]),
        .I3(sample_width_raw[0]),
        .I4(p_0_in[0]),
        .I5(sample_left_q[9]),
        .O(data_q_i_33_n_0));
  LUT6 #(
    .INIT(64'hF0FFF000AACCAACC)) 
    data_q_i_34
       (.I0(sample_left_q[15]),
        .I1(sample_left_q[14]),
        .I2(sample_left_q[13]),
        .I3(data_q_i_23_n_0),
        .I4(sample_left_q[12]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_34_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_35
       (.I0(data_q_i_19_n_0),
        .I1(sample_left_q[23]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_left_q[22]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_35_n_0));
  LUT6 #(
    .INIT(64'h55555555FD5DFFFF)) 
    data_q_i_36
       (.I0(data_q_i_18_n_0),
        .I1(sample_left_q[16]),
        .I2(data_q_i_23_n_0),
        .I3(sample_left_q[17]),
        .I4(data_q_i_24_n_0),
        .I5(data_q_i_43_n_0),
        .O(data_q_i_36_n_0));
  LUT6 #(
    .INIT(64'h555D5D55DD5D5DDD)) 
    data_q_i_37
       (.I0(data_q_i_19_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_left_q[25]),
        .I3(p_0_in[0]),
        .I4(sample_width_raw[0]),
        .I5(sample_left_q[24]),
        .O(data_q_i_37_n_0));
  LUT6 #(
    .INIT(64'hBBBAAABABBBBBBBB)) 
    data_q_i_38
       (.I0(data_q_i_18_n_0),
        .I1(data_q_i_44_n_0),
        .I2(sample_left_q[28]),
        .I3(data_q_i_23_n_0),
        .I4(sample_left_q[29]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_38_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_39
       (.I0(data_q_i_19_n_0),
        .I1(sample_right_q[7]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_right_q[6]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_39_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    data_q_i_4
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .I2(p_0_in[2]),
        .I3(p_0_in[4]),
        .I4(p_0_in[3]),
        .O(data_q_i_4_n_0));
  LUT6 #(
    .INIT(64'h555D5D55DD5D5DDD)) 
    data_q_i_40
       (.I0(data_q_i_19_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_right_q[17]),
        .I3(p_0_in[0]),
        .I4(sample_width_raw[0]),
        .I5(sample_right_q[16]),
        .O(data_q_i_40_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_41
       (.I0(data_q_i_19_n_0),
        .I1(sample_right_q[31]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_right_q[30]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_41_n_0));
  LUT6 #(
    .INIT(64'h555D5D55DD5D5DDD)) 
    data_q_i_42
       (.I0(data_q_i_19_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_left_q[1]),
        .I3(p_0_in[0]),
        .I4(sample_width_raw[0]),
        .I5(sample_left_q[0]),
        .O(data_q_i_42_n_0));
  LUT6 #(
    .INIT(64'h555555555775F77F)) 
    data_q_i_43
       (.I0(data_q_i_19_n_0),
        .I1(sample_left_q[19]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_left_q[18]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_43_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAABBAFBBF)) 
    data_q_i_44
       (.I0(data_q_i_19_n_0),
        .I1(sample_left_q[31]),
        .I2(p_0_in[0]),
        .I3(sample_width_raw[0]),
        .I4(sample_left_q[30]),
        .I5(data_q_i_24_n_0),
        .O(data_q_i_44_n_0));
  LUT6 #(
    .INIT(64'h00000000DDDDFF0F)) 
    data_q_i_5
       (.I0(data_q_i_13_n_0),
        .I1(data_q_i_14_n_0),
        .I2(data_q_i_15_n_0),
        .I3(data_q_i_16_n_0),
        .I4(data_q_i_10_n_0),
        .I5(p_0_in2_in),
        .O(data_q_i_5_n_0));
  LUT5 #(
    .INIT(32'hCDCDFDCD)) 
    data_q_i_6
       (.I0(data_q_i_17_n_0),
        .I1(data_q_i_18_n_0),
        .I2(data_q_i_19_n_0),
        .I3(data_q_i_20_n_0),
        .I4(data_q_i_21_n_0),
        .O(data_q_i_6_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF54045555)) 
    data_q_i_7
       (.I0(data_q_i_22_n_0),
        .I1(sample_right_q[0]),
        .I2(data_q_i_23_n_0),
        .I3(sample_right_q[1]),
        .I4(data_q_i_24_n_0),
        .I5(data_q_i_25_n_0),
        .O(data_q_i_7_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF54045555)) 
    data_q_i_8
       (.I0(data_q_i_26_n_0),
        .I1(sample_right_q[20]),
        .I2(data_q_i_23_n_0),
        .I3(sample_right_q[21]),
        .I4(data_q_i_24_n_0),
        .I5(data_q_i_27_n_0),
        .O(data_q_i_8_n_0));
  LUT6 #(
    .INIT(64'h00000000AAAEEEAE)) 
    data_q_i_9
       (.I0(data_q_i_28_n_0),
        .I1(data_q_i_24_n_0),
        .I2(sample_right_q[24]),
        .I3(data_q_i_23_n_0),
        .I4(sample_right_q[25]),
        .I5(data_q_i_29_n_0),
        .O(data_q_i_9_n_0));
  FDCE data_q_reg
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(data_q_i_1_n_0),
        .Q(i2s_data));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry
       (.CI(1'b0),
        .CO({mclk_phase_acc_q0_carry_n_0,mclk_phase_acc_q0_carry_n_1,mclk_phase_acc_q0_carry_n_2,mclk_phase_acc_q0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({mclk_phase_sum[10:8],1'b0}),
        .O({mclk_phase_acc_q0[10:8],NLW_mclk_phase_acc_q0_carry_O_UNCONNECTED[0]}),
        .S({mclk_phase_acc_q0_carry_i_2_n_0,mclk_phase_acc_q0_carry_i_3_n_0,mclk_phase_acc_q0_carry_i_4_n_0,1'b0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__0
       (.CI(mclk_phase_acc_q0_carry_n_0),
        .CO({mclk_phase_acc_q0_carry__0_n_0,mclk_phase_acc_q0_carry__0_n_1,mclk_phase_acc_q0_carry__0_n_2,mclk_phase_acc_q0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,mclk_phase_sum[12:11]}),
        .O(mclk_phase_acc_q0[14:11]),
        .S({mclk_phase_sum[14:13],mclk_phase_acc_q0_carry__0_i_2_n_0,mclk_phase_acc_q0_carry__0_i_3_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__0_i_1
       (.CI(mclk_phase_acc_q0_carry_i_1_n_0),
        .CO({mclk_phase_acc_q0_carry__0_i_1_n_0,mclk_phase_acc_q0_carry__0_i_1_n_1,mclk_phase_acc_q0_carry__0_i_1_n_2,mclk_phase_acc_q0_carry__0_i_1_n_3}),
        .CYINIT(1'b0),
        .DI(mclk_phase_acc_q[15:12]),
        .O(mclk_phase_sum[15:12]),
        .S({mclk_phase_acc_q0_carry__0_i_4_n_0,mclk_phase_acc_q0_carry__0_i_5_n_0,mclk_phase_acc_q0_carry__0_i_6_n_0,mclk_phase_acc_q0_carry__0_i_7_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__0_i_2
       (.I0(mclk_phase_sum[12]),
        .O(mclk_phase_acc_q0_carry__0_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__0_i_3
       (.I0(mclk_phase_sum[11]),
        .O(mclk_phase_acc_q0_carry__0_i_3_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    mclk_phase_acc_q0_carry__0_i_4
       (.I0(mclk_phase_acc_q[15]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[6]),
        .O(mclk_phase_acc_q0_carry__0_i_4_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    mclk_phase_acc_q0_carry__0_i_5
       (.I0(mclk_phase_acc_q[14]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[5]),
        .O(mclk_phase_acc_q0_carry__0_i_5_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    mclk_phase_acc_q0_carry__0_i_6
       (.I0(mclk_phase_acc_q[13]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[4]),
        .O(mclk_phase_acc_q0_carry__0_i_6_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    mclk_phase_acc_q0_carry__0_i_7
       (.I0(mclk_phase_acc_q[12]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[3]),
        .O(mclk_phase_acc_q0_carry__0_i_7_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__1
       (.CI(mclk_phase_acc_q0_carry__0_n_0),
        .CO({mclk_phase_acc_q0_carry__1_n_0,mclk_phase_acc_q0_carry__1_n_1,mclk_phase_acc_q0_carry__1_n_2,mclk_phase_acc_q0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,mclk_phase_sum[17],1'b0,1'b0}),
        .O(mclk_phase_acc_q0[18:15]),
        .S({mclk_phase_sum[18],mclk_phase_acc_q0_carry__1_i_2_n_0,mclk_phase_sum[16:15]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__1_i_1
       (.CI(mclk_phase_acc_q0_carry__0_i_1_n_0),
        .CO({mclk_phase_acc_q0_carry__1_i_1_n_0,mclk_phase_acc_q0_carry__1_i_1_n_1,mclk_phase_acc_q0_carry__1_i_1_n_2,mclk_phase_acc_q0_carry__1_i_1_n_3}),
        .CYINIT(1'b0),
        .DI(mclk_phase_acc_q[19:16]),
        .O(mclk_phase_sum[19:16]),
        .S({mclk_phase_acc_q0_carry__1_i_3_n_0,mclk_phase_acc_q0_carry__1_i_4_n_0,mclk_phase_acc_q0_carry__1_i_5_n_0,mclk_phase_acc_q0_carry__1_i_6_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF2)) 
    mclk_phase_acc_q0_carry__1_i_10
       (.I0(sel0[9]),
        .I1(sel0[10]),
        .I2(sel0[11]),
        .I3(sel0[17]),
        .I4(sel0[16]),
        .I5(mclk_phase_acc_q0_carry__1_i_13_n_0),
        .O(mclk_phase_acc_q0_carry__1_i_10_n_0));
  LUT4 #(
    .INIT(16'h0001)) 
    mclk_phase_acc_q0_carry__1_i_11
       (.I0(sel0[1]),
        .I1(sel0[2]),
        .I2(sel0[3]),
        .I3(sel0[0]),
        .O(mclk_phase_acc_q0_carry__1_i_11_n_0));
  LUT4 #(
    .INIT(16'hEFEE)) 
    mclk_phase_acc_q0_carry__1_i_12
       (.I0(sel0[13]),
        .I1(sel0[14]),
        .I2(sel0[7]),
        .I3(sel0[6]),
        .O(mclk_phase_acc_q0_carry__1_i_12_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mclk_phase_acc_q0_carry__1_i_13
       (.I0(sel0[19]),
        .I1(sel0[18]),
        .O(mclk_phase_acc_q0_carry__1_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__1_i_2
       (.I0(mclk_phase_sum[17]),
        .O(mclk_phase_acc_q0_carry__1_i_2_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    mclk_phase_acc_q0_carry__1_i_3
       (.I0(mclk_phase_acc_q[19]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[10]),
        .O(mclk_phase_acc_q0_carry__1_i_3_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    mclk_phase_acc_q0_carry__1_i_4
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(mclk_phase_acc_q[18]),
        .I3(sel0[9]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__1_i_4_n_0));
  LUT5 #(
    .INIT(32'hF00FF0D2)) 
    mclk_phase_acc_q0_carry__1_i_5
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(mclk_phase_acc_q[17]),
        .I3(mclk_phase_acc_q0_carry_i_8_n_0),
        .I4(sel0[8]),
        .O(mclk_phase_acc_q0_carry__1_i_5_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    mclk_phase_acc_q0_carry__1_i_6
       (.I0(mclk_phase_acc_q[16]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(mclk_phase_acc_q0_carry__1_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__1_i_6_n_0));
  LUT5 #(
    .INIT(32'h00000002)) 
    mclk_phase_acc_q0_carry__1_i_7
       (.I0(mclk_phase_acc_q0_carry__1_i_9_n_0),
        .I1(sel0[7]),
        .I2(sel0[10]),
        .I3(sel0[11]),
        .I4(mclk_phase_acc_q0_carry__1_i_10_n_0),
        .O(mclk_phase_acc_q0_carry__1_i_7_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    mclk_phase_acc_q0_carry__1_i_8
       (.I0(sel0[7]),
        .I1(mclk_phase_acc_q0_carry__1_i_10_n_0),
        .I2(sel0[11]),
        .I3(sel0[10]),
        .I4(sel0[15]),
        .I5(mclk_phase_acc_q0_carry__1_i_9_n_0),
        .O(mclk_phase_acc_q0_carry__1_i_8_n_0));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    mclk_phase_acc_q0_carry__1_i_9
       (.I0(mclk_phase_acc_q0_carry__1_i_11_n_0),
        .I1(mclk_phase_acc_q0_carry__1_i_12_n_0),
        .I2(sel0[8]),
        .I3(sel0[5]),
        .I4(sel0[12]),
        .I5(sel0[4]),
        .O(mclk_phase_acc_q0_carry__1_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__2
       (.CI(mclk_phase_acc_q0_carry__1_n_0),
        .CO({mclk_phase_acc_q0_carry__2_n_0,mclk_phase_acc_q0_carry__2_n_1,mclk_phase_acc_q0_carry__2_n_2,mclk_phase_acc_q0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,mclk_phase_sum[19]}),
        .O(mclk_phase_acc_q0[22:19]),
        .S({mclk_phase_sum[22:20],mclk_phase_acc_q0_carry__2_i_2_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__2_i_1
       (.CI(mclk_phase_acc_q0_carry__1_i_1_n_0),
        .CO({mclk_phase_acc_q0_carry__2_i_1_n_0,mclk_phase_acc_q0_carry__2_i_1_n_1,mclk_phase_acc_q0_carry__2_i_1_n_2,mclk_phase_acc_q0_carry__2_i_1_n_3}),
        .CYINIT(1'b0),
        .DI(mclk_phase_acc_q[23:20]),
        .O(mclk_phase_sum[23:20]),
        .S({mclk_phase_acc_q0_carry__2_i_3_n_0,mclk_phase_acc_q0_carry__2_i_4_n_0,mclk_phase_acc_q0_carry__2_i_5_n_0,mclk_phase_acc_q0_carry__2_i_6_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__2_i_2
       (.I0(mclk_phase_sum[19]),
        .O(mclk_phase_acc_q0_carry__2_i_2_n_0));
  LUT3 #(
    .INIT(8'h56)) 
    mclk_phase_acc_q0_carry__2_i_3
       (.I0(mclk_phase_acc_q[23]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[14]),
        .O(mclk_phase_acc_q0_carry__2_i_3_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    mclk_phase_acc_q0_carry__2_i_4
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(mclk_phase_acc_q[22]),
        .I3(sel0[13]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__2_i_4_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    mclk_phase_acc_q0_carry__2_i_5
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(mclk_phase_acc_q[21]),
        .I3(sel0[12]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__2_i_5_n_0));
  LUT5 #(
    .INIT(32'h0F0F0FD2)) 
    mclk_phase_acc_q0_carry__2_i_6
       (.I0(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I1(sel0[15]),
        .I2(mclk_phase_acc_q[20]),
        .I3(sel0[11]),
        .I4(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__2_i_6_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__3
       (.CI(mclk_phase_acc_q0_carry__2_n_0),
        .CO({mclk_phase_acc_q0_carry__3_n_0,mclk_phase_acc_q0_carry__3_n_1,mclk_phase_acc_q0_carry__3_n_2,mclk_phase_acc_q0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,mclk_phase_sum[25],1'b0,1'b0}),
        .O(mclk_phase_acc_q0[26:23]),
        .S({mclk_phase_sum[26],mclk_phase_acc_q0_carry__3_i_2_n_0,mclk_phase_sum[24:23]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__3_i_1
       (.CI(mclk_phase_acc_q0_carry__2_i_1_n_0),
        .CO({mclk_phase_acc_q0_carry__3_i_1_n_0,mclk_phase_acc_q0_carry__3_i_1_n_1,mclk_phase_acc_q0_carry__3_i_1_n_2,mclk_phase_acc_q0_carry__3_i_1_n_3}),
        .CYINIT(1'b0),
        .DI(mclk_phase_acc_q[27:24]),
        .O(mclk_phase_sum[27:24]),
        .S({mclk_phase_acc_q[27],mclk_phase_acc_q0_carry__3_i_3_n_0,mclk_phase_acc_q0_carry__3_i_4_n_0,mclk_phase_acc_q0_carry__3_i_5_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__3_i_2
       (.I0(mclk_phase_sum[25]),
        .O(mclk_phase_acc_q0_carry__3_i_2_n_0));
  LUT4 #(
    .INIT(16'h5556)) 
    mclk_phase_acc_q0_carry__3_i_3
       (.I0(mclk_phase_acc_q[26]),
        .I1(sel0[19]),
        .I2(sel0[18]),
        .I3(sel0[17]),
        .O(mclk_phase_acc_q0_carry__3_i_3_n_0));
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    mclk_phase_acc_q0_carry__3_i_4
       (.I0(mclk_phase_acc_q[25]),
        .I1(sel0[17]),
        .I2(sel0[18]),
        .I3(sel0[19]),
        .I4(sel0[16]),
        .O(mclk_phase_acc_q0_carry__3_i_4_n_0));
  LUT4 #(
    .INIT(16'h0F1E)) 
    mclk_phase_acc_q0_carry__3_i_5
       (.I0(sel0[15]),
        .I1(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I2(mclk_phase_acc_q[24]),
        .I3(mclk_phase_acc_q0_carry_i_8_n_0),
        .O(mclk_phase_acc_q0_carry__3_i_5_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__4
       (.CI(mclk_phase_acc_q0_carry__3_n_0),
        .CO({mclk_phase_acc_q0_carry__4_n_0,mclk_phase_acc_q0_carry__4_n_1,mclk_phase_acc_q0_carry__4_n_2,mclk_phase_acc_q0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(mclk_phase_sum[30:27]),
        .O(mclk_phase_acc_q0[30:27]),
        .S({mclk_phase_acc_q0_carry__4_i_2_n_0,mclk_phase_acc_q0_carry__4_i_3_n_0,mclk_phase_acc_q0_carry__4_i_4_n_0,mclk_phase_acc_q0_carry__4_i_5_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__4_i_1
       (.CI(mclk_phase_acc_q0_carry__3_i_1_n_0),
        .CO({NLW_mclk_phase_acc_q0_carry__4_i_1_CO_UNCONNECTED[3],mclk_phase_acc_q0_carry__4_i_1_n_1,mclk_phase_acc_q0_carry__4_i_1_n_2,mclk_phase_acc_q0_carry__4_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,mclk_phase_acc_q[28]}),
        .O(mclk_phase_sum[31:28]),
        .S(mclk_phase_acc_q[31:28]));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__4_i_2
       (.I0(mclk_phase_sum[30]),
        .O(mclk_phase_acc_q0_carry__4_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__4_i_3
       (.I0(mclk_phase_sum[29]),
        .O(mclk_phase_acc_q0_carry__4_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__4_i_4
       (.I0(mclk_phase_sum[28]),
        .O(mclk_phase_acc_q0_carry__4_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__4_i_5
       (.I0(mclk_phase_sum[27]),
        .O(mclk_phase_acc_q0_carry__4_i_5_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry__5
       (.CI(mclk_phase_acc_q0_carry__4_n_0),
        .CO(NLW_mclk_phase_acc_q0_carry__5_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_mclk_phase_acc_q0_carry__5_O_UNCONNECTED[3:1],mclk_phase_acc_q0[31]}),
        .S({1'b0,1'b0,1'b0,mclk_phase_acc_q0_carry__5_i_1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry__5_i_1
       (.I0(mclk_phase_sum[31]),
        .O(mclk_phase_acc_q0_carry__5_i_1_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mclk_phase_acc_q0_carry_i_1
       (.CI(1'b0),
        .CO({mclk_phase_acc_q0_carry_i_1_n_0,mclk_phase_acc_q0_carry_i_1_n_1,mclk_phase_acc_q0_carry_i_1_n_2,mclk_phase_acc_q0_carry_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({mclk_phase_acc_q[11:9],1'b0}),
        .O(mclk_phase_sum[11:8]),
        .S({mclk_phase_acc_q0_carry_i_5_n_0,mclk_phase_acc_q0_carry_i_6_n_0,mclk_phase_acc_q0_carry_i_7_n_0,mclk_phase_acc_q[8]}));
  LUT6 #(
    .INIT(64'h770FFFFFFF0FFFFF)) 
    mclk_phase_acc_q0_carry_i_10
       (.I0(sel0[11]),
        .I1(sel0[12]),
        .I2(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I3(sel0[15]),
        .I4(sel0[14]),
        .I5(sel0[13]),
        .O(mclk_phase_acc_q0_carry_i_10_n_0));
  LUT5 #(
    .INIT(32'h00800000)) 
    mclk_phase_acc_q0_carry_i_11
       (.I0(sel0[4]),
        .I1(sel0[5]),
        .I2(sel0[6]),
        .I3(mclk_phase_acc_q0_carry__1_i_11_n_0),
        .I4(sel0[7]),
        .O(mclk_phase_acc_q0_carry_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry_i_2
       (.I0(mclk_phase_sum[10]),
        .O(mclk_phase_acc_q0_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry_i_3
       (.I0(mclk_phase_sum[9]),
        .O(mclk_phase_acc_q0_carry_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_phase_acc_q0_carry_i_4
       (.I0(mclk_phase_sum[8]),
        .O(mclk_phase_acc_q0_carry_i_4_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    mclk_phase_acc_q0_carry_i_5
       (.I0(mclk_phase_acc_q[11]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[2]),
        .O(mclk_phase_acc_q0_carry_i_5_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    mclk_phase_acc_q0_carry_i_6
       (.I0(mclk_phase_acc_q[10]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[1]),
        .O(mclk_phase_acc_q0_carry_i_6_n_0));
  LUT3 #(
    .INIT(8'h9A)) 
    mclk_phase_acc_q0_carry_i_7
       (.I0(mclk_phase_acc_q[9]),
        .I1(mclk_phase_acc_q0_carry_i_8_n_0),
        .I2(sel0[0]),
        .O(mclk_phase_acc_q0_carry_i_7_n_0));
  LUT6 #(
    .INIT(64'hFFFFEEFEEEEEEEEE)) 
    mclk_phase_acc_q0_carry_i_8
       (.I0(sel0[18]),
        .I1(sel0[19]),
        .I2(mclk_phase_acc_q0_carry_i_9_n_0),
        .I3(mclk_phase_acc_q0_carry_i_10_n_0),
        .I4(sel0[16]),
        .I5(sel0[17]),
        .O(mclk_phase_acc_q0_carry_i_8_n_0));
  LUT6 #(
    .INIT(64'hEFEEEFEEEFEEAFAA)) 
    mclk_phase_acc_q0_carry_i_9
       (.I0(sel0[10]),
        .I1(sel0[9]),
        .I2(sel0[15]),
        .I3(mclk_phase_acc_q0_carry__1_i_7_n_0),
        .I4(mclk_phase_acc_q0_carry_i_11_n_0),
        .I5(sel0[8]),
        .O(mclk_phase_acc_q0_carry_i_9_n_0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[10]_i_1 
       (.I0(mclk_phase_acc_q0[10]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[10]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[11]_i_1 
       (.I0(mclk_phase_acc_q0[11]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[11]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[12]_i_1 
       (.I0(mclk_phase_acc_q0[12]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[12]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[13]_i_1 
       (.I0(mclk_phase_acc_q0[13]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[13]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[13]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[14]_i_1 
       (.I0(mclk_phase_acc_q0[14]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[14]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[14]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[15]_i_1 
       (.I0(mclk_phase_acc_q0[15]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[15]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[16]_i_1 
       (.I0(mclk_phase_acc_q0[16]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[16]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[16]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[17]_i_1 
       (.I0(mclk_phase_acc_q0[17]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[17]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[17]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[18]_i_1 
       (.I0(mclk_phase_acc_q0[18]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[18]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[18]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[19]_i_1 
       (.I0(mclk_phase_acc_q0[19]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[19]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[19]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[20]_i_1 
       (.I0(mclk_phase_acc_q0[20]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[20]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[20]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[21]_i_1 
       (.I0(mclk_phase_acc_q0[21]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[21]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[21]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[22]_i_1 
       (.I0(mclk_phase_acc_q0[22]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[22]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[22]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[23]_i_1 
       (.I0(mclk_phase_acc_q0[23]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[23]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[24]_i_1 
       (.I0(mclk_phase_acc_q0[24]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[24]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[24]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[25]_i_1 
       (.I0(mclk_phase_acc_q0[25]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[25]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[25]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[26]_i_1 
       (.I0(mclk_phase_acc_q0[26]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[26]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \mclk_phase_acc_q[27]_i_1 
       (.I0(mclk_phase_acc_q0[27]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(mclk_q_i_3_n_0),
        .O(\mclk_phase_acc_q[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \mclk_phase_acc_q[28]_i_1 
       (.I0(mclk_phase_acc_q0[28]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(mclk_q_i_3_n_0),
        .O(\mclk_phase_acc_q[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \mclk_phase_acc_q[29]_i_1 
       (.I0(mclk_phase_acc_q0[29]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(mclk_q_i_3_n_0),
        .O(\mclk_phase_acc_q[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \mclk_phase_acc_q[30]_i_1 
       (.I0(mclk_phase_acc_q0[30]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(mclk_q_i_3_n_0),
        .O(\mclk_phase_acc_q[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \mclk_phase_acc_q[31]_i_1 
       (.I0(mclk_phase_acc_q0[31]),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(mclk_q_i_3_n_0),
        .O(\mclk_phase_acc_q[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[8]_i_1 
       (.I0(mclk_phase_acc_q0[8]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[8]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hE200)) 
    \mclk_phase_acc_q[9]_i_1 
       (.I0(mclk_phase_acc_q0[9]),
        .I1(mclk_q_i_3_n_0),
        .I2(mclk_phase_sum[9]),
        .I3(\slv_reg2_reg_n_0_[0] ),
        .O(\mclk_phase_acc_q[9]_i_1_n_0 ));
  FDCE \mclk_phase_acc_q_reg[10] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[10]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[10]));
  FDCE \mclk_phase_acc_q_reg[11] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[11]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[11]));
  FDCE \mclk_phase_acc_q_reg[12] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[12]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[12]));
  FDCE \mclk_phase_acc_q_reg[13] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[13]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[13]));
  FDCE \mclk_phase_acc_q_reg[14] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[14]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[14]));
  FDCE \mclk_phase_acc_q_reg[15] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[15]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[15]));
  FDCE \mclk_phase_acc_q_reg[16] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[16]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[16]));
  FDCE \mclk_phase_acc_q_reg[17] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[17]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[17]));
  FDCE \mclk_phase_acc_q_reg[18] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[18]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[18]));
  FDCE \mclk_phase_acc_q_reg[19] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[19]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[19]));
  FDCE \mclk_phase_acc_q_reg[20] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[20]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[20]));
  FDCE \mclk_phase_acc_q_reg[21] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[21]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[21]));
  FDCE \mclk_phase_acc_q_reg[22] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[22]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[22]));
  FDCE \mclk_phase_acc_q_reg[23] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[23]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[23]));
  FDCE \mclk_phase_acc_q_reg[24] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[24]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[24]));
  FDCE \mclk_phase_acc_q_reg[25] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[25]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[25]));
  FDCE \mclk_phase_acc_q_reg[26] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[26]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[26]));
  FDCE \mclk_phase_acc_q_reg[27] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[27]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[27]));
  FDCE \mclk_phase_acc_q_reg[28] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[28]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[28]));
  FDCE \mclk_phase_acc_q_reg[29] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[29]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[29]));
  FDCE \mclk_phase_acc_q_reg[30] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[30]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[30]));
  FDCE \mclk_phase_acc_q_reg[31] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[31]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[31]));
  FDCE \mclk_phase_acc_q_reg[8] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[8]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[8]));
  FDCE \mclk_phase_acc_q_reg[9] 
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(\mclk_phase_acc_q[9]_i_1_n_0 ),
        .Q(mclk_phase_acc_q[9]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h82)) 
    mclk_q_i_1
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(mclk_q_i_3_n_0),
        .I2(i2s_mclk),
        .O(mclk_q_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mclk_q_i_2
       (.I0(s00_axi_aresetn),
        .O(mclk_q_i_2_n_0));
  LUT4 #(
    .INIT(16'h001F)) 
    mclk_q_i_3
       (.I0(mclk_phase_sum[25]),
        .I1(mclk_q_i_4_n_0),
        .I2(mclk_phase_sum[26]),
        .I3(mclk_q_i_5_n_0),
        .O(mclk_q_i_3_n_0));
  LUT6 #(
    .INIT(64'h00000000FFFFAA08)) 
    mclk_q_i_4
       (.I0(mclk_phase_sum[18]),
        .I1(mclk_q_i_6_n_0),
        .I2(mclk_q_i_7_n_0),
        .I3(mclk_phase_sum[17]),
        .I4(mclk_phase_sum[19]),
        .I5(mclk_q_i_8_n_0),
        .O(mclk_q_i_4_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    mclk_q_i_5
       (.I0(mclk_phase_sum[31]),
        .I1(mclk_phase_sum[27]),
        .I2(mclk_phase_sum[29]),
        .I3(mclk_phase_sum[30]),
        .I4(mclk_phase_sum[28]),
        .O(mclk_q_i_5_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    mclk_q_i_6
       (.I0(mclk_phase_sum[12]),
        .I1(mclk_phase_sum[10]),
        .I2(mclk_phase_sum[8]),
        .I3(mclk_phase_sum[9]),
        .I4(mclk_phase_sum[11]),
        .O(mclk_q_i_6_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    mclk_q_i_7
       (.I0(mclk_phase_sum[15]),
        .I1(mclk_phase_sum[14]),
        .I2(mclk_phase_sum[16]),
        .I3(mclk_phase_sum[13]),
        .O(mclk_q_i_7_n_0));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    mclk_q_i_8
       (.I0(mclk_phase_sum[24]),
        .I1(mclk_phase_sum[20]),
        .I2(mclk_phase_sum[21]),
        .I3(mclk_phase_sum[23]),
        .I4(mclk_phase_sum[22]),
        .O(mclk_q_i_8_n_0));
  FDCE mclk_q_reg
       (.C(audio_clk),
        .CE(1'b1),
        .CLR(mclk_q_i_2_n_0),
        .D(mclk_q_i_1_n_0),
        .Q(i2s_mclk));
  FDCE \sample_left_q_reg[0] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[0]),
        .Q(sample_left_q[0]));
  FDCE \sample_left_q_reg[10] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[10]),
        .Q(sample_left_q[10]));
  FDCE \sample_left_q_reg[11] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[11]),
        .Q(sample_left_q[11]));
  FDCE \sample_left_q_reg[12] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[12]),
        .Q(sample_left_q[12]));
  FDCE \sample_left_q_reg[13] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[13]),
        .Q(sample_left_q[13]));
  FDCE \sample_left_q_reg[14] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[14]),
        .Q(sample_left_q[14]));
  FDCE \sample_left_q_reg[15] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[15]),
        .Q(sample_left_q[15]));
  FDCE \sample_left_q_reg[16] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[16]),
        .Q(sample_left_q[16]));
  FDCE \sample_left_q_reg[17] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[17]),
        .Q(sample_left_q[17]));
  FDCE \sample_left_q_reg[18] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[18]),
        .Q(sample_left_q[18]));
  FDCE \sample_left_q_reg[19] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[19]),
        .Q(sample_left_q[19]));
  FDCE \sample_left_q_reg[1] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[1]),
        .Q(sample_left_q[1]));
  FDCE \sample_left_q_reg[20] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[20]),
        .Q(sample_left_q[20]));
  FDCE \sample_left_q_reg[21] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[21]),
        .Q(sample_left_q[21]));
  FDCE \sample_left_q_reg[22] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[22]),
        .Q(sample_left_q[22]));
  FDCE \sample_left_q_reg[23] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[23]),
        .Q(sample_left_q[23]));
  FDCE \sample_left_q_reg[24] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[24]),
        .Q(sample_left_q[24]));
  FDCE \sample_left_q_reg[25] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[25]),
        .Q(sample_left_q[25]));
  FDCE \sample_left_q_reg[26] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[26]),
        .Q(sample_left_q[26]));
  FDCE \sample_left_q_reg[27] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[27]),
        .Q(sample_left_q[27]));
  FDCE \sample_left_q_reg[28] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[28]),
        .Q(sample_left_q[28]));
  FDCE \sample_left_q_reg[29] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[29]),
        .Q(sample_left_q[29]));
  FDCE \sample_left_q_reg[2] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[2]),
        .Q(sample_left_q[2]));
  FDCE \sample_left_q_reg[30] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[30]),
        .Q(sample_left_q[30]));
  FDCE \sample_left_q_reg[31] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[31]),
        .Q(sample_left_q[31]));
  FDCE \sample_left_q_reg[3] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[3]),
        .Q(sample_left_q[3]));
  FDCE \sample_left_q_reg[4] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[4]),
        .Q(sample_left_q[4]));
  FDCE \sample_left_q_reg[5] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[5]),
        .Q(sample_left_q[5]));
  FDCE \sample_left_q_reg[6] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[6]),
        .Q(sample_left_q[6]));
  FDCE \sample_left_q_reg[7] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[7]),
        .Q(sample_left_q[7]));
  FDCE \sample_left_q_reg[8] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[8]),
        .Q(sample_left_q[8]));
  FDCE \sample_left_q_reg[9] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg0[9]),
        .Q(sample_left_q[9]));
  LUT5 #(
    .INIT(32'h00000400)) 
    \sample_right_q[31]_i_1 
       (.I0(bclk_q_reg_0),
        .I1(\slv_reg2_reg_n_0_[0] ),
        .I2(p_0_in2_in),
        .I3(data_q_i_4_n_0),
        .I4(bclk_q_i_2_n_0),
        .O(sample_left_q_0));
  FDCE \sample_right_q_reg[0] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[0]),
        .Q(sample_right_q[0]));
  FDCE \sample_right_q_reg[10] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[10]),
        .Q(sample_right_q[10]));
  FDCE \sample_right_q_reg[11] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[11]),
        .Q(sample_right_q[11]));
  FDCE \sample_right_q_reg[12] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[12]),
        .Q(sample_right_q[12]));
  FDCE \sample_right_q_reg[13] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[13]),
        .Q(sample_right_q[13]));
  FDCE \sample_right_q_reg[14] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[14]),
        .Q(sample_right_q[14]));
  FDCE \sample_right_q_reg[15] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[15]),
        .Q(sample_right_q[15]));
  FDCE \sample_right_q_reg[16] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[16]),
        .Q(sample_right_q[16]));
  FDCE \sample_right_q_reg[17] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[17]),
        .Q(sample_right_q[17]));
  FDCE \sample_right_q_reg[18] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[18]),
        .Q(sample_right_q[18]));
  FDCE \sample_right_q_reg[19] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[19]),
        .Q(sample_right_q[19]));
  FDCE \sample_right_q_reg[1] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[1]),
        .Q(sample_right_q[1]));
  FDCE \sample_right_q_reg[20] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[20]),
        .Q(sample_right_q[20]));
  FDCE \sample_right_q_reg[21] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[21]),
        .Q(sample_right_q[21]));
  FDCE \sample_right_q_reg[22] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[22]),
        .Q(sample_right_q[22]));
  FDCE \sample_right_q_reg[23] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[23]),
        .Q(sample_right_q[23]));
  FDCE \sample_right_q_reg[24] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[24]),
        .Q(sample_right_q[24]));
  FDCE \sample_right_q_reg[25] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[25]),
        .Q(sample_right_q[25]));
  FDCE \sample_right_q_reg[26] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[26]),
        .Q(sample_right_q[26]));
  FDCE \sample_right_q_reg[27] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[27]),
        .Q(sample_right_q[27]));
  FDCE \sample_right_q_reg[28] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[28]),
        .Q(sample_right_q[28]));
  FDCE \sample_right_q_reg[29] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[29]),
        .Q(sample_right_q[29]));
  FDCE \sample_right_q_reg[2] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[2]),
        .Q(sample_right_q[2]));
  FDCE \sample_right_q_reg[30] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[30]),
        .Q(sample_right_q[30]));
  FDCE \sample_right_q_reg[31] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[31]),
        .Q(sample_right_q[31]));
  FDCE \sample_right_q_reg[3] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[3]),
        .Q(sample_right_q[3]));
  FDCE \sample_right_q_reg[4] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[4]),
        .Q(sample_right_q[4]));
  FDCE \sample_right_q_reg[5] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[5]),
        .Q(sample_right_q[5]));
  FDCE \sample_right_q_reg[6] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[6]),
        .Q(sample_right_q[6]));
  FDCE \sample_right_q_reg[7] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[7]),
        .Q(sample_right_q[7]));
  FDCE \sample_right_q_reg[8] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[8]),
        .Q(sample_right_q[8]));
  FDCE \sample_right_q_reg[9] 
       (.C(audio_clk),
        .CE(sample_left_q_0),
        .CLR(mclk_q_i_2_n_0),
        .D(slv_reg1[9]),
        .Q(sample_right_q[9]));
  LUT3 #(
    .INIT(8'h40)) 
    \slv_reg0[15]_i_1 
       (.I0(write_addr[0]),
        .I1(s00_axi_wstrb[1]),
        .I2(\slv_reg1[31]_i_2_n_0 ),
        .O(\slv_reg0[15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \slv_reg0[23]_i_1 
       (.I0(write_addr[0]),
        .I1(s00_axi_wstrb[2]),
        .I2(\slv_reg1[31]_i_2_n_0 ),
        .O(\slv_reg0[23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \slv_reg0[31]_i_1 
       (.I0(write_addr[0]),
        .I1(s00_axi_wstrb[3]),
        .I2(\slv_reg1[31]_i_2_n_0 ),
        .O(\slv_reg0[31]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \slv_reg0[7]_i_1 
       (.I0(write_addr[0]),
        .I1(s00_axi_wstrb[0]),
        .I2(\slv_reg1[31]_i_2_n_0 ),
        .O(\slv_reg0[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[0] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg0[0]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[10] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg0[10]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[11] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg0[11]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[12] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg0[12]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[13] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg0[13]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[14] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg0[14]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[15] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg0[15]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[16] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg0[16]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[17] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg0[17]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[18] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg0[18]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[19] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg0[19]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[1] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg0[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[20] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg0[20]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[21] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg0[21]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[22] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg0[22]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[23] 
       (.C(audio_clk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg0[23]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[24] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg0[24]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[25] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg0[25]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[26] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg0[26]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[27] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg0[27]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[28] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg0[28]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[29] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg0[29]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[2] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg0[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[30] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg0[30]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[31] 
       (.C(audio_clk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg0[31]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[3] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg0[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[4] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg0[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[5] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg0[5]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[6] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg0[6]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[7] 
       (.C(audio_clk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg0[7]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[8] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg0[8]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg0_reg[9] 
       (.C(audio_clk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg0[9]),
        .R(mclk_q_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg1[15]_i_1 
       (.I0(\slv_reg1[31]_i_2_n_0 ),
        .I1(s00_axi_wstrb[1]),
        .I2(write_addr[0]),
        .O(\slv_reg1[15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg1[23]_i_1 
       (.I0(\slv_reg1[31]_i_2_n_0 ),
        .I1(s00_axi_wstrb[2]),
        .I2(write_addr[0]),
        .O(\slv_reg1[23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg1[31]_i_1 
       (.I0(\slv_reg1[31]_i_2_n_0 ),
        .I1(s00_axi_wstrb[3]),
        .I2(write_addr[0]),
        .O(\slv_reg1[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00008000)) 
    \slv_reg1[31]_i_2 
       (.I0(S_AXI_WREADY),
        .I1(S_AXI_AWREADY),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .I4(write_addr[1]),
        .O(\slv_reg1[31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg1[7]_i_1 
       (.I0(\slv_reg1[31]_i_2_n_0 ),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[0]),
        .O(\slv_reg1[7]_i_1_n_0 ));
  FDRE \slv_reg1_reg[0] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg1[0]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[10] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg1[10]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[11] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg1[11]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[12] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg1[12]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[13] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg1[13]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[14] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg1[14]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[15] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg1[15]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[16] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg1[16]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[17] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg1[17]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[18] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg1[18]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[19] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg1[19]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[1] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg1[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[20] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg1[20]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[21] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg1[21]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[22] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg1[22]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[23] 
       (.C(audio_clk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg1[23]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[24] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg1[24]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[25] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg1[25]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[26] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg1[26]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[27] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg1[27]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[28] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg1[28]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[29] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg1[29]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[2] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg1[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[30] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg1[30]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[31] 
       (.C(audio_clk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg1[31]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[3] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg1[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[4] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg1[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[5] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg1[5]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[6] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg1[6]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[7] 
       (.C(audio_clk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg1[7]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[8] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg1[8]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg1_reg[9] 
       (.C(audio_clk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg1[9]),
        .R(mclk_q_i_2_n_0));
  LUT3 #(
    .INIT(8'h20)) 
    \slv_reg2[15]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[1]),
        .O(p_1_in[15]));
  LUT3 #(
    .INIT(8'h20)) 
    \slv_reg2[23]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[2]),
        .O(p_1_in[23]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \slv_reg2[23]_i_2 
       (.I0(write_addr[1]),
        .I1(S_AXI_WREADY),
        .I2(S_AXI_AWREADY),
        .I3(s00_axi_wvalid),
        .I4(s00_axi_awvalid),
        .O(\slv_reg2[23]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hEFFF2000)) 
    \slv_reg2[24]_i_1 
       (.I0(s00_axi_wdata[24]),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[3]),
        .I3(\slv_reg2[23]_i_2_n_0 ),
        .I4(sel0[17]),
        .O(\slv_reg2[24]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hEFFF2000)) 
    \slv_reg2[25]_i_1 
       (.I0(s00_axi_wdata[25]),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[3]),
        .I3(\slv_reg2[23]_i_2_n_0 ),
        .I4(sel0[18]),
        .O(\slv_reg2[25]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hEFFF2000)) 
    \slv_reg2[26]_i_1 
       (.I0(s00_axi_wdata[26]),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[3]),
        .I3(\slv_reg2[23]_i_2_n_0 ),
        .I4(sel0[19]),
        .O(\slv_reg2[26]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \slv_reg2[7]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[0]),
        .O(p_1_in[7]));
  FDRE \slv_reg2_reg[0] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[0]),
        .Q(\slv_reg2_reg_n_0_[0] ),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[10] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[10]),
        .Q(sel0[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[11] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[11]),
        .Q(sel0[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[12] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[12]),
        .Q(sel0[5]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[13] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[13]),
        .Q(sel0[6]),
        .R(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[14] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[14]),
        .Q(sel0[7]),
        .S(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[15] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[15]),
        .Q(sel0[8]),
        .S(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[16] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[16]),
        .Q(sel0[9]),
        .S(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[17] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[17]),
        .Q(sel0[10]),
        .R(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[18] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[18]),
        .Q(sel0[11]),
        .S(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[19] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[19]),
        .Q(sel0[12]),
        .S(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[1] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[1]),
        .Q(mute_sync),
        .R(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[20] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[20]),
        .Q(sel0[13]),
        .S(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[21] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[21]),
        .Q(sel0[14]),
        .R(mclk_q_i_2_n_0));
  FDSE \slv_reg2_reg[22] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[22]),
        .Q(sel0[15]),
        .S(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[23] 
       (.C(audio_clk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[23]),
        .Q(sel0[16]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[24] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\slv_reg2[24]_i_1_n_0 ),
        .Q(sel0[17]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[25] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\slv_reg2[25]_i_1_n_0 ),
        .Q(sel0[18]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[26] 
       (.C(audio_clk),
        .CE(1'b1),
        .D(\slv_reg2[26]_i_1_n_0 ),
        .Q(sel0[19]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[2] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[2]),
        .Q(sample_width_raw[0]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[3] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[3]),
        .Q(sample_width_raw[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[4] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[4]),
        .Q(sample_width_raw[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[5] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[5]),
        .Q(sample_width_raw[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[6] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[6]),
        .Q(sample_width_raw[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[7] 
       (.C(audio_clk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[7]),
        .Q(sel0[0]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[8] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[8]),
        .Q(sel0[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg2_reg[9] 
       (.C(audio_clk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[9]),
        .Q(sel0[2]),
        .R(mclk_q_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg3[15]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(s00_axi_wstrb[1]),
        .I2(write_addr[0]),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg3[23]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(s00_axi_wstrb[2]),
        .I2(write_addr[0]),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg3[31]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(s00_axi_wstrb[3]),
        .I2(write_addr[0]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \slv_reg3[7]_i_1 
       (.I0(\slv_reg2[23]_i_2_n_0 ),
        .I1(write_addr[0]),
        .I2(s00_axi_wstrb[0]),
        .O(\slv_reg3[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[10] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg3[10]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[11] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg3[11]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[12] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg3[12]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[13] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg3[13]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[14] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg3[14]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[15] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg3[15]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[16] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg3[16]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[17] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg3[17]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[18] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg3[18]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[19] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg3[19]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[1] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg3[1]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[20] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg3[20]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[21] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg3[21]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[22] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg3[22]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[23] 
       (.C(audio_clk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg3[23]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[24] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg3[24]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[25] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg3[25]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[26] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg3[26]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[27] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg3[27]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[28] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg3[28]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[29] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg3[29]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[2] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg3[2]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[30] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg3[30]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[31] 
       (.C(audio_clk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg3[31]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[3] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg3[3]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[4] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg3[4]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[5] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg3[5]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[6] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg3[6]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[7] 
       (.C(audio_clk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg3[7]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[8] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg3[8]),
        .R(mclk_q_i_2_n_0));
  FDRE \slv_reg3_reg[9] 
       (.C(audio_clk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg3[9]),
        .R(mclk_q_i_2_n_0));
  LUT3 #(
    .INIT(8'h20)) 
    slv_reg_rden
       (.I0(s00_axi_arvalid),
        .I1(s00_axi_rvalid),
        .I2(S_AXI_ARREADY),
        .O(slv_reg_rden__0));
  LUT3 #(
    .INIT(8'h4F)) 
    ws_q_i_1
       (.I0(bclk_q_i_2_n_0),
        .I1(bclk_q_reg_0),
        .I2(\slv_reg2_reg_n_0_[0] ),
        .O(data_q));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    ws_q_i_2
       (.I0(\slv_reg2_reg_n_0_[0] ),
        .I1(p_0_in2_in),
        .O(ws_q));
  FDCE ws_q_reg
       (.C(audio_clk),
        .CE(data_q),
        .CLR(mclk_q_i_2_n_0),
        .D(ws_q),
        .Q(i2s_ws));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
