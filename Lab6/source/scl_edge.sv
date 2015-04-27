// $Id: $
// File name:   scl_edge.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: scl edge detector
module scl_edge
(
	input wire clk,
	input wire n_rst,
	input wire scl,
	output reg rising_edge_found,
	output reg falling_edge_found
);
    reg Q0;
	reg Q1;
	reg Q2;
	
	always_ff @ (posedge clk, negedge n_rst)
    begin
    	if(n_rst == 0) 
    	begin
            Q0 <= 1'b1;
    		Q1 <= 1'b1;
    		Q2 <= 1'b1;

    	end
    	else 
    	begin
            Q0 <= scl;
    		Q1 <= Q0;
    		Q2 <= Q1;
    	end
    end

    assign rising_edge_found = (!Q2 && Q1);
    assign falling_edge_found = (Q2 && !Q1);


endmodule