`timescale 1ns/1ps      
module slave #(parameter N=8)(
  input pclk,
  input prst_n,
  input pselx,
  input pwrite,
  input [N-1:0]paddr,
  input [N-1:0]pwdata,
  input penable,
  output reg pready,
  output reg [N-1:0]prdata
);
  reg [N-1:0] mem[255:0];
  always@(posedge pclk)begin
    if(!prst_n)begin
      pready<=0;
      prdata<=0;
    end
    else begin
      pready<=0;
      if(pselx && penable)begin
        pready=1;
        if(pwrite)
          mem[paddr]<=pwdata;
        else
          prdata<=mem[paddr];
      end
    end
  end
endmodule
