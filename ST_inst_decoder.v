module ST_inst_decoder(
  input [15:0] inst_in,

  output reg [7:0] op_sel,
  output reg       mem_inst,
  output reg       store,
  output wire      st_inst
);

  /* instruction headers */
  `define INST_PUSH  7'b1011_010
  `define INST_POP   7'b1011_110
  `define INST_ADDSP 9'b1011_00000
  `define INST_SUBSP 9'b1011_00001
  `define INST_MOVSP 13'b0100_0110_01101
  `define INST_ADDS  5'b10101
  `define INST_LDRSP 5'b10011
  `define INST_STRSP 5'b10010

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

  /* decode stack-related instruction */
  always @(*)
    begin
      case (inst_in[15:11])
        INST_ADDS:
          begin
            op_sel = ADDS;
            mem_inst = 1'b0;
            store = 1'b0;
          end

        INST_LDRSP:
          begin
            op_sel = LDRSP;
            mem_inst = 1'b1;
            store = 1'b0;
          end

        INST_STRSP:
          begin
            op_sel = STRSP;
            mem_inst = 1'b1;
            store = 1'b1;
          end

        default:
          begin
            case (inst_in[15:9])
              INST_PUSH:
                begin
                  op_sel = PUSH;
                  mem_inst = 1'b1;
                  store = 1'b1;
                end

              INST_POP:
                begin
                 op_sel = POP;
                 mem_inst = 1'b1;
                 store = 1'b0;
                end

              default:
                begin
                  case (inst_in[15:7])
                    INST_ADDSP:
                      begin
                        op_sel = ADDSP;
                        mem_inst = 1'b0;
                        store = 1'b0;
                      end

                    INST_SUBSP:
                      begin
                        op_sel = SUBSP;
                        mem_inst = 1'b0;
                        store = 1'b0;
                      end

                    default:
                      begin
                        if (inst_in[15:3] == INST_MOVSP)
                          begin
                            op_sel = MOVSP;
                            mem_inst = 1'b0;
                            store = 1'b0;
                          end
                        else
                          begin
                            op_sel = NOP;
                            mem_inst = 1'b0;
                            store = 1'b0;
                          end
                      end
                  endcase
                end
            endcase
          end
      endcase
    end

    /* whether this instruction stack-related? */
    assign st_inst = (op_sel == NOP) : 1'b0 ? 1'b1;

endmodule