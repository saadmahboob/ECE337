// $Id: $
// File name:   sensor_s.sv
// Created:     1/22/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: sensor detect
module sensor_s
(

   
   input wire [3:0] sensors,
   output wire error
   
);
  wire temp1;
  wire temp2;
  wire temp3;
  
  and A1 (temp1, sensors[2], sensors[1]);
  and A2 (temp2, sensors[3], sensors[1]);
  or OR1 (temp3, temp1, temp2);
  or OR2 (error, temp3, sensors[0]);
  
endmodule
