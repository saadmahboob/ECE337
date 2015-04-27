// $Id: $
// File name:   i2c_slave.sv
// Created:     2/19/2015
// Author:      Isaac Sheeley
// Lab Section: 4
// Version:     1.0  Initial Design Entry
// Description: i2c slave
module i2c_slave 
(
	input wire clk,
	input wire n_rst,
	input wire scl,
	input wire sda_in,
	input wire write_enable,
	input wire [7:0] write_data,
	output reg sda_out,
	output reg fifo_empty,
	output reg fifo_full
);
	reg rising_edge_found;
	reg falling_edge_found;
	reg [7:0]rx_data;
	reg rw_mode;
	reg tx_out;
	reg [7:0]read_data;
	reg load_data;
	reg tx_enable;
	reg rx_enable;
	reg address_match;
	reg ack_prep;
	reg check_ack;
	reg ack_done;	
	reg read_enable;
	reg [1:0]sda_mode;
	reg byte_received;
	reg start_found;
	reg stop_found;
	



	scl_edge DUT_SCL_EDGE
	(
		.clk               (clk),
		.n_rst             (n_rst),
		.scl               (scl),
		.rising_edge_found (rising_edge_found),
		.falling_edge_found(falling_edge_found)
	);


	decode DUT_DECODE 
	(
		.clk          (clk),
		.n_rst        (n_rst),
		.scl          (scl),
		.sda_in       (sda_in),
		.starting_byte(rx_data),
		.rw_mode      (rw_mode),
		.address_match(address_match),
		.stop_found   (stop_found),
		.start_found  (start_found)

	);

	rx_sr DUT_RX_SR
	(
		.clk              (clk),
		.n_rst            (n_rst),
		.sda_in           (sda_in),
		.rising_edge_found(rising_edge_found),
		.rx_enable        (rx_enable),
		.rx_data          (rx_data)
	);

	sda_sel DUT_SDA_SEL
	(
		.tx_out  (tx_out),
		.sda_mode(sda_mode),
		.sda_out (sda_out)
	);

	tx_sr DUT_TX_SR
	(
		.clk               (clk),
		.n_rst             (n_rst),
		.falling_edge_found(falling_edge_found),
		.tx_enable         (tx_enable),
		.tx_data           (read_data),
		.load_data         (load_data),
		.tx_out            (tx_out)
	);

	timer DUT_TIMER
	(
		.clk               (clk),
		.n_rst             (n_rst),
		.rising_edge_found (rising_edge_found),
		.falling_edge_found(falling_edge_found),
		.stop_found        (stop_found),
		.start_found       (start_found),
		.byte_received     (byte_received),
		.ack_prep          (ack_prep),
		.check_ack         (check_ack),
		.ack_done          (ack_done)
	);

	controller DUT_CONTROLLER 
	(
		.clk          (clk),
		.n_rst        (n_rst),
		.stop_found   (stop_found),
		.start_found  (start_found),
		.byte_received(byte_received),
		.ack_prep     (ack_prep),
		.check_ack    (check_ack),
		.ack_done     (ack_done),
		.rw_mode      (rw_mode),
		.address_match(address_match),
		.sda_in       (sda_in),
		.rx_enable    (rx_enable),
		.tx_enable    (tx_enable),
		.read_enable  (read_enable),
		.sda_mode     (sda_mode),
		.load_data    (load_data)
	);

	tx_fifo DUT_TX_FIFO
	(
		.clk         (clk),
		.n_rst       (n_rst),
		.read_enable (read_enable),
		.write_enable(write_enable),
		.write_data  (write_data),
		.read_data   (read_data),
		.fifo_empty  (fifo_empty),
		.fifo_full   (fifo_full)
	);


endmodule