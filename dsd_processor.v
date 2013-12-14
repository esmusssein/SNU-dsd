module dsd_processor (
  input         clk,
  input         resetn,
  input  [31:0] dmem_data_in,
  input  [15:0] imem_data,

  output [15:0] dmem_addr,
  output [31:0] dmem_data_out,
  output        dmem_wr,
  output [15:0] imem_addr
);

  wire [15:0] inst;
  wire [4:0]  immed5;
  wire [6:0]  immed7;
  wire [7:0]  immed8;
  wire [10:0] immed11;
  wire [2:0]  Rd0;
  wire [2:0]  Rd1;
  wire [2:0]  Rs0;
  wire [2:0]  Rs1;
  wire [2:0]  Rs2;
  wire [2:0]  Rs3;
  wire [8:0]  RL;
  wire [2:0]  addr_srcA;
  wire [2:0]  addr_srcB;
  wire [2:0]  addr_dest;
  wire [2:0]  addr_dest_in_ex;
  wire [2:0]  addr_dest_in_mem;
  wire [31:0] srcA;
  wire [31:0] srcB;
  wire [31:0] dest;
  wire [31:0] EX_data;
  wire [31:0] MEM_data;
  wire [15:0] PC_immed16;
  wire        br;
  wire        link;
  wire        store_ex;
  wire        IR_Wen;
  wire        PC_Wen;
  wire        PSR_Wen;
  wire        RF_Wen;
  wire        WR_in;
  wire        WR_out_ex;
  wire [31:0] RF_in;
  wire        in_mem_stage;
  wire [15:0] LR;
  wire [31:0] LR_ext;
  wire        ST_Wen;
  wire        PC_wr;

  /* wire for EXSTtoMEM_reg */
  wire [31:0] EXSTtoMEM_reg_din;

  /* wires for stack */
  wire [15:0] dmem_addr_st;
  wire [2:0]  rdest_addr_st;
  wire [31:0] dout_st;
  wire        store_st;
  wire        mem_inst_st;
  wire        mem_force_st;
  wire        dmem_wr_st;
  wire        PC_wr_st;
  wire        RF_wr_st;
  wire        st_inst;
  wire        LR_sel_st;

  /* wire for EXST */
  wire [31:0] EXST_data;
  wire        mem_inst_exst;
  wire        store_exst;
  wire        WR_out_exst;
  wire [2:0]  addr_dest_in_exst;
  wire        EXSTtoMEM_Wen;
  wire [15:0] mem_addr_in_exst;

  IR u_IR (
    .clk           (clk             ),
    .resetn        (resetn          ),
    .inst_in       (imem_data       ),
    .Wen           (IR_Wen          ),

    .immed5        (immed5          ),
    .immed7        (immed7          ),
    .immed8        (immed8          ),
    .immed11       (immed11         ),
    .inst_out      (inst            ),
    .Rd0           (Rd0             ),
    .Rd1           (Rd1             ),
    .Rs0           (Rs0             ),
    .Rs1           (Rs1             ),
    .Rs2           (Rs2             ),
    .Rs3           (Rs3             ),
    .RL            (RL              )
  );

  RF #(32) u_RF (
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
    .clk           (clk),
    .resetn        (resetn),
    .br            (br),
    .link          (link),
    .data_in       (dmem_data_in[15:0]),
    .offset        (PC_immed16),
    .PC_Wen        (PC_Wen),
    .PC_wr         (PC_wr),

    .LR            (LR),
    .PC            (imem_addr)
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

    .addr_srcA     (addr_srcA),
    .addr_srcB     (addr_srcB),
    .addr_dest     (addr_dest_in_ex),
    .PC_immed16    (PC_immed16),
    .br            (br),
    .data_out      (EX_data),
    .link          (link),
    .mem_inst      (mem_inst_ex),
    .store         (store_ex),
    .WR            (WR_out_ex)
  );

  ST_top u_ST_top(
    .clk(clk),
    .resetn(resetn),
    .ST_Wen(ST_Wen),
    .immed7(immed7),
    .immed8(immed8),
    .LR(LR),
    .RL(RL),
    .Rd0(Rd0),
    .Rd1(Rd1),
    .inst_in(inst),

    .dmem_addr(dmem_addr_st),
    .rdest_addr(rdest_addr_st),
    .dout(dout_st),
    .LR_sel(LR_sel_st),
    .mem_inst(mem_inst_st),
    .mem_force(mem_force_st),
    .dmem_wr(dmem_wr_st),
    .PC_wr(PC_wr_st),
    .RF_wr(RF_wr_st),
    .st_inst(st_inst)
  );  

  EXSTtoMEM_reg u_EXSTtoMEM_reg (
    .clk(clk),
    .resetn(resetn),
    .EXSTtoMEM_Wen(EXSTtoMEM_Wen),
    .mem_addr_in(mem_addr_in_exst),
    .rdest_addr_in(addr_dest_in_exst),
    .data_in(EXSTtoMEM_reg_din),
    .store_in(store_exst),
    .PC_wr_in(PC_wr_st),

    .mem_addr_out  (dmem_addr),
    .rdest_addr_out(addr_dest_in_mem),
    .data_out(MEM_data),
    .store_out(dmem_wr),
    .PC_wr_out(PC_wr)
  );

  stageFSM u_stageFSM (
    .clk           (clk),
    .resetn        (resetn),
    .mem_inst      (mem_inst_exst),
    .mem_force     (mem_force_st),

    .EXSTtoMEM_Wen (EXSTtoMEM_Wen),
    .IR_Wen        (IR_Wen),
    .PC_Wen        (PC_Wen),
    .PSR_Wen       (PSR_Wen),
    .RF_Wen        (RF_Wen),
    .ST_Wen        (ST_Wen)
  );

  /* for put LR instead of register */
  assign LR_ext = {{16{1'b0}}, LR};
  assign EXSTtoMEM_reg_din = (LR_sel_st == 1'b0) ? dest : LR_ext;

  /* select between ex and st */
  assign mem_inst_exst = mem_inst_ex | mem_inst_st;
  assign EXST_data = (st_inst == 1'b1) ? dout_st : EX_data;
  assign addr_dest_in_exst = (st_inst == 1'b1) ? rdest_addr_st : addr_dest_in_ex;
  assign store_exst = store_ex | dmem_wr_st;
  assign WR_out_exst = (st_inst == 1'b1) ? RF_wr_st : WR_out_ex;
  assign mem_addr_in_exst = (st_inst == 1'b1) ? dmem_addr_st : EX_data[15:0];

  /* select mem or exst */
  assign in_mem_stage  = (mem_inst_exst == 1'b1 && EXSTtoMEM_Wen == 1'b0) ? 1'b1 : 1'b0;
  assign WR_in         = (in_mem_stage == 1'b1) ? (~dmem_wr & RF_wr_st) : WR_out_exst;  // ~dmem_wr => load-instruction
  assign RF_in         = (in_mem_stage == 1'b1) ? dmem_data_in : EXST_data;
  assign addr_dest     = (in_mem_stage == 1'b1) ? addr_dest_in_mem : addr_dest_in_exst;
  assign dmem_data_out = MEM_data;

endmodule