`timescale 1ns/1ps
module apb_top(input pclk,
  input prst_n,
  input transfer,
  input write,
  input read,
  input [7:0] w_paddr,
  input [7:0] p_wdata, 
  output [7:0] rdata_out,
  output psel1,
  output psel2,
  output [7:0] prdata
  );
 
  wire psel;
  
  wire pwrite;
  wire [7:0] paddr;
  wire [7:0] pwdata;
  wire penable;
  wire pready1,pready2;
  wire [7:0] prdata1,prdata2;
  wire pready;
  //wire [N-1:0] prdata;
  

  master m1(
    .pclk(pclk),
    .prst_n(prst_n),
    .transfer(transfer),
    .write(write),
    .read(read),
    .pready(pready),
    .w_paddr(w_paddr),
    .p_wdata(p_wdata),
    .prdata(prdata),
    .psel(psel),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .rdata_out(rdata_out),
    .penable(penable)
  );
  decoder d1(
    .psel(psel),
    .psel1(psel1),
    .psel2(psel2),
    .paddr(paddr)
  );

  slave s1(
    .pclk(pclk),
    .prst_n(prst_n),
    .psel(psel1),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .penable(penable),
    .pready(pready1),
    .prdata(prdata1)
  );
  slave s2(
    .pclk(pclk),
    .prst_n(prst_n),
    .psel(psel2),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .penable(penable),
    .pready(pready2),
    .prdata(prdata2)
  );
  assign pready = psel1 ? pready1 :
                psel2 ? pready2 : 1'b0;

  assign prdata = psel1 ? prdata1 :
                psel2 ? prdata2 : 1'b0;

endmodule
