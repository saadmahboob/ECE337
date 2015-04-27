// $Id: $
// File name:   timer.sv
// Created:     2/12/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: timer block
module timer 
(
	input wire clk,
	input wire n_rst,
	input wire enable_timer,
	output wire shift_strobe,
	output wire packet_done
);
    reg [3:0]count_out1;
    reg [3:0]count_out2;

    reg ff_1;
    //reg ff_2;
    reg delayed_enable_timer;


    flex_counter #(4) count_to_10
    (
        .clk(clk),
 	    .n_rst(n_rst),
 	    .clear(packet_done),
 	    .count_enable(delayed_enable_timer),
 	    .rollover_val(4'd10),
 	    .count_out(count_out1),
 	    .rollover_flag(shift_strobe)
    );


    flex_counter #(4) count_to_9
    (
        .clk(clk),
        .n_rst(n_rst),
        .clear(packet_done),
        .count_enable(shift_strobe),
        .rollover_val(4'd9),
        .count_out(count_out2),
        .rollover_flag(packet_done)
    );


    always_ff @ (posedge clk, negedge n_rst) 
    begin
        if(n_rst == 0) 
        begin 
            ff_1 <= 0;
            //ff_2 <= 0;
            delayed_enable_timer <= 0;
        end
        else 
        begin
            ff_1 <= enable_timer;
            delayed_enable_timer <= ff_1;
            //delayed_enable_timer <= ff_2;
        end


    end

endmodule