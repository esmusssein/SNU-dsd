/*
 * UART top module
 */
module UART_top(
  input       clk,
  input       resetn,
  input [7:0] din,
  input       UART_wr,

  output wire TE,
  output wire TxD
);

  /* inner wire */
  wire TxC;

  /* UART transmitter */
  UART_transmitter_mod u_transmitter(
    .clk(clk),
    .resetn(resetn),
    .TxC(TxC),
    .load(UART_wr),
    .din(din),

    .TE(TE),
    .TxD(TxD)
  );

  /* UART baud rate generator */
  UART_baud_rate u_baudrate(
    .clk(clk),
    .resetn(resetn),

    .TxC(TxC)
  );

endmodule