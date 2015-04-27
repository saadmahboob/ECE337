// $Id: $
// File name:   controller.sv
// Created:     2/5/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: controller
module controller
(
    input wire clk,
    input wire n_reset,
    input wire dr,
    input wire overflow,
    output reg cnt_up,
    output wire modwait,
    output reg [1:0] op,
    output reg [3:0] src1,
    output reg [3:0] src2,
    output reg [3:0] dest,
    output reg err
);
    reg curr_modwait;
    reg next_modwait;
   
    typedef enum logic [3:0] {IDLE, STORE, SORT1, SORT2, SORT3, SORT4, ADD1, ADD2, ADD3, EIDLE}
    state_type;
    
    state_type curr_state, next_state;

    always_ff @ (posedge clk, negedge n_reset)
    begin
        if(n_reset == 0)
        begin
            curr_state <= IDLE;
            curr_modwait <= '0;
        end
        else
        begin
            curr_state <= next_state;
            curr_modwait <= next_modwait;
        end
    end


    always_comb begin
        next_state = curr_state;
        cnt_up = 1'b0;
        next_modwait = curr_modwait;    
        op = 2'b00;
        src1 = 4'h0;
        src2 = 4'h0;
        dest = 4'h0;
        err = 1'b0;

        case(curr_state) 

            IDLE      : begin

                            if(dr == 1)
                            begin
                                next_state = STORE;
                                next_modwait = 1'b1;
                            end

                            else
                            begin
                                next_state = IDLE;
                                next_modwait = 1'b0;
                            end

                            cnt_up = 1'b0;
                            op = 2'b00;
                            src1 = 4'h0;
                            src2 = 4'h0;
                            dest = 4'h0;
                            err = 1'b0;
                        end




            STORE     : begin
                            if(dr == 1)
                            begin
                                next_state = SORT1;
                                next_modwait = 1'b1;
                            end
                            else
                            begin
                                next_state = EIDLE;
                                next_modwait = 1'b0;
                            end

                            cnt_up = 1'b0;  
                            op = 2'b10;
                            src1 = 4'h0;
                            src2 = 4'h0;
                            dest = 4'h5;
                            err = 1'b0;
                        end




            SORT1     : begin
                            next_state = SORT2;
                            cnt_up = 1'b1;
                            next_modwait = 1'b1;    
                            op = 2'b01;
                            src1 = 4'h2;
                            src2 = 4'h0;
                            dest = 4'h1;
                            err = 1'b0;
                        end



            SORT2     : begin
                            next_state = SORT3;
                            cnt_up = 1'b0;
                            next_modwait = 1'b1;    
                            op = 2'b01;
                            src1 = 4'h3;
                            src2 = 4'h0;
                            dest = 4'h2;
                            err = 1'b0;
                        end




            SORT3     : begin
                            next_state = SORT4;
                            cnt_up = 1'b0;
                            next_modwait = 1'b1;    
                            op = 2'b01;
                            src1 = 4'h4;
                            src2 = 4'h0;
                            dest = 4'h3;
                            err = 1'b0;
                        end



            SORT4     : begin
                            next_state = ADD1;
                            cnt_up = 1'b0;
                            next_modwait = 1'b1;    
                            op = 2'b01;
                            src1 = 4'h5;
                            src2 = 4'h0;
                            dest = 4'h4;
                            err = 1'b0;
                        end


            ADD1     : begin
                            if(overflow == 0)
                            begin
                                next_modwait = 1'b1;
                                next_state = ADD2;
                            end
                            else
                            begin
                                next_modwait = 1'b0;
                                next_state = EIDLE;
                            end

                            cnt_up = 1'b0;
                            op = 2'b11;
                            src1 = 4'h1;
                            src2 = 4'h2;
                            dest = 4'h5;
                            err = 1'b0;
                       end



            ADD2     : begin
                            if(overflow == 0)
                            begin
                                next_state = ADD3;
                                next_modwait = 1'b1;
                            end
                            else
                            begin
                                next_state = EIDLE;
                                next_modwait = 1'b0;
                            end

                            cnt_up = 1'b0;   
                            op = 2'b11;
                            src1 = 4'h3;
                            src2 = 4'h4;
                            dest = 4'h6;
                            err = 1'b0;
                       end




            ADD3     :    begin
                            if(overflow == 0)
                            begin
                                next_state = IDLE;
                                next_modwait = 1'b0;
                            end

                            else
                            begin
                                next_state = EIDLE;
                                next_modwait = 1'b0;
                            end

                            cnt_up = 1'b0;
                            op = 2'b11;
                            src1 = 4'h5;
                            src2 = 4'h6;
                            dest = 4'h0;
                            err = 1'b0;
                          end



            EIDLE    :    begin
                            if(dr == 1)
                            begin
                                next_state = STORE;
                                next_modwait = 1'b1;
                            end
                            else
                            begin
                                next_state = EIDLE;
                                next_modwait = 1'b0;
                            end
                            
                            cnt_up = 1'b0;   
                            op = 2'b00;
                            src1 = 4'h0;
                            src2 = 4'h0;
                            dest = 4'h0;
                            err = 1'b1;                           
                          end

        endcase
    end


    assign modwait = curr_modwait;

endmodule


