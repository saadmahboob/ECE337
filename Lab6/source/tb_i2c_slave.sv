// $Id: $
// File name:   tb_i2c_slave.sv
// Created:     2/26/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: testbench for i2c slave
`timescale 1ns / 100ps
module tb_i2c_slave ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY = 30; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;
    localparam  SCLK_PERIOD = 300;

    // DUT_SLAVE Signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_scl;
	reg tb_sda_in;
	reg tb_write_enable;
	reg [7:0] tb_write_data;
	reg tb_sda_out;
	reg tb_fifo_empty;
	reg tb_fifo_full;


    //DUT_I2C Signals
    reg tb_Mscl;
    reg tb_Msda_in;
    reg tb_sclk;
    reg tb_Msda_out;




	// Declare DUT
    i2c_slave DUT_SLAVE
    ( 
    	.clk         (tb_clk),
    	.n_rst       (tb_n_rst),
    	.scl         (tb_scl),
    	.sda_in      (tb_sda_in),
    	.write_enable(tb_write_enable),
    	.write_data  (tb_write_data),
    	.sda_out     (tb_sda_out),
    	.fifo_empty  (tb_fifo_empty),
    	.fifo_full   (tb_fifo_full)

    );

    

    I2C_Bus DUT_I2C
        (
                .scl_read({tb_scl,tb_Mscl}),
                .scl_write({1'bz, tb_sclk}),
                .sda_read({tb_sda_in,tb_Msda_in}),
                .sda_write({tb_sda_out, tb_Msda_out})
        );
    


    // Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

    // Slave Clock generation block
    always
    begin
        tb_sclk = 1'b0;
        #(2 * SCLK_PERIOD/3.0);
        tb_sclk = 1'b1;
        #(SCLK_PERIOD/3.0);
    end

	
    initial
    begin
        // Do a reset first
        @(negedge tb_sclk);
        tb_n_rst = 0;
        #(CHECK_DELAY);
        tb_n_rst = 1;
        #(CHECK_DELAY);


        tb_n_rst = 1;
        tb_sclk = 0;
        tb_Msda_out = 0;
        tb_sclk = 0;
        tb_write_enable = 0;
        tb_write_data = 8'b11000010;

        // Just wait a bit to make sure all is well
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_sclk);
        @(posedge tb_sclk);


        

    end






    
    


endmodule


