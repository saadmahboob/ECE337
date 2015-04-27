// $Id: $
// File name:   timer.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: timer
module timer
(
	input wire clk,
	input wire n_rst,
	input wire rising_edge_found,
 	input wire falling_edge_found,
 	input wire stop_found,
 	input wire start_found,
    output reg byte_received,
    output reg ack_prep,
    output reg check_ack,
    output reg ack_done

);
	logic count_enable;
	logic [3:0]count_out;
	logic rollover_flag;
    logic clear;
	
  	flex_counter #(4) DUT_FLEX_COUNTER
  	(
  		.clk          (clk),
  		.n_rst        (n_rst),
  		.clear        (clear),
  		.count_enable (rising_edge_found),
  		.rollover_val (4'd9),
  		.count_out    (count_out),
  		.rollover_flag(rollover_flag)
  	);

    typedef enum logic [2:0] 
    {
        IDLE,
        COUNT_8,
        BYTE_RCVD,
        FALL_EDGE_1,
        RISE_EDGE,
        FALL_EDGE_2,
        CLEAR

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

        case(curr_state) 

            IDLE: 
            begin
                if(start_found)
                    next_state = CLEAR;
                else
                    next_state = IDLE;
            end

            CLEAR: 
            begin
                next_state = COUNT_8;
            end


            COUNT_8: 
            begin
                if(count_out == 8)
                    next_state = BYTE_RCVD;
                else
                    next_state = COUNT_8;
            end


            BYTE_RCVD: 
            begin
                if(falling_edge_found == 1)
                    next_state = FALL_EDGE_1;
                else
                    next_state = BYTE_RCVD;
            end


            FALL_EDGE_1: 
            begin
                if(rising_edge_found)
                    next_state = RISE_EDGE;
                else
                    next_state = FALL_EDGE_1;
            end

            RISE_EDGE: 
            begin
                if(falling_edge_found)
                    next_state = FALL_EDGE_2;
                else
                    next_state = RISE_EDGE;
            end

            FALL_EDGE_2: 
            begin
                next_state = COUNT_8;
            end

           


        endcase

        if(stop_found)
            next_state = IDLE;
    end

    assign byte_received = (curr_state == BYTE_RCVD);
    assign ack_prep = (curr_state == FALL_EDGE_1);
    assign check_ack = (curr_state == RISE_EDGE);
    assign ack_done = (curr_state == FALL_EDGE_2);
    assign clear = (curr_state == CLEAR);











    /*

  	// INPUT LOGIC
  	always @ (posedge start_found, posedge stop_found)
  	begin

  		if(start_found)
  		begin
  			count_enable = 1'b1;
  		end


  		else
  			count_enable = 1'b0;
  	end


  	// OUTPUT LOGIC
  	always @ (count_out, falling_edge_found)
  	begin
      check_ack = 1'b0;
  		byte_received = 1'b0;
  		ack_prep = 1'b0;
  		ack_done = 1'b0;

  		if(count_out == 4'd8)
  		begin
  			byte_received = 1'b1;
  			if(falling_edge_found)
  				ack_prep = 1'b1;
  		end

  		else if(rollover_flag)
  		begin
  			check_ack = 1;
  			if(falling_edge_found)
  				ack_done = 1'b1;
  		end
  	end
*/

endmodule