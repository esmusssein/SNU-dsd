module PSR (
    input            clk,
    input            resetn,
    input      [3:0] alu_flag_in,
    input      [6:0] alu_sel,
    input      [3:0] shifter_flag_in,
    input            shift,
    input            Wen,

    output reg [3:0] flag_out
);

    localparam  ADD = 7'b1000000,
                SUB = 7'b0100000,
                CMP = 7'b0010000,
                AND = 7'b0001000,
                ORR = 7'b0000100,
                EOR = 7'b0000010,
                MOV = 7'b0000001;

    wire [3:0] curr_flag;
    reg  [3:0] next_flag;

    assign curr_flag = flag_out;

    always@(posedge clk, negedge resetn)
        begin
            if(resetn == 1'b0)
                begin
                    flag_out <= 4'b0000;
                end
            else
                begin
                    if(Wen == 1'b1)
                        begin
                            flag_out <= next_flag;
                        end
                end
        end


    always@(*)
        begin
            if(shift == 1'b1)
                begin
                    next_flag[3:1] = shifter_flag_in[3:1];
                    next_flag[0]   = curr_flag[0];
                end
            else
                begin
                    //$display("PSR, alu_sel(%h), alu_flag_in(%b)",  alu_sel, alu_flag_in);
                    case(alu_sel)
                        ADD :
                            begin
                                next_flag = alu_flag_in;
                            end
                        SUB :
                            begin
                                next_flag = alu_flag_in;
                            end
                        CMP :
                            begin
                                next_flag = alu_flag_in;
                            end
                        AND :
                            begin
                                // Update only n, z-flag.
                                next_flag[3] = alu_flag_in[3];      // z-flag
                                next_flag[2] = alu_flag_in[2];      // n-flag
                                next_flag[1] = curr_flag[1];        // c-flag
                                next_flag[0] = curr_flag[0];        // v-flag
                            end
                        ORR :
                            begin
                                // Update only z, n-flag.
                                next_flag[3] = alu_flag_in[3];      // z-flag
                                next_flag[2] = alu_flag_in[2];      // n-flag
                                next_flag[1] = curr_flag[1];        // c-flag
                                next_flag[0] = curr_flag[0];        // v-flag
                            end
                        EOR :
                            begin
                                // Update only z, n-flag.
                                next_flag[3] = alu_flag_in[3];      // z-flag
                                next_flag[2] = alu_flag_in[2];      // n-flag
                                next_flag[1] = curr_flag[1];        // c-flag
                                next_flag[0] = curr_flag[0];        // v-flag
                            end
                        MOV :
                            begin
                                next_flag = curr_flag;
                            end
                        default:
                            begin
                                next_flag = curr_flag;
                            end
                    endcase
                end
        end

endmodule

