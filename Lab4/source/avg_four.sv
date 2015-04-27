// $Id: $
// File name:   avg_four.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: avg_four
module avg_four
(
    input wire clk,
    input wire n_reset,
    input wire [15:0] sample_data,
    input wire data_ready,
    output wire one_k_samples,
    output wire modwait,
    output wire [15:0] avg_out,
    output wire err
);

	reg [1:0] op;
	reg [3:0] src1;
	reg [3:0] src2;
	reg [3:0] dest;
	reg overflow;
	reg cnt_up;
	reg [15:0]outreg_data;
	reg dr;

	sync Synch
	(
		.clk(clk), 
		.n_reset(n_reset), 
		.async_in(data_ready), 
		.sync_out(dr)
	);

	counter COUNTER
	(
		.clk(clk), 
		.n_reset(n_reset), 
		.cnt_up(cnt_up), 
		.one_k_samples(one_k_samples)
	);

	controller CONTROLLER
	(
		.clk(clk), 
		.n_reset(n_reset), 
		.dr(dr), 
		.overflow(overflow), 
		.cnt_up(cnt_up),
		.modwait (modwait),
		.op(op),
		.src1(src1),
		.src2(src2),
		.dest(dest),
		.err(err)

	);

	datapath DATAPATH
	(
		.clk(clk),
		.n_reset(n_reset),
		.op(op),
		.src1(src1),
		.src2(src2),
		.dest(dest),
		.ext_data(sample_data),
		.outreg_data(outreg_data),
		.overflow(overflow)
	);



	assign avg_out = outreg_data >> 2;




endmodule