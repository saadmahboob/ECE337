// $Id: $
// File name:   tb_moore.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 1101 tb
`timescale 1ns / 100ps

module tb_moore ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;


  
   
    reg tb_clk;
    reg tb_n_rst;
    reg tb_i;
    reg tb_o;
   
    integer testcase;


    moore DUT
    ( 

        .clk( tb_clk ),
        .n_rst( tb_n_rst ),
        .i( tb_i ),
        .o( tb_o )
     
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


        //TEST CASE 1 -> Reset then move to 1 state and check if o is 0
        testcase = 1;

        //async reset
		tb_n_rst = 1'b0;
        #(CHECK_DELAY);
        tb_n_rst = 1'b1;
        @(posedge tb_clk);

        //send in a 1 from wait state		
        tb_i = 1'b1;
       
        @(posedge tb_clk); 

        
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");
        
        
        //TEST CASE 2 -> From 1 state pass in 1 to get to 11, check if o is 0
        testcase = 2;

        
        //send in a 1 from 1 state		
        tb_i = 1'b1;
        
        @(posedge tb_clk); 
       
        
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        //TEST CASE 3 -> From 11 state pass in 0 to get to 110, check if o is 0
        testcase = 3;

        
        //send in a 0 from 11 state		
        tb_i = 1'b0;
        
        @(posedge tb_clk); 
       
       
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        
        
        //TEST CASE 4 -> From 110 state pass in 1 to get to 1101, check if o is 1
        testcase = 4;

        
        //send in a 1 from 110 state		
        tb_i = 1'b1;
        
        @(posedge tb_clk); 
        @(posedge tb_clk);
        
       
        
        if( tb_o == 1 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        //TEST CASE 5 -> From 1101 state pass in 1 to get to 11, check if o is 0
        testcase = 5;

        
        //send in a 1 from 1101 state		
        tb_i = 1'b1;
        
        @(posedge tb_clk); 
        
        
       
        
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


       //TEST CASE 6 -> From 11 state pass in 0 to get to 110, check if o is 0
        testcase = 6;

        
        //send in a 0 from 11 state		
        tb_i = 1'b0;
        
        @(posedge tb_clk); 
       
       
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        
        
        //TEST CASE 7 -> From 110 state pass in 1 to get to 1101, check if o is 1
        testcase = 7;

        
        //send in a 1 from 110 state		
        tb_i = 1'b1;
        
        @(posedge tb_clk); 
        @(posedge tb_clk);
        
       
        
        if( tb_o == 1 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");

    
         //TEST CASE 8 -> 
        testcase = 8;

        //async reset
		tb_n_rst = 1'b0;
        #(CHECK_DELAY);
        tb_n_rst = 1'b1;
        @(posedge tb_clk);

        
        //send in a 1 from 110 state		
        tb_i = 1'b1;
        @(posedge tb_clk); 
        tb_i = 1'b1;
        @(posedge tb_clk); 
        tb_i = 1'b0;
        @(posedge tb_clk); 
        tb_i = 1'b0;

 
        @(posedge tb_clk);
        
       
        
        if( tb_o == 0 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        //TEST CASE 9 -> 
        testcase = 9;

        //async reset
		tb_n_rst = 1'b0;
        #(CHECK_DELAY);
        tb_n_rst = 1'b1;
        @(posedge tb_clk);

        
        //send in a 1 from 110 state		
        tb_i = 1'b1;
        @(posedge tb_clk); 
        tb_i = 1'b1;
        @(posedge tb_clk); 
        tb_i = 1'b0;
        @(posedge tb_clk); 
        tb_i = 1'b1;

 
        @(posedge tb_clk);
        @(posedge tb_clk);
        
       
        
        if( tb_o == 1 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


    end




endmodule
