module decoder(
  input psel,
  input [7:0] paddr,
  output reg psel1,
  output reg psel2
);

always @(*) begin
  psel1 = 0;
  psel2 = 0;

  if(psel) begin
    if(paddr < 8'b00000101)
      psel1 = 1;
    else
      psel2 = 1;
  end
end

endmodule
