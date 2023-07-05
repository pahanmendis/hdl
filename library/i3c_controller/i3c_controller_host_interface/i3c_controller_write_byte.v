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
/**
 * Packs u8 stream into u32.
 * Restrictions:
 * Length must be > 0
 * At partial payload, e.g. 3-bytes, the remaining byte value is unknown.
 */

`timescale 1ns/100ps
`default_nettype none

module i3c_controller_write_byte (
  input  wire clk,
  input  wire reset_n,

  input  wire u32_ready,
  output wire u32_valid,
  output wire [31:0] u32,

  output wire u8_len_ready,
  input  wire u8_len_valid,
  input  wire [11:0] u8_len,
  output reg  [11:0] u8_lvl,

  output wire u8_ready,
  input  wire u8_valid,
  input  wire [7:0] u8
);
  reg [1:0] sm;
  localparam [1:0]
    idle     = 0,
    transfer = 1,
    move     = 2;

  reg [7:0] u32_reg [3:0];
  reg [1:0] c;

  always @(posedge clk) begin
    if (!reset_n) begin
      sm <= idle;
      c <= 2'b00;
    end else begin
      case (sm)
        idle: begin
          if (u8_len_valid) begin
            u8_lvl <= u8_len;
          end
          sm <= u8_len_valid & u8_len != 0 & u32_ready ? transfer : idle;
          c <= 2'b00;
        end
        transfer: begin
          if (u8_valid) begin // tick
            u32_reg[c] <= u8;
            u8_lvl <= u8_lvl - 12'b1;
            c <= c + 1;
            if (c == 2'b11 | u8_lvl == 12'd1) begin
              sm <= move;
            end
          end
        end
        move: begin
          sm <= u32_ready ? (~|u8_lvl ? idle : transfer) : sm;
        end
        default: begin
          sm <= idle;
        end
      endcase
    end
  end

  assign u8_len_ready = sm == idle;
  assign u8_ready = (sm == transfer & |u8_lvl);
  assign u32_valid = sm == move;
  genvar i;
  for (i=0; i<4; i=i+1) begin
    assign u32[8*i+7:8*i] = u32_reg[3-i];
  end
endmodule