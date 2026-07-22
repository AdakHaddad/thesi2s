-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Fri Jul 17 14:55:00 2026
-- Host        : DESKTOP-HTVV1N1 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_i2s_0_2_sim_netlist.vhdl
-- Design      : design_1_i2s_0_2
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s_slave_lite_v1_0_S00_AXI is
  port (
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    i2s_ws : out STD_LOGIC;
    i2s_data : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bclk_q_reg_0 : out STD_LOGIC;
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    i2s_mclk : out STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    audio_clk : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s_slave_lite_v1_0_S00_AXI;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s_slave_lite_v1_0_S00_AXI is
  signal \^s_axi_arready\ : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal aw_en_i_1_n_0 : STD_LOGIC;
  signal aw_en_reg_n_0 : STD_LOGIC;
  signal axi_araddr : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \axi_araddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_araddr[3]_i_1_n_0\ : STD_LOGIC;
  signal axi_arready0 : STD_LOGIC;
  signal \axi_awaddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_awaddr[3]_i_1_n_0\ : STD_LOGIC;
  signal axi_awready0 : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal axi_wready0 : STD_LOGIC;
  signal bclk_phase_acc_q : STD_LOGIC_VECTOR ( 31 downto 7 );
  signal bclk_phase_acc_q0 : STD_LOGIC_VECTOR ( 31 downto 7 );
  signal \bclk_phase_acc_q0_carry__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__0_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__0_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__0_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__1_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__1_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__1_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__2_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__2_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__2_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__2_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__3_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__3_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__3_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__3_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__4_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__4_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__4_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry__4_n_3\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_10_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_11_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_12_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__0_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__0_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__0_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__1_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__1_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__1_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__2_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__2_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__2_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__2_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__3_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__3_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__3_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__3_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__4_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__4_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__4_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__4_n_3\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_1__5_n_3\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_1_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__2_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__3_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__4_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__4_n_1\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__4_n_2\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_2__4_n_3\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_2_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_3__0__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_3__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_3__1__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_3__1_n_0\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_3_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_4__0__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_4__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_4__1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_4__2_n_0\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_4_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_5__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_5__1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_5__2_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_5__3_n_0\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_5_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_6__0_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_6__1_n_0\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_6_n_0 : STD_LOGIC;
  signal \bclk_phase_acc_q0_carry_i_7__0_n_0\ : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_7_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_8_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_i_9_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_n_0 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_n_1 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_n_2 : STD_LOGIC;
  signal bclk_phase_acc_q0_carry_n_3 : STD_LOGIC;
  signal \bclk_phase_acc_q[10]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[11]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[12]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[13]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[14]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[15]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[16]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[17]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[18]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[19]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[20]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[21]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[22]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[23]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[24]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[25]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[26]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[27]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[28]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[29]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[30]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[31]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[7]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[8]_i_1_n_0\ : STD_LOGIC;
  signal \bclk_phase_acc_q[9]_i_1_n_0\ : STD_LOGIC;
  signal bclk_phase_sum : STD_LOGIC_VECTOR ( 31 downto 7 );
  signal bclk_q_i_1_n_0 : STD_LOGIC;
  signal bclk_q_i_2_n_0 : STD_LOGIC;
  signal bclk_q_i_3_n_0 : STD_LOGIC;
  signal bclk_q_i_4_n_0 : STD_LOGIC;
  signal bclk_q_i_5_n_0 : STD_LOGIC;
  signal bclk_q_i_6_n_0 : STD_LOGIC;
  signal bclk_q_i_7_n_0 : STD_LOGIC;
  signal \^bclk_q_reg_0\ : STD_LOGIC;
  signal \bit_count_q[1]_i_1_n_0\ : STD_LOGIC;
  signal \bit_count_q[5]_i_2_n_0\ : STD_LOGIC;
  signal current_latch_status_q : STD_LOGIC;
  signal current_latch_status_q_i_1_n_0 : STD_LOGIC;
  signal data_q : STD_LOGIC;
  signal data_q_i_10_n_0 : STD_LOGIC;
  signal data_q_i_11_n_0 : STD_LOGIC;
  signal data_q_i_12_n_0 : STD_LOGIC;
  signal data_q_i_13_n_0 : STD_LOGIC;
  signal data_q_i_14_n_0 : STD_LOGIC;
  signal data_q_i_15_n_0 : STD_LOGIC;
  signal data_q_i_16_n_0 : STD_LOGIC;
  signal data_q_i_17_n_0 : STD_LOGIC;
  signal data_q_i_18_n_0 : STD_LOGIC;
  signal data_q_i_19_n_0 : STD_LOGIC;
  signal data_q_i_1_n_0 : STD_LOGIC;
  signal data_q_i_20_n_0 : STD_LOGIC;
  signal data_q_i_21_n_0 : STD_LOGIC;
  signal data_q_i_22_n_0 : STD_LOGIC;
  signal data_q_i_23_n_0 : STD_LOGIC;
  signal data_q_i_24_n_0 : STD_LOGIC;
  signal data_q_i_25_n_0 : STD_LOGIC;
  signal data_q_i_26_n_0 : STD_LOGIC;
  signal data_q_i_27_n_0 : STD_LOGIC;
  signal data_q_i_28_n_0 : STD_LOGIC;
  signal data_q_i_29_n_0 : STD_LOGIC;
  signal data_q_i_2_n_0 : STD_LOGIC;
  signal data_q_i_30_n_0 : STD_LOGIC;
  signal data_q_i_31_n_0 : STD_LOGIC;
  signal data_q_i_32_n_0 : STD_LOGIC;
  signal data_q_i_33_n_0 : STD_LOGIC;
  signal data_q_i_34_n_0 : STD_LOGIC;
  signal data_q_i_35_n_0 : STD_LOGIC;
  signal data_q_i_36_n_0 : STD_LOGIC;
  signal data_q_i_37_n_0 : STD_LOGIC;
  signal data_q_i_38_n_0 : STD_LOGIC;
  signal data_q_i_39_n_0 : STD_LOGIC;
  signal data_q_i_3_n_0 : STD_LOGIC;
  signal data_q_i_40_n_0 : STD_LOGIC;
  signal data_q_i_41_n_0 : STD_LOGIC;
  signal data_q_i_42_n_0 : STD_LOGIC;
  signal data_q_i_43_n_0 : STD_LOGIC;
  signal data_q_i_44_n_0 : STD_LOGIC;
  signal data_q_i_4_n_0 : STD_LOGIC;
  signal data_q_i_5_n_0 : STD_LOGIC;
  signal data_q_i_6_n_0 : STD_LOGIC;
  signal data_q_i_7_n_0 : STD_LOGIC;
  signal data_q_i_8_n_0 : STD_LOGIC;
  signal data_q_i_9_n_0 : STD_LOGIC;
  signal \^i2s_mclk\ : STD_LOGIC;
  signal mclk_phase_acc_q : STD_LOGIC_VECTOR ( 31 downto 8 );
  signal mclk_phase_acc_q0 : STD_LOGIC_VECTOR ( 31 downto 8 );
  signal \mclk_phase_acc_q0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__0_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_10_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_11_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_12_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_13_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_i_9_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__2_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__3_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_1_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_1_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_1_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_i_5_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_n_1\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_n_2\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__4_n_3\ : STD_LOGIC;
  signal \mclk_phase_acc_q0_carry__5_i_1_n_0\ : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_10_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_11_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_1_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_1_n_1 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_1_n_2 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_1_n_3 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_2_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_3_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_4_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_5_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_6_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_7_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_8_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_i_9_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_n_0 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_n_1 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_n_2 : STD_LOGIC;
  signal mclk_phase_acc_q0_carry_n_3 : STD_LOGIC;
  signal \mclk_phase_acc_q[10]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[11]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[12]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[13]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[14]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[15]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[16]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[17]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[18]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[19]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[20]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[21]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[22]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[23]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[24]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[25]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[26]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[27]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[28]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[29]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[30]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[31]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[8]_i_1_n_0\ : STD_LOGIC;
  signal \mclk_phase_acc_q[9]_i_1_n_0\ : STD_LOGIC;
  signal mclk_phase_sum : STD_LOGIC_VECTOR ( 31 downto 8 );
  signal mclk_q_i_1_n_0 : STD_LOGIC;
  signal mclk_q_i_2_n_0 : STD_LOGIC;
  signal mclk_q_i_3_n_0 : STD_LOGIC;
  signal mclk_q_i_4_n_0 : STD_LOGIC;
  signal mclk_q_i_5_n_0 : STD_LOGIC;
  signal mclk_q_i_6_n_0 : STD_LOGIC;
  signal mclk_q_i_7_n_0 : STD_LOGIC;
  signal mclk_q_i_8_n_0 : STD_LOGIC;
  signal mute_sync : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal p_0_in2_in : STD_LOGIC;
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal p_1_in : STD_LOGIC_VECTOR ( 23 downto 7 );
  signal reg_data_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s00_axi_bvalid\ : STD_LOGIC;
  signal \^s00_axi_rvalid\ : STD_LOGIC;
  signal sample_left_q : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal sample_left_q_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal sample_right_q : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal sample_width_raw : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal sel0 : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal slv_reg0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg0[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg1[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[31]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg1[7]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[23]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg2[24]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[25]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[26]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2_reg_n_0_[0]\ : STD_LOGIC;
  signal slv_reg3 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal \slv_reg3[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[7]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg_rden__0\ : STD_LOGIC;
  signal write_addr : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ws_q : STD_LOGIC;
  signal \NLW_bclk_phase_acc_q0_carry__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_bclk_phase_acc_q0_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_bclk_phase_acc_q0_carry_i_1__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_bclk_phase_acc_q0_carry_i_1__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_bclk_phase_acc_q0_carry_i_2__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_mclk_phase_acc_q0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_mclk_phase_acc_q0_carry__4_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_mclk_phase_acc_q0_carry__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_mclk_phase_acc_q0_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \axi_araddr[3]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of axi_arready_i_1 : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of axi_awready_i_1 : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of axi_wready_i_1 : label is "soft_lutpair17";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of bclk_phase_acc_q0_carry : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__0\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__1\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__2\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__3\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__4\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_1__5\ : label is 35;
  attribute ADDER_THRESHOLD of \bclk_phase_acc_q0_carry_i_2__4\ : label is 35;
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[10]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[11]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[12]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[27]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[28]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[29]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[30]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[31]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[7]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[8]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \bclk_phase_acc_q[9]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of bclk_q_i_1 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \bit_count_q[0]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \bit_count_q[1]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \bit_count_q[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \bit_count_q[3]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \bit_count_q[5]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \bit_count_q[5]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of data_q_i_10 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of data_q_i_18 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of data_q_i_23 : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of data_q_i_24 : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of data_q_i_4 : label is "soft_lutpair1";
  attribute ADDER_THRESHOLD of mclk_phase_acc_q0_carry : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__0_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__1_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__2_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__3_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__4_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \mclk_phase_acc_q0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of mclk_phase_acc_q0_carry_i_1 : label is 35;
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[10]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[11]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[12]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[13]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[27]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[28]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[29]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[30]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[31]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[8]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \mclk_phase_acc_q[9]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of mclk_q_i_1 : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \slv_reg1[31]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \slv_reg2[23]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of ws_q_i_2 : label is "soft_lutpair19";
begin
  S_AXI_ARREADY <= \^s_axi_arready\;
  S_AXI_AWREADY <= \^s_axi_awready\;
  S_AXI_WREADY <= \^s_axi_wready\;
  bclk_q_reg_0 <= \^bclk_q_reg_0\;
  i2s_mclk <= \^i2s_mclk\;
  s00_axi_bvalid <= \^s00_axi_bvalid\;
  s00_axi_rvalid <= \^s00_axi_rvalid\;
aw_en_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF88880FFF8888"
    )
        port map (
      I0 => s00_axi_bready,
      I1 => \^s00_axi_bvalid\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_wvalid,
      I4 => aw_en_reg_n_0,
      I5 => \^s_axi_awready\,
      O => aw_en_i_1_n_0
    );
aw_en_reg: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => '1',
      D => aw_en_i_1_n_0,
      Q => aw_en_reg_n_0,
      S => mclk_q_i_2_n_0
    );
\axi_araddr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(0),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(2),
      O => \axi_araddr[2]_i_1_n_0\
    );
\axi_araddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(1),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(3),
      O => \axi_araddr[3]_i_1_n_0\
    );
\axi_araddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \axi_araddr[2]_i_1_n_0\,
      Q => axi_araddr(2),
      R => mclk_q_i_2_n_0
    );
