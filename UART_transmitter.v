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
  output wire TxD        /* TSDR output */
);

  /* FSM states */
  localparam IDLE =  1'b0;
  localparam SHIFT = 1'b1;

  /* transmitter data register */
  reg [7:0] TDR;
  /* transmitter shift data register include start bit */
  reg [8:0] TSDR;
  /* bit counter */
  reg [3:0] bitcnt;
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
          TDR <= 8'd0;
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
            if (bitcnt != 8)
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
          bitcnt <= 4'd0;
          TSDR   <= 9'd0;
        end
      else
        begin
          if (state_ff == IDLE)
            begin
              if (TE == 1'b0)
                begin
                  TSDR   <= {TDR, 1'b0};        /* {payload, startbit} */
                  bitcnt <= 4'd0;
                  set_TE <= 1'b0;               /* ISSUE */
                end
            end
          else if (state_ff == SHIFT)
            begin
              if (bitcnt != 4'd9)
                begin
                  set_TE <= 1'b0;
                end
              else
                begin
                  set_TE <= 1'b1;
                end
              bitcnt <= bitcnt + 1;
              TSDR   <= {1'b1, TSDR[8:1]};
            end
        end
    end

  assign TxD = TSDR[0] & (state_ff == SHIFT) | (state_ff == IDLE);

endmodule