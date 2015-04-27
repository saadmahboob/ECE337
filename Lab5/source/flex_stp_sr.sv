// $Id: $
// File name:   flex_stp_sr.sv
// Created:     1/29/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: Flexible and Scalable S2P Shift Reg
module flex_stp_sr
#(
  NUM_BITS = 4,
  SHIFT_MSB = 1
)
  
(
  input wire clk, n_rst, shift_enable, serial_in,
  output reg [NUM_BITS-1:0]parallel_out

);

  reg [(NUM_BITS - 1):0] next_state;



  always_ff @ (posedge clk, negedge n_rst)
  begin
    
    if( n_rst == 0)
      parallel_out <= '1;
    else
      parallel_out <= next_state;
        
  end
  
  
  always_comb
  begin
    
    if(shift_enable == 1)
    begin
      
      if (SHIFT_MSB == 1)
        next_state = {parallel_out[NUM_BITS-2:0], serial_in};
      
      else
        next_state = { serial_in, parallel_out[NUM_BITS-1:1]};

    end
    else
        next_state = parallel_out;
  
  end
  
  


endmodule