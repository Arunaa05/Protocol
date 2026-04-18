`timescale 1ns/1ps
`include "transmitter_baudrate.v"
`include"receiver_baudrate.v"
`include "transmitter.v"
`include"receiver.v"
module uart_top_module(input r_clk,
                       input t_clk,
                       input t_rst,
                       input r_rst,
                       input wr_en,
                       input [7:0] data_in,
                       output [7:0] data_out,
                       output rdy);
  wire tx_en;
  wire rx_en;
  wire tx_wire;
  // baudrate transmitter
  transmitter_baudrate tx_baud(.clk(t_clk),.rst(t_rst),.tx_en(tx_en));
  
  //baudrate receiver
  receiver_baudrate m2(.clk(r_clk),
                            .rst(r_rst),
                            .rx_en(rx_en));
  
  //transmitter
  transmitter tx_inst(.clk(t_clk),
                      .rst(t_rst),
                      .wr_en(wr_en),
                      .data_in(data_in),
                      .en(tx_en),
                      .tx(tx_wire));
    
  //receiver
  receiver rx_inst(.clk(r_clk),
                   .rst(r_rst),
                   .rx_en(rx_en),
                   .rx(tx_wire),
                   .data(data_out),
                   .rdy(rdy));
  
endmodule
