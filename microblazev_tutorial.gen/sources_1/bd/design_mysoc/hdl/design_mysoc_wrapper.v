//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Tue Feb 24 02:25:31 2026
//Host        : DESKTOP-HTVV1N1 running 64-bit major release  (build 9200)
//Command     : generate_target design_mysoc_wrapper.bd
//Design      : design_mysoc_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_mysoc_wrapper
   (an_0,
    dip_switches_16bits_tri_i,
    dp_0,
    led_16bits_tri_o,
    reset,
    seg_0,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  output [3:0]an_0;
  input [15:0]dip_switches_16bits_tri_i;
  output dp_0;
  output [15:0]led_16bits_tri_o;
  input reset;
  output [6:0]seg_0;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [3:0]an_0;
  wire [15:0]dip_switches_16bits_tri_i;
  wire dp_0;
  wire [15:0]led_16bits_tri_o;
  wire reset;
  wire [6:0]seg_0;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  design_mysoc design_mysoc_i
       (.an_0(an_0),
        .dip_switches_16bits_tri_i(dip_switches_16bits_tri_i),
        .dp_0(dp_0),
        .led_16bits_tri_o(led_16bits_tri_o),
        .reset(reset),
        .seg_0(seg_0),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
