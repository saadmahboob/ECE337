// $Id: $
// File name:   sync.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: synchronizer
module sync
(
  input wire clk,
  input wire n_reset,
  input wire async_in,
  output reg sync_out
);

reg Q1;


always_ff @ (posedge clk, negedge n_reset) begin : Sync

  if(1'b0 == n_reset) begin
    Q1 <= 0; sync_out <= 0;

  end else begin
    Q1 <= async_in;
    sync_out <= Q1;
  end
  
end


endmodule
