module UART_baud_rate(
  input       clk,
  input       resetn,

  output reg TxC
);

  /* period constant */
  localparam period = 8'd216;

  /* counter */
  reg [7:0] cnt;

  /* update count */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          cnt <= 8'd0;
			 TxC <= 1'b0;
        end
		else if (cnt == period)
		  begin
		    cnt <= 8'd0;
			 TxC <= ~TxC;
		  end
      else
        begin
          cnt <= cnt + 1;
			 TxC <= TxC;
        end
    end
	 
endmodule