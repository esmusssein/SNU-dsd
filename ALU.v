module ALU(
    input [31:0]  a,
    input [6:0]   alu_sel,
    input [31:0]  b,

    output reg [31:0] data_out,
    output reg [3:0]  flag_out
);

  // alu_sel
  localparam ADD = 7'b1000000;
  localparam SUB = 7'b0100000;
  localparam CMP = 7'b0010000;
  localparam AND = 7'b0001000;
  localparam ORR = 7'b0000100;
  localparam EOR = 7'b0000010;
  localparam MOV = 7'b0000001;

  // Inner regs
  reg [31:0] cla_a;
  reg        cla_cin;

  // Inner wires
  wire [31:0] cla_sum;
  wire [31:0] cla_cout;
  wire [3:0]  cla_fout;


  // Decide cla input a_in using 2-1 MUX.
  always @(*)
    begin
      if (cla_cin == 1'b1)
        begin
          cla_a = a ^ 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        end
      else
        begin
          cla_a = a;
        end
    end

  // Compute carry_in. where carry_in is 1'b1, it implies subtraction.
  always @(*)
    begin
      if (alu_sel == SUB || alu_sel == CMP)
        begin
          cla_cin = 1'b1;
        end
      else
        begin
          cla_cin = 1'b0;
        end
    end

  cla_32bits cla(
    .a(cla_a),
    .b(b),
    .cin(cla_cin),

    .sum(cla_sum),
    .cout(cla_cout)
  );

  // Select data_out.
  always @(*)
    begin
      case (alu_sel)
        ADD:
          begin
            data_out = cla_sum;
          end

        SUB:
          begin
            data_out = cla_sum;
          end

        AND:
          begin
            data_out = a & b;
          end

        ORR:
          begin
            data_out = a ^ b;
          end

        EOR:
          begin
            data_out = a ^ b;
          end

        MOV:
          begin
            data_out = a;
          end

        default:
          begin
           data_out = 32'd0;
          end
      endcase
    end

  flag_decoder #(32) fdecoder(
    .sin(cla_sum),
    .cin(cla_cout),

    .fout(cla_fout)
  );

  // Select flag_out.
  always @(*)
    begin
      case (alu_sel)
        ADD:
          begin
            flag_out = cla_fout;
          end

        SUB:
          begin
            flag_out = cla_fout;
          end

        CMP:
          begin
            flag_out = cla_fout;
          end

        AND:
          begin
            flag_out[3] = cla_fout[3];
            flag_out[2] = cla_fout[2];
            flag_out[1] = 0;
            flag_out[0] = 0;
          end

        ORR:
          begin
            flag_out[3] = cla_fout[3];
            flag_out[2] = cla_fout[2];
            flag_out[1] = 0;
            flag_out[0] = 0;
          end

        EOR:
          begin
            flag_out[3] = cla_fout[3];
            flag_out[2] = cla_fout[2];
            flag_out[1] = 0;
            flag_out[0] = 0;
          end

        MOV:
          begin
            flag_out[3] = cla_fout[3];
            flag_out[2] = cla_fout[2];
            flag_out[1] = 0;
            flag_out[0] = 0;
          end

        default:
          begin
           flag_out = 4'd0;
          end
      endcase
    end

endmodule


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
      fout[3] = ~(|sin);
      fout[2] = sin[W-1];
      fout[1] = cin[W-1];
      fout[0] = cin[W-2] ^ cin[W-1];
    end

endmodule