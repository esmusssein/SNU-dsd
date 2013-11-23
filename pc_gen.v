/*  Writer:  Jay Kim
    Purpose: Store a present instruction address
             and calculate a next instruction or a Link Register.
    Args:    br: whether Branch occurs.
             PC_Wen: PC write enable.
             link: whether Branch with Link occurs.
    Verified: Yes.
*/
module pc_gen (
    input             clk,
    input             resetn,
    input             br,
    input             link,
    input      [15:0] offset,
    input             PC_Wen,

    output reg [15:0] LR,
    output reg [15:0] PC
);

    reg [15:0] nextPC;
    reg [15:0] nextLR;

    always @(posedge clk or negedge resetn)
        begin
            if(resetn == 1'b0) 
                begin
                    PC <= 16'h0000;
                    LR <= 16'h0000;
                end 
            else 
                begin
                    PC <= nextPC;
                    LR <= nextLR;
                end
        end
  
    // Calculate nextPC.
    always @(*)
        begin
            if (PC_Wen == 1'b1)
                begin
                    if (br == 1'b1)
                        begin
                            nextPC = PC + (offset << 1) + 4;            
                        end
                    else
                        begin
                            nextPC = PC + 2;
                        end
                end
            else
                begin
                    nextPC = PC;
                end
        end

    // Calculate nextLR.
    always @(*)
        begin
            if (PC_Wen == 1'b1)
                begin
                    if (link == 1'b1)
                        begin
                            nextLR = PC + 2;
                        end
                    else
                        begin
                            nextLR = LR;
                        end
                end
            else
                begin
                    nextLR = LR;
                end
        end

endmodule
