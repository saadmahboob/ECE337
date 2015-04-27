// $Id: $
// File name:   adder_16bit.sv
// Created:     1/29/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 16 bit adder
module adder_16bit
(
  input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

  genvar i;
  generate
    for(i = 0; i <= (15); i = i + 1)
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
      
    end
  endgenerate

	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be an 8-bit ripple carry adder design
	adder_nbit #(16) A1 ( .a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));  



endmodule
