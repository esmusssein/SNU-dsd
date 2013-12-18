module top (
  input clk,
  input reset,
  
  output wire UART_TxD,
  output wire led_dmemwr
);

  wire [15:0] imem_addr;
  wire [15:0] imem_data;
  wire [15:0] dmem_addr;
  wire [31:0] dmem_data_write;
  wire [31:0] dmem_data_read;
  wire dmem_wr;

  /* UART-related signals */
  wire       UART_TE;
  wire       UART_load;
  wire [7:0] UART_din;
  
  dsd_processor u_dsd_processor (
    .clk            (clk), 
    .resetn         (~reset), 
    .dmem_data_in   (dmem_data_read),
    .imem_data      (imem_data), 
    .UART_TE        (UART_TE),
    
    .dmem_addr      (dmem_addr),
    .dmem_data_out  (dmem_data_write),
    .dmem_wr        (dmem_wr), 
    .imem_addr      (imem_addr),
    .UART_load      (UART_load),
    .UART_din       (UART_din)
  );
  
  imem u_imem (
    .clka      (~clk),
    .addra     (imem_addr[10:1]),

    .douta     (imem_data)
  );
  
  dmem u_dmem (
    .clka  (~clk),
    .addra (dmem_addr[14:2]),
    .dina  (dmem_data_write),
    .wea   (dmem_wr),

    .douta (dmem_data_read)
  );

  UART_top u_uart(
    .clk        (clk),
    .resetn     (~reset),
    .din        (UART_din),
    .UART_wr    (UART_load),

    .TE         (UART_TE),
    .TxD        (UART_TxD)
  );
  
  assign led_dmemwr = dmem_wr;

endmodule

