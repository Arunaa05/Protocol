 module receiver(input clk,
                input rst,rx_en,rx,
                output reg [7:0]data,
                output reg rdy);
  parameter start_state=2'b00,
            data_out_state=2'b01,
            stop_state=2'b10;
  reg[1:0]state,next_state;
  reg[3:0] count;
  reg data_sam;
  reg [2:0] num;
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      state<=start_state;
    end else begin
        state<=next_state;
    end
  end
    
  
  
 always@(posedge clk or posedge rst) begin
   if(rst)begin
    count <= 0;
     data=0;
   end
  else if(rx_en) begin
    if(count == 15)
      count<=0;
    else
      count <= count + 1;
  end
 end
  always@(posedge clk) begin
    if((count==7)&&(state==start_state)) begin
        data_sam<=rx;
        num<=0;
      end
    else if((count==7)&&(state==data_out_state))begin
      data[num]<=rx;
    end
    else if ((count==15)&&(state==data_out_state))
      num<=num+1;
    else if((count==7)&&(state==stop_state))
     data_sam<=rx;
  end
  always@(*)begin
        next_state=state;
    case(state)   
          start_state:begin
            if((!(data_sam))&&(count==15))begin
              next_state=data_out_state;
              rdy=0;
            end
          end
           data_out_state:begin  
             if((num==7)&&(count==15))begin
              next_state=stop_state;
               num=0;
               rdy=0;
             end
          end
          stop_state:begin
            if ((data_sam)&&(count==15))begin
              next_state=start_state;
              rdy=1;
            end
          end
      endcase
  end
endmodule

  
endmodule
