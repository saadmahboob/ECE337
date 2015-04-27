// $Id: $
// File name:   rcu.sv
// Created:     2/12/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: receiver control unit
module rcu 
(
	input wire clk,
	input wire n_rst,
	input wire start_bit_detected,
	input wire packet_done,
	input wire framing_error,
	output reg sbc_clear,
	output reg sbc_enable,
	output reg load_buffer,
	output reg enable_timer
);

    

	typedef enum logic [2:0] {IDLE, START_BIT_RCVD, RCV_PACKET_BIT, STOP_BIT_RCVD, CHECK_FRAMING_ERR, STORE_DATA} state_type;

    state_type curr_state, next_state;


    always_ff @ (posedge clk, negedge n_rst)
    begin
    	if(n_rst == 0) 
        begin 
            curr_state <= IDLE;
        end

        else
        begin
            curr_state <= next_state;
        end
    end


    always_comb
    begin
        next_state = curr_state;

        case(curr_state) 

            IDLE: 
            begin

                if(start_bit_detected == 1)
                begin
                    next_state = START_BIT_RCVD;
                end

                else
                begin
                    next_state = IDLE;
                end
            end

            START_BIT_RCVD: 
            begin
                next_state = RCV_PACKET_BIT;
            end

            RCV_PACKET_BIT: 
            begin

                if(packet_done == 1)
                begin
                    next_state = STOP_BIT_RCVD;
                end

                else
                begin
                    next_state = RCV_PACKET_BIT;
                end
            end

            STOP_BIT_RCVD: 
            begin
                next_state = CHECK_FRAMING_ERR;
            end

            CHECK_FRAMING_ERR: 
            begin

                if(framing_error == 1)
                begin
                    next_state = IDLE;
                end

                else
                begin
                    next_state = STORE_DATA;
                end

            end

            STORE_DATA: 
            begin
                next_state = IDLE;
            end

            default
            begin
                next_state = IDLE;
            end





        endcase


    end

    assign sbc_clear = (curr_state == START_BIT_RCVD);
    assign sbc_enable = (curr_state == STOP_BIT_RCVD);
    assign enable_timer = (curr_state == RCV_PACKET_BIT);
    assign load_buffer = (curr_state == STORE_DATA);

endmodule