// $Id: $
// File name:   tb_DES_block.sv
// Created:     4/26/2015
// Author:      Isaac Sheeley & Seth Bontrager
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: test bench for DES block
`timescale 1ns / 10ps

module tb_DES_block();
    // Define parameters
    localparam  CLK_PERIOD  = 5; // 200MHz clock
    localparam  CHECK_DELAY = 1; // Check 2ns after the rising edge to allow for propagation delay

    logic tb_clk;
    logic tb_nrst;
    logic tb_enable;
    logic tb_encr_decr;
    logic tb_enable_next_block;
    logic[63:0] tb_input_data_block;
    logic[63:0] tb_output_data_block;
    logic[63:0] tb_user_key;
    logic im_checking_now;

    DES_block DUT_DES_BLOCK(
    	.clk              (tb_clk),
    	.nrst             (tb_nrst),
    	.enable           (tb_enable),
    	.encr_decr        (tb_encr_decr),
    	.enable_next_block(tb_enable_next_block),
    	.input_data_block(tb_input_data_block),
    	.output_data_block(tb_output_data_block),
    	.user_key(tb_user_key)

    );

    // Generate clock signal
    always begin
        tb_clk = 1'b0;
        #(CLK_PERIOD/2.0);
        tb_clk = 1'b1;
        #(CLK_PERIOD/2.0);
    end

    // Test bench procedures
    initial
    begin
        //Reset everything
        tb_nrst = 0;
        #(CHECK_DELAY)
        tb_nrst = 1;
        #(CHECK_DELAY)

        tb_user_key = 64'h736865726c6f636b;
        tb_enable = 1;
        im_checking_now = 0;

        //Set for encryption
        tb_encr_decr = 1;

        tb_input_data_block = 64'h5368656C6C73686F;

        //Setting values
        @(posedge tb_clk)


        //16 rounds of processing
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)

        tb_input_data_block = 64'h636B2C20616C736F;


        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        tb_enable = 0;
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)

        //Basically CHECK_DELAY
        @(posedge tb_clk)

        im_checking_now = 1;
        if(tb_output_data_block == 64'hFDDF016E17322DB6)
            $info("1 PASSSED");
        else
            $error("1 BAD!");



        

        //16 rounds of processing
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)
        @(posedge tb_clk)

        //Basically CHECK_DELAY
        //No time... so fast

        im_checking_now = 0;
        if(tb_output_data_block == 64'h9920CDCB024005FF)
            $info("2 PASSSED");
        else
            $error("2 BAD!");




        


     
    	
    end

endmodule