\axi_araddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \axi_araddr[3]_i_1_n_0\,
      Q => axi_araddr(3),
      R => mclk_q_i_2_n_0
    );
axi_arready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s_axi_arready\,
      O => axi_arready0
    );
axi_arready_reg: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => axi_arready0,
      Q => \^s_axi_arready\,
      R => mclk_q_i_2_n_0
    );
\axi_awaddr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => s00_axi_awaddr(0),
      I1 => axi_awready0,
      I2 => s00_axi_aresetn,
      I3 => write_addr(0),
      O => \axi_awaddr[2]_i_1_n_0\
    );
\axi_awaddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => s00_axi_awaddr(1),
      I1 => axi_awready0,
      I2 => s00_axi_aresetn,
      I3 => write_addr(1),
      O => \axi_awaddr[3]_i_1_n_0\
    );
\axi_awaddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \axi_awaddr[2]_i_1_n_0\,
      Q => write_addr(0),
      R => '0'
    );
\axi_awaddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \axi_awaddr[3]_i_1_n_0\,
      Q => write_addr(1),
      R => '0'
    );
axi_awready_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => aw_en_reg_n_0,
      I2 => s00_axi_wvalid,
      I3 => s00_axi_awvalid,
      O => axi_awready0
    );
axi_awready_reg: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => axi_awready0,
      Q => \^s_axi_awready\,
      R => mclk_q_i_2_n_0
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FFFF80008000"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => s00_axi_wvalid,
      I2 => \^s_axi_awready\,
      I3 => \^s_axi_wready\,
      I4 => s00_axi_bready,
      I5 => \^s00_axi_bvalid\,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^s00_axi_bvalid\,
      R => mclk_q_i_2_n_0
    );
\axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => current_latch_status_q,
      I1 => slv_reg1(0),
      I2 => axi_araddr(2),
      I3 => \slv_reg2_reg_n_0_[0]\,
      I4 => axi_araddr(3),
      I5 => slv_reg0(0),
      O => reg_data_out(0)
    );
\axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(10),
      I1 => slv_reg1(10),
      I2 => axi_araddr(2),
      I3 => sel0(3),
      I4 => axi_araddr(3),
      I5 => slv_reg0(10),
      O => reg_data_out(10)
    );
\axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(11),
      I1 => slv_reg1(11),
      I2 => axi_araddr(2),
      I3 => sel0(4),
      I4 => axi_araddr(3),
      I5 => slv_reg0(11),
      O => reg_data_out(11)
    );
\axi_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(12),
      I1 => slv_reg1(12),
      I2 => axi_araddr(2),
      I3 => sel0(5),
      I4 => axi_araddr(3),
      I5 => slv_reg0(12),
      O => reg_data_out(12)
    );
\axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(13),
      I1 => slv_reg1(13),
      I2 => axi_araddr(2),
      I3 => sel0(6),
      I4 => axi_araddr(3),
      I5 => slv_reg0(13),
      O => reg_data_out(13)
    );
\axi_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(14),
      I1 => slv_reg1(14),
      I2 => axi_araddr(2),
      I3 => sel0(7),
      I4 => axi_araddr(3),
      I5 => slv_reg0(14),
      O => reg_data_out(14)
    );
\axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(15),
      I1 => slv_reg1(15),
      I2 => axi_araddr(2),
      I3 => sel0(8),
      I4 => axi_araddr(3),
      I5 => slv_reg0(15),
      O => reg_data_out(15)
    );
\axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(16),
      I1 => slv_reg1(16),
      I2 => axi_araddr(2),
      I3 => sel0(9),
      I4 => axi_araddr(3),
      I5 => slv_reg0(16),
      O => reg_data_out(16)
    );
\axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(17),
      I1 => slv_reg1(17),
      I2 => axi_araddr(2),
      I3 => sel0(10),
      I4 => axi_araddr(3),
      I5 => slv_reg0(17),
      O => reg_data_out(17)
    );
\axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(18),
      I1 => slv_reg1(18),
      I2 => axi_araddr(2),
      I3 => sel0(11),
      I4 => axi_araddr(3),
      I5 => slv_reg0(18),
      O => reg_data_out(18)
    );
\axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(19),
      I1 => slv_reg1(19),
      I2 => axi_araddr(2),
      I3 => sel0(12),
      I4 => axi_araddr(3),
      I5 => slv_reg0(19),
      O => reg_data_out(19)
    );
\axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(1),
      I1 => slv_reg1(1),
      I2 => axi_araddr(2),
      I3 => mute_sync,
      I4 => axi_araddr(3),
      I5 => slv_reg0(1),
      O => reg_data_out(1)
    );
\axi_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(20),
      I1 => slv_reg1(20),
      I2 => axi_araddr(2),
      I3 => sel0(13),
      I4 => axi_araddr(3),
      I5 => slv_reg0(20),
      O => reg_data_out(20)
    );
\axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(21),
      I1 => slv_reg1(21),
      I2 => axi_araddr(2),
      I3 => sel0(14),
      I4 => axi_araddr(3),
      I5 => slv_reg0(21),
      O => reg_data_out(21)
    );
\axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(22),
      I1 => slv_reg1(22),
      I2 => axi_araddr(2),
      I3 => sel0(15),
      I4 => axi_araddr(3),
      I5 => slv_reg0(22),
      O => reg_data_out(22)
    );
\axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(23),
      I1 => slv_reg1(23),
      I2 => axi_araddr(2),
      I3 => sel0(16),
      I4 => axi_araddr(3),
      I5 => slv_reg0(23),
      O => reg_data_out(23)
    );
\axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(24),
      I1 => slv_reg1(24),
      I2 => axi_araddr(2),
      I3 => sel0(17),
      I4 => axi_araddr(3),
      I5 => slv_reg0(24),
      O => reg_data_out(24)
    );
\axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(25),
      I1 => slv_reg1(25),
      I2 => axi_araddr(2),
      I3 => sel0(18),
      I4 => axi_araddr(3),
      I5 => slv_reg0(25),
      O => reg_data_out(25)
    );
\axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(26),
      I1 => slv_reg1(26),
      I2 => axi_araddr(2),
      I3 => sel0(19),
      I4 => axi_araddr(3),
      I5 => slv_reg0(26),
      O => reg_data_out(26)
    );
\axi_rdata[27]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => slv_reg3(27),
      I1 => slv_reg1(27),
      I2 => axi_araddr(2),
      I3 => slv_reg0(27),
      I4 => axi_araddr(3),
      O => reg_data_out(27)
    );
\axi_rdata[28]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => slv_reg3(28),
      I1 => slv_reg1(28),
      I2 => axi_araddr(2),
      I3 => slv_reg0(28),
      I4 => axi_araddr(3),
      O => reg_data_out(28)
    );
\axi_rdata[29]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => slv_reg3(29),
      I1 => slv_reg1(29),
      I2 => axi_araddr(2),
      I3 => slv_reg0(29),
      I4 => axi_araddr(3),
      O => reg_data_out(29)
    );
\axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(2),
      I1 => slv_reg1(2),
      I2 => axi_araddr(2),
      I3 => sample_width_raw(0),
      I4 => axi_araddr(3),
      I5 => slv_reg0(2),
      O => reg_data_out(2)
    );
\axi_rdata[30]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => slv_reg3(30),
      I1 => slv_reg1(30),
      I2 => axi_araddr(2),
      I3 => slv_reg0(30),
      I4 => axi_araddr(3),
      O => reg_data_out(30)
    );
\axi_rdata[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => slv_reg3(31),
      I1 => slv_reg1(31),
      I2 => axi_araddr(2),
      I3 => slv_reg0(31),
      I4 => axi_araddr(3),
      O => reg_data_out(31)
    );
\axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(3),
      I1 => slv_reg1(3),
      I2 => axi_araddr(2),
      I3 => sample_width_raw(1),
      I4 => axi_araddr(3),
      I5 => slv_reg0(3),
      O => reg_data_out(3)
    );
\axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(4),
      I1 => slv_reg1(4),
      I2 => axi_araddr(2),
      I3 => sample_width_raw(2),
      I4 => axi_araddr(3),
      I5 => slv_reg0(4),
      O => reg_data_out(4)
    );
\axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(5),
      I1 => slv_reg1(5),
      I2 => axi_araddr(2),
      I3 => sample_width_raw(3),
      I4 => axi_araddr(3),
      I5 => slv_reg0(5),
      O => reg_data_out(5)
    );
\axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(6),
      I1 => slv_reg1(6),
      I2 => axi_araddr(2),
      I3 => sample_width_raw(4),
      I4 => axi_araddr(3),
      I5 => slv_reg0(6),
      O => reg_data_out(6)
    );
\axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(7),
      I1 => slv_reg1(7),
      I2 => axi_araddr(2),
      I3 => sel0(0),
      I4 => axi_araddr(3),
      I5 => slv_reg0(7),
      O => reg_data_out(7)
    );
\axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(8),
      I1 => slv_reg1(8),
      I2 => axi_araddr(2),
      I3 => sel0(1),
      I4 => axi_araddr(3),
      I5 => slv_reg0(8),
      O => reg_data_out(8)
    );
\axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(9),
      I1 => slv_reg1(9),
      I2 => axi_araddr(2),
      I3 => sel0(2),
      I4 => axi_araddr(3),
      I5 => slv_reg0(9),
      O => reg_data_out(9)
    );
\axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(0),
      Q => s00_axi_rdata(0),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(10),
      Q => s00_axi_rdata(10),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(11),
      Q => s00_axi_rdata(11),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(12),
      Q => s00_axi_rdata(12),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(13),
      Q => s00_axi_rdata(13),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(14),
      Q => s00_axi_rdata(14),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(15),
      Q => s00_axi_rdata(15),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(16),
      Q => s00_axi_rdata(16),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(17),
      Q => s00_axi_rdata(17),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(18),
      Q => s00_axi_rdata(18),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(19),
      Q => s00_axi_rdata(19),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(1),
      Q => s00_axi_rdata(1),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(20),
      Q => s00_axi_rdata(20),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(21),
      Q => s00_axi_rdata(21),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(22),
      Q => s00_axi_rdata(22),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(23),
      Q => s00_axi_rdata(23),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(24),
      Q => s00_axi_rdata(24),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(25),
      Q => s00_axi_rdata(25),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(26),
      Q => s00_axi_rdata(26),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(27),
      Q => s00_axi_rdata(27),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(28),
      Q => s00_axi_rdata(28),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(29),
      Q => s00_axi_rdata(29),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(2),
      Q => s00_axi_rdata(2),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(30),
      Q => s00_axi_rdata(30),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(31),
      Q => s00_axi_rdata(31),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(3),
      Q => s00_axi_rdata(3),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(4),
      Q => s00_axi_rdata(4),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(5),
      Q => s00_axi_rdata(5),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(6),
      Q => s00_axi_rdata(6),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(7),
      Q => s00_axi_rdata(7),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(8),
      Q => s00_axi_rdata(8),
      R => mclk_q_i_2_n_0
    );
\axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(9),
      Q => s00_axi_rdata(9),
      R => mclk_q_i_2_n_0
    );
axi_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08F8"
    )
        port map (
      I0 => \^s_axi_arready\,
      I1 => s00_axi_arvalid,
      I2 => \^s00_axi_rvalid\,
      I3 => s00_axi_rready,
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^s00_axi_rvalid\,
      R => mclk_q_i_2_n_0
    );
axi_wready_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => aw_en_reg_n_0,
      I2 => s00_axi_wvalid,
      I3 => s00_axi_awvalid,
      O => axi_wready0
    );
axi_wready_reg: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => axi_wready0,
      Q => \^s_axi_wready\,
      R => mclk_q_i_2_n_0
    );
bclk_phase_acc_q0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => bclk_phase_acc_q0_carry_n_0,
      CO(2) => bclk_phase_acc_q0_carry_n_1,
      CO(1) => bclk_phase_acc_q0_carry_n_2,
      CO(0) => bclk_phase_acc_q0_carry_n_3,
      CYINIT => '0',
      DI(3 downto 1) => bclk_phase_sum(10 downto 8),
      DI(0) => '0',
      O(3 downto 0) => bclk_phase_acc_q0(10 downto 7),
      S(3) => \bclk_phase_acc_q0_carry_i_3__1_n_0\,
      S(2) => \bclk_phase_acc_q0_carry_i_4__2_n_0\,
      S(1) => bclk_phase_acc_q0_carry_i_5_n_0,
      S(0) => bclk_phase_sum(7)
    );
