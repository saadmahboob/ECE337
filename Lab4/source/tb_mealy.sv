// $Id: $
// File name:   tb_mealy.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 1101 tb
`timescale 1ns / 100ps

module tb_mealy ();

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


    mealy DUT
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


        //TEST CASE 1 -> check 1101 works
        testcase = 1;

        //async reset
		tb_n_rst = 1'b0;
        #5;
        tb_n_rst = 1'b1;
        #5;

        //send in a 1101 from wait state		
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b0;
        @(posedge tb_clk);
        tb_i = 1'b1;
        
         
        #(CHECK_DELAY);
        
        if( tb_o == 1 )
            $info("Test case 1: Passed");
        else 
            $error("Test case 1: FAILED");


        
        //TEST CASE 2 -> check 1101 works from a 1101
        testcase = 2;

        //async reset
		tb_n_rst = 1'b0;
        #5;
        tb_n_rst = 1'b1;
        #5;

        //send in a 1101 from 1101 
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b0;
        @(posedge tb_clk);
        tb_i = 1'b1;	
        @(posedge tb_clk);	
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b0;
        @(posedge tb_clk);
        tb_i = 1'b1;
       
        
         

        #(CHECK_DELAY);
        if( tb_o == 1 )
            $info("Test case 2: Passed");
        else 
            $error("Test case 2: FAILED");

        //TEST CASE 3 -> check fail
        testcase = 3;

       
        //async reset
		tb_n_rst = 1'b0;
        #5;
        tb_n_rst = 1'b1;
        #5;

        //send in a 1101 from 1101 
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b0;
        @(posedge tb_clk);
        tb_i = 1'b1;	
        @(posedge tb_clk);	
        tb_i = 1'b1;
        @(posedge tb_clk);
        tb_i = 1'b0;
        @(posedge tb_clk);
        tb_i = 1'b0;
       
       
        
         

        #(CHECK_DELAY);
        if( tb_o == 0 )
            $info("Test case 3: Passed");
        else 
            $error("Test case 3: FAILED");
        
        

    end




endmodule
