/* TEST */
module carry_lookahead_unit(
  cin,
  g,
  p,

  cout
);

  // Default word length = 4
  parameter W = 4;


  // Input & Output
  input cin;
  input [W-1:0] g;
  input [W-1:0] p;

  output [W-1:0] cout;


  // Generate cout.
  genvar i;
  generate for(i = 0; i < W; i=i+1)
    if (i == 0)
      begin
        carry ca(
          .cin(cin),
          .g(g[i]),
          .p(p[i]),
          .cout(cout[i])
        );
      end
    else
      begin
        carry ca(
          .cin(cout[i-1]),
          .g(g[i]),
          .p(p[i]),
          .cout(cout[i])
        );
      end
  endgenerate

endmodule



module carry(
  input cin,
  input g,
  input p,

  output reg cout
);

  // Generate carry from carry generate and propagate.
  always @(*)
    begin
      cout = g | (p & cin);
    end

endmodule