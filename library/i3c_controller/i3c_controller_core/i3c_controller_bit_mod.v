// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
`default_nettype wire
`include "i3c_controller_bit_mod_cmd.v"

module i3c_controller_bit_mod (
  input reset_n,
  input clk,   // 100 MHz

  // Bit Modulation Command

  input  [`MOD_BIT_CMD_WIDTH:0] cmd,
  input  cmd_valid,
  output cmd_ready,
  // Indicates that the bus is not transfering,
  // is different from bus idle because does not wait 200us after Stop.
  output cmd_nop,
  // 0: 12.50MHz
  // 1:  6.25MHz
  // 2:  3.12MHz
  // 3:  1.56MHz
  input [1:0] scl_pp_sg, // SCL Push-pull speed grade

  output reg rx,
  output reg rx_raw,
  output reg rx_valid,


  // Bus drive signals

  output reg sdo,
  output scl,
  input  sdi,
  output t
);

  reg [`MOD_BIT_CMD_WIDTH:0] cmd_r;
  reg [1:0] pp_sg;
  reg [5:0] count; // Worst-case: 1.56MHz, 32-bits per half-bit.
  reg transfer;
  reg sr;

  reg scl_high_reg;
  wire scl_high = count[pp_sg+2];
  wire sdo_w;
  wire t_w;

  wire scl_end;
  wire [3:0] scl_end_multi;
  genvar i;
  for (i = 0; i < 4; i = i+1) begin
    assign scl_end_multi[i] = &count[i+2:0];
  end
  assign scl_end = scl_end_multi[pp_sg];

  assign cmd_ready = (scl_end | !transfer) & reset_n;

  wire [1:0] st = cmd_r[1:0];
  wire [`MOD_BIT_CMD_WIDTH:2] sm = cmd_r[`MOD_BIT_CMD_WIDTH:2];

  always @(posedge clk) begin
    if (!reset_n) begin
      cmd_r <= {`MOD_BIT_CMD_NOP_, 2'b01};
      pp_sg <= 2'b11;
    end else begin
      if (cmd_ready) begin
        if (cmd_valid) begin
          cmd_r <= cmd;
          pp_sg <= cmd[1] ? scl_pp_sg : 2'b11;
        end else begin
          cmd_r <= {`MOD_BIT_CMD_NOP_, 2'b01};
        end
      end
    end
  end

  always @(posedge clk) begin
    count <= 0;
    if (!reset_n) begin
      transfer <= 1'b0;
      sr <= 1'b0;
    end else begin
      if (cmd_valid) begin
        transfer <= 1'b1;
      end else if (scl_end) begin
        transfer <= 1'b0;
      end
      if (transfer & ~scl_end) begin
        count <= count + 1;
      end

      if (scl_end) begin
        sr <= cmd_valid & sm != `MOD_BIT_CMD_NOP_ ? 1'b1 : 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    scl_high_reg <= scl_high;
    rx_valid  <= 1'b0;
    sdo <= sdo_w;
    rx_raw <= sdi;
    if (~scl_high_reg & scl_high) begin
      rx <= sdi; // Multi-cycle-path worst-case: 4 clks (12.5MHz, half-bit ack)
      rx_valid <= 1'b1;
    end
  end

  assign sdo_w = sm == `MOD_BIT_CMD_START_   ? (scl_high ? ~count[pp_sg+1] : 1'b1) :
                 sm == `MOD_BIT_CMD_STOP_    ? (scl_high ?  count[pp_sg+1] : 1'b0) :
                 sm == `MOD_BIT_CMD_WRITE_   ? st[0] :
                 sm == `MOD_BIT_CMD_ACK_SDR_ ? (scl_high ? rx   : 1'b1) :
                 sm == `MOD_BIT_CMD_ACK_IBI_ ? (scl_high ? 1'b1 : 1'b0) :
                 1'b1;

  // Gets optimized to
  assign t_w = sm[4] ? 1'b0 : st[1];
  //assign t_w = sm == `MOD_BIT_CMD_STOP_    ? 1'b0 :
  //             sm == `MOD_BIT_CMD_START_   ? 1'b0 :
  //             sm == `MOD_BIT_CMD_READ_    ? 1'b0 :
  //             sm == `MOD_BIT_CMD_ACK_SDR_ ? 1'b0 :
  //             st[1];
  assign t = ~t_w & sdo ? 1'b1 : 1'b0;

  assign scl = sm == `MOD_BIT_CMD_START_ ? (sr ? scl_high : 1'b1) :
               sm == `MOD_BIT_CMD_NOP_   ? 1'b1 :
               scl_high;

  assign cmd_nop = sm == `MOD_BIT_CMD_NOP_;
endmodule
