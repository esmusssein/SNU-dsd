module RF (
  clk,
  resetn,
  addr_srcA,
  addr_srcB,
  addr_dest,
  data_in,
  RF_Wen,
  WR,

  dest,
  srcA,
  srcB
);

  // Word length
  parameter W = 32;

  // Input and outputs
  input          clk;
  input          resetn;
  input  [2:0]   addr_srcA;
  input  [2:0]   addr_srcB;
  input  [2:0]   addr_dest;
  input  [W-1:0] data_in;
  input          RF_Wen;
  input          WR;

  output [W-1:0] dest;
  output [W-1:0] srcA;
  output [W-1:0] srcB;

  // Inner reg
  reg [W-1:0] register [7:0];


  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          register[0] <= {W{1'b0}};
          register[1] <= {W{1'b0}};
          register[2] <= {W{1'b0}};
          register[3] <= {W{1'b0}};
          register[4] <= {W{1'b0}};
          register[5] <= {W{1'b0}};
          register[6] <= {W{1'b0}};
          register[7] <= {W{1'b0}};
        end
      else
        begin
          if (RF_Wen == 1'b1 && WR == 1'b1)
            begin
              register[addr_dest] <= data_in;
            end
        end
    end

  assign dest = register[addr_dest];
  assign srcA = register[addr_srcA];
  assign srcB = register[addr_srcB];

endmodule
