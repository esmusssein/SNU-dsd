module flag_decoder(
  sin,
  cin,

  fout
);

  parameter W = 32;

  // Input and outputs
  input [W-1:0] sin;
  input [W-1:0] cin;

  output reg [3:0] fout;


  // Compute fout.
  // z_flag(fout[3]), n_flag(fout[2]), c_flag(fout[1]), v_flag(fout[0])
  always @(*)
    begin
      fout[3] = !sin;
      fout[2] = sin[W-1];
      fout[1] = cin[W-1];
      fout[0] = cin[W-2] ^ cin[W-1];
    end

endmodule