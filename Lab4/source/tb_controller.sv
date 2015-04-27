// $Id: $
// File name:   tb_controller.sv
// Created:     2/7/2015
// Author:      John Busch Jr.
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench file for the main controller of the averager

`timescale 1ns / 10ps

module tb_controller();
  // Define parameters
	localparam	CLK_PERIOD	= 5; // 200MHz clock
	localparam	CHECK_DELAY = 2; // Check 2ns after the rising edge to allow for propagation delay
	localparam NEW_SAMPLE_REGISTER = 4'h5; // will be moved into SAMPLE_4_REGISTER during SORT4
	localparam SAMPLE_4_REGISTER = 4'h4;   // will be moved into SAMPLE_3_REGISTER during SORT3
	localparam SAMPLE_3_REGISTER = 4'h3;   // will be moved into SAMPLE_2_REGISTER during SORT2
	localparam SAMPLE_2_REGISTER = 4'h2;   // will be moved into SAMPLE_1_REGISTER during SORT1
	localparam SAMPLE_1_REGISTER = 4'h1;   // will be overwritten during SORT1
	localparam SUM_2_REGISTER = 4'h6; // intermediate sum 2, SAMPLE_3_REGISTER + SAMPLE_4_REGISTER
	localparam SUM_1_REGISTER = 4'h5; // intermediate sum 1, SAMPLE_1_REGISTER + SAMPLE_2_REGISTER
	localparam TOTAL_REGISTER = 4'h0; // output register for final sum from datapath
  
  integer tb_test_num;
  reg tb_clk;
  reg tb_dut_n_reset;
  reg tb_dut_dr;
  reg tb_dut_overflow;
  reg tb_dut_cnt_up;
  reg tb_dut_modwait;
  reg [1:0] tb_dut_op;
  reg [3:0] tb_dut_src1;
  reg [3:0] tb_dut_src2;
  reg [3:0] tb_dut_dest;
  reg tb_dut_err;
  reg tb_dut_expected_cnt_up;
  reg tb_dut_expected_modwait;
  reg [1:0] tb_dut_expected_op;
  reg [3:0] tb_dut_expected_src1;
  reg [3:0] tb_dut_expected_src2;
  reg [3:0] tb_dut_expected_dest;
  reg tb_dut_expected_err;
  
  controller DUT (
    .clk(tb_clk),
    .n_reset(tb_dut_n_reset),
    .dr(tb_dut_dr),
    .overflow(tb_dut_overflow),
    .cnt_up(tb_dut_cnt_up),
    .modwait(tb_dut_modwait),
    .op(tb_dut_op),
    .src1(tb_dut_src1),
    .src2(tb_dut_src2),
    .dest(tb_dut_dest),
    .err(tb_dut_err)
  );
  
  // Generate clock signal
	always begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	// Test bench procedures
  initial begin
    // Initialize input signals
    tb_test_num = 0;
    tb_dut_n_reset = 1'b1;
    tb_dut_dr = 1'b0;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
	  // Initial device power on
	  #(0.1)
	  tb_dut_n_reset = 1'b0;
	  #(CLK_PERIOD * 2.25) // Come out of reset asynchronously
	  tb_dut_n_reset = 1'b1;
	  #(CLK_PERIOD) // Wait for device to stabalize
    
    // Test 1: check for proper reset with idle inputs
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b0;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 2: check for proper reset with active inputs
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b1;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 3: check store state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b10;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = NEW_SAMPLE_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into store state
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 4: check store state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 5: check Sort1 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b1;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b01;
    tb_dut_expected_src1 = SAMPLE_2_REGISTER;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = SAMPLE_1_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into sort1 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 6: check Sort1 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 7: check Sort2 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b01;
    tb_dut_expected_src1 = SAMPLE_3_REGISTER;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = SAMPLE_2_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Sort2 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 8: check Sort2 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 9: check Sort3 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b01;
    tb_dut_expected_src1 = SAMPLE_4_REGISTER;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = SAMPLE_3_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Sort3 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 10: check Sort3 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 11: check Sort4 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b01;
    tb_dut_expected_src1 = NEW_SAMPLE_REGISTER;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = SAMPLE_4_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Sort4 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 12: check Sort4 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 13: check Add1 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b11;
    tb_dut_expected_src1 = SAMPLE_3_REGISTER;
    tb_dut_expected_src2 = SAMPLE_4_REGISTER;
    tb_dut_expected_dest = SUM_2_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add1 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_src2 == tb_dut_expected_src2 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 14: check Add1 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 15: check Add2 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b11;
    tb_dut_expected_src1 = SAMPLE_1_REGISTER;
    tb_dut_expected_src2 = SAMPLE_2_REGISTER;
    tb_dut_expected_dest = SUM_1_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add2 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_src2 == tb_dut_expected_src2 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 16: check Add2 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 17: check Add3 state
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b11;
    tb_dut_expected_src1 = SUM_1_REGISTER;
    tb_dut_expected_src2 = SUM_2_REGISTER;
    tb_dut_expected_dest = TOTAL_REGISTER;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add3 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_src1 == tb_dut_expected_src1 &&
            tb_dut_src2 == tb_dut_expected_src2 &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 18: check Add3 state reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 19: check rollover to idle
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into idle state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 20: check eidle entry from loss of data ready signal
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b1;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into store state
    @(posedge tb_clk)
    @(negedge tb_clk)
    // Turn off data read line
    tb_dut_dr = 1'b0;
    // Clock into eidle state
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 21: check eidle remains in eidle
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b1;
    tb_dut_dr = 1'b0;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b1;
    
    // Clock remain in eidle state
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 22: check re-enter to store state after data ready asserted
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b1;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b1;
    tb_dut_expected_op = 2'b10;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = NEW_SAMPLE_REGISTER;
    tb_dut_expected_err = 1'b0;
    
    // Clock enter store state
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_dest == tb_dut_expected_dest &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 23: check eidle enter to idle after reset
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b1;
    tb_dut_dr = 1'b0;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b0;
    
    // clock in to eidle
    @(posedge tb_clk)
    // Reset on negative edge
    @(negedge tb_clk)
    tb_dut_n_reset = 1'b0;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 24: check Add1 to eidle on overflow
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b1;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add1 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(negedge tb_clk)
    tb_dut_overflow = 1'b1;
    // Clock into eidle
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 25: check Add2 to eidle on overflow
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b1;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add2 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(negedge tb_clk)
    tb_dut_overflow = 1'b1;
    // Clock into eidle
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
    // Test 26: check Add3 to eidle on overflow
    @(negedge tb_clk) // Toggle inputs after falling edge of clock
    tb_test_num = tb_test_num + 1;
    tb_dut_n_reset = 1'b0;
    tb_dut_dr = 1'b1;
    tb_dut_overflow = 1'b0;
    tb_dut_expected_cnt_up = 1'b0;
    tb_dut_expected_modwait = 1'b0;
    tb_dut_expected_op = 2'b00;
    tb_dut_expected_src1 = 4'h0;
    tb_dut_expected_src2 = 4'h0;
    tb_dut_expected_dest = 4'h0;
    tb_dut_expected_err = 1'b1;
	  #(CLK_PERIOD * 2)  // Let device reset for a clock period
	  @(negedge tb_clk)  // Release reset at falling edge of clock
	  tb_dut_n_reset = 1'b1;
    
    // Clock into Add3 state
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(posedge tb_clk)
    @(negedge tb_clk)
    tb_dut_overflow = 1'b1;
    // Clock into eidle
    @(posedge tb_clk)
    // Wait for propagation delay
    #(CHECK_DELAY)
    
    // Check outputs against expected
    assert (tb_dut_cnt_up == tb_dut_expected_cnt_up &&
            tb_dut_modwait == tb_dut_expected_modwait &&
            tb_dut_op == tb_dut_expected_op &&
            tb_dut_err == tb_dut_expected_err)
			$info("Controller Case %0d:: PASSED", tb_test_num);
		else
		  $error("Controller Case %0d:: FAILED", tb_test_num);
    
  end
endmodule