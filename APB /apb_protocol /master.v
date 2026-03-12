`timescale 1ns/1ps
module master(
  input pclk,prst_n,transfer,write,read,pready,
  input [7:0]w_paddr,
  input [7:0]p_wdata,
  input [7:0]prdata,
  output reg psel,
  output reg pwrite,
  output reg [7:0]paddr,
  output reg [7:0]pwdata,rdata_out,
  output reg penable
);
  parameter  idle =2'b00,
            setup =2'b01,
            access =2'b10;
  reg [1:0]state,next_state;          
  always@(posedge pclk)begin
    if(!prst_n)
      state <= idle;
    else
      state <= next_state;
  end
  always@(state,transfer,pready)
    begin
      next_state<= state;
      case(state)
        idle:begin
             if(transfer)
               next_state<=setup;
        end
        setup:begin
              next_state<=access;
        end
        access:begin
          if(pready)begin
            if(transfer)
              next_state<=setup;
            else
              next_state<=idle;
          end
          else
            next_state<=access;
          end
        default: next_state<=idle;
      endcase
     end
  always@(posedge pclk)begin
     if(!prst_n) begin
      psel <= 0;
      penable<=0;
      pwrite<=0;
      paddr <=0;
      pwdata <=0;
     end
    else begin
      case(state)
        idle:begin
          psel <= 0;
          penable<=0;
        end
        setup:begin
          psel<=1;
      penable<=0;
      pwrite<=write;
      paddr <=w_paddr;
      pwdata <=p_wdata;
        end
        access:begin
          psel <=1;
          penable<=1;
        end
      endcase
    end   
   end
  always @(posedge pclk or negedge prst_n) begin
    if(!prst_n)
      rdata_out<=0;
    else if(psel && penable && !pwrite && pready)
      rdata_out<=prdata;
  end
  endmodule
