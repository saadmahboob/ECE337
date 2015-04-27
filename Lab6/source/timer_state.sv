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
    logic clear_cnt;
	
  	flex_counter #(4) DUT
  	(
  		.clk          (clk),
  		.n_rst        (n_rst),
  		.clear        (clear_cnt),
  		.count_enable (rising_edge_found & count_enable),
  		.rollover_val (4'd9),
  		.count_out    (count_out),
  		.rollover_flag(rollover_flag)
  	);

    typedef enum logic [2:0] 
    {
        IDLE,
        BYTE_RCVD,
        COUNT_8,
        CHECK_ACK,
        ACK_DONE,
        ACK_PREP


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

        byte_received = 1'b0;
        ack_prep = 1'b0;
        check_ack = 1'b0;
        ack_done = 1'b0;
        clear_cnt = 1'b0; 
        

        case(curr_state) 

            IDLE: 
            begin
                if(start_found)
                    next_state = COUNT_8;
                else
                    next_state = IDLE   

                byte_received = 1'b0;
                ack_prep = 1'b0;
                check_ack = 1'b0;
                ack_done = 1'b0; 
                clear_cnt = 1'b0;         

            end

            COUNT_8: 
            begin
                if(count_out == 8)
                    next_state = BYTE_RCVD;
                else
                    next_state = COUNT_8;     

                byte_received = 1'b0;
                ack_prep = 1'b0;
                check_ack = 1'b0;
                ack_done = 1'b0;
                clear_cnt = 1'b0;          

            end

            BYTE_RCVD
                if(falling_edge_found)
                    next_state = ACK_PREP;
                else
                    next_state = BYTE_RCVD;

                byte_received = 1'b1;
                ack_prep = 1'b0;
                check_ack = 1'b0;
                ack_done = 1'b0;
                clear_cnt = 1'b0;            

            end

            ACK_PREP: 
            begin
                if(rollover_flag)
                    next_state = CHECK_ACK;
                else    
                    next_state = ACK_PREP;  

                byte_received = 1'b0;
                ack_prep = 1'b1;
                check_ack = 1'b0;
                ack_done = 1'b0; 
                clear_cnt = 1'b0;                

            end

            CHECK_ACK: 
            begin
                if(falling_edge_found)
                    next_state = ACK_DONE;
                else
                    next_state = CHECK_ACK;

                byte_received = 1'b0;
                ack_prep = 1'b0;
                check_ack = 1'b0;
                ack_done = 1'b0; 
                clear_cnt = 1'b0;        

            end

            ACK_DONE: 
            begin
                next_state = CLEAR; 
                byte_received = 1'b0;
                ack_prep = 1'b0;
                check_ack = 1'b0;
                ack_done = 1'b0; 
                clear_cnt = 1'b0;           

            end

            CLEAR:
            begin
                clear_cnt = 1'b1;   

            end


        endcase
    end

    /*

  	// INPUT LOGIC
  	always @ (posedge start_found, posedge stop_found)
  	begin

  		if(start_found)
  			count_enable = 1'b1;
  	

  		else if(stop_found)
  			count_enable = 1'b0;
  

  		else
  			count_enable = 1'b0;
  	end

    /*

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