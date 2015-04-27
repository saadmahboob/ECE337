// $Id: $
// File name:   tb_timer.sv
// Created:     2/26/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: timer testbench
`timescale 1ns / 100ps

module tb_timer ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY = 3; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;

    // DUT Signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_rising_edge_found;
	reg tb_falling_edge_found;
	reg tb_stop_found;
	reg tb_start_found;
	reg tb_byte_received;
	reg tb_ack_prep;
	reg tb_check_ack;
	reg tb_ack_done;

	// Declare DUT
    timer DUT
    ( 
    	.clk               (tb_clk),
    	.n_rst             (tb_n_rst),
    	.rising_edge_found (tb_rising_edge_found),
    	.falling_edge_found(tb_falling_edge_found),
    	.stop_found        (tb_stop_found),
    	.start_found       (tb_start_found),
    	.byte_received     (tb_byte_received),
    	.ack_prep          (tb_ack_prep),
    	.check_ack         (tb_check_ack),
    	.ack_done          (tb_ack_done)
    );



    // Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	integer testcase = 1;






endmodule