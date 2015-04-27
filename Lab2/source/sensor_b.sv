// $Id: $
// File name:   sensor_b.sv
// Created:     1/22/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: behavioral

module sensor_b
(
  input wire [3:0] sensors,
  output reg error

);

  always @ (sensors)
  begin
    error = ((sensors & sensors[1]) | (sensors[3] & sensors[1]) | (sensors[0]));
    
  end

endmodule
