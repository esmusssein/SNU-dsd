module ST_datapath(
  input [31:0] data_in,
  input [7:0]  op_sel,
  input [6:0]  immed7,
  input [7:0]  immed8,

  output reg [31:0] data_out
);

  /* op codes */
  parameter NOP   = 8'b0000_0000;
  parameter PUSH  = 8'b0000_0001;
  parameter POP   = 8'b0000_0010;
  parameter ADDSP = 8'b0000_0100;
  parameter SUBSP = 8'b0000_1000;
  parameter MOVSP = 8'b0001_0000;
  parameter ADDS  = 8'b0010_0000;
  parameter LDRSP = 8'b0100_0000;
  parameter STRSP = 8'b1000_0000;

  /* compute data_out */
  always @(*)
    begin
      if (op_sel == ADDSP)
        begin
          data_out = data_in + {immed7[4:0], 2'b00};
        end
      else if (op_sel == SUBSP)
        begin
          data_out = data_in - {immed7[4:0], 2'b00};
        end
      else if (op_sel == ADDS || op_sel == LDRSP || op_sel == STRSP)
        begin
          data_out = data_in + {immed8[5:0], 2'b00};
        end
      else if (op_sel == POP)
        begin
          data_out = data_in + 4;
        end
      else if (op_sel == PUSH)
        begin
          data_out = data_in - 4;
        end
      else
        begin
          data_out = data_in; 
        end
    end

endmodule