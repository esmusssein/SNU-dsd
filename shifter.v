/* TEST */
module shifter(
  input [31:0] data_in,
  input        dir,
  input [2:0]  func,
  input [4:0]  shamt,

  output [31:0] data_out,
  output [3:0]  flag_out
);

  localparam LOG_SHIFT = 3'b100;
  localparam ARI_SHIFT = 3'b010;
  localparam ROT_SHIFT = 3'b001;

  reg [31:0] stage1;    // shifted by 16
  reg [31:0] stage2;    // shifted by 8
  reg [31:0] stage3;    // shifted by 4
  reg [31:0] stage4;    // shifted by 2
  reg [31:0] stage5;    // shifted by 1
  reg [4:0]  last_out;

  /*shifted by 16*/
  always@(*)
    begin
      if(shamt[4] == 1'b1) 
        begin
          if(dir == 1'b1) 
            begin
              last_out[0] = data_in[15];

              case(func)
                LOG_SHIFT :
                  begin
                    stage1 = {{16{1'b0}}, data_in[31:16]};
                  end

                ARI_SHIFT :
                  begin
                    if(data_in[31] == 1'b1) 
                      begin
                        stage1 = {{16{1'b1}}, data_in[31:16]};
                      end 
                    else 
                      begin
                        stage1 = {{16{1'b0}}, data_in[31:16]};
                      end
                  end

                ROT_SHIFT :
                  begin
                    stage1 = {data_in[15:0], data_in[31:16]};
                  end

                default :
                  begin
                    stage1 = data_in;
                  end
              endcase
            end 
          else 
            begin
              last_out[0] = data_in[16];

              case(func)
                LOG_SHIFT :
                  begin
                    stage1 = {data_in[15:0], {16{1'b0}}};
                  end

                ARI_SHIFT :
                  begin
                    stage1 = {data_in[15:0], {16{1'b0}}};
                  end

                ROT_SHIFT :
                  begin
                    stage1 = {data_in[15:0], data_in[31:16]};
                  end

                default :
                  begin 
                    stage1 = data_in;
                  end
              endcase
            end
        end 
      else 
        begin
          last_out[0] = 1'b0;
          stage1      = data_in;
        end
    end

  /*shifted by 8*/
  always@(*)
    begin
      if (shamt[3] == 1'b1)
        begin
          if (dir == 1'b1)
            begin
              last_out[1] = stage1[7];
              stage2[23:0] = stage1[31:8];

              case (func)
                LOG_SHIFT:
                  begin
                    stage2[31:24] = {8{1'b0}};
                  end

                ARI_SHIFT:
                  begin
                    stage2[31:24] = {8{stage1[31]}};
                  end

                ROT_SHIFT:
                  begin
                    stage2[31:24] = stage1[7:0];
                  end

                default
                  begin
                    stage2[31:24] = {8{1'b0}};
                  end
              endcase
            end
          else
            begin
              last_out[1] = stage1[24];
              stage2[31:8] = stage1[23:0];

              case (func)
                LOG_SHIFT:
                  begin
                    stage2[7:0] = {8{1'b0}};
                  end

                ARI_SHIFT:
                  begin
                    stage2[7:0] = {8{1'b0}};
                  end

                ROT_SHIFT:
                  begin
                    stage2[7:0] = stage1[31:24];
                  end

                default
                  begin
                    stage2[7:0] = {8{1'b0}};
                  end
              endcase
            end
        end
      else
        begin
          last_out[1] = last_out[0];
          stage2 = stage1; 
        end
    end

  /*shifted by 4*/
  always@(*)
    begin
      if(shamt[2] == 1'b1) 
        begin
          if(dir == 1'b1) 
            begin
              last_out[2]  = stage2[3];
              stage3[27:0] = stage2[31:4];

              case(func)
                LOG_SHIFT :
                  begin
                    stage3[31:28] = 0;
                  end

                ARI_SHIFT :
                  begin
                    if(stage2[15] == 1'b1) 
                      begin
                        stage3[31:28] = 4'hf;
                      end 
                    else 
                      begin
                        stage3[31:28] = 4'h0;
                      end
                  end

                ROT_SHIFT :
                  begin
                    stage3[31:28] = stage2[3:0];
                  end

                default :
                  begin
                    stage3[31:28] = 0;
                  end
              endcase
            end 
          else 
            begin
              last_out[2]  = stage2[28];
              stage3[31:4] = stage2[27:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage3[3:0] = 4'd0;
                  end

                ARI_SHIFT :
                  begin
                    stage3[3:0] = 4'd0;
                  end

                ROT_SHIFT :
                  begin
                    stage3[3:0] = stage2[31:28];
                  end

                default :
                  begin 
                    stage3[3:0] = 4'd0;
                  end
              endcase
            end
        end
      else 
        begin
          last_out[2] = last_out[1];
          stage3 = stage2;
        end
    end

  /*shifted by 2*/
  always@(*)
    begin
      if(shamt[1] == 1'b1) 
        begin
          if(dir == 1'b1) 
            begin
              last_out[3]  = stage3[1];
              stage4[29:0] = stage3[31:2];

              case(func)
                LOG_SHIFT :
                  begin
                    stage4[31:30] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage4[31:30] = {2{stage3[31]}};
                  end

                ROT_SHIFT :
                  begin
                    stage4[31:30] = stage3[1:0];
                  end

                default :
                  begin
                    stage4[31:30] = {2{1'b0}};
                  end
              endcase
            end 
          else 
            begin
              last_out[3]  = stage3[30];
              stage4[31:2] = stage3[29:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage4[1:0] = 2'd0;
                  end

                ARI_SHIFT :
                  begin
                    stage4[1:0] = 2'd0;
                  end

                ROT_SHIFT :
                  begin
                    stage4[1:0] = stage3[31:30];
                  end

                default :
                  begin 
                    stage4[1:0] = 2'd0;
                  end
              endcase
            end
        end 
      else 
        begin
          last_out[3] = last_out[2];
          stage4 = stage3;
        end
    end

  /*shifted by 1*/
  always@(*)
    begin
      if(shamt[0] == 1'b1) 
        begin
          if(dir == 1'b1) 
            begin
              last_out[4]  = stage4[0];
              stage5[30:0] = stage4[31:1];

              case(func)
                LOG_SHIFT :
                  begin
                    stage5[31] = 1'd0;
                  end

                ARI_SHIFT :
                  begin
                    stage5[31] = stage4[31];
                  end

                ROT_SHIFT :
                  begin
                    stage5[31] = stage3[0];
                  end

                default :
                  begin
                    stage5[31] = 1'b0;
                  end
              endcase
            end 
          else
            begin
              last_out[4]  = stage4[31];
              stage5[31:1] = stage4[30:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage5[0] = 1'b0;
                  end

                ARI_SHIFT :
                  begin
                    stage5[0] = 1'b0;
                  end

                ROT_SHIFT :
                  begin
                    stage5[0] = stage4[31];
                  end

                default :
                  begin 
                    stage5[0] = 1'b0;
                  end
              endcase
            end
        end 
      else 
        begin
          last_out[4] = last_out[3];
          stage5 = stage4;
        end
    end
  
  assign data_out    = stage5;
  assign flag_out[3] = ~| stage5;   // z flag
  assign flag_out[2] = stage5[15];  // n flag
  assign flag_out[1] = last_out[4]; // c flag
  assign flag_out[0] = 1'b0;        // v flag

endmodule
