// $Id: $
// File name:   tb_tx_fifo.sv
// Created:     2/24/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: tx_fifo test bench
`timescale 1ns / 100ps

module tb_tx_fifo ();

    // Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 10;
	localparam	CHECK_DELAY = 3; // Check 1ns after the rising edge to allow for propagation delay
    localparam  NUM_CNT_BITS = 4;

    // DUT Signals
	reg tb_clk;
    reg tb_n_rst;
    reg tb_read_enable;
    reg tb_write_enable;
    reg [7:0] tb_write_data;
    reg [7:0] tb_read_data;
    reg tb_fifo_empty;
    reg tb_fifo_full;

	// Declare DUT
    tx_fifo DUT
    ( 
        .clk(tb_clk),
        .n_rst(tb_n_rst),
        .read_enable(tb_read_enable),
        .write_enable(tb_write_enable),
        .write_data(tb_write_data),
        .read_data(tb_read_data),
        .fifo_empty(tb_fifo_empty),
        .fifo_full(tb_fifo_full)

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

        //Test case 1
        //Write data to fifo
    	testcase = 1;

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
    
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;

        #CHECK_DELAY

        if(tb_read_data == 8'b00001111)
        begin
            $info("Testcase 1: PASSED");
        end
        else
        begin
            $error("Testcase 1: FAILED");
        end

        //Test case 2
        //Two writes and a read
        testcase = 1;

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        //Write byte
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY



        //Write byte
        tb_write_data = 8'b11110000;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        if(tb_read_data == 8'b11110000)
        begin
            $info("Testcase 2: PASSED");
        end
        else
        begin
            $error("Testcase 2: FAILED");
        end


        //Test case 3
        //Make the buffer full
        testcase = 1;

        //Reset the signals
        #CHECK_DELAY
        tb_n_rst = 0;
        #CHECK_DELAY
        tb_n_rst = 1;
        #CHECK_DELAY

        
        //Write byte
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY



        //Write byte
        tb_write_data = 8'b11110000;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY

        //Write byte
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY



        //Write byte
        tb_write_data = 8'b11110000;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY

        //Write byte
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY



        //Write byte
        tb_write_data = 8'b11110000;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY

        //Write byte
        tb_write_data = 8'b00001111;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY



        //Write byte
        tb_write_data = 8'b11110000;
        #CHECK_DELAY
        tb_write_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_write_enable = 1'b0;
        #CHECK_DELAY

        

        if(tb_fifo_full == 1'b1)
        begin
            $info("Testcase 3: PASSED");
        end
        else
        begin
            $error("Testcase 3: FAILED");
        end


        //Testcase 4
        //EMPTY THAT FIFO!!!!


        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        //Read Byte
        tb_read_enable = 1'b1;
        #CHECK_DELAY
        @(posedge tb_clk);
        #CHECK_DELAY
        tb_read_enable = 1'b0;
        #CHECK_DELAY

        //Wait for read to occur
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);

        if(tb_fifo_full == 1'b0 && tb_fifo_empty == 1'b1)
        begin
            $info("Testcase 5: PASSED");
        end
        else
        begin
            $error("Testcase 5: FAILED");
        end



        


    end




endmodule