\bclk_phase_acc_q0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => bclk_phase_acc_q0_carry_n_0,
      CO(3) => \bclk_phase_acc_q0_carry__0_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry__0_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry__0_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => bclk_phase_sum(12 downto 11),
      O(3 downto 0) => bclk_phase_acc_q0(14 downto 11),
      S(3 downto 2) => bclk_phase_sum(14 downto 13),
      S(1) => bclk_phase_acc_q0_carry_i_2_n_0,
      S(0) => \bclk_phase_acc_q0_carry_i_3__0__0_n_0\
    );
\bclk_phase_acc_q0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry__0_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry__1_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry__1_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry__1_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => bclk_phase_sum(17),
      DI(1 downto 0) => B"00",
      O(3 downto 0) => bclk_phase_acc_q0(18 downto 15),
      S(3) => bclk_phase_sum(18),
      S(2) => \bclk_phase_acc_q0_carry_i_2__0_n_0\,
      S(1 downto 0) => bclk_phase_sum(16 downto 15)
    );
\bclk_phase_acc_q0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry__1_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry__2_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry__2_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry__2_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => bclk_phase_sum(19),
      O(3 downto 0) => bclk_phase_acc_q0(22 downto 19),
      S(3 downto 1) => bclk_phase_sum(22 downto 20),
      S(0) => \bclk_phase_acc_q0_carry_i_2__1_n_0\
    );
\bclk_phase_acc_q0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry__2_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry__3_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry__3_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry__3_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry__3_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => bclk_phase_sum(25),
      DI(1 downto 0) => B"00",
      O(3 downto 0) => bclk_phase_acc_q0(26 downto 23),
      S(3) => bclk_phase_sum(26),
      S(2) => \bclk_phase_acc_q0_carry_i_2__2_n_0\,
      S(1 downto 0) => bclk_phase_sum(24 downto 23)
    );
\bclk_phase_acc_q0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry__3_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry__4_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry__4_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry__4_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => bclk_phase_sum(30 downto 27),
      O(3 downto 0) => bclk_phase_acc_q0(30 downto 27),
      S(3) => \bclk_phase_acc_q0_carry_i_2__3_n_0\,
      S(2) => \bclk_phase_acc_q0_carry_i_3__1__0_n_0\,
      S(1) => \bclk_phase_acc_q0_carry_i_4__0__0_n_0\,
      S(0) => \bclk_phase_acc_q0_carry_i_5__0_n_0\
    );
\bclk_phase_acc_q0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry__4_n_0\,
      CO(3 downto 0) => \NLW_bclk_phase_acc_q0_carry__5_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_bclk_phase_acc_q0_carry__5_O_UNCONNECTED\(3 downto 1),
      O(0) => bclk_phase_acc_q0(31),
      S(3 downto 1) => B"000",
      S(0) => bclk_phase_acc_q0_carry_i_1_n_0
    );
bclk_phase_acc_q0_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(31),
      O => bclk_phase_acc_q0_carry_i_1_n_0
    );
bclk_phase_acc_q0_carry_i_10: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => bclk_phase_acc_q(9),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(2),
      O => bclk_phase_acc_q0_carry_i_10_n_0
    );
bclk_phase_acc_q0_carry_i_11: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => bclk_phase_acc_q(8),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(1),
      O => bclk_phase_acc_q0_carry_i_11_n_0
    );
bclk_phase_acc_q0_carry_i_12: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => bclk_phase_acc_q(7),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(0),
      O => bclk_phase_acc_q0_carry_i_12_n_0
    );
\bclk_phase_acc_q0_carry_i_1__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_2__4_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry_i_1__0_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_1__0_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_1__0_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_1__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => bclk_phase_acc_q(13 downto 10),
      O(3 downto 0) => bclk_phase_sum(13 downto 10),
      S(3) => \bclk_phase_acc_q0_carry_i_6__1_n_0\,
      S(2) => bclk_phase_acc_q0_carry_i_7_n_0,
      S(1) => bclk_phase_acc_q0_carry_i_8_n_0,
      S(0) => bclk_phase_acc_q0_carry_i_9_n_0
    );
\bclk_phase_acc_q0_carry_i_1__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_1__0_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry_i_1__1_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_1__1_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_1__1_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_1__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => bclk_phase_acc_q(17 downto 14),
      O(3 downto 0) => bclk_phase_sum(17 downto 14),
      S(3) => bclk_phase_acc_q0_carry_i_4_n_0,
      S(2) => \bclk_phase_acc_q0_carry_i_5__2_n_0\,
      S(1) => \bclk_phase_acc_q0_carry_i_6__0_n_0\,
      S(0) => \bclk_phase_acc_q0_carry_i_7__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_1__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_1__1_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry_i_1__2_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_1__2_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_1__2_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_1__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => bclk_phase_acc_q(21 downto 18),
      O(3 downto 0) => bclk_phase_sum(21 downto 18),
      S(3) => bclk_phase_acc_q0_carry_i_3_n_0,
      S(2) => \bclk_phase_acc_q0_carry_i_4__1_n_0\,
      S(1) => \bclk_phase_acc_q0_carry_i_5__1_n_0\,
      S(0) => bclk_phase_acc_q0_carry_i_6_n_0
    );
\bclk_phase_acc_q0_carry_i_1__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_1__2_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry_i_1__3_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_1__3_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_1__3_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_1__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => bclk_phase_acc_q(25 downto 22),
      O(3 downto 0) => bclk_phase_sum(25 downto 22),
      S(3) => bclk_phase_acc_q(25),
      S(2) => \bclk_phase_acc_q0_carry_i_3__0_n_0\,
      S(1) => \bclk_phase_acc_q0_carry_i_4__0_n_0\,
      S(0) => \bclk_phase_acc_q0_carry_i_5__3_n_0\
    );
\bclk_phase_acc_q0_carry_i_1__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_1__3_n_0\,
      CO(3) => \bclk_phase_acc_q0_carry_i_1__4_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_1__4_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_1__4_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_1__4_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => bclk_phase_acc_q(26),
      O(3 downto 0) => bclk_phase_sum(29 downto 26),
      S(3 downto 0) => bclk_phase_acc_q(29 downto 26)
    );
\bclk_phase_acc_q0_carry_i_1__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \bclk_phase_acc_q0_carry_i_1__4_n_0\,
      CO(3 downto 1) => \NLW_bclk_phase_acc_q0_carry_i_1__5_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \bclk_phase_acc_q0_carry_i_1__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 2) => \NLW_bclk_phase_acc_q0_carry_i_1__5_O_UNCONNECTED\(3 downto 2),
      O(1 downto 0) => bclk_phase_sum(31 downto 30),
      S(3 downto 2) => B"00",
      S(1 downto 0) => bclk_phase_acc_q(31 downto 30)
    );
bclk_phase_acc_q0_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(12),
      O => bclk_phase_acc_q0_carry_i_2_n_0
    );
\bclk_phase_acc_q0_carry_i_2__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(17),
      O => \bclk_phase_acc_q0_carry_i_2__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_2__1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(19),
      O => \bclk_phase_acc_q0_carry_i_2__1_n_0\
    );
\bclk_phase_acc_q0_carry_i_2__2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(25),
      O => \bclk_phase_acc_q0_carry_i_2__2_n_0\
    );
\bclk_phase_acc_q0_carry_i_2__3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(30),
      O => \bclk_phase_acc_q0_carry_i_2__3_n_0\
    );
\bclk_phase_acc_q0_carry_i_2__4\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \bclk_phase_acc_q0_carry_i_2__4_n_0\,
      CO(2) => \bclk_phase_acc_q0_carry_i_2__4_n_1\,
      CO(1) => \bclk_phase_acc_q0_carry_i_2__4_n_2\,
      CO(0) => \bclk_phase_acc_q0_carry_i_2__4_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => bclk_phase_acc_q(9 downto 7),
      DI(0) => '0',
      O(3 downto 1) => bclk_phase_sum(9 downto 7),
      O(0) => \NLW_bclk_phase_acc_q0_carry_i_2__4_O_UNCONNECTED\(0),
      S(3) => bclk_phase_acc_q0_carry_i_10_n_0,
      S(2) => bclk_phase_acc_q0_carry_i_11_n_0,
      S(1) => bclk_phase_acc_q0_carry_i_12_n_0,
      S(0) => '0'
    );
bclk_phase_acc_q0_carry_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => bclk_phase_acc_q(21),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(14),
      O => bclk_phase_acc_q0_carry_i_3_n_0
    );
\bclk_phase_acc_q0_carry_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5556"
    )
        port map (
      I0 => bclk_phase_acc_q(24),
      I1 => sel0(19),
      I2 => sel0(18),
      I3 => sel0(17),
      O => \bclk_phase_acc_q0_carry_i_3__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_3__0__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(11),
      O => \bclk_phase_acc_q0_carry_i_3__0__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_3__1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(10),
      O => \bclk_phase_acc_q0_carry_i_3__1_n_0\
    );
\bclk_phase_acc_q0_carry_i_3__1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(29),
      O => \bclk_phase_acc_q0_carry_i_3__1__0_n_0\
    );
bclk_phase_acc_q0_carry_i_4: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => bclk_phase_acc_q(17),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(10),
      O => bclk_phase_acc_q0_carry_i_4_n_0
    );
\bclk_phase_acc_q0_carry_i_4__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAA9AAAA"
    )
        port map (
      I0 => bclk_phase_acc_q(23),
      I1 => sel0(17),
      I2 => sel0(18),
      I3 => sel0(19),
      I4 => sel0(16),
      O => \bclk_phase_acc_q0_carry_i_4__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_4__0__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(28),
      O => \bclk_phase_acc_q0_carry_i_4__0__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_4__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => bclk_phase_acc_q(20),
      I3 => sel0(13),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \bclk_phase_acc_q0_carry_i_4__1_n_0\
    );
\bclk_phase_acc_q0_carry_i_4__2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(9),
      O => \bclk_phase_acc_q0_carry_i_4__2_n_0\
    );
bclk_phase_acc_q0_carry_i_5: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(8),
      O => bclk_phase_acc_q0_carry_i_5_n_0
    );
\bclk_phase_acc_q0_carry_i_5__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => bclk_phase_sum(27),
      O => \bclk_phase_acc_q0_carry_i_5__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_5__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => bclk_phase_acc_q(19),
      I3 => sel0(12),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \bclk_phase_acc_q0_carry_i_5__1_n_0\
    );
\bclk_phase_acc_q0_carry_i_5__2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => bclk_phase_acc_q(16),
      I3 => sel0(9),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \bclk_phase_acc_q0_carry_i_5__2_n_0\
    );
\bclk_phase_acc_q0_carry_i_5__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F1E"
    )
        port map (
      I0 => sel0(15),
      I1 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I2 => bclk_phase_acc_q(22),
      I3 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \bclk_phase_acc_q0_carry_i_5__3_n_0\
    );
bclk_phase_acc_q0_carry_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => bclk_phase_acc_q(18),
      I3 => sel0(11),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => bclk_phase_acc_q0_carry_i_6_n_0
    );
\bclk_phase_acc_q0_carry_i_6__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F00FF0D2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => bclk_phase_acc_q(15),
      I3 => mclk_phase_acc_q0_carry_i_8_n_0,
      I4 => sel0(8),
      O => \bclk_phase_acc_q0_carry_i_6__0_n_0\
    );
\bclk_phase_acc_q0_carry_i_6__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => bclk_phase_acc_q(13),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(6),
      O => \bclk_phase_acc_q0_carry_i_6__1_n_0\
    );
bclk_phase_acc_q0_carry_i_7: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => bclk_phase_acc_q(12),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(5),
      O => bclk_phase_acc_q0_carry_i_7_n_0
    );
\bclk_phase_acc_q0_carry_i_7__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => bclk_phase_acc_q(14),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => \mclk_phase_acc_q0_carry__1_i_8_n_0\,
      O => \bclk_phase_acc_q0_carry_i_7__0_n_0\
    );
bclk_phase_acc_q0_carry_i_8: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => bclk_phase_acc_q(11),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(4),
      O => bclk_phase_acc_q0_carry_i_8_n_0
    );
bclk_phase_acc_q0_carry_i_9: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => bclk_phase_acc_q(10),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(3),
      O => bclk_phase_acc_q0_carry_i_9_n_0
    );
\bclk_phase_acc_q[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(10),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(10),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[10]_i_1_n_0\
    );
