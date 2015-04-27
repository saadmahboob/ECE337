// $Id: $
// File name:   tb_sda_sel.sv
// Created:     2/24/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: sda select test bench
`timescale 1ns / 100ps

module tb_sda_sel ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;

    // DUT Signals
	reg tb_tx_out;
	reg [1:0]tb_sda_mode;
	reg tb_sda_out;
	reg tb_clk;

	// Declare DUT
    sda_sel DUT
    ( 
    	.tx_out  (tb_tx_out),
    	.sda_mode(tb_sda_mode),
    	.sda_out (tb_sda_out)
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


    initial
    begin


    	//Testcase 1
    	@(posedge tb_clk);
    	tb_sda_mode = 2'b00;
    	@(posedge tb_clk);
        #CHECK_DELAY


        if(tb_sda_out == 1'b1)
        begin
        	$info("Test case 1: PASSED");
        end
        else
        begin
        	$error("Test case 1: FAILED");
        end

        

        //Testcase 2
        testcase = 2;
    	tb_sda_mode = 2'b01;
        #CHECK_DELAY
        @(posedge tb_clk);



        if(tb_sda_out == 1'b0)
        begin
        	$info("Test case 2: PASSED");
        end
        else
        begin
        	$error("Test case 2: FAILED");
        end

        @(posedge tb_clk);

        //Testcase 3
        testcase = 3;
    	tb_sda_mode = 2'b10;
        #CHECK_DELAY
        @(posedge tb_clk);


        if(tb_sda_out == 1'b1)
        begin
        	$info("Test case 3: PASSED");
        end
        else
        begin
        	$error("Test case 3: FAILED");
        end
        @(posedge tb_clk);

        //Testcase 4
        testcase = 4;
    	tb_sda_mode = 2'b11;
    	tb_tx_out = 1'b0;
        #CHECK_DELAY
        @(posedge tb_clk);


        if(tb_sda_out == 1'b0)
        begin
        	$info("Test case 4: PASSED");
        end
        else
        begin
        	$error("Test case 4: FAILED");
        end

        @(posedge tb_clk);

        //Testcase 5
        testcase = 5;
    	tb_sda_mode = 2'b11;
    	tb_tx_out = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);


        if(tb_sda_out == 1'b1)
        begin
        	$info("Test case 5: PASSED");
        end
        else
        begin
        	$error("Test case 5: FAILED");
        end

        //Testcase 6
        testcase = 5;
    	tb_sda_mode = 2'b11;
    	tb_tx_out = 1'b0;
        #CHECK_DELAY
        @(posedge tb_clk);


        if(tb_sda_out == 1'b0)
        begin
        	$info("Test case 6: PASSED");
        end
        else
        begin
        	$error("Test case 6: FAILED");
        end




    end




endmodule