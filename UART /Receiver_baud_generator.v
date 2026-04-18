`timescale 1ns/1ps
module receiver_baudrate(input clk,rst,output reg rx_en);
  reg[9:0]rx_counter;
  always @(posedge clk or posedge rst)begin
    if(rst)begin
      rx_en<=0;
      rx_counter<=0;end
      else if(rx_counter==10'd651) begin
      rx_en<=1;
        rx_counter<=0;end
    else begin
      rx_en<=0;
      rx_counter<=rx_counter+1;
    end
  end
endmodule