\bclk_phase_acc_q[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(11),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(11),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[11]_i_1_n_0\
    );
\bclk_phase_acc_q[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(12),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(12),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[12]_i_1_n_0\
    );
\bclk_phase_acc_q[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(13),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(13),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[13]_i_1_n_0\
    );
\bclk_phase_acc_q[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(14),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(14),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[14]_i_1_n_0\
    );
\bclk_phase_acc_q[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(15),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(15),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[15]_i_1_n_0\
    );
\bclk_phase_acc_q[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(16),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(16),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[16]_i_1_n_0\
    );
\bclk_phase_acc_q[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(17),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(17),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[17]_i_1_n_0\
    );
\bclk_phase_acc_q[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(18),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(18),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[18]_i_1_n_0\
    );
\bclk_phase_acc_q[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(19),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(19),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[19]_i_1_n_0\
    );
\bclk_phase_acc_q[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(20),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(20),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[20]_i_1_n_0\
    );
\bclk_phase_acc_q[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(21),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(21),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[21]_i_1_n_0\
    );
\bclk_phase_acc_q[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(22),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(22),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[22]_i_1_n_0\
    );
\bclk_phase_acc_q[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(23),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(23),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[23]_i_1_n_0\
    );
\bclk_phase_acc_q[24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(24),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(24),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[24]_i_1_n_0\
    );
\bclk_phase_acc_q[25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(25),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(25),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[25]_i_1_n_0\
    );
\bclk_phase_acc_q[26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(26),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(26),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[26]_i_1_n_0\
    );
\bclk_phase_acc_q[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => bclk_phase_acc_q0(27),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => bclk_q_i_2_n_0,
      O => \bclk_phase_acc_q[27]_i_1_n_0\
    );
\bclk_phase_acc_q[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => bclk_phase_acc_q0(28),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => bclk_q_i_2_n_0,
      O => \bclk_phase_acc_q[28]_i_1_n_0\
    );
\bclk_phase_acc_q[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => bclk_phase_acc_q0(29),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => bclk_q_i_2_n_0,
      O => \bclk_phase_acc_q[29]_i_1_n_0\
    );
\bclk_phase_acc_q[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => bclk_phase_acc_q0(30),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => bclk_q_i_2_n_0,
      O => \bclk_phase_acc_q[30]_i_1_n_0\
    );
\bclk_phase_acc_q[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => bclk_phase_acc_q0(31),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => bclk_q_i_2_n_0,
      O => \bclk_phase_acc_q[31]_i_1_n_0\
    );
\bclk_phase_acc_q[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(7),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(7),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[7]_i_1_n_0\
    );
\bclk_phase_acc_q[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(8),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(8),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[8]_i_1_n_0\
    );
\bclk_phase_acc_q[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => bclk_phase_acc_q0(9),
      I1 => bclk_q_i_2_n_0,
      I2 => bclk_phase_sum(9),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \bclk_phase_acc_q[9]_i_1_n_0\
    );
\bclk_phase_acc_q_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[10]_i_1_n_0\,
      Q => bclk_phase_acc_q(10)
    );
\bclk_phase_acc_q_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[11]_i_1_n_0\,
      Q => bclk_phase_acc_q(11)
    );
\bclk_phase_acc_q_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[12]_i_1_n_0\,
      Q => bclk_phase_acc_q(12)
    );
\bclk_phase_acc_q_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[13]_i_1_n_0\,
      Q => bclk_phase_acc_q(13)
    );
\bclk_phase_acc_q_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[14]_i_1_n_0\,
      Q => bclk_phase_acc_q(14)
    );
\bclk_phase_acc_q_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[15]_i_1_n_0\,
      Q => bclk_phase_acc_q(15)
    );
\bclk_phase_acc_q_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[16]_i_1_n_0\,
      Q => bclk_phase_acc_q(16)
    );
\bclk_phase_acc_q_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[17]_i_1_n_0\,
      Q => bclk_phase_acc_q(17)
    );
\bclk_phase_acc_q_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[18]_i_1_n_0\,
      Q => bclk_phase_acc_q(18)
    );
\bclk_phase_acc_q_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[19]_i_1_n_0\,
      Q => bclk_phase_acc_q(19)
    );
\bclk_phase_acc_q_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[20]_i_1_n_0\,
      Q => bclk_phase_acc_q(20)
    );
\bclk_phase_acc_q_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[21]_i_1_n_0\,
      Q => bclk_phase_acc_q(21)
    );
\bclk_phase_acc_q_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[22]_i_1_n_0\,
      Q => bclk_phase_acc_q(22)
    );
\bclk_phase_acc_q_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[23]_i_1_n_0\,
      Q => bclk_phase_acc_q(23)
    );
\bclk_phase_acc_q_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[24]_i_1_n_0\,
      Q => bclk_phase_acc_q(24)
    );
\bclk_phase_acc_q_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[25]_i_1_n_0\,
      Q => bclk_phase_acc_q(25)
    );
\bclk_phase_acc_q_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[26]_i_1_n_0\,
      Q => bclk_phase_acc_q(26)
    );
\bclk_phase_acc_q_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[27]_i_1_n_0\,
      Q => bclk_phase_acc_q(27)
    );
\bclk_phase_acc_q_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[28]_i_1_n_0\,
      Q => bclk_phase_acc_q(28)
    );
\bclk_phase_acc_q_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[29]_i_1_n_0\,
      Q => bclk_phase_acc_q(29)
    );
\bclk_phase_acc_q_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[30]_i_1_n_0\,
      Q => bclk_phase_acc_q(30)
    );
\bclk_phase_acc_q_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[31]_i_1_n_0\,
      Q => bclk_phase_acc_q(31)
    );
\bclk_phase_acc_q_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[7]_i_1_n_0\,
      Q => bclk_phase_acc_q(7)
    );
\bclk_phase_acc_q_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[8]_i_1_n_0\,
      Q => bclk_phase_acc_q(8)
    );
\bclk_phase_acc_q_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \bclk_phase_acc_q[9]_i_1_n_0\,
      Q => bclk_phase_acc_q(9)
    );
bclk_q_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"82"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => bclk_q_i_2_n_0,
      I2 => \^bclk_q_reg_0\,
      O => bclk_q_i_1_n_0
    );
bclk_q_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"001F"
    )
        port map (
      I0 => bclk_phase_sum(25),
      I1 => bclk_q_i_3_n_0,
      I2 => bclk_phase_sum(26),
      I3 => bclk_q_i_4_n_0,
      O => bclk_q_i_2_n_0
    );
bclk_q_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFFAA08"
    )
        port map (
      I0 => bclk_phase_sum(18),
      I1 => bclk_q_i_5_n_0,
      I2 => bclk_q_i_6_n_0,
      I3 => bclk_phase_sum(17),
      I4 => bclk_phase_sum(19),
      I5 => bclk_q_i_7_n_0,
      O => bclk_q_i_3_n_0
    );
bclk_q_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => bclk_phase_sum(31),
      I1 => bclk_phase_sum(27),
      I2 => bclk_phase_sum(29),
      I3 => bclk_phase_sum(30),
      I4 => bclk_phase_sum(28),
      O => bclk_q_i_4_n_0
    );
bclk_q_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => bclk_phase_sum(12),
      I1 => bclk_phase_sum(10),
      I2 => bclk_phase_sum(8),
      I3 => bclk_phase_sum(9),
      I4 => bclk_phase_sum(11),
      O => bclk_q_i_5_n_0
    );
bclk_q_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => bclk_phase_sum(15),
      I1 => bclk_phase_sum(14),
      I2 => bclk_phase_sum(16),
      I3 => bclk_phase_sum(13),
      O => bclk_q_i_6_n_0
    );
bclk_q_i_7: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
        port map (
      I0 => bclk_phase_sum(23),
      I1 => bclk_phase_sum(21),
      I2 => bclk_phase_sum(20),
      I3 => bclk_phase_sum(22),
      I4 => bclk_phase_sum(24),
      O => bclk_q_i_7_n_0
    );
bclk_q_reg: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => bclk_q_i_1_n_0,
      Q => \^bclk_q_reg_0\
    );
\bit_count_q[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => p_0_in(0),
      O => \p_0_in__0\(0)
    );
\bit_count_q[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      I2 => \slv_reg2_reg_n_0_[0]\,
      O => \bit_count_q[1]_i_1_n_0\
    );
\bit_count_q[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      I3 => p_0_in(2),
      O => \p_0_in__0\(2)
    );
\bit_count_q[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2AAA8000"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      I3 => p_0_in(2),
      I4 => p_0_in(3),
      O => \p_0_in__0\(3)
    );
\bit_count_q[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AAAAAAA80000000"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => p_0_in(2),
      I2 => p_0_in(1),
      I3 => p_0_in(0),
      I4 => p_0_in(3),
      I5 => p_0_in(4),
      O => \p_0_in__0\(4)
    );
\bit_count_q[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => \bit_count_q[5]_i_2_n_0\,
      I2 => p_0_in(4),
      I3 => p_0_in2_in,
      O => \p_0_in__0\(5)
    );
\bit_count_q[5]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => p_0_in(2),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      I3 => p_0_in(3),
      O => \bit_count_q[5]_i_2_n_0\
    );
\bit_count_q_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \p_0_in__0\(0),
      Q => p_0_in(0)
    );
\bit_count_q_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \bit_count_q[1]_i_1_n_0\,
      Q => p_0_in(1)
    );
\bit_count_q_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \p_0_in__0\(2),
      Q => p_0_in(2)
    );
\bit_count_q_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \p_0_in__0\(3),
      Q => p_0_in(3)
    );
\bit_count_q_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \p_0_in__0\(4),
      Q => p_0_in(4)
    );
\bit_count_q_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => \p_0_in__0\(5),
      Q => p_0_in2_in
    );
current_latch_status_q_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFBFF00000400"
    )
        port map (
      I0 => bclk_q_i_2_n_0,
      I1 => data_q_i_4_n_0,
      I2 => p_0_in2_in,
      I3 => \slv_reg2_reg_n_0_[0]\,
      I4 => \^bclk_q_reg_0\,
      I5 => current_latch_status_q,
      O => current_latch_status_q_i_1_n_0
    );
current_latch_status_q_reg: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => current_latch_status_q_i_1_n_0,
      Q => current_latch_status_q
    );
data_q_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000200"
    )
        port map (
      I0 => data_q_i_2_n_0,
      I1 => data_q_i_3_n_0,
      I2 => mute_sync,
      I3 => \slv_reg2_reg_n_0_[0]\,
      I4 => data_q_i_4_n_0,
      I5 => data_q_i_5_n_0,
      O => data_q_i_1_n_0
    );
data_q_i_10: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96996696"
    )
        port map (
      I0 => sample_width_raw(4),
      I1 => p_0_in(4),
      I2 => sample_width_raw(3),
      I3 => p_0_in(3),
      I4 => data_q_i_12_n_0,
      O => data_q_i_10_n_0
    );
data_q_i_11: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBBBBBBBBBB8"
    )
        port map (
      I0 => p_0_in(4),
      I1 => sample_width_raw(4),
      I2 => sample_width_raw(3),
      I3 => sample_width_raw(1),
      I4 => sample_width_raw(2),
      I5 => sample_width_raw(0),
      O => data_q_i_11_n_0
    );
data_q_i_12: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BB2B2B22BB2BBB2B"
    )
        port map (
      I0 => sample_width_raw(2),
      I1 => p_0_in(2),
      I2 => p_0_in(1),
      I3 => sample_width_raw(1),
      I4 => sample_width_raw(0),
      I5 => p_0_in(0),
      O => data_q_i_12_n_0
    );
data_q_i_13: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBABABABBBAB"
    )
        port map (
      I0 => data_q_i_30_n_0,
      I1 => data_q_i_31_n_0,
      I2 => data_q_i_24_n_0,
      I3 => sample_left_q(4),
      I4 => data_q_i_23_n_0,
      I5 => sample_left_q(5),
      O => data_q_i_13_n_0
    );
data_q_i_14: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DD0F"
    )
        port map (
      I0 => data_q_i_32_n_0,
      I1 => data_q_i_33_n_0,
      I2 => data_q_i_34_n_0,
      I3 => data_q_i_19_n_0,
      I4 => data_q_i_18_n_0,
      O => data_q_i_14_n_0
    );
data_q_i_15: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF54045555"
    )
        port map (
      I0 => data_q_i_35_n_0,
      I1 => sample_left_q(20),
      I2 => data_q_i_23_n_0,
      I3 => sample_left_q(21),
      I4 => data_q_i_24_n_0,
      I5 => data_q_i_36_n_0,
      O => data_q_i_15_n_0
    );
