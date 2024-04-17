// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
//
//  EMIO GPIO Settings:
//    0-8   : gpio_hdr
//    9-21  : Reserved
//    22-29 : AD9361 CTRL_OUT (gpio_status_0) (In)
//    30-37 : AD9361 (2) CTRL_OUT (gpio_status_1) (In)
//    38-41 : AD9361 CTRL_IN (gpio_ctl_0) (Out)
//    42-45 : AD9361 (2) CTRL_IN (gpio_ctl_1) (Out)
//    46-50 : Reserved
//    51    : AD9361 Sync (Out)
//    52    : AD9361 Resetb (Out)
//    53    : AD9361 EN AGC (Out)
//    54    : UP Enable (Out)
//    55    : UP TXnRX (Out)
//    56    : AD9361 (2) EN AGC (Out)
//    57    : UP Enable (2) (Out)
//    58    : UP TXnRX (2) (Out)
//    59-64 : Reserved
//    65    : AD9361 (2) Resetb (Out)
//    66-94 : Reserved

`timescale 1ns/100ps

module system_top (

  // ADI Master
  input         rx_clk_in_0_p,
  input         rx_clk_in_0_n,
  input         rx_frame_in_0_p,
  input         rx_frame_in_0_n,
  input [ 5:0]  rx_data_in_0_p,
  input [ 5:0]  rx_data_in_0_n,
  output        tx_clk_out_0_p,
  output        tx_clk_out_0_n,
  output        tx_frame_out_0_p,
  output        tx_frame_out_0_n,
  output [ 5:0] tx_data_out_0_p,
  output [ 5:0] tx_data_out_0_n,

  output        enable_0,
  output        txnrx_0,

  output        gpio_resetb_0,
  output reg    mcs_sync,
  output        gpio_en_agc_0,
  output [ 3:0] gpio_ctl_0,
  input  [ 7:0] gpio_status_0,

  output        ad_clk_out_0,
  input  [ 3:0] ad_rfic_gpo_0,
  input         ad_clk_ref,

  // ADI Slave
  input         rx_clk_in_1_p,
  input         rx_clk_in_1_n,
  input         rx_frame_in_1_p,
  input         rx_frame_in_1_n,
  input [ 5:0]  rx_data_in_1_p,
  input [ 5:0]  rx_data_in_1_n,
  output        tx_clk_out_1_p,
  output        tx_clk_out_1_n,
  output        tx_frame_out_1_p,
  output        tx_frame_out_1_n,
  output [ 5:0] tx_data_out_1_p,
  output [ 5:0] tx_data_out_1_n,

  output        enable_1,
  output        txnrx_1,

  output        gpio_resetb_1,
  output        gpio_en_agc_1,
  output [ 3:0] gpio_ctl_1,
  input  [ 7:0] gpio_status_1,

  output        ad_clk_out_1,
  input  [ 3:0] ad_rfic_gpo_1,

  /*
  // PCIE
  input  [ 3:0] pcie_rx_p,
  input  [ 3:0] pcie_rx_n,
  output [ 3:0] pcie_tx_p,
  output [ 3:0] pcie_tx_n,

  output        pcie_rst,
  */

  // Accessory
  inout  [ 8:0] gpio_hdr
);

  genvar i;

  wire [94:0] gpio_i;
  wire [94:0] gpio_o;
  wire [94:0] gpio_t;

  wire        gpio_enable_0;
  wire        gpio_enable_1;
  wire        gpio_txnrx_0;
  wire        gpio_txnrx_1;

  // internal registers
  reg     [  2:0] mcs_sync_m = 'd0;

  // internal signals
  wire            sys_100m_resetn;
  wire            gpio_sync;

  // multi-chip sync
  always @(posedge ad_clk_ref or negedge sys_100m_resetn) begin
    if (sys_100m_resetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_sync};
      mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  generate for (i = 0; i < 9; i = i + 1)
    begin
      assign gpio_hdr[i] = gpio_t[i] ? 1'bz : gpio_o[i];
      assign gpio_i[i] = gpio_hdr[i];
    end
  endgenerate

  assign gpio_resetb_1 = gpio_o[65];
  assign gpio_txnrx_1  = gpio_o[58];
  assign gpio_enable_1 = gpio_o[57];
  assign gpio_en_agc_1 = gpio_o[56];
  assign gpio_txnrx_0  = gpio_o[55];
  assign gpio_enable_0 = gpio_o[54];
  assign gpio_en_agc_0 = gpio_o[53];
  assign gpio_resetb_0 = gpio_o[52];
  assign gpio_sync = gpio_o[51];
  assign gpio_ctl_1 = gpio_o[45:42];
  assign gpio_ctl_0 = gpio_o[41:38];
  assign gpio_i[29:22] = gpio_status_0;
  assign gpio_i[37:30] = gpio_status_1;

  assign gpio_i[21:9] = gpio_o[21:9];
  assign gpio_i[94:38] = gpio_o[94:38];

  assign ad_clk_out_0 = 'd0;
  assign ad_clk_out_1 = 'd0;
  /*
  assign pcie_tx_p = 'd0;
  assign pcie_tx_n = 'd0;
  assign pcie_rst  = 'd0;
  */
  system_wrapper i_system_wrapper (
       .gpio_i (gpio_i),
       .gpio_o (gpio_o),
       .gpio_t(gpio_t),
    .rx_clk_in_0_n (rx_clk_in_0_n),
    .rx_clk_in_0_p (rx_clk_in_0_p),
    .rx_clk_in_1_n (rx_clk_in_1_n),
    .rx_clk_in_1_p (rx_clk_in_1_p),
    .rx_data_in_0_n (rx_data_in_0_n),
    .rx_data_in_0_p (rx_data_in_0_p),
    .rx_data_in_1_n (rx_data_in_1_n),
    .rx_data_in_1_p (rx_data_in_1_p),
    .rx_frame_in_0_n (rx_frame_in_0_n),
    .rx_frame_in_0_p (rx_frame_in_0_p),
    .rx_frame_in_1_n (rx_frame_in_1_n),
    .rx_frame_in_1_p (rx_frame_in_1_p),
    .sys_100m_resetn (sys_100m_resetn),
    .tx_clk_out_0_n (tx_clk_out_0_n),
    .tx_clk_out_0_p (tx_clk_out_0_p),
    .tx_clk_out_1_n (tx_clk_out_1_n),
    .tx_clk_out_1_p (tx_clk_out_1_p),
    .tx_data_out_0_n (tx_data_out_0_n),
    .tx_data_out_0_p (tx_data_out_0_p),
    .tx_data_out_1_n (tx_data_out_1_n),
    .tx_data_out_1_p (tx_data_out_1_p),
    .tx_frame_out_0_n (tx_frame_out_0_n),
    .tx_frame_out_0_p (tx_frame_out_0_p),
    .tx_frame_out_1_n (tx_frame_out_1_n),
    .tx_frame_out_1_p (tx_frame_out_1_p),
    .txnrx_0 (txnrx_0),
    .enable_0 (enable_0),
    .up_enable_0 (gpio_enable_0),
    .up_txnrx_0 (gpio_txnrx_0),
    .txnrx_1 (txnrx_1),
    .enable_1 (enable_1),
    .up_enable_1 (gpio_enable_1),
    .up_txnrx_1 (gpio_txnrx_1));

endmodule

// ***************************************************************************
// ***************************************************************************
