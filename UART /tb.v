`timescale 1ns/1ps
module UART_tb;
reg t_clk;
reg r_clk;
reg t_rst;
reg r_rst;
reg wr_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire rdy;
uart_top_module DUT (.*);
always #10 t_clk = ~t_clk;
always #15 r_clk = ~r_clk;
initial begin
    t_clk = 0;
    r_clk = 0;
    t_rst = 1;
    r_rst = 1;
    wr_en  = 0;
    data_in = 0;
    // RESET
    #100;
    t_rst = 0;
    r_rst = 0;
    // Send data
    #100;
    data_in = 8'b10101010;
    wr_en = 1;
    #200 $finish;
end
initial begin
  $monitor("time=%0t,INPUT VALUES:t_clk=%b,r_clk=%b,t_rst=%b,r_rst=%b,data_in=%b' OUTPUT VALUES:data_out=%b",$time,t_clk,r_clk,t_rst,r_rst,data_in,data_out);
end
endmodule
