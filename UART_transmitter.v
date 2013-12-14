/*
 * UART_transmitter
 * 
 * Verification required.
 * Codes by the textbook.
 * Question: what set_TE for?
 */
module UART_transmitter(
  input       clk,
  input       resetn,
  input       TxC,       /* transmitter clock signal */
  input       load_TDR,  /* parallel load TDR signal */
  input [7:0] data_bus,

  output reg  TE,        /* TDR empty flag */
  output wire TxD        /* TSDR output */
);

  /* the frame size excluding the stop bit */
  parameter M = 10;

  /* FSM states */
  localparam IDLE =  1'b0;
  localparam SHIFT = 1'b1;

  /* inner regs */
  reg [7:0]   TDR;     /* transmitter data register */
  reg [M-1:0] TSDR;    /* transmitter shift data register */
  reg [3:0]   bitcnt;  /* bit counter */
  reg state_ff;
  reg state_nxt;
  reg set_TE;

  /* load TDR when load_TDR is activated */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TDR <= 8'd0;
        end
      else if (load_TDR == 1'b1)
        begin
          TDR <= data_bus;
        end
    end

  /* update TDR empty flag */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TE <= 1'b1;
        end
      else
        begin
          TE <= (set_TE & ~TE) | (~load_TDR & TE);
        end
    end
 
  /* 
   * Load TSDR from TDR and perform data transmission.
   */
  /* step 1: initialize and update state registers */
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
  /* step 2: compute next state */
  always @(*)
    begin
      case (state_ff)
        IDLE:
          begin
            if (TE == 1'b1)
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
            if (bitcnt != M-1)  /* bitcnt < M-1 */
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
  /* step 3: execute RTL operations */
  always @(posedge TxC or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TSDR <= {M{1'b1}};
          bitcnt <= 3'd0;
          set_TE <= 1'b0;
        end
      else
        begin
          case (state_ff)
            IDLE:
              begin
                if (TE == 1'b1)
                  begin
                    TSDR <= {1'b1, TSDR[M-1:1]};  /* send '1' */
                    set_TE <= 1'b0;
                  end
                else
                  begin
                    TSDR <= {^TDR, TDR, 1'b0};  /* {paritybit, TDR, 0} */
                    set_TE <= 1'b1;
                    bitcnt <= 3'd0;
                  end
              end

            SHIFT:
              begin
                TSDR <= {1'b1, TSDR[M-1:1]};
                set_TE <= 1'b0;
                bitcnt <= bitcnt + 1;
              end
          endcase
        end
    end

  /* If it has no data to be sent, send '1' continuously. */
  assign TxD = TSDR[0] & (state_ff == SHIFT) | (state_ff == IDLE);

endmodule