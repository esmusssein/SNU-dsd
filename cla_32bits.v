/* TEST */
/* TODO - delete display */
module cla_32bits (
  input [31:0] a,
  input [31:0] b,
  input        cin,

  output [31:0] sum,
  output [31:0] cout
);

  // Inner regs
  wire [7:0] groupG;
  wire [7:0] groupP;
  wire [7:0] groupC;


  // Generate carries.
  carry_lookahead_unit #(8) u_carry_lookahead_unit(
    .cin(cin),
    .g(groupG),
    .p(groupP),

    .cout(groupC)
  );

  // Generate sum.
  genvar i;
  generate for (i = 0; i < 8; i=i+1)
    begin
      if (i == 0)
        begin
          cla_4bits cla4(
            .a(a[4*i+3:4*i]),
            .b(b[4*i+3:4*i]),
            .cin(cin),

            .sum(sum[4*i+3:4*i]),
            .cout(cout[4*i+3:4*i]),
            .groupG(groupG[i]),
            .groupP(groupP[i])
          );
        end
      else
        begin
          cla_4bits cla4(
            .a(a[4*i+3:4*i]),
            .b(b[4*i+3:4*i]),
            .cin(groupC[i-1]),

            .sum(sum[4*i+3:4*i]),
            .cout(cout[4*i+3:4*i]),
            .groupG(groupG[i]),
            .groupP(groupP[i])
          );
        end
    end
  endgenerate
  
endmodule