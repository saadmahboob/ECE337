// $Id: $
// File name:   adder_nbits.sv
// Created:     1/27/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: n bit adder
module adder_nbit 
#(
parameter BIT_WIDTH = 4
)
(
  input wire [(BIT_WIDTH - 1):0] a,
  input wire [(BIT_WIDTH - 1):0] b,
  input wire carry_in,
  output wire [(BIT_WIDTH - 1):0] sum,
  output wire overflow  
);
wire [(BIT_WIDTH):0] carry_flags;
genvar i;
assign carry_flags[0] = carry_in;

generate
  for(i = 0; i <= (BIT_WIDTH - 1); i = i + 1)
  begin
    
    always @ (a, b, carry_in)
    begin
      assert((a[i] == 1'b1) || (a[i] == 1'b0))
      else $error("Input 'a[i]' of component is not a digital logic value ");
    
      assert((b[i] == 1'b1) || (b[i] == 1'b0))
      else $error("Input 'b[i]' of component is not a digital logic value ");
    
      assert((carry_in == 1'b1) || (carry_in == 1'b0))
      else $error("Input 'carry_in' of component is not a digital logic value ");
    end
    
    adder_1bit IX ( .a(a[i]), .b(b[i]), .carry_in(carry_flags[i]), .sum(sum[i]), .carry_out(carry_flags[i+1]));
    
  end
endgenerate

assign overflow = carry_flags[(BIT_WIDTH)]; 


endmodule