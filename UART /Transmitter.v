module transmitter(input clk,
                   input wr_en,en,
                   input rst,
                   input [7:0]data_in,
                   output reg tx
                  );
  parameter idle_state=2'b00,
            start_state = 2'b01,
            data_state = 2'b10,
            stop_state = 2'b11;
  
  reg [7:0]data;
  reg[1:0]state,next;
  reg[2:0]counter;
  integer i;
  //sequential block
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      state<=idle_state;
       tx<=1;
       counter<=0;
    end
    else 
      state<=next;
    end
  //combinational
  always@(*)begin
    next=state;
    case(state)
      idle_state:begin
        if(wr_en)
          next=start_state;
        else
          next=idle_state;
      end
      
      start_state:begin
        if(en) begin
          tx=1'b0;
          next=data_state;
        end
        else
          next=start_state;
      end
      
      data_state:begin
        if(en) begin
          tx=data_in[counter];
          counter=counter+1;
          next=data_state;
        end
        else if(counter==3'd7)
          next=stop_state;
      end
      
      stop_state:begin
        if(en) begin
          next=idle_state;
          tx=1'b1;
        end
        else
          next=stop_state;
      end
    endcase
  end
endmodule
