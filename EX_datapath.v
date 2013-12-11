module EX_datapath (
  input         clk, 
  input         resetn, 
  input  [6:0]  alu_sel, 
  input  [4:0]  immed5, 
  input  [31:0] immed32, 
  input         immed_sel, 
  input         shift, 
  input         sh_dir, 
  input  [2:0]  sh_func, 
  input  [31:0] srcA,
  input  [31:0] srcB, 
  input         PSR_Wen, 
  
  output [31:0] data_out,
  output [3:0]  PSR_flags
);

  /* inner wire */
  wire [31:0] selected_a;
  wire [3:0]  alu_flag;
  wire [3:0]  sh_flag;
  wire [31:0] alu_data;
  wire [31:0] sh_data;
  wire [4:0]  shamt;
  
  /* be aware of it selects a, not b */
  assign selected_a = (immed_sel == 1'b1)? immed32 : srcA;
  assign shamt      = (immed_sel == 1'b1)? immed5  : srcA[4:0];
  
  ALU u_ALU (
    .a               (selected_a),
    .b               (srcB      ),
    .alu_sel         (alu_sel   ),
    
    .data_out        (alu_data  ),
    .flag_out        (alu_flag  )
  );
  
  shifter u_shifter (
    .data_in         (srcB      ),
    .dir             (sh_dir    ),
    .func            (sh_func   ),
    .shamt           (shamt     ),
    
    .data_out        (sh_data   ),
    .flag_out        (sh_flag   )
  );
  
  PSR u_PSR (
    .clk             (clk       ),
    .resetn          (resetn    ),
    .alu_flag_in     (alu_flag  ),
    .alu_sel         (alu_sel   ),
    .shifter_flag_in (sh_flag   ),
    .shift           (shift     ),
    .Wen             (PSR_Wen   ),
    
    .flag_out        (PSR_flags )
  );
  
  assign data_out = (shift == 1'b1)? sh_data : alu_data;

endmodule