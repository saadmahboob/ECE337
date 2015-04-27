// $Id: $
// File name:   decode.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: Decode Block
module decode
(
	input wire clk,
	input wire n_rst,
	input wire scl,
	input wire sda_in,
	input wire [7:0] starting_byte,
	output wire rw_mode,
	output wire address_match,
	output wire stop_found,
	output wire start_found
);

	reg sda_1;
	reg sda_2;

	reg scl_1;
	reg scl_2;



	always_ff @ (posedge clk, negedge n_rst)
    begin
    	if(n_rst == 0) 
    	begin
    		sda_1 <= 1'b1;
    		sda_2 <= 1'b1;

    		scl_1 <= scl;
    		scl_2 <= scl;
    	end

    	else 
    	begin
    		sda_1 <= sda_in;
    		sda_2 <= sda_1;

    		scl_1 <= scl;
    		scl_2 <= scl_1;
    	end
    end

    assign rw_mode = starting_byte[0];
    assign address_match = (starting_byte[7:1] == 7'b1111000);

    assign stop_found = (!sda_2 && scl_2 && sda_1 && scl_1);
    assign start_found = (sda_2 && scl_2 && !sda_1 && scl_1);













	




endmodule
