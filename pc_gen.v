  module pc_gen (
  input             clk,
  input             resetn,
  input             br,
  input             link,
  input      [15:0] data_in,
  input      [15:0] offset,
  input             PC_Wen,
  input             PC_wr,
  input             PCLR,     /* if set, nextPC = LR */

  output reg [15:0] LR,
  output reg [15:0] PC
  );

  localparam IDLE = 0;
  localparam CHANGED = 1;
  
  /* if the pc changed, maintain pc at least 1 clock */
  reg state_ff;
  reg state_nxt;

  reg [15:0] nextPC;
  reg [15:0] nextLR;

  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0) 
        begin
          PC <= 16'h0000;
          LR <= 16'h0000;
          state_ff <= 1'b0;
        end
      else if (PCLR == 1'b1)
        begin
          PC <= LR;
          LR <= nextLR;
          state_ff <= state_nxt;
        end
      else 
        begin
          PC <= nextPC;
          LR <= nextLR;
          state_ff <= state_nxt;
        end
    end

  /* compute next pc */
  always @(*)
    begin
      if (PC_Wen == 1'b1 && state_ff == IDLE)
        begin
          if (br == 1'b1)
            begin
              nextPC = PC + (offset << 1) + 4;
            end
          else
            begin
              nextPC = PC + 2;
            end
        end
      else if (PC_wr == 1'b1 && state_ff == IDLE)
        begin
          nextPC = data_in;
        end
      else
        begin
          nextPC = PC;
        end
    end

  /* compute next state */
  always @(*)
    begin
      if (PC_wr == 1'b1 && state_ff == IDLE)
        begin
          state_nxt = CHANGED;
        end
      else
        begin
          state_nxt = IDLE;
        end
    end

  /* compute next lr */
  always @(*)
    begin
      if (PC_Wen == 1'b1)
        begin
          if (link == 1'b1)
            begin
              nextLR = PC + 2;
            end
          else
            begin
              nextLR = LR;
            end
        end
      else
        begin
          nextLR = LR;
        end
    end

endmodule
