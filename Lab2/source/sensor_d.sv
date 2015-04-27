// $Id: $
// File name:   sensor_d.sv
// Created:     1/22/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: sensor_d
module sensor_d
(
  input wire [3:0] sensors,
  output wire error
);

  wire temp1;
  wire temp2;
  wire temp3;
  
  assign temp1 = (sensors[2] & sensors[1]);  
  assign temp2 = (sensors[3] & sensors[1]);
  assign temp3 = (temp1 | temp2);
  assign error = (temp3 | sensors[0]);
  
endmodule