data_q_i_16: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AAABBBAB"
    )
        port map (
      I0 => data_q_i_37_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_left_q(26),
      I3 => data_q_i_23_n_0,
      I4 => sample_left_q(27),
      I5 => data_q_i_38_n_0,
      O => data_q_i_16_n_0
    );
data_q_i_17: unisim.vcomponents.LUT6
    generic map(
      INIT => X"505F3030505F3F3F"
    )
        port map (
      I0 => sample_right_q(13),
      I1 => sample_right_q(12),
      I2 => data_q_i_24_n_0,
      I3 => sample_right_q(15),
      I4 => data_q_i_23_n_0,
      I5 => sample_right_q(14),
      O => data_q_i_17_n_0
    );
data_q_i_18: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => sample_width_raw(3),
      I1 => p_0_in(3),
      I2 => data_q_i_12_n_0,
      O => data_q_i_18_n_0
    );
data_q_i_19: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9969666699999969"
    )
        port map (
      I0 => sample_width_raw(2),
      I1 => p_0_in(2),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_width_raw(1),
      I5 => p_0_in(1),
      O => data_q_i_19_n_0
    );
data_q_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8F8F8F8F0F0FFF0F"
    )
        port map (
      I0 => data_q_i_6_n_0,
      I1 => data_q_i_7_n_0,
      I2 => p_0_in2_in,
      I3 => data_q_i_8_n_0,
      I4 => data_q_i_9_n_0,
      I5 => data_q_i_10_n_0,
      O => data_q_i_2_n_0
    );
data_q_i_20: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F9FFFFF9F96699F9"
    )
        port map (
      I0 => p_0_in(1),
      I1 => sample_width_raw(1),
      I2 => sample_right_q(10),
      I3 => sample_width_raw(0),
      I4 => p_0_in(0),
      I5 => sample_right_q(11),
      O => data_q_i_20_n_0
    );
data_q_i_21: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0900000909669909"
    )
        port map (
      I0 => p_0_in(1),
      I1 => sample_width_raw(1),
      I2 => sample_right_q(8),
      I3 => sample_width_raw(0),
      I4 => p_0_in(0),
      I5 => sample_right_q(9),
      O => data_q_i_21_n_0
    );
data_q_i_22: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555555555775F77F"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_right_q(3),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_right_q(2),
      I5 => data_q_i_24_n_0,
      O => data_q_i_22_n_0
    );
data_q_i_23: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in(0),
      I1 => sample_width_raw(0),
      O => data_q_i_23_n_0
    );
data_q_i_24: unisim.vcomponents.LUT4
    generic map(
      INIT => X"D22D"
    )
        port map (
      I0 => p_0_in(0),
      I1 => sample_width_raw(0),
      I2 => sample_width_raw(1),
      I3 => p_0_in(1),
      O => data_q_i_24_n_0
    );
data_q_i_25: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555FD5DFFFF"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => sample_right_q(4),
      I2 => data_q_i_23_n_0,
      I3 => sample_right_q(5),
      I4 => data_q_i_24_n_0,
      I5 => data_q_i_39_n_0,
      O => data_q_i_25_n_0
    );
data_q_i_26: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_right_q(23),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_right_q(22),
      I5 => data_q_i_24_n_0,
      O => data_q_i_26_n_0
    );
data_q_i_27: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555FFFDDDFD"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_right_q(18),
      I3 => data_q_i_23_n_0,
      I4 => sample_right_q(19),
      I5 => data_q_i_40_n_0,
      O => data_q_i_27_n_0
    );
data_q_i_28: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555555555775F77F"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_right_q(27),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_right_q(26),
      I5 => data_q_i_24_n_0,
      O => data_q_i_28_n_0
    );
data_q_i_29: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBAAABABBBBBBBB"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => data_q_i_41_n_0,
      I2 => sample_right_q(28),
      I3 => data_q_i_23_n_0,
      I4 => sample_right_q(29),
      I5 => data_q_i_24_n_0,
      O => data_q_i_29_n_0
    );
data_q_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"28AA2828AAAA28AA"
    )
        port map (
      I0 => data_q_i_11_n_0,
      I1 => p_0_in(4),
      I2 => sample_width_raw(4),
      I3 => data_q_i_12_n_0,
      I4 => p_0_in(3),
      I5 => sample_width_raw(3),
      O => data_q_i_3_n_0
    );
data_q_i_30: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555FFFDDDFD"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_left_q(2),
      I3 => data_q_i_23_n_0,
      I4 => sample_left_q(3),
      I5 => data_q_i_42_n_0,
      O => data_q_i_30_n_0
    );
data_q_i_31: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_left_q(7),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_left_q(6),
      I5 => data_q_i_24_n_0,
      O => data_q_i_31_n_0
    );
data_q_i_32: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F9FFFFF9F96699F9"
    )
        port map (
      I0 => p_0_in(1),
      I1 => sample_width_raw(1),
      I2 => sample_left_q(10),
      I3 => sample_width_raw(0),
      I4 => p_0_in(0),
      I5 => sample_left_q(11),
      O => data_q_i_32_n_0
    );
data_q_i_33: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0900000909669909"
    )
        port map (
      I0 => p_0_in(1),
      I1 => sample_width_raw(1),
      I2 => sample_left_q(8),
      I3 => sample_width_raw(0),
      I4 => p_0_in(0),
      I5 => sample_left_q(9),
      O => data_q_i_33_n_0
    );
data_q_i_34: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFF000AACCAACC"
    )
        port map (
      I0 => sample_left_q(15),
      I1 => sample_left_q(14),
      I2 => sample_left_q(13),
      I3 => data_q_i_23_n_0,
      I4 => sample_left_q(12),
      I5 => data_q_i_24_n_0,
      O => data_q_i_34_n_0
    );
data_q_i_35: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_left_q(23),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_left_q(22),
      I5 => data_q_i_24_n_0,
      O => data_q_i_35_n_0
    );
data_q_i_36: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555FD5DFFFF"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => sample_left_q(16),
      I2 => data_q_i_23_n_0,
      I3 => sample_left_q(17),
      I4 => data_q_i_24_n_0,
      I5 => data_q_i_43_n_0,
      O => data_q_i_36_n_0
    );
data_q_i_37: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555D5D55DD5D5DDD"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_left_q(25),
      I3 => p_0_in(0),
      I4 => sample_width_raw(0),
      I5 => sample_left_q(24),
      O => data_q_i_37_n_0
    );
data_q_i_38: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBAAABABBBBBBBB"
    )
        port map (
      I0 => data_q_i_18_n_0,
      I1 => data_q_i_44_n_0,
      I2 => sample_left_q(28),
      I3 => data_q_i_23_n_0,
      I4 => sample_left_q(29),
      I5 => data_q_i_24_n_0,
      O => data_q_i_38_n_0
    );
data_q_i_39: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_right_q(7),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_right_q(6),
      I5 => data_q_i_24_n_0,
      O => data_q_i_39_n_0
    );
data_q_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      I2 => p_0_in(2),
      I3 => p_0_in(4),
      I4 => p_0_in(3),
      O => data_q_i_4_n_0
    );
data_q_i_40: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555D5D55DD5D5DDD"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_right_q(17),
      I3 => p_0_in(0),
      I4 => sample_width_raw(0),
      I5 => sample_right_q(16),
      O => data_q_i_40_n_0
    );
data_q_i_41: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_right_q(31),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_right_q(30),
      I5 => data_q_i_24_n_0,
      O => data_q_i_41_n_0
    );
data_q_i_42: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555D5D55DD5D5DDD"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_left_q(1),
      I3 => p_0_in(0),
      I4 => sample_width_raw(0),
      I5 => sample_left_q(0),
      O => data_q_i_42_n_0
    );
data_q_i_43: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555555555775F77F"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_left_q(19),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_left_q(18),
      I5 => data_q_i_24_n_0,
      O => data_q_i_43_n_0
    );
data_q_i_44: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAABBAFBBF"
    )
        port map (
      I0 => data_q_i_19_n_0,
      I1 => sample_left_q(31),
      I2 => p_0_in(0),
      I3 => sample_width_raw(0),
      I4 => sample_left_q(30),
      I5 => data_q_i_24_n_0,
      O => data_q_i_44_n_0
    );
data_q_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000DDDDFF0F"
    )
        port map (
      I0 => data_q_i_13_n_0,
      I1 => data_q_i_14_n_0,
      I2 => data_q_i_15_n_0,
      I3 => data_q_i_16_n_0,
      I4 => data_q_i_10_n_0,
      I5 => p_0_in2_in,
      O => data_q_i_5_n_0
    );
data_q_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CDCDFDCD"
    )
        port map (
      I0 => data_q_i_17_n_0,
      I1 => data_q_i_18_n_0,
      I2 => data_q_i_19_n_0,
      I3 => data_q_i_20_n_0,
      I4 => data_q_i_21_n_0,
      O => data_q_i_6_n_0
    );
data_q_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF54045555"
    )
        port map (
      I0 => data_q_i_22_n_0,
      I1 => sample_right_q(0),
      I2 => data_q_i_23_n_0,
      I3 => sample_right_q(1),
      I4 => data_q_i_24_n_0,
      I5 => data_q_i_25_n_0,
      O => data_q_i_7_n_0
    );
data_q_i_8: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF54045555"
    )
        port map (
      I0 => data_q_i_26_n_0,
      I1 => sample_right_q(20),
      I2 => data_q_i_23_n_0,
      I3 => sample_right_q(21),
      I4 => data_q_i_24_n_0,
      I5 => data_q_i_27_n_0,
      O => data_q_i_8_n_0
    );
data_q_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AAAEEEAE"
    )
        port map (
      I0 => data_q_i_28_n_0,
      I1 => data_q_i_24_n_0,
      I2 => sample_right_q(24),
      I3 => data_q_i_23_n_0,
      I4 => sample_right_q(25),
      I5 => data_q_i_29_n_0,
      O => data_q_i_9_n_0
    );
data_q_reg: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => data_q_i_1_n_0,
      Q => i2s_data
    );
mclk_phase_acc_q0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => mclk_phase_acc_q0_carry_n_0,
      CO(2) => mclk_phase_acc_q0_carry_n_1,
      CO(1) => mclk_phase_acc_q0_carry_n_2,
      CO(0) => mclk_phase_acc_q0_carry_n_3,
      CYINIT => '0',
      DI(3 downto 1) => mclk_phase_sum(10 downto 8),
      DI(0) => '0',
      O(3 downto 1) => mclk_phase_acc_q0(10 downto 8),
      O(0) => NLW_mclk_phase_acc_q0_carry_O_UNCONNECTED(0),
      S(3) => mclk_phase_acc_q0_carry_i_2_n_0,
      S(2) => mclk_phase_acc_q0_carry_i_3_n_0,
      S(1) => mclk_phase_acc_q0_carry_i_4_n_0,
      S(0) => '0'
    );
\mclk_phase_acc_q0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => mclk_phase_acc_q0_carry_n_0,
      CO(3) => \mclk_phase_acc_q0_carry__0_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__0_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__0_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => mclk_phase_sum(12 downto 11),
      O(3 downto 0) => mclk_phase_acc_q0(14 downto 11),
      S(3 downto 2) => mclk_phase_sum(14 downto 13),
      S(1) => \mclk_phase_acc_q0_carry__0_i_2_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__0_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => mclk_phase_acc_q0_carry_i_1_n_0,
      CO(3) => \mclk_phase_acc_q0_carry__0_i_1_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__0_i_1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__0_i_1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__0_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => mclk_phase_acc_q(15 downto 12),
      O(3 downto 0) => mclk_phase_sum(15 downto 12),
      S(3) => \mclk_phase_acc_q0_carry__0_i_4_n_0\,
      S(2) => \mclk_phase_acc_q0_carry__0_i_5_n_0\,
      S(1) => \mclk_phase_acc_q0_carry__0_i_6_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__0_i_7_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(12),
      O => \mclk_phase_acc_q0_carry__0_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(11),
      O => \mclk_phase_acc_q0_carry__0_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => mclk_phase_acc_q(15),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(6),
      O => \mclk_phase_acc_q0_carry__0_i_4_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => mclk_phase_acc_q(14),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(5),
      O => \mclk_phase_acc_q0_carry__0_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => mclk_phase_acc_q(13),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(4),
      O => \mclk_phase_acc_q0_carry__0_i_6_n_0\
    );
