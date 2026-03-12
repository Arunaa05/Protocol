`timescale 1ns/1ps
module apb_top_tb;
parameter N = 8;
reg pclk;
reg prst_n;
reg transfer;
reg write;
reg read;
reg [N-1:0] w_paddr;
reg [N-1:0] p_wdata;
wire pselx;
wire pwrite;
wire [N-1:0] paddr;
wire [N-1:0] pwdata;
wire penable;
wire pready;
wire [N-1:0] prdata;
wire [N-1:0] rdata_out;

master #(N) DUT_master (
  .pclk(pclk),
  .prst_n(prst_n),
  .transfer(transfer),
  .write(write),
  .read(read),
  .pready(pready),
  .w_paddr(w_paddr),
  .p_wdata(p_wdata),
  .p_rdata(prdata),
  .pselx(pselx),
  .pwrite(pwrite),
  .paddr(paddr),
  .pwdata(pwdata),
  .rdata_out(rdata_out),
  .penable(penable)
);

slave #(N) DUT_slave (
  .pclk(pclk),
  .prst_n(prst_n),
  .pselx(pselx),
  .pwrite(pwrite),
  .paddr(paddr),
  .pwdata(pwdata),
  .penable(penable),
  .pready(pready),
  .prdata(prdata)
);

always #5 pclk = ~pclk;
initial begin
  pclk = 0;
  prst_n = 0;
  transfer = 0;
  write = 0;
  read = 0;
  w_paddr = 0;
  p_wdata = 0;


  #20 prst_n = 1;
  #10;
  transfer = 1;
  write = 1;
  read = 0;
  w_paddr = 8'h02;
  p_wdata = 8'h55;

  #20 transfer = 0;
  write = 0;

  #20;
  transfer = 1;
  read = 1;
  write = 0;
  w_paddr = 8'h02;

  #20 transfer = 0;
  read = 0;

  #50 $finish;
end
initial begin
  $dumpfile("apb_top.vcd");
  $dumpvars(1, apb_top_tb);
end
initial begin
  $monitor("time=%0t | psel=%b penable=%b pwrite=%b paddr=%h pwdata=%h prdata=%h rdata_out=%h",
           $time, pselx, penable, pwrite, paddr, pwdata, prdata, rdata_out);
end

endmodule
