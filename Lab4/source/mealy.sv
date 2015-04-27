// $Id: $
// File name:   mealy.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: 1101 detector
module mealy
(
    input wire clk,
    input wire n_rst,
    input wire i,
    output reg o
);
    reg [1:0]curr_state;
    reg [1:0]next_state;

    parameter [1:0]state_start = 2'b00;
    parameter [1:0]state_1 = 2'b01;
    parameter [1:0]state_11 = 2'b10;
    parameter [1:0]state_110 = 2'b11;
    

    always_ff @ ( posedge clk, negedge n_rst ) 
    begin
      
        if( n_rst == 0 )
            curr_state <= 2'b00;
        else
            curr_state <= next_state;

    end


    always_comb begin
        next_state = curr_state;
        o = 0;
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
                            begin
                                next_state = state_1;
                                o = 1;
                            end
                            else
                                next_state = state_start;
                          end

            

            default     : begin
                            next_state = state_start;
                           

                          end


        endcase


        

    end

   


endmodule
