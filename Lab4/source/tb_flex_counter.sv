// $Id: $
// File name:   tb_flex_counter.sv
// Created:     2/2/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: test bench for flex counter
`timescale 1ns / 100ps

module tb_flex_counter ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;


    reg tb_clk;
    reg tb_n_rst;
    reg tb_clear;
    reg tb_count_enable;
    reg [NUM_CNT_BITS-1:0] tb_rollover_val;
    reg [NUM_CNT_BITS-1:0] tb_count_out;
    reg tb_rollover_flag;
    integer testcase;


    flex_counter DUT
    ( 
        .clk( tb_clk ),
        .n_rst( tb_n_rst ),
        .clear( tb_clear ),
        .count_enable( tb_count_enable ),
        .rollover_val( tb_rollover_val ),
        .count_out( tb_count_out ),
        .rollover_flag( tb_rollover_flag ) 
    );



    // Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end




    initial
    begin

        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
        @(posedge tb_clk)

        //TEST CASE 1
        testcase = 1;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 4;
        tb_count_enable = 1'b0;
		tb_clear	= 1'b1;

        @(posedge tb_clk); 
        #(CHECK_DELAY);
        if( (tb_count_out == 0) && ( tb_rollover_flag == 0 ) )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");
        
        
        //TEST CASE 2
        
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
        
        
        testcase = 2;

		tb_n_rst		= 1'b0;		
        tb_rollover_val = 4;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

    
        #(CHECK_DELAY);
        if( (tb_count_out == 0) && ( tb_rollover_flag == 0 ) )
            $info("Test case 2: Passed");
        else 
            $error("Test case 2: FAILED");


        //TEST CASE 3
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 3;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 5;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 3: Passed");
        else 
            $error("Test case 3: FAILED");

        //TEST CASE 4
        tb_count_enable = 1'b0;
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
        
        testcase = 4;

		tb_n_rst		= 1'b1;		
        tb_rollover_val = 5;
        


        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
      

        #(CHECK_DELAY);
        if( (tb_count_out == 0) && ( tb_rollover_flag == 0 ) )
            $info("Test case 4: Passed");
        else 
            $error("Test case 4: FAILED");


        //TEST CASE 5
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
      

        testcase = 5;

		tb_n_rst		= 1'b1;		
        tb_rollover_val = 5;
        tb_count_enable = 1'b1;
		

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        
        tb_n_rst = 1'b0; 
        @(posedge tb_clk);

        #(CHECK_DELAY);
        if( (tb_count_out == 0) && ( tb_rollover_flag == 0 ) )
            $info("Test case 5: Passed");
        else 
            $error("Test case 5: FAILED");

        //TEST CASE 6
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 6;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 6;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 6: Passed");
        else 
            $error("Test case 6: FAILED");


        //TEST CASE 7
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 7;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 7;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 7: Passed");
        else 
            $error("Test case 7: FAILED");

        //TEST CASE 8
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 8;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 8;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 8: Passed");
        else 
            $error("Test case 8: FAILED");


        //TEST CASE 9
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 9;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 9;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 9: Passed");
        else 
            $error("Test case 9: FAILED");


        //TEST CASE 10
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 10;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 10;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 10: Passed");
        else 
            $error("Test case 10: FAILED");
            

        //TEST CASE 11
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 11;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 11;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 11: Passed");
        else 
            $error("Test case 11: FAILED");
    
        //TEST CASE 12
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 12;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 12;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 12: Passed");
        else 
            $error("Test case 12: FAILED");


        //TEST CASE 13
        @(posedge tb_clk);
        tb_clear	= 1'b1;
        @(posedge tb_clk);
        tb_clear    = 1'b0;
       

        testcase = 13;
		tb_n_rst		= 1'b1;		
        tb_rollover_val = 13;
        tb_count_enable = 1'b1;
		tb_clear	= 1'b0;

        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk); 
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        
         

        #(CHECK_DELAY);
        if( (tb_count_out == tb_rollover_val) && ( tb_rollover_flag == 1 ) )
            $info("Test case 13: Passed");
        else 
            $error("Test case 13: FAILED");



    end




endmodule


