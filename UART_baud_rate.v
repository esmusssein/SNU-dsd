module UART_baud_rate(
  input       clk,
  input       resetn,

  output reg TxC
);

  /* counter */
  reg [7:0] cnt_ff;
  reg [7:0] cnt_nxt;
  /* toggle flag */
  wire tg;

  /* update count */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          cnt_ff <= 8'b0;
        end
      else
        begin
          cnt_ff <= cnt_nxt;
        end
    end

  /* compute next counter */
  always @(*)
    begin
      if (cnt_ff == 8'b1101_1001)
        begin
          cnt_nxt = 8'd0;
        end
      else
        begin
          cnt_nxt = cnt_ff + 1;
        end
    end

  /* update TxC */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TxC <= 1'b0;
        end
      else
        if (tg == 1'b1)
          begin
            TxC <= ~TxC;
          end
    end

  /* assign toggle flag */
  assign tg = (cnt_ff == 8'b1101_1001) ? 1'b1 : 1'b0;

endmodule