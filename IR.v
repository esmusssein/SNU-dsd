module IR (
  input         clk,
  input         resetn,
  input  [15:0] inst_in,
  input         Wen,

  output [4:0]  immed5,
  output [6:0]  immed7,
  output [7:0]  immed8,
  output [10:0] immed11,
  output [15:0] inst_out,
  output [2:0]  Rd0,
  output [2:0]  Rd1,
  output [2:0]  Rs0,
  output [2:0]  Rs1,
  output [2:0]  Rs2,
  output [2:0]  Rs3
);

  reg [15:0] inst_reg;

  always @(posedge clk or negedge resetn)
    begin
    if (resetn == 1'b0)
      begin
        inst_reg <= 16'b0100_0011_0000_0000;        // set inst_reg NOP.
      end
    else
      begin
        if (Wen)
          begin
            inst_reg <= inst_in;    
          end
      end
  end

  assign immed5   = inst_reg[10:6];
  assign immed7   = inst_reg[6:0];
  assign immed8   = inst_reg[7:0];
  assign immed11  = inst_reg[10:0];
  assign Rs0      = inst_reg[2:0];
  assign Rs1      = inst_reg[5:3];
  assign Rs2      = inst_reg[8:6];
  assign Rs3      = inst_reg[10:8];
  assign Rd0      = inst_reg[2:0];
  assign Rd1      = inst_reg[10:8];
  assign inst_out = inst_reg;

endmodule
