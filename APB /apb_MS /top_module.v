`timescale 1ns/1ps
module apb_top #(parameter N=8);
  reg pclk;
  reg prst_n;
  reg transfer;
  reg write;
  reg read;
  reg  [N-1:0] w_paddr;
  reg  [N-1:0] p_wdata;
  wire pselx;
  wire pwrite;
  wire [N-1:0] paddr;
  wire [N-1:0] pwdata;
  wire penable;
  wire pready;
  wire [N-1:0] prdata;
  wire [N-1:0] rdata_out;

  master #(N) u_master (
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

  slave #(N) u_slave (
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

endmodule
