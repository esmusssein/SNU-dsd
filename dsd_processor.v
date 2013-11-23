module dsd_processor (
  input         clk, 
  input         resetn, 
  input  [15:0] dmem_data_in, 
  input  [15:0] imem_data, 
  
  output [15:0] dmem_addr, 
  output [15:0] dmem_data_out,
  output        dmem_wr, 
  output [15:0] imem_addr 
);

  wire [15:0] inst;
  wire [4:0]  immed5;
  wire [7:0]  immed8;
  wire [10:0] immed11;
  wire [2:0]  Rd0;
  wire [2:0]  Rd1;
  wire [2:0]  Rs0;
  wire [2:0]  Rs1;
  wire [2:0]  Rs2;
  wire [2:0]  Rs3;
  wire [2:0]  addr_srcA;
  wire [2:0]  addr_srcB;
  wire [2:0]  addr_dest;
  wire [2:0]  addr_dest_in_ex;
  wire [2:0]  addr_dest_in_mem;
  wire [15:0] srcA;
  wire [15:0] srcB;
  wire [15:0] dest;
  wire [15:0] EX_data;
  wire [15:0] MEM_data;
  wire [15:0] PC_immed16;
  wire        br;
  wire        link;
  wire        mem_inst;
  wire        store;
  wire        IR_Wen;
  wire        PC_Wen;
  wire        EXtoMEM_Wen;
  wire        PSR_Wen;
  wire        RF_Wen;
  wire        WR_in;
  wire        WR_out;
  wire [15:0] RF_in;
  wire        in_mem_stage;
  
  IR u_IR (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .inst_in       (imem_data       ),
    .Wen           (IR_Wen          ),

    .immed5        (immed5          ),
    .immed8        (immed8          ),
    .immed11       (immed11         ),
    .inst_out      (inst            ),
    .Rd0           (Rd0             ),
    .Rd1           (Rd1             ),
    .Rs0           (Rs0             ),
    .Rs1           (Rs1             ),
    .Rs2           (Rs2             ),
    .Rs3           (Rs3             )
  );
  
  EX_top u_EX_top (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .immed5        (immed5          ),
    .immed8        (immed8          ),
    .immed11       (immed11         ),
    .inst          (inst            ),
    .PSR_Wen       (PSR_Wen         ),
    .Rd0           (Rd0             ),
    .Rd1           (Rd1             ),
    .Rs0           (Rs0             ),
    .Rs1           (Rs1             ),
    .Rs2           (Rs2             ),
    .Rs3           (Rs3             ),
    .srcA          (srcA            ),
    .srcB          (srcB            ),

    .addr_srcA     (addr_srcA       ),
    .addr_srcB     (addr_srcB       ),
    .addr_dest     (addr_dest_in_ex ),
    .PC_immed16    (PC_immed16      ),
    .br            (br              ),
    .data_out      (EX_data         ),
    .link          (link            ),
    .mem_inst      (mem_inst        ),
    .store         (store           ),
    .WR            (WR_out          )
  );
  
  RF u_RF (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .addr_srcA     (addr_srcA       ),
    .addr_srcB     (addr_srcB       ),
    .addr_dest     (addr_dest       ),
    .data_in       (RF_in           ),
    .RF_Wen        (RF_Wen          ),
    .WR            (WR_in           ),

    .dest          (dest            ),
    .srcA          (srcA            ),
    .srcB          (srcB            )
  );
  
  pc_gen u_pc_gen (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .br            (br              ),
    .link          (link            ),
    .offset        (PC_immed16      ),
    .PC_Wen        (PC_Wen          ),

    .LR            (                ),
    .PC            (imem_addr       )
  );
  
  EXtoMEM_reg u_EXtoMEM_reg (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .EXtoMEM_Wen   (EXtoMEM_Wen     ),
    .mem_addr_in   (EX_data         ),
    .rdest_addr_in (addr_dest_in_ex ),
    .rdest_data_in (dest            ),
    .store_in      (store           ),

    .mem_addr_out  (dmem_addr       ),
    .rdest_addr_out(addr_dest_in_mem),
    .rdest_data_out(MEM_data        ),
    .store_out     (dmem_wr         )
  );
  
  stageFSM u_stageFSM (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .mem_inst      (mem_inst        ),
    
    .EXtoMEM_Wen   (EXtoMEM_Wen     ),
    .IR_Wen        (IR_Wen          ),
    .PC_Wen        (PC_Wen          ),
    .PSR_Wen       (PSR_Wen         ),
    .RF_Wen        (RF_Wen          )
  );
  
  assign in_mem_stage  = (mem_inst == 1'b1 && EXtoMEM_Wen == 1'b0)? 1'b1 : 1'b0;
  assign WR_in         = (in_mem_stage)? ~dmem_wr : WR_out;
  assign RF_in         = (in_mem_stage)? dmem_data_in : EX_data;
  assign addr_dest     = (in_mem_stage)? addr_dest_in_mem : addr_dest_in_ex;
  assign dmem_data_out = MEM_data;

endmodule

