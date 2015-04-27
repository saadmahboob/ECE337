// $Id: $
// File name:   flex_counter.sv
// Created:     2/2/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: flexible counter
module flex_counter
#(
  NUM_CNT_BITS = 4
)
  
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [NUM_CNT_BITS-1:0] rollover_val,
  output wire [NUM_CNT_BITS-1:0] count_out,
  output reg rollover_flag

);

  reg [NUM_CNT_BITS-1:0]curr_count;
  reg [NUM_CNT_BITS-1:0]next_count;
  reg curr_roll_flag;
  reg next_roll_flag;
  


  always_ff @ (posedge clk, negedge n_rst)
  begin
    
    if( n_rst == 0)
    begin
      curr_count <= '0;
      curr_roll_flag <= '0;     
    end
      
    else
    begin
      curr_count <= next_count;
      curr_roll_flag <= next_roll_flag;
    end
        
        
  end
  
  
  always_comb
  begin
    
    if(clear == 1)
    begin
      next_count = '0;
      next_roll_flag = '0;
    end



    
    else
    begin 



      
      if(count_enable == 1)
      begin
      
        next_count = curr_count + 1;
        next_roll_flag = 1'b0;
        if(next_count == (rollover_val + 1))
        begin
        
            next_count = 1;
            
        
        end
        if(next_count == rollover_val)
            next_roll_flag = 1'b1;
        
      end
      
      
      
      else
      begin
        next_roll_flag = curr_roll_flag;
        next_count = curr_count;
      end


      
    end
    
    
    
  end
  
  assign count_out = curr_count;
  assign rollover_flag = curr_roll_flag;


endmodule
