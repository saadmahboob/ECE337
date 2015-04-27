// $Id: $
// File name:   adder_1bit.sv
// Created:     1/27/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: postlab prob1
module adder_1bit
  
(
  input wire a,
  input wire b,
  input wire carry_in,
  output wire sum,
  output wire carry_out

);

assign sum = carry_in ^ (a ^ b);
assign carry_out = ((~ carry_in) & b & a) | (carry_in & (b | a));

endmodule