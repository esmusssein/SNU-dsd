module ST_controller(
  input        clk,
  input        resetn,
  input        op_sel,
  input [15:0] LR,
  input [8:0]  RL,
  input [2:0]  Rd0,
  input [2:0]  Rd1,
  input [31:0] data_in,

  output reg  [2:0]  rdest_addr,
  output reg  [15:0] dmem_addr,
  output wire [15:0] SP_out,
  output reg         LR_sel,
  output reg         mem_force,
  output reg         dmem_wr,
  output reg         PC_wr,
  output reg         RF_wr
);

  /* default stack pointer */
  // TODO - find accurate value of it
  `define DEFAULT_SP 15'b0000_0000_0000_000;

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

  /* pos parameter */
  localparam IDLE_POS  = 4'd10;
  localparam FULL_POS  = 4'd15;
  localparam EMPTY_POS = 4'd9;

  /* pop, push RL state */
  reg [3:0] pos_cur;
  reg [3:0] pos_nxt;

  /* stack pointer */
  reg [15:0] SP_cur;
  reg [15:0] SP_nxt;


  /* generate control signal and output */
  always @(*)
    begin
      case (op_sel)
        NOP:
          begin
            rdest_addr = 3'd0;
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b0;
          end
        
        PUSH:
          begin
            if (pos_cur == IDLE_POS)
              begin
                rdest_addr = 3'd0;
                dmem_addr = 16'd0;
                LR_sel = 1'b0;
                mem_force = 1'b1;  /**/
                dmem_wr = 1'b0;
                PC_wr = 1'b0;
                RF_wr = 1'b0;
              end
            else if (pos_cur == FULL_POS)
              begin
                rdest_addr = 3'd0;
                dmem_addr = 16'd0;
                LR_sel = 1'b0;
                mem_force = 1'b0;
                dmem_wr = 1'b0;
                PC_wr = 1'b0;
                RF_wr = 1'b0;
              end
            else
              begin
                if (RL[pos_cur] == 1'b1)
                  begin
                    rdest_addr = pos_cur;
                    dmem_addr = SP_cur;
                    LR_sel = (pos_cur == 4'd8) ? 1'b1 : 1'b0;  /**/
                    mem_force = 1'b1;  /**/
                    dmem_wr = 1'b1;    /**/
                    PC_wr = 1'b0;
                    RF_wr = 1'b0;
                  end
                else
                  begin
                    rdest_addr = 3'd0;
                    dmem_addr = 16'd0;
                    LR_sel = 1'b0;
                    mem_force = 1'b1;  /**/
                    dmem_wr = 1'b0;
                    PC_wr = 1'b0;
                    RF_wr = 1'b0;
                  end
              end
          end

        POP:
          begin
            if (pos_cur == IDLE_POS)
              begin
                rdest_addr = 3'd0;
                dmem_addr = 16'd0;
                LR_sel = 1'b0;
                mem_force = 1'b1;  /**/
                dmem_wr = 1'b0;
                PC_wr = 1'b0;
                RF_wr = 1'b0;
              end
            else if (pos_cur == EMPTY_POS)
              begin
                rdest_addr = 3'd0;
                dmem_addr = 16'd0;
                LR_sel = 1'b0;
                mem_force = 1'b0;
                dmem_wr = 1'b0;
                PC_wr = 1'b0;
                RF_wr = 1'b0;
              end
            else
              begin
                if (RL[pos_cur] == 1'b1)
                  begin
                    rdest_addr = pos_cur;  /**/
                    dmem_addr = SP_cur;  /**/
                    LR_sel = 1'b0;
                    mem_force = 1'b1;    /**/
                    dmem_wr = 1'b0;
                    PC_wr = (pos_cur == 4'd8) ? 1'b1 : 1'b0; /**/
                    RF_wr = (pos_cur == 4'd8) ? 1'b0 : 1'b1; /**/
                  end
                else
                  begin
                    rdest_addr = 3'd0;
                    dmem_addr = 16'd0;
                    LR_sel = 1'b0;
                    mem_force = 1'b1;  /**/
                    dmem_wr = 1'b0;
                    PC_wr = 1'b0;
                    RF_wr = 1'b0;
                  end
              end
          end
        
        ADDSP:
          begin
            rdest_addr = 3'd0;
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b0;
          end

        SUBSP:
          begin
            rdest_addr = 3'd0;
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b0;
          end

        MOVSP:
          begin
            rdest_addr = Rd0;  /**/ 
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b1;  /**/
          end

        ADDS:
          begin
            rdest_addr = Rd1;  /**/
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b1;  /**/
          end

        LDRSP:
          begin
            rdest_addr = Rd1;  /**/
            dmem_addr = data_in[15:0];  /**/
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b1;  /**/
          end

        STRSP:
          begin
            rdest_addr = Rd1;  /**/
            dmem_addr = data_in[15:0];  /**/
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b1;  /**/
            PC_wr = 1'b0;
            RF_wr = 1'b0;
          end

        default:
          begin  
            rdest_addr = 3'd0;
            dmem_addr = 16'd0;
            LR_sel = 1'b0;
            mem_force = 1'b0;
            dmem_wr = 1'b0;
            PC_wr = 1'b0;
            RF_wr = 1'b0;
          end
      endcase
    end

  /* update reg */
  always @(posedge clk or negedge resetn)
    begin
      if (resetn == 1'b0)
        begin
          SP_cur  <= DEFAULT_SP;
          pos_cur <= IDLE_POS;
        end
      else
        begin
          SP_cur  <= SP_nxt;
          pos_cur <= pos_nxt;
        end
    end

  /* compute next reg */
  always @(*)
    begin
      /* not changed SP */
      if (op_sel == MOVSP || op_sel == ADDS || op_sel == LDRSP || op_sel == STRSP)
        begin
          SP_nxt  = SP_cur;
          pos_nxt = IDLE_POS;
        end
      
      /* PUSH and POP */
      else if (op_sel == PUSH)
        begin
          if (pos_cur == IDLE_POS)
            begin
              SP_nxt = SP_cur;
              pos_nxt = 4'd8;
            end
          else if (pos_cur == FULL_POS)
            begin
              SP_nxt = SP_cur;
              pos_nxt = IDLE_POS;
            end
          else             
            begin
              SP_nxt = data_in[15:0];
              pos_nxt = pos_cur - 1;
            end
        end
      else if (op_sel == POP)
        begin
          if (pos_cur == IDLE_POS)
            begin
              SP_nxt = SP_cur;
              pos_nxt = 4'd0;
            end
          else if (pos_nxt == EMPTY_POS)
            begin
              SP_nxt = SP_cur;
              pos_nxt = IDLE_POS;
            end
          else
            begin
              SP_nxt = data_in[15:0];
              pos_nxt = pos_cur + 1;
            end
        end
      
      /* changed SP */
      else
        begin
          SP_nxt = data_in[15:0];
          pos_nxt = IDLE_POS;
        end
    end
  
  /* assign stack pointer output */
  assign SP_out = SP_cur;

endmodule