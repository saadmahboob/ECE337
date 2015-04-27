// $Id: $
// File name:   tb_scl_edge.sv
// Created:     2/24/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: scl edge testbench
`timescale 1ns / 100ps

module tb_scl_edge ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY = 3; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;

    // DUT Signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_scl;
	reg tb_rising_edge_found;
	reg tb_falling_edge_found;


	// Declare DUT
    scl_edge DUT
    ( 
        .clk               (tb_clk),
        .n_rst             (tb_n_rst),
        .scl               (tb_scl),
        .rising_edge_found (tb_rising_edge_found),
        .falling_edge_found(tb_falling_edge_found)
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


        // Testcase 0, reset stuff
        tb_n_rst = 0;
        tb_scl = 0;


        #CHECK_DELAY
        tb_n_rst = 1;
        tb_scl = 1;
        #CHECK_DELAY
        tb_n_rst = 0;
        tb_scl = 1;
        #CHECK_DELAY
        tb_n_rst = 1;
        tb_scl = 0;
        #CHECK_DELAY

        #CHECK_DELAY
        tb_n_rst = 1;
        tb_scl = 1;
        #CHECK_DELAY
        tb_n_rst = 0;
        tb_scl = 1;
        #CHECK_DELAY
        tb_n_rst = 0;
        tb_scl = 1;
        #CHECK_DELAY
        #CHECK_DELAY
        tb_n_rst = 0;
        tb_scl = 0;
        #CHECK_DELAY







    	// Testcase 1, sending in all zeros
    	// No rising or falling edges should be found
	 	tb_scl = 0;
    	tb_n_rst = 1;

        @(posedge tb_clk);
        @(posedge tb_clk);

        @(posedge tb_clk);

        if(!tb_falling_edge_found && !tb_rising_edge_found)
        begin
        	$info("Test case 1: PASSED");
        end
        else
        begin
        	$error("Test case 1: FAILED");
        end

    	// Testcase 2, check rising edge
	 	tb_scl = 0;
    	tb_n_rst = 1;

        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;

        @(posedge tb_clk);

        #CHECK_DELAY

        if(!tb_falling_edge_found && tb_rising_edge_found)
        begin
        	$info("Test case 2: PASSED");
        end
        else
        begin
        	$error("Test case 2: FAILED");
        end

        // Testcase 3, check falling edge
    	tb_n_rst = 1;

        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);

        #CHECK_DELAY

        if(tb_falling_edge_found && !tb_rising_edge_found)
        begin
        	$info("Test case 3: PASSED");
        end
        else
        begin
        	$error("Test case 3: FAILED");
        end


        // Testcase 4, lots of changes followed by n_rst
    	tb_n_rst = 1;


        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        
        tb_n_rst = 0;
        
        #CHECK_DELAY


        if(!tb_falling_edge_found && !tb_rising_edge_found)
        begin
        	$info("Test case 4: PASSED");
        end
        else
        begin
        	$error("Test case 4: FAILED");
        end

        // Testcase 5, lots of changes followed by rising edge
    	tb_n_rst = 1;


        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        
      
        
        #CHECK_DELAY


        if(!tb_falling_edge_found && tb_rising_edge_found)
        begin
        	$info("Test case 5: PASSED");
        end
        else
        begin
        	$error("Test case 5: FAILED");
        end

        // Testcase 6, lots of changes followed by falling edge
        tb_n_rst = 1;


        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 1;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        
      
        
        #CHECK_DELAY


        if(tb_falling_edge_found && !tb_rising_edge_found)
        begin
            $info("Test case 6: PASSED");
        end
        else
        begin
            $error("Test case 6: FAILED");
        end

        // Testcase 7, lots of changes followed by falling edge
        tb_n_rst = 1;


        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_scl = 0;
        @(posedge tb_clk);
        
      
        
        #CHECK_DELAY


        if(!tb_falling_edge_found && !tb_rising_edge_found)
        begin
            $info("Test case 7: PASSED");
        end
        else
        begin
            $error("Test case 7: FAILED");
        end







        
        
        


    end




endmodule