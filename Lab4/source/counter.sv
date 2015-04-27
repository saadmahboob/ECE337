// $Id: $
// File name:   counter.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: counter module
module counter
(
    input wire clk,
    input wire n_reset,
    input wire cnt_up,
    output wire one_k_samples
);

    reg [9:0] dc;

    flex_counter #(10) CNT
    (
        .clk(clk), 
        .n_rst(n_reset),
        .clear(1'b0), 
        .count_enable(cnt_up), 
        .rollover_val(10'd1000),
        .count_out(dc),
        .rollover_flag(one_k_samples)
       
    );



endmodule
