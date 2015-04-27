// $Id: $
// File name:   sr_9bit.sv
// Created:     2/12/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 9 bit shift register
module sr_9bit 
(
	input wire clk,
	input wire n_rst,
	input wire shift_strobe,
	input wire serial_in,
	output wire [7:0] packet_data,
	output wire stop_bit
);

	reg [8:0]p_out;

	flex_stp_sr #(9,0) SHIFT_REG_9bit
	(
		.clk         (clk),
		.n_rst       (n_rst),
		.shift_enable(shift_strobe),
		.serial_in   (serial_in),
		.parallel_out(p_out)
	);

	assign stop_bit = p_out[8];
	assign packet_data = p_out[7:0];


endmodule