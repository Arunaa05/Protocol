`timescale 1ns/1ps
module master #(parameter N=8)(
  input pclk,prst_n,transfer,write,read,pready,
  input [N-1:0]w_paddr,
  input [N-1:0]p_wdata,
  input [N-1:0]p_rdata,
  output reg pselx,
  output reg pwrite,
  output reg [N-1:0]paddr,
  output reg [N-1:0]pwdata,rdata_out,
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
      state <= idle;
      pselx <= 0;
      penable<=0;
      pwrite<=0;
      paddr <=0;
      pwdata <=0;
     end
    else begin
      case(state)
        idle:begin
          pselx <= 0;
          penable<=0;
        end
        setup:begin
          pselx <= 1;
      penable<=0;
      pwrite<=write;
      paddr <=w_paddr;
      pwdata <=p_wdata;
        end
        access:begin
          pselx <= 1;
          penable<=1;
        end
      endcase
    end   
   end
  
  endmodule
