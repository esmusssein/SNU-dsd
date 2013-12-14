module multiplier (
  input [31:0] a,
  input [31:0] b,

  output reg [31:0] p
);

  always @(*)
    begin
      p = a * b;
    end

endmodule