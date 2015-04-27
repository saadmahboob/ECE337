// $Id: $
// File name:   tb_rcu.sv
// Created:     2/10/2015
// Author:      Subhav Ramachandran
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Receiver Control Unit Testbench

`timescale 1ns / 10ps

module tb_rcu ();

	typedef enum bit[2:0] {
		START,
		PACKET_DONE,
		CHECK_FRAME,
		LOAD,
		IDLE
	} rcu_state;

	localparam CLOCK_PER = 2.5;
	localparam CHECK_DELAY = 1;

	reg tb_clk;
	reg tb_n_rst;
	reg tb_start_bit_detected;
	reg tb_packet_done;
	reg tb_framing_error;
	reg tb_sbc_clear;
	reg tb_sbc_enable;
	reg tb_load_buffer;
	reg tb_enable_timer;

	// Generate clock.
	always begin 
		tb_clk = 0;
		#(CLOCK_PER / 2);
		tb_clk = 1;
		#(CLOCK_PER / 2);
	end

	function check_state;
		input rcu_state state;
	
		case (state)
			IDLE: 
				check_state = (tb_sbc_clear == 0)
						&& (tb_sbc_enable == 0)
						&& (tb_load_buffer == 0)
						&& (tb_enable_timer == 0);
			
			START:
				check_state = (tb_sbc_clear == 1)
						&& (tb_sbc_enable == 0)
						&& (tb_load_buffer == 0)
						&& (tb_enable_timer == 1);

			PACKET_DONE:
				check_state = (tb_sbc_clear == 0)
						&& (tb_sbc_enable == 1)
						&& (tb_load_buffer == 0)
						&& (tb_enable_timer == 0);

			CHECK_FRAME:
				check_state = (tb_sbc_clear == 0)
						&& (tb_sbc_enable == 0)
						&& (tb_load_buffer == 0)
						&& (tb_enable_timer == 0);

			LOAD:
				check_state = (tb_sbc_clear == 0)
						&& (tb_sbc_enable == 0)
						&& (tb_load_buffer == 1)
						&& (tb_enable_timer == 0);
		endcase
	endfunction

	int test_i = 1; // Index of current test.

	/*
	 * display_assertion(condition, test_info);
	 */
	task display_assertion;
		input condition;
		input string test_info;
		
	begin 
		assert(condition)
			$info("PASSED Test %d: %s", test_i, test_info);
		else
			$error("FAILED Test %d: %s", test_i, test_info);

		test_i++;
	end
	endtask 

	/*
	 * run_test(start_bit_detected, packet_done, framing_error, state,
	 * 		test_info)
	 * 
	 * Change the inputs to the DUT, and check that looks like it's in
	 * the right state.
	 */
	task run_test;
		input start_bit_detected;
		input packet_done;
		input framing_error;

		input rcu_state state;

		input string test_info;

	begin 
		// Change values on the next negative edge.
		@(negedge tb_clk);
		tb_start_bit_detected = start_bit_detected;
		tb_packet_done = packet_done;
		tb_framing_error = framing_error;

		// Check output values.
		@(posedge tb_clk);
		#(CHECK_DELAY);
		display_assertion(check_state(state), test_info);
	end
	endtask

	/*
	 * reset()
	 *
	 * Assert then release n_rst.
	 *
	 * Should reset before starting any test.
	 */
	task reset;
		begin
			@(negedge tb_clk);
			tb_n_rst = 0;
			@(posedge tb_clk);
			tb_n_rst = 1;
		end
	endtask

	rcu DUT(
		.clk               (tb_clk),
		.n_rst             (tb_n_rst),
		.start_bit_detected(tb_start_bit_detected),
		.packet_done       (tb_packet_done),
		.framing_error     (tb_framing_error),
		.sbc_clear         (tb_sbc_clear),
		.sbc_enable        (tb_sbc_enable),
		.load_buffer       (tb_load_buffer),
		.enable_timer      (tb_enable_timer)
	);

	initial begin 
		// Set all the inputs to zero initially.
		tb_n_rst = 0;
		tb_start_bit_detected = 0;
		tb_packet_done = 0;
		tb_framing_error = 0;

		#(CLOCK_PER);

		// Test 1: IDLE state out of reset.
		reset();
		run_test(0, 0, 0, IDLE, "IDLE state out of reset.");

		// Test 2: Normal Operation
		begin : TEST_1
			reset();
			run_test(0, 0, 0, IDLE, "Remain in IDLE state.");
			run_test(0, 0, 0, IDLE, "Remain in IDLE state.");
			run_test(0, 0, 0, IDLE, "Remain in IDLE state.");
			run_test(1, 0, 0, START, "Move to START state.");
			run_test(0, 0, 0, START, "Remain in START state.");
			run_test(1, 0, 0, START, "Remain in START state.");
			run_test(0, 1, 0, PACKET_DONE, "Move to PACKET_DONE state.");
			run_test(0, 1, 0, CHECK_FRAME, "Move to CHECK_FRAME state.");
			run_test(0, 0, 1, CHECK_FRAME, "Move to IDLE state because of framing error.");

			reset();
			run_test(1, 0, 0, START, "Move to START state.");
			run_test(0, 1, 0, PACKET_DONE, "Move to PACKET_DONE state.");
			run_test(0, 0, 0, CHECK_FRAME, "Move to CHECK_FRAME state.");
			run_test(0, 0, 0, LOAD, "Move to LOAD state.");
			run_test(0, 0, 0, IDLE, "Move back to IDLE");

		end

		// Test 3: Move up to each state, then reset to cover FSM transitions.
		begin : TEST_2
			reset();
			run_test(1, 0, 0, START, "Move to START state.");
			reset();
			display_assertion(check_state(IDLE), "Reset to IDLE state.");

			reset();
			run_test(1, 0, 0, START, "Move to START state.");
			run_test(0, 1, 0, PACKET_DONE, "Move to PACKET_DONE state.");
			reset();
			display_assertion(check_state(IDLE), "Reset to IDLE state.");

			reset();
			run_test(1, 0, 0, START, "Move to START state.");
			run_test(0, 1, 0, PACKET_DONE, "Move to PACKET_DONE state.");
			run_test(0, 0, 0, CHECK_FRAME, "Move to CHECK_FRAME state.");
			reset();
			display_assertion(check_state(IDLE), "Reset to IDLE state.");

			reset();
			run_test(1, 0, 0, START, "Move to START state.");
			run_test(0, 1, 0, PACKET_DONE, "Move to PACKET_DONE state.");
			run_test(0, 0, 0, CHECK_FRAME, "Move to CHECK_FRAME state.");
			run_test(0, 0, 0, LOAD, "Move to LOAD state.");
			reset();
			display_assertion(check_state(IDLE), "Reset to IDLE state.");
		end
	end	

endmodule