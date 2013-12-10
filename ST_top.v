/*
 * Stack Top - Parse stack-related instruction,
 * make appropriate control signals for dsd_processor,
 * modify stack pointer.
 */
module ST_top(
  input        clk,
  input        resetn,
  input [2:0]  Rd0,
  input [2:0]  Rd1,
  input [8:0]  Rl,
  input [6:0]  immed7,
  input [7:0]  immed8,
  input [15:0] LR,
  input [15:0] inst_in,

  output reg [15:0] dmem_addr_out,
  output reg [2:0]  rdest_addr_out,
  output reg [31:0] rdest_data_out,
  output reg [15:0] PC_out,
  output reg        RF_WR,
  output reg        PC_WR,
  output reg        store,
  output reg        mem_inst,
  output reg        mem_force
);

  /* default stack pointer */
  // TODO - find accurate value of it
  `define DEFAULT_SP 15'b0000_0000_0000_000;

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
  localparam NOP   = 8'b0000_0000;
  localparam PUSH  = 8'b0000_0001;
  localparam POP   = 8'b0000_0010;
  localparam ADDSP = 8'b0000_0100;
  localparam SUBSP = 8'b0000_1000;
  localparam MOVSP = 8'b0001_0000;
  localparam ADDS  = 8'b0010_0000;
  localparam LDRSP = 8'b0100_0000;
  localparam STRSP = 8'b1000_0000;
  

  /* operation indicator via hot encoding */
  reg [7:0] op_sel;

  /* stack pointer */
  reg [15:0] sp_cur;
  reg [15:0] sp_nxt;

  
  /* update or reset sp */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b1)
        begin
          sp_cur <= DEFAULT_SP;
        end
      else
        begin
          sp_cur <= sp_nxt;
        end
    end

  /* compute output and control signals */
  always @(posedge clk or negedge resetn)
    begin
      begin
      case (op_sel)
        NOP:
          begin
            dmem_addr_out = 16'd0;
            rdest_addr_out = 3'd0;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b0;
            mem_inst = 1'b0;
            mem_force = 1'b1;
          end

        PUSH:
          begin
            // TODO
          end
        POP:
          begin
            // TODO
          end
        ADDSP:
          begin
            dmem_addr_out = 16'd0;
            rdest_addr_out = 3'd0;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b0;
          end
        SUBSP:
          begin
            dmem_addr_out = 16'd0;
            rdest_addr_out = 3'd0;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b0;
          end
        MOVSP:
          begin
            dmem_addr_out = 16'd0;    
            rdest_addr_out = Rd0;      /**/
            rdest_data_out = sp_cur;   /**/
            PC_out = 16'd0;
            RF_WR = 1'b1;              /**/
            PC_WR = 1'b0;
            store = 1'b0;
          end
        ADDS:
          begin
            dmem_addr_out = 16'd0;
            rdest_addr_out = Rd1;      /**/
            rdest_data_out = sp_cur + {immed8[5:0], 2'b0};    /**/
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b0;
          end
        LDRSP:
          begin
            dmem_addr_out = sp_cur + sp_cur + {immed8[5:0], 2'b0};  /**/
            rdest_addr_out = Rd1;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b1;    /**/
            PC_WR = 1'b0;
            store = 1'b0;
          end
        STRSP:
          begin
            dmem_addr_out = sp_cur + sp_cur + {immed8[5:0], 2'b0};  /**/
            rdest_addr_out = Rd1;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b1;    /**/
          end
        default:
          begin
            dmem_addr_out = 16'd0;
            rdest_addr_out = 3'd0;
            rdest_data_out = 32'd0;
            PC_out = 16'd0;
            RF_WR = 1'b0;
            PC_WR = 1'b0;
            store = 1'b0;
          end
      endcase
    end

  /* compute next sp */
  always @(*)
    begin
      case (op_sel)
        NOP:
          begin
            sp_nxt = sp_cur;
          end

        PUSH:
          begin
            sp_nxt = sp_cur - 4;
          end
        POP:
          begin
            sp_nxt = sp_cur + 4;
          end
        ADDSP:
          begin
            sp_nxt = sp_cur + {immed7[4:0], 2'b00};  /* sp + 4 * immed7 */
          end
        SUBSP:
          begin
            sp_nxt = sp_cur - {immed7[4:0], 2'b00};  /* sp - 4 * immed7 */
          end
        MOVSP:
          begin
            sp_nxt = sp_cur;
          end
        ADDS:
          begin
            sp_nxt = sp_cur;
          end
        LDRSP:
          begin
            sp_nxt = sp_cur;
          end
        STRSP:
          begin
            sp_nxt = sp_cur;
          end
        default:
          begin
            sp_nxt = sp_cur;
          end
      endcase
    end

  /* decode stack-related instruction */
  always @(*)
    begin
      case (inst_in[15:11])
        INST_ADDS:
          begin
            op_sel = ADDS;
          end

        INST_LDRSP:
          begin
            op_sel = LDRSP;
          end

        INST_STRSP:
          begin
            op_sel = STRSP;
          end

        default:
          begin
            case (inst_in[15:9])
              INST_PUSH:
                begin
                  op_sel = PUSH;
                end

              INST_POP:
                begin
                 op_sel = POP;
                end

              default:
                begin
                  case (inst_in[15:7])
                    INST_ADDSP:
                      begin
                        op_sel = ADDSP;
                      end

                    INST_SUBSP:
                      begin
                        op_sel = SUBSP;
                      end

                    default:
                      begin
                        if (inst_in[15:3] == INST_MOVSP)
                          begin
                            op_sel = MOVSP;
                          end
                        else
                          begin
                            op_sel = NOP;
                          end
                      end
                  endcase
                end
            endcase
          end
      endcase
    end

endmodule