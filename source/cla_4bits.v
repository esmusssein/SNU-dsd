module cla_4bits(
  input [3:0] a,
  input [3:0] b,
  input       cin,

  output reg  [3:0] sum,
  output wire [3:0] cout,
  output reg        groupG,
  output reg        groupP
);

  // Inner regs
  reg [3:0] p;
  reg [3:0] g;


  // Generate g, p.
  always @(*)
    begin
        p = a ^ b;
        g = a & b;
    end

  // Generate cout.
  carry_lookahead_unit #(4) u_carry_lookahead_unit(
    .cin(cin),
    .g(g),
    .p(p),

    .cout(cout)
  );

  // Generate sum.
  always @(*)
    begin
      sum[0] = p[0] ^ cin;
      sum[1] = p[1] ^ cout[0];
      sum[2] = p[2] ^ cout[1];
      sum[3] = p[3] ^ cout[2];
    end

  // Generate group generate and propagate.
  always @(*)
    begin
      groupP = &p;
      groupG = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);
    end

endmodule