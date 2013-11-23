/* TEST */
module control_mux (
    input      [4:0]  immed5,
    input      [7:0]  immed8,
    input      [10:0] immed11,
    input             mem_inst,
    input             pc_offset_sel,
    input             rdest_sel,
    input      [1:0]  rsrcA_sel,
    input      [1:0]  rsrcB_sel,
    input      [2:0]  Rd0,
    input      [2:0]  Rd1,
    input      [2:0]  Rs0,
    input      [2:0]  Rs1,
    input      [2:0]  Rs2,
    input      [2:0]  Rs3,

    output reg [2:0]  addr_srcA,
    output reg [2:0]  addr_srcB,
    output reg [2:0]  addr_dest,
    output reg [15:0] ALU_immed32,
    output reg [15:0] PC_offset16
);

    /* Selects addr_srcA */
    always @(*)
        begin
            case (rsrcA_sel)
                2'b00:
                    begin
                        addr_srcA = Rs0;
                    end
                2'b01:
                    begin
                        addr_srcA = Rs1;
                    end
                2'b10:
                    begin
                        addr_srcA = Rs2;
                    end
                2'b11:
                    begin
                        addr_srcA = Rs3;
                    end
                default:
                    begin
                        addr_srcA = Rs0;
                    end
            endcase
        end

    /* Selects addr_srcB */
    always @(*)
        begin
            case (rsrcB_sel)
                2'b00:
                    begin
                        addr_srcB = Rs0;
                    end
                2'b01:
                    begin
                        addr_srcB = Rs1;
                    end
                2'b10:
                    begin
                        addr_srcB = Rs2;
                    end
                2'b11:
                    begin
                        addr_srcB = Rs3;
                    end
                default:
                    begin
                        addr_srcB = Rs0;
                    end
            endcase
        end

    /* Selects addr_dest */
    always @(*)
        begin
            case (rdest_sel)
                1'b0:
                    begin
                        addr_dest = Rd0;
                    end
                1'b1:
                    begin
                        addr_dest = Rd1;
                    end
                default:
                    begin
                        addr_dest = Rd0;
                    end
            endcase
        end

    /* Extends ALU_immed32 to zeros.
       mem_inst selectes what would be extended for. */
    always @(*)
        begin
            if (mem_inst == 1'b1)
                begin
                    ALU_immed32 = {25'd0, immed5, 2'd0};
                end
            else
                begin
                    ALU_immed32 = {24'd0, immed8};
                end
        end

    /* Extends PC_offset16 to sign bits.
       pc_offset_sel selects what would be extends for. */
    always @(*)
        begin
            if (pc_offset_sel == 1'b1)
                begin
                    if (immed11[10] == 1'b1)
                        begin
                            PC_offset16 = {5'b11111, immed11};
                        end
                    else
                        begin
                            PC_offset16 = {5'b00000, immed11};
                        end
                end
            else
                begin
                    if (immed8[7] == 1'b1)
                        begin
                            PC_offset16 = {8'b1111_1111, immed8};
                        end
                    else
                        begin
                            PC_offset16 = {8'b0000_0000, immed8};
                        end
                end
        end

endmodule
