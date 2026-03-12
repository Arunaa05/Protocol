`timescale 1ns/1ps      
module slave(
  input pclk,
  input prst_n,
  input psel,
  input pwrite,
  input [7:0]paddr,
  input [7:0]pwdata,
  input penable,
  output reg pready,
  output reg [7:0]prdata
);
  reg [7:0] mem[255:0];
  integer i;
  initial begin
    for(i=0;i<256;i=i+1)
         mem[i] = 0;
  end
  always@(posedge pclk)begin
    if(!prst_n)begin
      pready<=1'b1;
      prdata<=8'b0;
    end
    else begin
      if(psel && penable && pwrite)begin
          pready<=1;
          mem[paddr[6:0]]<=pwdata;
      end
      else if(psel && penable && !pwrite)begin
          prdata<=mem[paddr[6:0]];
          pready<=1;
      end
      else
         pready<=1;
    end
  end
endmodule
