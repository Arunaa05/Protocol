`timescale  1ns/1ps
module transmitter_baudrate(input clk,rst,output reg tx_en);
  reg[12:0]tx_counter;
  always @(posedge clk or posedge rst)begin
    if(rst)begin
      tx_en<=0;
      tx_counter<=0;
    end
    else if(tx_counter==13'd5207) begin
      tx_en<=1;
      tx_counter<=0;
    end
    else begin
      tx_en<=0;
      tx_counter<=tx_counter+1;
   end
  end
endmodule
