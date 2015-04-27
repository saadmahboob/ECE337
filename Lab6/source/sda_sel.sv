// $Id: $
// File name:   sda_sel.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: SDA_Out Select Block Description
module sda_sel
(
	input wire tx_out,
	input wire [1:0] sda_mode,
	output reg sda_out
);

	always @ (sda_mode, tx_out)
	begin
		sda_out = 1'b1;
		case(sda_mode) 

            2'b00: 
            	sda_out = 1'b1;

            2'b01:
            	sda_out = 1'b0;

            2'b10:
            	sda_out = 1'b1;

            2'b11:
	            sda_out = tx_out;
	    endcase

	end


endmodule