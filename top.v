module top ();
  reg         clk;
  reg         resetn;

  wire [15:0] imem_addr;
  wire [15:0] imem_data;
  wire [15:0] dmem_addr;
  wire [31:0] dmem_data_write;
  wire [31:0] dmem_data_read;
  wire dmem_wr;

  /* UART-related signals */
  wire       UART_TE;
  wire       UART_load;
  wire       UART_TxD;
  wire [7:0] UART_din;
  
  dsd_processor u_dsd_processor (
    .clk            (clk                     ), 
    .resetn         (resetn                  ), 
    .dmem_data_in   (dmem_data_read          ),
    .imem_data      (imem_data               ), 
    .UART_TE        (UART_TE),
    
    .dmem_addr      (dmem_addr               ),
    .dmem_data_out  (dmem_data_write         ),
    .dmem_wr        (dmem_wr                 ), 
    .imem_addr      (imem_addr               ),
    .UART_load      (UART_load),
    .UART_din       (UART_din)
  );
  
  imem u_imem (
    .clk           (~clk                    ),
    .imem_addr     ({1'b0, imem_addr[15:1]} ),

    .imem_data     (imem_data               )
  );
  
  dmem u_dmem (
    .clk           (~clk                    ),
    .dmem_addr     ({2'b00, dmem_addr[15:2]}),
    .dmem_data_in  (dmem_data_write         ),
    .dmem_wr       (dmem_wr                 ),

    .dmem_data_out (dmem_data_read          )
  );

  UART_top u_uart(
    .clk        (clk),
    .resetn     (resetn),
    .din        (UART_din),
    .UART_wr    (UART_load),

    .TE         (UART_TE),
    .TxD        (TxD)
  );
  
  initial
    begin
      resetn = 1'b0;
      clk    = 1'b1;
      #15 
      resetn = 1'b1;
    end
  
  initial
    begin
      forever
        begin
          #5 clk = ~clk;
        end
    end

endmodule

