// File name:   adder_16.sv
// Created:     1/19/2015
// Author:      Tim Pritchett
// Version:     1.0  Initial Design Entry
// Description: 16 bit adder design wrapper for synthesis optimization seciton of Lab 2

module adder_16
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	// Utilize and scale a 16-bit wide instance of a Carry-Look-Ahead Adder
	scalable_cla_addr 
	#(
		.NUM_CLA_BLKS(4),
		.CLA_BLK_SIZE_BITS(4)
	)
	ADDER
	(
		.A(a),
		.B(b),
		.Cin(carry_in),
		.S(sum),
		.V(overflow)
	);

endmodule
