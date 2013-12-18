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
  cla_4bits cla0(
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),

    .sum(sum[3:0]),
    .cout(cout[3:0]),
    .groupG(groupG[0]),
    .groupP(groupP[0])
  );
  
  cla_4bits cla1(
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(groupC[0]),

    .sum(sum[7:4]),
    .cout(cout[7:4]),
    .groupG(groupG[1]),
    .groupP(groupP[1])
  );
  
  cla_4bits cla2(
    .a(a[11:8]),
    .b(b[11:8]),
    .cin(groupC[1]),

    .sum(sum[11:8]),
    .cout(cout[11:8]),
    .groupG(groupG[2]),
    .groupP(groupP[2])
  );
  
  cla_4bits cla3(
    .a(a[15:12]),
    .b(b[15:12]),
    .cin(groupC[2]),

    .sum(sum[15:12]),
    .cout(cout[15:12]),
    .groupG(groupG[3]),
    .groupP(groupP[3])
  );
  
  cla_4bits cla4(
    .a(a[19:16]),
    .b(b[19:16]),
    .cin(groupC[3]),

    .sum(sum[19:16]),
    .cout(cout[19:16]),
    .groupG(groupG[4]),
    .groupP(groupP[4])
  );
  
  cla_4bits cla5(
    .a(a[23:20]),
    .b(b[23:20]),
    .cin(groupC[4]),

    .sum(sum[23:20]),
    .cout(cout[23:20]),
    .groupG(groupG[5]),
    .groupP(groupP[5])
  );
  
  cla_4bits cla6(
    .a(a[27:24]),
    .b(b[27:24]),
    .cin(groupC[5]),

    .sum(sum[27:24]),
    .cout(cout[27:24]),
    .groupG(groupG[6]),
    .groupP(groupP[6])
  );
  
  cla_4bits cla7(
    .a(a[31:28]),
    .b(b[31:28]),
    .cin(groupC[6]),

    .sum(sum[31:28]),
    .cout(cout[31:28]),
    .groupG(groupG[7]),
    .groupP(groupP[7])
  );
          
  
endmodule