\mclk_phase_acc_q0_carry__0_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => mclk_phase_acc_q(12),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(3),
      O => \mclk_phase_acc_q0_carry__0_i_7_n_0\
    );
\mclk_phase_acc_q0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__0_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__1_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => mclk_phase_sum(17),
      DI(1 downto 0) => B"00",
      O(3 downto 0) => mclk_phase_acc_q0(18 downto 15),
      S(3) => mclk_phase_sum(18),
      S(2) => \mclk_phase_acc_q0_carry__1_i_2_n_0\,
      S(1 downto 0) => mclk_phase_sum(16 downto 15)
    );
\mclk_phase_acc_q0_carry__1_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__0_i_1_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__1_i_1_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__1_i_1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__1_i_1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__1_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => mclk_phase_acc_q(19 downto 16),
      O(3 downto 0) => mclk_phase_sum(19 downto 16),
      S(3) => \mclk_phase_acc_q0_carry__1_i_3_n_0\,
      S(2) => \mclk_phase_acc_q0_carry__1_i_4_n_0\,
      S(1) => \mclk_phase_acc_q0_carry__1_i_5_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__1_i_6_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFF2"
    )
        port map (
      I0 => sel0(9),
      I1 => sel0(10),
      I2 => sel0(11),
      I3 => sel0(17),
      I4 => sel0(16),
      I5 => \mclk_phase_acc_q0_carry__1_i_13_n_0\,
      O => \mclk_phase_acc_q0_carry__1_i_10_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => sel0(1),
      I1 => sel0(2),
      I2 => sel0(3),
      I3 => sel0(0),
      O => \mclk_phase_acc_q0_carry__1_i_11_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFEE"
    )
        port map (
      I0 => sel0(13),
      I1 => sel0(14),
      I2 => sel0(7),
      I3 => sel0(6),
      O => \mclk_phase_acc_q0_carry__1_i_12_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_13\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => sel0(19),
      I1 => sel0(18),
      O => \mclk_phase_acc_q0_carry__1_i_13_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(17),
      O => \mclk_phase_acc_q0_carry__1_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => mclk_phase_acc_q(19),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(10),
      O => \mclk_phase_acc_q0_carry__1_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => mclk_phase_acc_q(18),
      I3 => sel0(9),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \mclk_phase_acc_q0_carry__1_i_4_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F00FF0D2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => mclk_phase_acc_q(17),
      I3 => mclk_phase_acc_q0_carry_i_8_n_0,
      I4 => sel0(8),
      O => \mclk_phase_acc_q0_carry__1_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => mclk_phase_acc_q(16),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => \mclk_phase_acc_q0_carry__1_i_8_n_0\,
      O => \mclk_phase_acc_q0_carry__1_i_6_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000002"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_9_n_0\,
      I1 => sel0(7),
      I2 => sel0(10),
      I3 => sel0(11),
      I4 => \mclk_phase_acc_q0_carry__1_i_10_n_0\,
      O => \mclk_phase_acc_q0_carry__1_i_7_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAAA"
    )
        port map (
      I0 => sel0(7),
      I1 => \mclk_phase_acc_q0_carry__1_i_10_n_0\,
      I2 => sel0(11),
      I3 => sel0(10),
      I4 => sel0(15),
      I5 => \mclk_phase_acc_q0_carry__1_i_9_n_0\,
      O => \mclk_phase_acc_q0_carry__1_i_8_n_0\
    );
\mclk_phase_acc_q0_carry__1_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_11_n_0\,
      I1 => \mclk_phase_acc_q0_carry__1_i_12_n_0\,
      I2 => sel0(8),
      I3 => sel0(5),
      I4 => sel0(12),
      I5 => sel0(4),
      O => \mclk_phase_acc_q0_carry__1_i_9_n_0\
    );
\mclk_phase_acc_q0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__1_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__2_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__2_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__2_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => mclk_phase_sum(19),
      O(3 downto 0) => mclk_phase_acc_q0(22 downto 19),
      S(3 downto 1) => mclk_phase_sum(22 downto 20),
      S(0) => \mclk_phase_acc_q0_carry__2_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__1_i_1_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__2_i_1_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__2_i_1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__2_i_1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__2_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => mclk_phase_acc_q(23 downto 20),
      O(3 downto 0) => mclk_phase_sum(23 downto 20),
      S(3) => \mclk_phase_acc_q0_carry__2_i_3_n_0\,
      S(2) => \mclk_phase_acc_q0_carry__2_i_4_n_0\,
      S(1) => \mclk_phase_acc_q0_carry__2_i_5_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__2_i_6_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(19),
      O => \mclk_phase_acc_q0_carry__2_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"56"
    )
        port map (
      I0 => mclk_phase_acc_q(23),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(14),
      O => \mclk_phase_acc_q0_carry__2_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => mclk_phase_acc_q(22),
      I3 => sel0(13),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \mclk_phase_acc_q0_carry__2_i_4_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => mclk_phase_acc_q(21),
      I3 => sel0(12),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \mclk_phase_acc_q0_carry__2_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__2_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F0F0FD2"
    )
        port map (
      I0 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I1 => sel0(15),
      I2 => mclk_phase_acc_q(20),
      I3 => sel0(11),
      I4 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \mclk_phase_acc_q0_carry__2_i_6_n_0\
    );
\mclk_phase_acc_q0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__2_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__3_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__3_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__3_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__3_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => mclk_phase_sum(25),
      DI(1 downto 0) => B"00",
      O(3 downto 0) => mclk_phase_acc_q0(26 downto 23),
      S(3) => mclk_phase_sum(26),
      S(2) => \mclk_phase_acc_q0_carry__3_i_2_n_0\,
      S(1 downto 0) => mclk_phase_sum(24 downto 23)
    );
\mclk_phase_acc_q0_carry__3_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__2_i_1_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__3_i_1_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__3_i_1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__3_i_1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__3_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => mclk_phase_acc_q(27 downto 24),
      O(3 downto 0) => mclk_phase_sum(27 downto 24),
      S(3) => mclk_phase_acc_q(27),
      S(2) => \mclk_phase_acc_q0_carry__3_i_3_n_0\,
      S(1) => \mclk_phase_acc_q0_carry__3_i_4_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__3_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__3_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(25),
      O => \mclk_phase_acc_q0_carry__3_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__3_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5556"
    )
        port map (
      I0 => mclk_phase_acc_q(26),
      I1 => sel0(19),
      I2 => sel0(18),
      I3 => sel0(17),
      O => \mclk_phase_acc_q0_carry__3_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__3_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAA9AAAA"
    )
        port map (
      I0 => mclk_phase_acc_q(25),
      I1 => sel0(17),
      I2 => sel0(18),
      I3 => sel0(19),
      I4 => sel0(16),
      O => \mclk_phase_acc_q0_carry__3_i_4_n_0\
    );
\mclk_phase_acc_q0_carry__3_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F1E"
    )
        port map (
      I0 => sel0(15),
      I1 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I2 => mclk_phase_acc_q(24),
      I3 => mclk_phase_acc_q0_carry_i_8_n_0,
      O => \mclk_phase_acc_q0_carry__3_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__3_n_0\,
      CO(3) => \mclk_phase_acc_q0_carry__4_n_0\,
      CO(2) => \mclk_phase_acc_q0_carry__4_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__4_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => mclk_phase_sum(30 downto 27),
      O(3 downto 0) => mclk_phase_acc_q0(30 downto 27),
      S(3) => \mclk_phase_acc_q0_carry__4_i_2_n_0\,
      S(2) => \mclk_phase_acc_q0_carry__4_i_3_n_0\,
      S(1) => \mclk_phase_acc_q0_carry__4_i_4_n_0\,
      S(0) => \mclk_phase_acc_q0_carry__4_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__4_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__3_i_1_n_0\,
      CO(3) => \NLW_mclk_phase_acc_q0_carry__4_i_1_CO_UNCONNECTED\(3),
      CO(2) => \mclk_phase_acc_q0_carry__4_i_1_n_1\,
      CO(1) => \mclk_phase_acc_q0_carry__4_i_1_n_2\,
      CO(0) => \mclk_phase_acc_q0_carry__4_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => mclk_phase_acc_q(28),
      O(3 downto 0) => mclk_phase_sum(31 downto 28),
      S(3 downto 0) => mclk_phase_acc_q(31 downto 28)
    );
\mclk_phase_acc_q0_carry__4_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(30),
      O => \mclk_phase_acc_q0_carry__4_i_2_n_0\
    );
\mclk_phase_acc_q0_carry__4_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(29),
      O => \mclk_phase_acc_q0_carry__4_i_3_n_0\
    );
\mclk_phase_acc_q0_carry__4_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(28),
      O => \mclk_phase_acc_q0_carry__4_i_4_n_0\
    );
\mclk_phase_acc_q0_carry__4_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(27),
      O => \mclk_phase_acc_q0_carry__4_i_5_n_0\
    );
\mclk_phase_acc_q0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \mclk_phase_acc_q0_carry__4_n_0\,
      CO(3 downto 0) => \NLW_mclk_phase_acc_q0_carry__5_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_mclk_phase_acc_q0_carry__5_O_UNCONNECTED\(3 downto 1),
      O(0) => mclk_phase_acc_q0(31),
      S(3 downto 1) => B"000",
      S(0) => \mclk_phase_acc_q0_carry__5_i_1_n_0\
    );
\mclk_phase_acc_q0_carry__5_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(31),
      O => \mclk_phase_acc_q0_carry__5_i_1_n_0\
    );
mclk_phase_acc_q0_carry_i_1: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => mclk_phase_acc_q0_carry_i_1_n_0,
      CO(2) => mclk_phase_acc_q0_carry_i_1_n_1,
      CO(1) => mclk_phase_acc_q0_carry_i_1_n_2,
      CO(0) => mclk_phase_acc_q0_carry_i_1_n_3,
      CYINIT => '0',
      DI(3 downto 1) => mclk_phase_acc_q(11 downto 9),
      DI(0) => '0',
      O(3 downto 0) => mclk_phase_sum(11 downto 8),
      S(3) => mclk_phase_acc_q0_carry_i_5_n_0,
      S(2) => mclk_phase_acc_q0_carry_i_6_n_0,
      S(1) => mclk_phase_acc_q0_carry_i_7_n_0,
      S(0) => mclk_phase_acc_q(8)
    );
mclk_phase_acc_q0_carry_i_10: unisim.vcomponents.LUT6
    generic map(
      INIT => X"770FFFFFFF0FFFFF"
    )
        port map (
      I0 => sel0(11),
      I1 => sel0(12),
      I2 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I3 => sel0(15),
      I4 => sel0(14),
      I5 => sel0(13),
      O => mclk_phase_acc_q0_carry_i_10_n_0
    );
mclk_phase_acc_q0_carry_i_11: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00800000"
    )
        port map (
      I0 => sel0(4),
      I1 => sel0(5),
      I2 => sel0(6),
      I3 => \mclk_phase_acc_q0_carry__1_i_11_n_0\,
      I4 => sel0(7),
      O => mclk_phase_acc_q0_carry_i_11_n_0
    );
mclk_phase_acc_q0_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(10),
      O => mclk_phase_acc_q0_carry_i_2_n_0
    );
mclk_phase_acc_q0_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(9),
      O => mclk_phase_acc_q0_carry_i_3_n_0
    );
mclk_phase_acc_q0_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mclk_phase_sum(8),
      O => mclk_phase_acc_q0_carry_i_4_n_0
    );
mclk_phase_acc_q0_carry_i_5: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => mclk_phase_acc_q(11),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(2),
      O => mclk_phase_acc_q0_carry_i_5_n_0
    );
mclk_phase_acc_q0_carry_i_6: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => mclk_phase_acc_q(10),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(1),
      O => mclk_phase_acc_q0_carry_i_6_n_0
    );
mclk_phase_acc_q0_carry_i_7: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => mclk_phase_acc_q(9),
      I1 => mclk_phase_acc_q0_carry_i_8_n_0,
      I2 => sel0(0),
      O => mclk_phase_acc_q0_carry_i_7_n_0
    );
mclk_phase_acc_q0_carry_i_8: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEEFEEEEEEEEE"
    )
        port map (
      I0 => sel0(18),
      I1 => sel0(19),
      I2 => mclk_phase_acc_q0_carry_i_9_n_0,
      I3 => mclk_phase_acc_q0_carry_i_10_n_0,
      I4 => sel0(16),
      I5 => sel0(17),
      O => mclk_phase_acc_q0_carry_i_8_n_0
    );
