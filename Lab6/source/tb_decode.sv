// $Id: $
// File name:   tb_decode.sv
// Created:     2/24/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: decoder testbench
`timescale 1ns / 100ps

module tb_decode ();

    // Define parameters
    // basic test bench parameters
    localparam  CLK_PERIOD  = 10;
    localparam  CHECK_DELAY = 3; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;

    // DUT Signals
    reg tb_clk;
    reg tb_n_rst;
    reg tb_scl;
    reg tb_sda_in;
    reg [7:0] tb_starting_byte;
    reg tb_rw_mode;
    reg tb_address_match;
    reg tb_stop_found;
    reg tb_start_found;
    

    // Declare DUT
    decode DUT 
    (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .scl(tb_scl),
    .sda_in(tb_sda_in),
    .starting_byte(tb_starting_byte),
    .rw_mode(tb_rw_mode),
    .address_match(tb_address_match),
    .stop_found(tb_stop_found),
    .start_found(tb_start_found)

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
        //Check for scl and sda_in low
        //Shoud result in no stop or start
        //No address match and rw_mode = 0
        testcase = 1;

        tb_n_rst = 1;
        tb_scl = 1'b0;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b01110000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && !tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 1: PASSED");
        end
        else
        begin
            $error("Testcase 1: FAILED");
        end


        //Testcase 2
        //Set start conditions
        //Shoud result in no stop but yes start
        //No address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        testcase = 2;

        tb_scl = 1'b1;
        tb_sda_in = 1'b1;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b10110000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY

        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        @(posedge tb_clk);
        #CHECK_DELAY
        

        if(!tb_stop_found && tb_start_found && !tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 2: PASSED");
        end
        else
        begin
            $error("Testcase 2: FAILED");
        end


        //Testcase 3
        //Set stop conditions
        //Shoud result in yes stop but no start
        //No address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        testcase = 3;

        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11010000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY

        tb_scl = 1'b1;
        tb_sda_in = 1'b1;

        @(posedge tb_clk);
        #CHECK_DELAY
        

        if(tb_stop_found && !tb_start_found && !tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 3: PASSED");
        end
        else
        begin
            $error("Testcase 3: FAILED");
        end


        //Testcase 4
        //Check for scl in high and sda_in low
        //Shoud result in no stop or start
        //No address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        testcase = 4;

        tb_n_rst = 1;
        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11100000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && !tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 4: PASSED");
        end
        else
        begin
            $error("Testcase 4: FAILED");
        end


        //Testcase 5
        //Check for scl in low and sda_in high
        //Shoud result in no stop or start
        //No address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        testcase = 5;

        tb_n_rst = 1;
        tb_scl = 1'b0;
        tb_sda_in = 1'b1;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11111000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && !tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 5: PASSED");
        end
        else
        begin
            $error("Testcase 5: FAILED");
        end


        //ALL THE SAME CHECKS EXCEPT MOVE 
        //ADDRESS AND RW_MODE AROUND

        //Testcase 6
        //Check for scl and sda_in low
        //Shoud result in no stop or start
        //address match and rw_mode = 1
        testcase = 6;

        tb_n_rst = 1;
        tb_scl = 1'b0;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11110001;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && tb_address_match && tb_rw_mode) 
        begin 
            $info("Testcase 6: PASSED");
        end
        else
        begin
            $error("Testcase 6: FAILED");
        end


        //Testcase 7
        //Set start conditions
        //Shoud result in no stop but yes start
        //address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        testcase = 7;

        tb_scl = 1'b1;
        tb_sda_in = 1'b1;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11110000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY

        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        @(posedge tb_clk);
        #CHECK_DELAY
        

        if(!tb_stop_found && tb_start_found && tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 7: PASSED");
        end
        else
        begin
            $error("Testcase 7: FAILED");
        end


        //Testcase 8
        //Set stop conditions
        //Shoud result in yes stop but no start
        //No address match and rw_mode = 1

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        testcase = 8;

        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11111101;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY

        tb_scl = 1'b1;
        tb_sda_in = 1'b1;

        @(posedge tb_clk);
        #CHECK_DELAY
        

        if(tb_stop_found && !tb_start_found && !tb_address_match && tb_rw_mode) 
        begin 
            $info("Testcase 8: PASSED");
        end
        else
        begin
            $error("Testcase 8: FAILED");
        end


        //Testcase 9
        //Check for scl in high and sda_in low
        //Shoud result in no stop or start
        //address match and rw_mode = 0

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        testcase = 9;

        tb_n_rst = 1;
        tb_scl = 1'b1;
        tb_sda_in = 1'b0;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11110000;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && tb_address_match && !tb_rw_mode) 
        begin 
            $info("Testcase 9: PASSED");
        end
        else
        begin
            $error("Testcase 9: FAILED");
        end


        //Testcase 10
        //Check for scl in low and sda_in high
        //Shoud result in no stop or start
        //No address match and rw_mode = 1

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        testcase = 10;

        tb_n_rst = 1;
        tb_scl = 1'b0;
        tb_sda_in = 1'b1;

        //send bad address and rw_mode = 0
        tb_starting_byte = 8'b11111111;

        //Wait two edges for values to enter regs
        @(posedge tb_clk);
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        if(!tb_stop_found && !tb_start_found && !tb_address_match && tb_rw_mode) 
        begin 
            $info("Testcase 10: PASSED");
        end
        else
        begin
            $error("Testcase 10: FAILED");
        end


        

        

       



    end




endmodule