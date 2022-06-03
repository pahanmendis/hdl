// ***************************************************************************
// ***************************************************************************
// Copyright 2022 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module system_top (

  inout   [14:0]   ddr_addr,
  inout   [ 2:0]   ddr_ba,
  inout            ddr_cas_n,
  inout            ddr_ck_n,
  inout            ddr_ck_p,
  inout            ddr_cke,
  inout            ddr_cs_n,
  inout   [ 3:0]   ddr_dm,
  inout   [31:0]   ddr_dq,
  inout   [ 3:0]   ddr_dqs_n,
  inout   [ 3:0]   ddr_dqs_p,
  inout            ddr_odt,
  inout            ddr_ras_n,
  inout            ddr_reset_n,
  inout            ddr_we_n,

  inout            fixed_io_ddr_vrn,
  inout            fixed_io_ddr_vrp,
  inout   [53:0]   fixed_io_mio,
  inout            fixed_io_ps_clk,
  inout            fixed_io_ps_porb,
  inout            fixed_io_ps_srstb,

  inout   [14:0]   gpio_bd,

  output           hdmi_out_clk,
  output           hdmi_vsync,
  output           hdmi_hsync,
  output           hdmi_data_e,
  output  [23:0]   hdmi_data,

  output           spdif,

  inout            iic_scl,
  inout            iic_sda,

  // m2k fmc specific

  inout   [15:0]   data_bd,
  inout   [ 1:0]   trigger_bd,

  input            rx_clk,
  input            rxiq,
  input   [11:0]   rxd,
  input            tx_clk,
  output           txiq,
  output  [11:0]   txd,

  output           ad9963_resetn,
  output           ad9963_csn,
  output           adf4360_cs,
  output           spi_clk,
  inout            spi_sdio,

  inout            iic_m2k_fmc_sda,
  inout            iic_m2k_fmc_scl
);

  // internal signals

  wire    [63:0]   gpio_i;
  wire    [63:0]   gpio_o;
  wire    [63:0]   gpio_t;

  wire    [15:0]   data_i;
  wire    [15:0]   data_o;
  wire    [15:0]   data_t;

  wire    [ 1:0]   trigger_i;
  wire    [ 1:0]   trigger_o;
  wire    [ 1:0]   trigger_t;

  wire    [ 1:0]   spi0_csn;
  wire             spi0_clk;
  wire             spi0_mosi;
  wire             spi0_miso;

  // m2k fmc specific
  // chose the first available gpio
  assign ad9963_resetn = gpio_o[32];

  assign ad9963_csn = spi0_csn[0];
  assign adf4360_cs = spi0_csn[1];
  assign spi_clk = spi0_clk;
  assign spi_mosi = spi0_mosi;
  assign spi0_miso = spi_miso;

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_gpio_bd (
    .dio_t (gpio_t[14:0]),
    .dio_i (gpio_o[14:0]),
    .dio_o (gpio_i[14:0]),
    .dio_p (gpio_bd));

  assign gpio_i[63:15] = gpio_o[63:15];

  // m2k fmc specific

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_trigger_bd (
    .dio_t (trigger_t),
    .dio_i (trigger_o),
    .dio_o (trigger_i),
    .dio_p (trigger_bd));

  m2k_spi i_m2k_spi (
    .ad9963_csn (ad9963_csn),
    .adf4360_cs (adf4360_cs),
    .spi_clk (spi_clk),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .spi_sdio (spi_sdio));

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .hdmi_data (hdmi_data),
    .hdmi_data_e (hdmi_data_e),
    .hdmi_hsync (hdmi_hsync),
    .hdmi_out_clk (hdmi_out_clk),
    .hdmi_vsync (hdmi_vsync),
    .iic_main_scl_io (iic_scl),
    .iic_main_sda_io (iic_sda),

    .iic_m2k_fmc_sda_io (iic_m2k_fmc_sda),
    .iic_m2k_fmc_scl_io (iic_m2k_fmc_scl),
    .data_i (data_i),
    .data_o (data_o),
    .data_t (data_t),
    .trigger_i (trigger_i),
    .trigger_o (trigger_o),
    .trigger_t (trigger_t),
    .rx_clk (rx_clk),
    .rxiq (rxiq),
    .rxd (rxd),
    .tx_clk (tx_clk),
    .txiq (txiq),
    .txd (txd),
    .spi0_clk_i (spi0_clk),
    .spi0_clk_o (spi0_clk),
    .spi0_csn_0_o (spi0_csn[0]),
    .spi0_csn_1_o (spi0_csn[1]),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi0_miso),
    .spi0_sdo_i (spi0_mosi),
    .spi0_sdo_o (spi0_mosi),

    .spdif (spdif),

    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o());

endmodule