mclk_phase_acc_q0_carry_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFEEEFEEEFEEAFAA"
    )
        port map (
      I0 => sel0(10),
      I1 => sel0(9),
      I2 => sel0(15),
      I3 => \mclk_phase_acc_q0_carry__1_i_7_n_0\,
      I4 => mclk_phase_acc_q0_carry_i_11_n_0,
      I5 => sel0(8),
      O => mclk_phase_acc_q0_carry_i_9_n_0
    );
\mclk_phase_acc_q[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(10),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(10),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[10]_i_1_n_0\
    );
\mclk_phase_acc_q[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(11),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(11),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[11]_i_1_n_0\
    );
\mclk_phase_acc_q[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(12),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(12),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[12]_i_1_n_0\
    );
\mclk_phase_acc_q[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(13),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(13),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[13]_i_1_n_0\
    );
\mclk_phase_acc_q[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(14),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(14),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[14]_i_1_n_0\
    );
\mclk_phase_acc_q[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(15),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(15),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[15]_i_1_n_0\
    );
\mclk_phase_acc_q[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(16),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(16),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[16]_i_1_n_0\
    );
\mclk_phase_acc_q[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(17),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(17),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[17]_i_1_n_0\
    );
\mclk_phase_acc_q[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(18),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(18),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[18]_i_1_n_0\
    );
\mclk_phase_acc_q[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(19),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(19),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[19]_i_1_n_0\
    );
\mclk_phase_acc_q[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(20),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(20),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[20]_i_1_n_0\
    );
\mclk_phase_acc_q[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(21),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(21),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[21]_i_1_n_0\
    );
\mclk_phase_acc_q[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(22),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(22),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[22]_i_1_n_0\
    );
\mclk_phase_acc_q[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(23),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(23),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[23]_i_1_n_0\
    );
\mclk_phase_acc_q[24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(24),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(24),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[24]_i_1_n_0\
    );
\mclk_phase_acc_q[25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(25),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(25),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[25]_i_1_n_0\
    );
\mclk_phase_acc_q[26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(26),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(26),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[26]_i_1_n_0\
    );
\mclk_phase_acc_q[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => mclk_phase_acc_q0(27),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => mclk_q_i_3_n_0,
      O => \mclk_phase_acc_q[27]_i_1_n_0\
    );
\mclk_phase_acc_q[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => mclk_phase_acc_q0(28),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => mclk_q_i_3_n_0,
      O => \mclk_phase_acc_q[28]_i_1_n_0\
    );
\mclk_phase_acc_q[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => mclk_phase_acc_q0(29),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => mclk_q_i_3_n_0,
      O => \mclk_phase_acc_q[29]_i_1_n_0\
    );
\mclk_phase_acc_q[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => mclk_phase_acc_q0(30),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => mclk_q_i_3_n_0,
      O => \mclk_phase_acc_q[30]_i_1_n_0\
    );
\mclk_phase_acc_q[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => mclk_phase_acc_q0(31),
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => mclk_q_i_3_n_0,
      O => \mclk_phase_acc_q[31]_i_1_n_0\
    );
\mclk_phase_acc_q[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(8),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(8),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[8]_i_1_n_0\
    );
\mclk_phase_acc_q[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => mclk_phase_acc_q0(9),
      I1 => mclk_q_i_3_n_0,
      I2 => mclk_phase_sum(9),
      I3 => \slv_reg2_reg_n_0_[0]\,
      O => \mclk_phase_acc_q[9]_i_1_n_0\
    );
\mclk_phase_acc_q_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[10]_i_1_n_0\,
      Q => mclk_phase_acc_q(10)
    );
\mclk_phase_acc_q_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[11]_i_1_n_0\,
      Q => mclk_phase_acc_q(11)
    );
\mclk_phase_acc_q_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[12]_i_1_n_0\,
      Q => mclk_phase_acc_q(12)
    );
\mclk_phase_acc_q_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[13]_i_1_n_0\,
      Q => mclk_phase_acc_q(13)
    );
\mclk_phase_acc_q_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[14]_i_1_n_0\,
      Q => mclk_phase_acc_q(14)
    );
\mclk_phase_acc_q_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[15]_i_1_n_0\,
      Q => mclk_phase_acc_q(15)
    );
\mclk_phase_acc_q_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[16]_i_1_n_0\,
      Q => mclk_phase_acc_q(16)
    );
\mclk_phase_acc_q_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[17]_i_1_n_0\,
      Q => mclk_phase_acc_q(17)
    );
\mclk_phase_acc_q_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[18]_i_1_n_0\,
      Q => mclk_phase_acc_q(18)
    );
\mclk_phase_acc_q_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[19]_i_1_n_0\,
      Q => mclk_phase_acc_q(19)
    );
\mclk_phase_acc_q_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[20]_i_1_n_0\,
      Q => mclk_phase_acc_q(20)
    );
\mclk_phase_acc_q_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[21]_i_1_n_0\,
      Q => mclk_phase_acc_q(21)
    );
\mclk_phase_acc_q_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[22]_i_1_n_0\,
      Q => mclk_phase_acc_q(22)
    );
\mclk_phase_acc_q_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[23]_i_1_n_0\,
      Q => mclk_phase_acc_q(23)
    );
\mclk_phase_acc_q_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[24]_i_1_n_0\,
      Q => mclk_phase_acc_q(24)
    );
\mclk_phase_acc_q_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[25]_i_1_n_0\,
      Q => mclk_phase_acc_q(25)
    );
\mclk_phase_acc_q_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[26]_i_1_n_0\,
      Q => mclk_phase_acc_q(26)
    );
\mclk_phase_acc_q_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[27]_i_1_n_0\,
      Q => mclk_phase_acc_q(27)
    );
\mclk_phase_acc_q_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[28]_i_1_n_0\,
      Q => mclk_phase_acc_q(28)
    );
\mclk_phase_acc_q_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[29]_i_1_n_0\,
      Q => mclk_phase_acc_q(29)
    );
\mclk_phase_acc_q_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[30]_i_1_n_0\,
      Q => mclk_phase_acc_q(30)
    );
\mclk_phase_acc_q_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[31]_i_1_n_0\,
      Q => mclk_phase_acc_q(31)
    );
\mclk_phase_acc_q_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[8]_i_1_n_0\,
      Q => mclk_phase_acc_q(8)
    );
\mclk_phase_acc_q_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => \mclk_phase_acc_q[9]_i_1_n_0\,
      Q => mclk_phase_acc_q(9)
    );
mclk_q_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"82"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => mclk_q_i_3_n_0,
      I2 => \^i2s_mclk\,
      O => mclk_q_i_1_n_0
    );
mclk_q_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s00_axi_aresetn,
      O => mclk_q_i_2_n_0
    );
mclk_q_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"001F"
    )
        port map (
      I0 => mclk_phase_sum(25),
      I1 => mclk_q_i_4_n_0,
      I2 => mclk_phase_sum(26),
      I3 => mclk_q_i_5_n_0,
      O => mclk_q_i_3_n_0
    );
mclk_q_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFFAA08"
    )
        port map (
      I0 => mclk_phase_sum(18),
      I1 => mclk_q_i_6_n_0,
      I2 => mclk_q_i_7_n_0,
      I3 => mclk_phase_sum(17),
      I4 => mclk_phase_sum(19),
      I5 => mclk_q_i_8_n_0,
      O => mclk_q_i_4_n_0
    );
mclk_q_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => mclk_phase_sum(31),
      I1 => mclk_phase_sum(27),
      I2 => mclk_phase_sum(29),
      I3 => mclk_phase_sum(30),
      I4 => mclk_phase_sum(28),
      O => mclk_q_i_5_n_0
    );
mclk_q_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => mclk_phase_sum(12),
      I1 => mclk_phase_sum(10),
      I2 => mclk_phase_sum(8),
      I3 => mclk_phase_sum(9),
      I4 => mclk_phase_sum(11),
      O => mclk_q_i_6_n_0
    );
mclk_q_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => mclk_phase_sum(15),
      I1 => mclk_phase_sum(14),
      I2 => mclk_phase_sum(16),
      I3 => mclk_phase_sum(13),
      O => mclk_q_i_7_n_0
    );
mclk_q_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
        port map (
      I0 => mclk_phase_sum(24),
      I1 => mclk_phase_sum(20),
      I2 => mclk_phase_sum(21),
      I3 => mclk_phase_sum(23),
      I4 => mclk_phase_sum(22),
      O => mclk_q_i_8_n_0
    );
mclk_q_reg: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => '1',
      CLR => mclk_q_i_2_n_0,
      D => mclk_q_i_1_n_0,
      Q => \^i2s_mclk\
    );
\sample_left_q_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(0),
      Q => sample_left_q(0)
    );
\sample_left_q_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(10),
      Q => sample_left_q(10)
    );
\sample_left_q_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(11),
      Q => sample_left_q(11)
    );
\sample_left_q_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(12),
      Q => sample_left_q(12)
    );
\sample_left_q_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(13),
      Q => sample_left_q(13)
    );
\sample_left_q_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(14),
      Q => sample_left_q(14)
    );
\sample_left_q_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(15),
      Q => sample_left_q(15)
    );
\sample_left_q_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(16),
      Q => sample_left_q(16)
    );
\sample_left_q_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(17),
      Q => sample_left_q(17)
    );
\sample_left_q_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(18),
      Q => sample_left_q(18)
    );
\sample_left_q_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(19),
      Q => sample_left_q(19)
    );
\sample_left_q_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(1),
      Q => sample_left_q(1)
    );
\sample_left_q_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(20),
      Q => sample_left_q(20)
    );
\sample_left_q_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(21),
      Q => sample_left_q(21)
    );
\sample_left_q_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(22),
      Q => sample_left_q(22)
    );
\sample_left_q_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(23),
      Q => sample_left_q(23)
    );
\sample_left_q_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(24),
      Q => sample_left_q(24)
    );
\sample_left_q_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(25),
      Q => sample_left_q(25)
    );
\sample_left_q_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(26),
      Q => sample_left_q(26)
    );
\sample_left_q_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(27),
      Q => sample_left_q(27)
    );
\sample_left_q_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(28),
      Q => sample_left_q(28)
    );
\sample_left_q_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(29),
      Q => sample_left_q(29)
    );
\sample_left_q_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(2),
      Q => sample_left_q(2)
    );
\sample_left_q_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(30),
      Q => sample_left_q(30)
    );
\sample_left_q_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(31),
      Q => sample_left_q(31)
    );
\sample_left_q_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(3),
      Q => sample_left_q(3)
    );
\sample_left_q_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(4),
      Q => sample_left_q(4)
    );
\sample_left_q_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(5),
      Q => sample_left_q(5)
    );
\sample_left_q_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(6),
      Q => sample_left_q(6)
    );
\sample_left_q_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(7),
      Q => sample_left_q(7)
    );
\sample_left_q_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(8),
      Q => sample_left_q(8)
    );
\sample_left_q_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg0(9),
      Q => sample_left_q(9)
    );
\sample_right_q[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000400"
    )
        port map (
      I0 => \^bclk_q_reg_0\,
      I1 => \slv_reg2_reg_n_0_[0]\,
      I2 => p_0_in2_in,
      I3 => data_q_i_4_n_0,
      I4 => bclk_q_i_2_n_0,
      O => sample_left_q_0(0)
    );
\sample_right_q_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(0),
      Q => sample_right_q(0)
    );
\sample_right_q_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(10),
      Q => sample_right_q(10)
    );
\sample_right_q_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(11),
      Q => sample_right_q(11)
    );
\sample_right_q_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(12),
      Q => sample_right_q(12)
    );
\sample_right_q_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(13),
      Q => sample_right_q(13)
    );
\sample_right_q_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(14),
      Q => sample_right_q(14)
    );
\sample_right_q_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(15),
      Q => sample_right_q(15)
    );
\sample_right_q_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(16),
      Q => sample_right_q(16)
    );
\sample_right_q_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(17),
      Q => sample_right_q(17)
    );
\sample_right_q_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(18),
      Q => sample_right_q(18)
    );
\sample_right_q_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(19),
      Q => sample_right_q(19)
    );
\sample_right_q_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(1),
      Q => sample_right_q(1)
    );
\sample_right_q_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(20),
      Q => sample_right_q(20)
    );
\sample_right_q_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(21),
      Q => sample_right_q(21)
    );
\sample_right_q_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(22),
      Q => sample_right_q(22)
    );
\sample_right_q_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(23),
      Q => sample_right_q(23)
    );
