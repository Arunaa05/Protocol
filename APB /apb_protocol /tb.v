`timescale 1ns/1ps
module tb;
reg pclk;
reg prst_n;
reg transfer;
reg write;
reg read;
reg [7:0] w_paddr;
reg [7:0] p_wdata;
wire psel;
wire psel1;
wire psel2;
wire pwrite;
wire [7:0] paddr;
wire [7:0] pwdata;
wire penable;
wire pready;
wire pready1;
wire pready2;
wire [7:0] prdata;
wire [7:0] prdata1;
wire [7:0] prdata2;
wire [7:0] rdata_out;

apb_top dut(.*);
always #5 pclk = ~pclk;
initial begin
pclk = 0;
prst_n = 0;
transfer = 0;
write = 0;
read = 0;
w_paddr = 0;
p_wdata = 0;

#20;
prst_n = 1;

#10;
transfer = 1;
write = 1;
read = 0;
w_paddr = 8'b00000010;   
p_wdata = 8'd5;

#40;
transfer = 0;

#10;
transfer = 1;
write = 1;
read = 0;
w_paddr = 8'b00000100;   
p_wdata = 8'd7;

#40;
transfer = 0;


#10;
transfer = 1;
write = 0;
read = 1;
w_paddr = 8'b00000010;

#40;
transfer = 0;
  
#10;
transfer = 1;
write = 0;
read = 1;
w_paddr = 8'b00000100;   
p_wdata = 8'd7;

#40;
transfer = 0;
#100;
$finish;
end
initial begin
    $dumpfile("apb_top.vcd");
    $dumpvars(1,tb);
    $monitor("time=%0t pclk=%b prst_n=%b transfer=%b write=%b w_paddr=%d p_wdata=%d prdata=%h rdata_out=%h psel1=%b psel2=%b penable=%b psel=%b pready=%b pwrite=%b",
          $time,pclk,prst_n,transfer,write,w_paddr,p_wdata,prdata,rdata_out,psel1,psel2,dut.penable,dut.psel,dut.pready,dut.pwrite);
end
endmodule
