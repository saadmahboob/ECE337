// $Id: $
// File name:   tx_fifo.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: IP module
module tx_fifo
(
	input wire clk,
	input wire n_rst,
	input wire read_enable,
	input wire write_enable,
	input wire [7:0] write_data,
	output wire [7:0] read_data,
	output wire fifo_empty,
	output wire fifo_full

);

	fifo F1 
		(
			.r_clk(clk),
			.w_clk(clk),
			.n_rst(n_rst),
			.r_enable(read_enable),
			.w_enable(write_enable),
			.r_data(read_data),
			.w_data(write_data),
			.empty(fifo_empty),
			.full(fifo_full)
		);

endmodule