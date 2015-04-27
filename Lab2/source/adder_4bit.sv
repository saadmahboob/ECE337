// $Id: $
// File name:   adder_4bit.sv
// Created:     1/27/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 4 bit adder 
module adder_4bit
(
  input wire [3:0] a,
  input wire [3:0] b,
  input wire carry_in,
  output wire [3:0] sum,
  output wire overflow  
);
wire [4:0] carry_flags;
genvar i;
assign carry_flags[0] = carry_in;

generate
  for(i = 0; i <= 3; i = i + 1)
  begin
    adder_1bit IX ( .a(a[i]), .b(b[i]), .carry_in(carry_flags[i]), .sum(sum[i]), .carry_out(carry_flags[i+1]));
  end
endgenerate

assign overflow = carry_flags[4]; 


endmodule