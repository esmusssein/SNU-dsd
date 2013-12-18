module UART_transmitter_mod(
  input        clk,
  input        resetn,
  input        TxC,       /* transmitter clock signal */
  input        load,      /* parallel load TDR signal */
  input [7:0]  din,

  output reg  TE,        /* TDR empty flag */
  output reg  TxD        /* TSDR output */
);

  /* state constants */
  localparam IDLE  = 1'b0;
  localparam SHIFT = 1'b1;

  /**/
  reg [7:0] TDR;
  /* transmit shift data register include start-bit */
  reg [8:0] TSDR;
  /**/
  reg [3:0] bitcnt;
  /**/
  reg state_ff;
  reg state_nxt;
  /**/
  reg set_TE;
  /**/
  reg loaded;
  /**/
  reg clear_loaded;
  
  /* load TDR when load is activated */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TDR    <= 8'd0;
          loaded <= 1'b0;
        end
      else if (load == 1'b1)
        begin
          TDR    <= din;
          loaded <= 1'b1;
        end
      else if (clear_loaded == 1'b1)
        begin
          loaded <= 1'b0;
        end
    end

  /* update TDR empty flag */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TE <= 1'b1;
        end
      else if (load == 1'b1)
        begin
          TE <= 1'b0;
        end
      else
        begin
          TE <= ~loaded & set_TE;
        end
    end

  /* initialize and update state registers */
  always @(posedge TxC or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          state_ff <= IDLE;
        end
      else
        begin
          state_ff <= state_nxt;
        end
    end

  /* compute next state */
  always @(*)
    begin
      case (state_ff)
        IDLE:
          begin
            if (loaded == 1'b0)
              begin
                state_nxt = IDLE;
              end
            else
              begin
                state_nxt = SHIFT;
              end
          end

        SHIFT:
          begin
            if (bitcnt < 8)
              begin
                state_nxt = SHIFT;
              end
            else
              begin
                state_nxt = IDLE;
              end
          end
      endcase
    end

  /* RTL operations */
  always @(posedge TxC or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TSDR   <= 9'b1111_1111_1;
          bitcnt <= 4'd0;
          set_TE <= 1'b1;
          TxD    <= 1'b1;
        end
      else
        begin
          case (state_ff)
            IDLE:
              begin
                if (loaded == 1'b1)  /* IDLE -> SHIFT */
                  begin
                    TSDR   <= {TDR, 1'b0};
                    clear_loaded <= 1'b1;
                    bitcnt <= 4'd0;
                    set_TE <= 1'b0;
                    TxD    <= 1'b1;
                  end
                else
                  begin
                    TSDR <= 9'b1111_1111_1;
                    bitcnt <= 4'd0;
                    set_TE <= 1'b1;
                    TxD    <= 1'b1;
                  end
              end

            SHIFT:
              begin
                set_TE <= 1'b0;
                bitcnt <= bitcnt + 1;
                TSDR <= {1'b1, TSDR[8:1]};
                clear_loaded <= 1'b0;
                TxD  <= TSDR[0];
              end
          endcase
        end
    end

endmodule