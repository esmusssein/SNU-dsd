module stageFSM (
  input      clk,
  input      resetn,
  input      mem_inst,
  input      mem_force,
  input      send_inst,

  output reg EXSTtoMEM_Wen,
  output reg IR_Wen,
  output reg PC_Wen,
  output reg PSR_Wen,
  output reg RF_Wen,
  output reg ST_Wen
);

  reg [1:0] curr_stage;
  reg [1:0] next_stage;

  localparam IF   = 2'b00;
  localparam EXST = 2'b01;
  localparam MEM  = 2'b10;

  always @(posedge clk or negedge resetn)
    begin
      if(resetn == 1'b0)
        begin
          curr_stage <= IF;
        end
      else
        begin
          curr_stage <= next_stage;
        end
    end

  always @(*)
    begin
      case(curr_stage)
        IF:
          begin
            next_stage = EXST;
          end

        EXST:
          begin
            if(mem_inst == 1'b1)
              begin
                next_stage = MEM;
              end
            else
              begin
                next_stage = IF;
              end
          end

        MEM:
          begin
            next_stage = (mem_force == 1'b1) ? EXST : IF;
          end

        default:
          begin
            next_stage = IF;
          end
      endcase
  end

  always @(*)
    begin
      case(curr_stage)
        IF :
          begin
            EXSTtoMEM_Wen = 1'b0;
            IR_Wen      = 1'b1;
            PC_Wen      = 1'b0;
            PSR_Wen     = 1'b0;
            RF_Wen      = 1'b0;
            ST_Wen      = 1'b0;
          end

        EXST :
          begin
            if (mem_inst == 1'b1)
              begin
                EXSTtoMEM_Wen = 1'b1;
                IR_Wen      = 1'b0;
                PC_Wen      = 1'b0;
                PSR_Wen     = 1'b0;
                RF_Wen      = 1'b0;
                ST_Wen      = 1'b0;
              end
            else
              begin
                EXSTtoMEM_Wen = 1'b0;
                IR_Wen      = 1'b0;
                PC_Wen      = 1'b1;
                PSR_Wen     = 1'b1;
                RF_Wen      = 1'b1;
                ST_Wen      = 1'b1;
              end
          end

        MEM :
          begin
            EXSTtoMEM_Wen = 1'b0;  
            IR_Wen      = 1'b0;
            PC_Wen      = (mem_force == 1'b1) ? 1'b0 : 1'b1;
            PSR_Wen     = 1'b0;
            RF_Wen      = 1'b1;
            ST_Wen      = 1'b1;
          end

        default :
          begin
            EXSTtoMEM_Wen = 1'b0;
            IR_Wen      = 1'b0;
            PC_Wen      = 1'b0;
            PSR_Wen     = 1'b0;
            RF_Wen      = 1'b0;
            ST_Wen      = 1'b0;
          end
      endcase
  end

endmodule
