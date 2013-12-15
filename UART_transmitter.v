/*
 * UART transmitter module
 */
module UART_transmitter(
  input       clk,
  input       resetn,
  input       TxC,       /* transmitter clock signal */
  input       load,      /* parallel load TDR signal */
  input [7:0] din,

  output reg  TE,        /* TDR empty flag */
  output reg  TxD        /* TSDR output */
);

  /* the sending bit size excluding stop of start bit */
  parameter M = 8;
  parameter N = 3;

  /* FSM states */
  localparam IDLE =  1'b0;
  localparam SHIFT = 1'b1;

  /* transmitter data register */
  reg [M-1:0] TDR;
  /* transmitter shift data register */
  reg [M-1:0] TSDR;
  /* bit counter */
  reg [N:0] bitcnt;
  /* state register */
  reg state_ff;
  reg state_nxt;
  /* TDSR empty flag control signal */
  reg set_TE;
  
  /* load TDR when load is activated */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TDR <= {M{1'b0}};
        end
      else
        begin
          if (load == 1'b1)
            begin
              TDR <= din;
            end
        end
    end

  /* update TE */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          TE <= 1'b1;
        end
      else
        begin
          TE <= (set_TE & ~TE) | (~load & TE);  /* ISSUE */
        end
    end

  /* update state */
  always @(posedge TxC or negedge resetn)
    begin
      if (resetn == 1'b1)
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
            if (TE == 1'b0)
              begin
                state_nxt = SHIFT;
              end
            else
              begin
                state_nxt = IDLE;
              end
          end

        SHIFT:
          begin
            if (bitcnt != M)
              begin
                state_nxt = IDLE;
              end
            else
              begin
                state_nxt = SHIFT;
              end
          end

        default:
          begin
            state_nxt = state_ff;
          end
      endcase
    end

  /* update bitcnt, set_TE, TSDR */
  always @(posedge TxC or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          set_TE <= 1'b0;
          bitcnt <= {{N{1'b0}}, 1'b0};
          TSDR   <= {M{1'b0}};
        end
      else
        begin
          if (state_ff == IDLE)
            begin
              if (TE == 1'b0)
                begin
                  TSDR   <= TDR;
                  bitcnt <= {{N{1'b0}}, 1'b0};
                  set_TE <= 1'b0;    /* ISSUE */
                end
            end
          else if (state_ff == SHIFT)
            begin
              if (bitcnt != M)
                begin
                  set_TE <= 1'b0;
                end
              else
                begin
                  set_TE <= 1'b1;
                end
              bitcnt <= bitcnt + 1;
              TSDR   <= TDR;
            end
        end
    end

  /* compute TxD */
  always @(*)
    begin
      case (state_ff)
        IDLE:
          begin
            if (TE == 1'b0)  /* send start bit */
              begin
                TxD = 1'b0;
              end
            else             /* send stop bit */
              begin
                TxD = 1'b1;
              end
          end

        SHIFT:
          begin
            TxD = TSDR[0];
          end

        default:
          begin
            TxD = 1'b1;
          end
      endcase
    end

endmodule