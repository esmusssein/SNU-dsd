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

  reg [15:0] stage1;    // shifted by 16
  reg [15:0] stage2;    // shifted by 8
  reg [15:0] stage3;    // shifted by 4
  reg [15:0] stage4;    // shifted by 2
  reg [15:0] stage5;    // shifted by 1
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
                    stage1 = 16'd0;
                  end

                ARI_SHIFT :
                  begin
                    if(data_in[15] == 1'b1) 
                      begin
                        stage1 = 16'hFFFF;
                      end 
                    else 
                      begin
                        stage1 = 16'h0000;
                      end
                  end

                ROT_SHIFT :
                  begin
                    stage1 = data_in;
                  end

                default :
                  begin
                    stage1 = data_in;
                  end
              endcase
            end 
          else 
            begin
              last_out[0] = data_in[0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage1 = 16'd0;
                  end

                ARI_SHIFT :
                  begin
                    stage1 = 16'd0;
                  end

                ROT_SHIFT :
                  begin
                    stage1 = data_in;
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
              stage2[7:0] = stage1[15:8];

              case (func)
                LOG_SHIFT:
                  begin
                    stage2[15:8] = {8{1'b0}};
                  end

                ARI_SHIFT:
                  begin
                    stage2[15:8] = {8{stage1[15]}};
                  end

                ROT_SHIFT:
                  begin
                    stage2[15:8] = stage1[7:0];
                  end

                default
                  begin
                    stage2[15:8] = {8{1'b0}};
                  end
              endcase
            end
          else
            begin
              last_out[1] = stage1[8];
              stage2[15:8] = stage1[7:0];

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
                    stage2[7:0] = stage1[15:8];
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
              stage3[11:0] = stage2[15:4];

              case(func)
                LOG_SHIFT :
                  begin
                    stage3[15:12] = 0;
                  end

                ARI_SHIFT :
                  begin
                    if(stage2[15] == 1'b1) 
                      begin
                        stage3[15:12] = 4'hf;
                      end 
                    else 
                      begin
                        stage3[15:12] = 4'h0;
                      end
                  end

                ROT_SHIFT :
                  begin
                    stage3[15:12] = stage2[3:0];
                  end

                default :
                  begin
                    stage3[15:12] = 0;
                  end
              endcase
            end 
          else 
            begin
              last_out[2]  = stage2[12];
              stage3[15:4] = stage2[11:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage3[3:0] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage3[3:0] = 0;
                  end

                ROT_SHIFT :
                  begin
                    stage3[3:0] = stage2[15:12];
                  end

                default :
                  begin 
                    stage3[3:0] = 0;
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
              stage4[13:0] = stage3[15:2];

              case(func)
                LOG_SHIFT :
                  begin
                    stage4[15:14] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage4[15:14] = {2{stage3[15]}};
                  end

                ROT_SHIFT :
                  begin
                    stage4[15:14] = stage3[1:0];
                  end

                default :
                  begin
                    stage4[15:14] = {2{1'b0}};
                  end
              endcase
            end 
          else 
            begin
              last_out[3]  = stage3[14];
              stage4[15:2] = stage3[13:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage4[1:0] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage4[1:0] = 0;
                  end

                ROT_SHIFT :
                  begin
                    stage4[1:0] = stage3[15:14];
                  end

                default :
                  begin 
                    stage4[1:0] = 0;
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
              stage5[14:0] = stage4[15:1];

              case(func)
                LOG_SHIFT :
                  begin
                    stage5[15] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage5[15] = stage4[15];
                  end

                ROT_SHIFT :
                  begin
                    stage5[15] = stage3[1:0];
                  end

                default :
                  begin
                    stage5[15] = 1'b0;
                  end
              endcase
            end 
          else
            begin
              last_out[4]  = stage4[15];
              stage5[15:1] = stage4[14:0];

              case(func)
                LOG_SHIFT :
                  begin
                    stage5[0] = 0;
                  end

                ARI_SHIFT :
                  begin
                    stage5[0] = 0;
                  end

                ROT_SHIFT :
                  begin
                    stage5[0] = stage4[15];
                  end

                default :
                  begin 
                    stage5[0] = 0;
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
