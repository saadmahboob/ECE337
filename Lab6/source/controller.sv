// $Id: $
// File name:   controller.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: Slave Controller
module controller (
	input wire clk,    
	input wire n_rst,  
	input wire stop_found,
	input wire start_found, 
	input wire byte_received,
	input wire ack_prep,
	input wire check_ack,
	input wire ack_done,
	input wire rw_mode,
	input wire address_match,
	input wire sda_in,
	output reg rx_enable,
	output reg tx_enable,
	output reg read_enable,
	output reg [1:0] sda_mode,
	output reg load_data
);


	typedef enum logic [3:0] 
	{
		IDLE,
		START_RCVD,
		CHECK_ADDR_RW,
		SEND_ACK,
		SEND_NACK,
		LOAD_DATA,
		SEND_BYTE,
		CHECK_ACK,
		INC_PNTR,
		ACK_RCVD,
		NACK_RCVD,
		CHECK_MASTER_DONE

	} state_type;

    state_type curr_state, next_state;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if(n_rst == 0)
            curr_state <= IDLE;
        else 
            curr_state <= next_state;
    end



    always_comb
    begin
        next_state = curr_state;

        rx_enable = 1'b0;
        tx_enable = 1'b0;
        read_enable = 1'b0;
        sda_mode = 2'b00;
        load_data = 1'b0;

        case(curr_state) 

            IDLE: 
            begin
            	if(start_found)
            		next_state = START_RCVD;
            	else
            		next_state = IDLE;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;

            end

            START_RCVD:
            begin
            	if(byte_received)
            		next_state = CHECK_ADDR_RW;
            	else
            		next_state = START_RCVD;

            	rx_enable = 1'b1;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            CHECK_ADDR_RW:
            begin
            	if(address_match & rw_mode)
            		next_state = SEND_ACK;
            	else 
            		next_state = SEND_NACK;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            SEND_NACK:
            begin
            	if(ack_done)
            		next_state = IDLE;
            	else
            		next_state = SEND_NACK;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b10;
        		load_data = 1'b0;
        		
            end

            SEND_ACK:
            begin
            	if(ack_done)
            		next_state = LOAD_DATA;
            	else
            		next_state = SEND_ACK;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b01;
        		load_data = 1'b0;

            end

            LOAD_DATA:
            begin
            	next_state = SEND_BYTE;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b1;
        		
            end

            SEND_BYTE:
            begin
            	if(ack_prep)
            		next_state = CHECK_ACK;
            	else
            		next_state = SEND_BYTE;

            	rx_enable = 1'b0;
        		tx_enable = 1'b1;
        		read_enable = 1'b0;
        		sda_mode = 2'b11;
        		load_data = 1'b0;
        		
            end

            CHECK_ACK:
            begin
            	if(sda_in & check_ack)
            		next_state = NACK_RCVD;
            	else if(!sda_in & check_ack)
            		next_state = INC_PNTR;
            	else 
            		next_state = CHECK_ACK;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            INC_PNTR:
            begin        
            	next_state = ACK_RCVD;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b1;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            ACK_RCVD:
            begin
            	if(ack_done)
            		next_state = LOAD_DATA;
            	else
            		next_state = ACK_RCVD;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            NACK_RCVD:
            begin
            	if(ack_done)
            		next_state = CHECK_MASTER_DONE;
            	else
            		next_state = NACK_RCVD;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

            CHECK_MASTER_DONE:
            begin
            	if(stop_found)
            		next_state = IDLE;
            	else if(start_found)
            		next_state = START_RCVD;
                else 
                    next_state = CHECK_MASTER_DONE;

            	rx_enable = 1'b0;
        		tx_enable = 1'b0;
        		read_enable = 1'b0;
        		sda_mode = 2'b00;
        		load_data = 1'b0;
        		
            end

        endcase

    end

endmodule