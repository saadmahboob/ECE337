// $Id: $
// File name:   moore.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 1101 detector
module moore
(
    input wire clk,
    input wire n_rst,
    input wire i,
    output reg o
);
    reg [2:0]curr_state;
    reg [2:0]next_state;

    parameter [2:0]state_start = 3'b000;
    parameter [2:0]state_1 = 3'b001;
    parameter [2:0]state_11 = 3'b010;
    parameter [2:0]state_110 = 3'b011;
    parameter [2:0]state_1101 = 3'b100;

    always_ff @ ( posedge clk, negedge n_rst ) 
    begin
      
        if( n_rst == 0 )
            curr_state <= 3'b000;
        else
            curr_state <= next_state;

    end


    always_comb begin
        next_state = curr_state;
        case(curr_state) 

            state_start : begin
                            
                            if(i == 1)
                                next_state = state_1;
                            else
                                next_state = state_start;
                          end

            state_1     : begin
                            
                            if(i == 1)
                                next_state = state_11;
                            else
                                next_state = state_start;
                          end

            state_11    : begin
                            
                            if(i == 0)
                                next_state = state_110;
                            else
                                next_state = state_11;
                          end

            state_110   : begin
                            
                            if(i == 1)
                                next_state = state_1101;
                            else
                                next_state = state_start;
                          end

            state_1101  : begin
                            
                            if(i == 1)
                                next_state = state_11;
                            else
                                next_state = state_start;
                          end

            default     : begin
                            next_state = state_start;
                           

                          end


        endcase


        

    end

    assign o = (curr_state == state_1101);


endmodule
