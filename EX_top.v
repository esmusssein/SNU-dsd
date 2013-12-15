module EX_top (
  input         clk, 
  input         resetn, 
  input  [4:0]  immed5, 
  input  [7:0]  immed8, 
  input  [10:0] immed11, 
  input  [15:0] inst, 
  input         PSR_Wen, 
  input  [2:0]  Rd0, 
  input  [2:0]  Rd1, 
  input  [2:0]  Rs0, 
  input  [2:0]  Rs1, 
  input  [2:0]  Rs2,
  input  [2:0]  Rs3,
  input  [31:0] srcA,
  input  [31:0] srcB,

  output [2:0]  addr_srcA,
  output [2:0]  addr_srcB,
  output [2:0]  addr_dest,
  output [15:0] PC_immed16,
  output        br,
  output [31:0] data_out,
  output        link,
  output        mem_inst,
  output        store,
  output        WR,
  output        PC_wr,
  output        send
);

  wire [31:0] ALU_immed32;
  wire [6:0]  alu_sel;
  wire        immed_sel;
  wire        pc_offset_sel;
  wire [3:0]  PSR_flags;
  wire        rdest_sel;
  wire [1:0]  rsrcA_sel;
  wire [1:0]  rsrcB_sel;
  wire        sh_dir;
  wire [2:0]  sh_func;
  wire        shift;
  wire        mult;
  
  control_mux u_control_mux (
    .immed5        (immed5       ),
    .immed8        (immed8       ),
    .immed11       (immed11      ),
    .mem_inst      (mem_inst     ),
    .pc_offset_sel (pc_offset_sel),
    .rdest_sel     (rdest_sel    ),
    .rsrcA_sel     (rsrcA_sel    ),
    .rsrcB_sel     (rsrcB_sel    ),
    .Rd0           (Rd0          ),
    .Rd1           (Rd1          ),
    .Rs0           (Rs0          ),
    .Rs1           (Rs1          ),
    .Rs2           (Rs2          ),
    .Rs3           (Rs3          ),
    
    .addr_srcA     (addr_srcA    ),
    .addr_srcB     (addr_srcB    ),
    .addr_dest     (addr_dest    ),
    .ALU_immed32   (ALU_immed32  ),
    .PC_offset16   (PC_immed16   )
  );
  
  inst_decoder u_inst_decoder (
    .inst_in       (inst         ),
    .PSR_in        (PSR_flags    ),
    
    .alu_sel       (alu_sel      ),
    .br            (br           ),
    .immed_sel     (immed_sel    ),
    .link          (link         ),
    .mem_inst      (mem_inst     ),
    .pc_offset_sel (pc_offset_sel),
    .sh_dir        (sh_dir       ),
    .sh_func       (sh_func      ),
    .shift         (shift        ),
    .store         (store        ),
    .rdest_sel     (rdest_sel    ),
    .rsrcA_sel     (rsrcA_sel    ),
    .rsrcB_sel     (rsrcB_sel    ),
    .WR            (WR           ),
    .mult          (mult         ),
    .PC_wr         (PC_wr),
    .send          (send)
  );
  
  EX_datapath u_EX_datapath (
    .clk           (clk          ),
    .resetn        (resetn       ),
    .alu_sel       (alu_sel      ),
    .immed5        (immed5       ),
    .immed32       (ALU_immed32  ),
    .immed_sel     (immed_sel    ),
    .shift         (shift        ),
    .sh_dir        (sh_dir       ),
    .sh_func       (sh_func      ),
    .srcA          (srcA         ),
    .srcB          (srcB         ),
    .PSR_Wen       (PSR_Wen      ),
    .mult          (mult         ),
    
    .data_out      (data_out     ),
    .PSR_flags     (PSR_flags    )
  );

endmodule