\sample_right_q_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(24),
      Q => sample_right_q(24)
    );
\sample_right_q_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(25),
      Q => sample_right_q(25)
    );
\sample_right_q_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(26),
      Q => sample_right_q(26)
    );
\sample_right_q_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(27),
      Q => sample_right_q(27)
    );
\sample_right_q_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(28),
      Q => sample_right_q(28)
    );
\sample_right_q_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(29),
      Q => sample_right_q(29)
    );
\sample_right_q_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(2),
      Q => sample_right_q(2)
    );
\sample_right_q_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(30),
      Q => sample_right_q(30)
    );
\sample_right_q_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(31),
      Q => sample_right_q(31)
    );
\sample_right_q_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(3),
      Q => sample_right_q(3)
    );
\sample_right_q_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(4),
      Q => sample_right_q(4)
    );
\sample_right_q_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(5),
      Q => sample_right_q(5)
    );
\sample_right_q_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(6),
      Q => sample_right_q(6)
    );
\sample_right_q_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(7),
      Q => sample_right_q(7)
    );
\sample_right_q_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(8),
      Q => sample_right_q(8)
    );
\sample_right_q_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => sample_left_q_0(0),
      CLR => mclk_q_i_2_n_0,
      D => slv_reg1(9),
      Q => sample_right_q(9)
    );
\slv_reg0[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => write_addr(0),
      I1 => s00_axi_wstrb(1),
      I2 => \slv_reg1[31]_i_2_n_0\,
      O => \slv_reg0[15]_i_1_n_0\
    );
\slv_reg0[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => write_addr(0),
      I1 => s00_axi_wstrb(2),
      I2 => \slv_reg1[31]_i_2_n_0\,
      O => \slv_reg0[23]_i_1_n_0\
    );
\slv_reg0[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => write_addr(0),
      I1 => s00_axi_wstrb(3),
      I2 => \slv_reg1[31]_i_2_n_0\,
      O => \slv_reg0[31]_i_1_n_0\
    );
\slv_reg0[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => write_addr(0),
      I1 => s00_axi_wstrb(0),
      I2 => \slv_reg1[31]_i_2_n_0\,
      O => \slv_reg0[7]_i_1_n_0\
    );
\slv_reg0_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg0(0),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg0(10),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg0(11),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg0(12),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg0(13),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg0(14),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg0(15),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg0(16),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg0(17),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg0(18),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg0(19),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg0(1),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg0(20),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg0(21),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg0(22),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg0(23),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg0(24),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg0(25),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg0(26),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg0(27),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg0(28),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg0(29),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg0(2),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg0(30),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg0(31),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg0(3),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg0(4),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg0(5),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg0(6),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg0(7),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg0(8),
      R => mclk_q_i_2_n_0
    );
\slv_reg0_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg0(9),
      R => mclk_q_i_2_n_0
    );
\slv_reg1[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg1[31]_i_2_n_0\,
      I1 => s00_axi_wstrb(1),
      I2 => write_addr(0),
      O => \slv_reg1[15]_i_1_n_0\
    );
\slv_reg1[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg1[31]_i_2_n_0\,
      I1 => s00_axi_wstrb(2),
      I2 => write_addr(0),
      O => \slv_reg1[23]_i_1_n_0\
    );
\slv_reg1[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg1[31]_i_2_n_0\,
      I1 => s00_axi_wstrb(3),
      I2 => write_addr(0),
      O => \slv_reg1[31]_i_1_n_0\
    );
\slv_reg1[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => \^s_axi_awready\,
      I2 => s00_axi_wvalid,
      I3 => s00_axi_awvalid,
      I4 => write_addr(1),
      O => \slv_reg1[31]_i_2_n_0\
    );
\slv_reg1[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg1[31]_i_2_n_0\,
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(0),
      O => \slv_reg1[7]_i_1_n_0\
    );
\slv_reg1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg1(0),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg1(10),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg1(11),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg1(12),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg1(13),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg1(14),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg1(15),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg1(16),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg1(17),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg1(18),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg1(19),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg1(1),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg1(20),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg1(21),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg1(22),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg1(23),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg1(24),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg1(25),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg1(26),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg1(27),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg1(28),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg1(29),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg1(2),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg1(30),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg1(31),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg1(3),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg1(4),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg1(5),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg1(6),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg1(7),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg1(8),
      R => mclk_q_i_2_n_0
    );
\slv_reg1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg1(9),
      R => mclk_q_i_2_n_0
    );
\slv_reg2[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(1),
      O => p_1_in(15)
    );
\slv_reg2[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(2),
      O => p_1_in(23)
    );
\slv_reg2[23]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => write_addr(1),
      I1 => \^s_axi_wready\,
      I2 => \^s_axi_awready\,
      I3 => s00_axi_wvalid,
      I4 => s00_axi_awvalid,
      O => \slv_reg2[23]_i_2_n_0\
    );
\slv_reg2[24]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFFF2000"
    )
        port map (
      I0 => s00_axi_wdata(24),
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(3),
      I3 => \slv_reg2[23]_i_2_n_0\,
      I4 => sel0(17),
      O => \slv_reg2[24]_i_1_n_0\
    );
\slv_reg2[25]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFFF2000"
    )
        port map (
      I0 => s00_axi_wdata(25),
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(3),
      I3 => \slv_reg2[23]_i_2_n_0\,
      I4 => sel0(18),
      O => \slv_reg2[25]_i_1_n_0\
    );
\slv_reg2[26]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFFF2000"
    )
        port map (
      I0 => s00_axi_wdata(26),
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(3),
      I3 => \slv_reg2[23]_i_2_n_0\,
      I4 => sel0(19),
      O => \slv_reg2[26]_i_1_n_0\
    );
\slv_reg2[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(0),
      O => p_1_in(7)
    );
\slv_reg2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(0),
      Q => \slv_reg2_reg_n_0_[0]\,
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(10),
      Q => sel0(3),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(11),
      Q => sel0(4),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(12),
      Q => sel0(5),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(13),
      Q => sel0(6),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[14]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(14),
      Q => sel0(7),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[15]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(15),
      Q => sel0(8),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(16),
      Q => sel0(9),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(17),
      Q => sel0(10),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(18),
      Q => sel0(11),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[19]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(19),
      Q => sel0(12),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(1),
      Q => mute_sync,
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[20]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(20),
      Q => sel0(13),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(21),
      Q => sel0(14),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[22]\: unisim.vcomponents.FDSE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(22),
      Q => sel0(15),
      S => mclk_q_i_2_n_0
    );
\slv_reg2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(23),
      D => s00_axi_wdata(23),
      Q => sel0(16),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \slv_reg2[24]_i_1_n_0\,
      Q => sel0(17),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \slv_reg2[25]_i_1_n_0\,
      Q => sel0(18),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => '1',
      D => \slv_reg2[26]_i_1_n_0\,
      Q => sel0(19),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(2),
      Q => sample_width_raw(0),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(3),
      Q => sample_width_raw(1),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(4),
      Q => sample_width_raw(2),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(5),
      Q => sample_width_raw(3),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(6),
      Q => sample_width_raw(4),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(7),
      D => s00_axi_wdata(7),
      Q => sel0(0),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(8),
      Q => sel0(1),
      R => mclk_q_i_2_n_0
    );
\slv_reg2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => p_1_in(15),
      D => s00_axi_wdata(9),
      Q => sel0(2),
      R => mclk_q_i_2_n_0
    );
\slv_reg3[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => s00_axi_wstrb(1),
      I2 => write_addr(0),
      O => \slv_reg3[15]_i_1_n_0\
    );
\slv_reg3[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => s00_axi_wstrb(2),
      I2 => write_addr(0),
      O => \slv_reg3[23]_i_1_n_0\
    );
\slv_reg3[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => s00_axi_wstrb(3),
      I2 => write_addr(0),
      O => \slv_reg3[31]_i_1_n_0\
    );
\slv_reg3[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \slv_reg2[23]_i_2_n_0\,
      I1 => write_addr(0),
      I2 => s00_axi_wstrb(0),
      O => \slv_reg3[7]_i_1_n_0\
    );
\slv_reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg3(10),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg3(11),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg3(12),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg3(13),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg3(14),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg3(15),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg3(16),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg3(17),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg3(18),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg3(19),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg3(1),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg3(20),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg3(21),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg3(22),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg3(23),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg3(24),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg3(25),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg3(26),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg3(27),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg3(28),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg3(29),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg3(2),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg3(30),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg3(31),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg3(3),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg3(4),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg3(5),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg3(6),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg3(7),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg3(8),
      R => mclk_q_i_2_n_0
    );
\slv_reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => audio_clk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg3(9),
      R => mclk_q_i_2_n_0
    );
slv_reg_rden: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s00_axi_rvalid\,
      I2 => \^s_axi_arready\,
      O => \slv_reg_rden__0\
    );
ws_q_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4F"
    )
        port map (
      I0 => bclk_q_i_2_n_0,
      I1 => \^bclk_q_reg_0\,
      I2 => \slv_reg2_reg_n_0_[0]\,
      O => data_q
    );
ws_q_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \slv_reg2_reg_n_0_[0]\,
      I1 => p_0_in2_in,
      O => ws_q
    );
ws_q_reg: unisim.vcomponents.FDCE
     port map (
      C => audio_clk,
      CE => data_q,
      CLR => mclk_q_i_2_n_0,
      D => ws_q,
      Q => i2s_ws
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s is
  port (
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    i2s_ws : out STD_LOGIC;
    i2s_data : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bclk_q_reg : out STD_LOGIC;
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    i2s_mclk : out STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    audio_clk : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s is
begin
i2s_slave_lite_v1_0_S00_AXI_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s_slave_lite_v1_0_S00_AXI
     port map (
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WREADY => S_AXI_WREADY,
      audio_clk => audio_clk,
      bclk_q_reg_0 => bclk_q_reg,
      i2s_data => i2s_data,
      i2s_mclk => i2s_mclk,
      i2s_ws => i2s_ws,
      s00_axi_araddr(1 downto 0) => s00_axi_araddr(1 downto 0),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(1 downto 0) => s00_axi_awaddr(1 downto 0),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    audio_clk : in STD_LOGIC;
    i2s_mclk : out STD_LOGIC;
    i2s_bclk : out STD_LOGIC;
    i2s_ws : out STD_LOGIC;
    i2s_data : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "design_1_i2s_0_2,i2s,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "i2s,Vivado 2025.2";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const0>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of audio_clk : signal is "xilinx.com:signal:clock:1.0 audio_clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of audio_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of audio_clk : signal is "XIL_INTERFACENAME audio_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK";
  attribute X_INTERFACE_MODE of s00_axi_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_aclk : signal is "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S00_AXI_RST RST";
  attribute X_INTERFACE_MODE of s00_axi_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_aresetn : signal is "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  attribute X_INTERFACE_INFO of s00_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  attribute X_INTERFACE_INFO of s00_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  attribute X_INTERFACE_INFO of s00_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  attribute X_INTERFACE_INFO of s00_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  attribute X_INTERFACE_INFO of s00_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  attribute X_INTERFACE_INFO of s00_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  attribute X_INTERFACE_INFO of s00_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  attribute X_INTERFACE_INFO of s00_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  attribute X_INTERFACE_INFO of s00_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  attribute X_INTERFACE_INFO of s00_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  attribute X_INTERFACE_INFO of s00_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  attribute X_INTERFACE_INFO of s00_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  attribute X_INTERFACE_MODE of s00_axi_awaddr : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_awaddr : signal is "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  attribute X_INTERFACE_INFO of s00_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  attribute X_INTERFACE_INFO of s00_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  attribute X_INTERFACE_INFO of s00_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  attribute X_INTERFACE_INFO of s00_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  attribute X_INTERFACE_INFO of s00_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
begin
  s00_axi_bresp(1) <= \<const0>\;
  s00_axi_bresp(0) <= \<const0>\;
  s00_axi_rresp(1) <= \<const0>\;
  s00_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_i2s
     port map (
      S_AXI_ARREADY => s00_axi_arready,
      S_AXI_AWREADY => s00_axi_awready,
      S_AXI_WREADY => s00_axi_wready,
      audio_clk => audio_clk,
      bclk_q_reg => i2s_bclk,
      i2s_data => i2s_data,
      i2s_mclk => i2s_mclk,
      i2s_ws => i2s_ws,
      s00_axi_araddr(1 downto 0) => s00_axi_araddr(3 downto 2),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(1 downto 0) => s00_axi_awaddr(3 downto 2),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid
    );
end STRUCTURE;
