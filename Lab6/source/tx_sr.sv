// $Id: $
// File name:   tx_sr.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: Transmitting Shift Register
module tx_sr
(
	input wire clk,
	input wire n_rst,
	input wire falling_edge_found,
	input wire tx_enable,
	input wire [7:0] tx_data,
	input wire load_data,
	output wire tx_out
);
	

	logic shift_enable;
	assign shift_enable = tx_enable & falling_edge_found;

	flex_pts_sr # (8,1) DUT
	(
		.clk         (clk),
		.n_rst       (n_rst),
		.shift_enable(shift_enable),
		.load_enable (load_data),
		.parallel_in (tx_data),
		.serial_out  (tx_out)
	);




endmodule
