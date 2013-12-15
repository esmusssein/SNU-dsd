module inst_decoder (
  input      [15:0] inst_in,
  input      [3:0]  PSR_in,
  
  output reg [6:0]  alu_sel,
  output reg        br,
  output reg        immed_sel,
  output reg        link,
  output reg        mem_inst,
  output reg        pc_offset_sel,
  output reg        sh_dir,
  output reg [2:0]  sh_func,
  output reg        shift,
  output reg        store,
  output reg        rdest_sel,
  output reg [1:0]  rsrcA_sel,
  output reg [1:0]  rsrcB_sel,
  output reg        WR,
  output reg        mult,
  output reg        PC_wr
);

  /*opcodes*/
  parameter ADD  = 7'b0001100; 
  parameter ADDI = 5'b00110;  
  parameter SUB  = 7'b0001101;
  parameter SUBI = 5'b00111;
  parameter CMP  = 10'b0100001010; 
  parameter CMPI = 5'b00101;  
  parameter AND  = 10'b0100000000;
  parameter ORR  = 10'b0100001100; 
  parameter EOR  = 10'b0100000001;
  parameter MOV  = 10'b0001110000; 
  parameter MOVI = 5'b00100;
  parameter LSL  = 10'b0100000010;
  parameter LSLI = 5'b00000;  
  parameter LSR  = 10'b0100000011; 
  parameter LSRI = 5'b00001;
  parameter ASR  = 10'b0100000100;
  parameter ASRI = 5'b00010;  
  parameter ROR  = 10'b0100000111;
  parameter LDR  = 7'b0101100; 
  parameter LDRI = 5'b01101;
  parameter STR  = 7'b0101000;
  parameter STRI = 5'b01100;  
  parameter B    = 4'b1101;      
  parameter BL   = 5'b11111;
  parameter BAL  = 5'b11100;
  parameter MUL  = 10'b0100001101;
  parameter RET  = 16'b0100011101110000;
  
  /*ALU operations*/
  `define ALU_ADD 7'b1000000
  `define ALU_SUB 7'b0100000
  `define ALU_CMP 7'b0010000
  `define ALU_AND 7'b0001000
  `define ALU_ORR 7'b0000100
  `define ALU_EOR 7'b0000010
  `define ALU_MOV 7'b0000001
  `define ALU_NOP 7'b0000000
 
  /*conditional codes*/
  `define EQ 4'b0000
  `define NE 4'b0001
  `define CS 4'b0010
  `define CC 4'b0011
  `define MI 4'b0100
  `define PL 4'b0101
  `define VS 4'b0110
  `define VC 4'b0111
  `define HI 4'b1000
  `define LS 4'b1001
  `define GE 4'b1010
  `define LT 4'b1011
  `define GT 4'b1100
  `define LE 4'b1101
  `define AL 4'b1110
  
  always@(*)
    begin
      case(inst_in[15:12])
        B :
          begin
            case(inst_in[11:8])
              `EQ :
                begin
                  if (PSR_in[3] == 1'b1)        // z_flag == 1'b1
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `NE :
                begin
                  if (PSR_in[3] == 1'b0)        // z_flag == 1'b0
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `CS :
                begin
                  if (PSR_in[1] == 1'b1)        // c_flag == 1'b1
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `CC :
                begin
                  if (PSR_in[1] == 1'b0)        // c-flag == 1'b0
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `MI :
                begin
                  if (PSR_in[2] == 1'b1)        // n-flag == 1'b1
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `PL :
                begin
                  if (PSR_in[2] == 1'b0)        // n-flag == 1'b0
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `VS:
                begin
                  if (PSR_in[0] == 1'b1)        // v-flag == 1'b1
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `VC:
                begin
                  if (PSR_in[0] == 1'b0)        // v-flag == 1'b0
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `HI:
                begin
                  if (PSR_in[3] == 1'b0 && PSR_in[1] == 1'b1)       // z_flag == 1'b0 && c_flag == 1'b1
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `LS:
                begin
                  if (PSR_in[3] == 1'b1 || PSR_in[1] == 1'b0)       // z_flag == 1'b1 || c_flag == 1'b0
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `GE:
                begin
                  if (PSR_in[2] == PSR_in[0])       // n_flag == v_flag
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `LT:
                begin
                  if (PSR_in[2] != PSR_in[0])       // n_flag != v_flag
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `GT:
                begin
                  if (PSR_in[3] == 1'b0 && PSR_in[2] == PSR_in[0])     // z_flag == 1'b0 && n_flag == v_flag
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `LE:
                begin
                  if (PSR_in[3] == 1'b1 || PSR_in[2] != PSR_in[0])     // z_flag == 1'b1 || n_flag != v_flag
                    begin 
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b1;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                  else 
                    begin
                      alu_sel = `ALU_NOP;
                      immed_sel = 1'b0;
                      br = 1'b0;
                      link = 1'b0;
                      sh_func = 3'b100;
                      sh_dir = 1'b0;
                      shift = 1'b0;
                      mem_inst = 1'b0;
                      store = 1'b0;
                      rsrcA_sel = 2'b00;
                      rsrcB_sel = 2'b00;
                      rdest_sel = 1'b0;
                      WR = 1'b0;
                      pc_offset_sel = 1'b0;
                      mult = 1'b0;
                      PC_wr = 1'b0;
                    end
                end
              `AL:
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b0;
                  br = 1'b1;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b00;
                  rsrcB_sel = 2'b00;
                  rdest_sel = 1'b0;
                  WR = 1'b0;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              default:
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b0;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b00;
                  rsrcB_sel = 2'b00;
                  rdest_sel = 1'b0;
                  WR = 1'b0;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
            endcase
          end
        default:
          begin
            case(inst_in[15:11])
              ADDI :
                begin
                  alu_sel = `ALU_ADD;
                  immed_sel = 1'b1;     // Immed8
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b11;
                  rsrcB_sel = 2'b11;
                  rdest_sel = 1'b1;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              SUBI :
                begin
                  alu_sel = `ALU_SUB;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b11;
                  rsrcB_sel = 2'b11;
                  rdest_sel = 1'b1;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              CMPI :
                begin
                  alu_sel = `ALU_CMP;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b11;
                  rsrcB_sel = 2'b11;
                  rdest_sel = 1'b1;
                  WR = 1'b0;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              MOVI :
                begin
                  alu_sel = `ALU_MOV;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b11;
                  rsrcB_sel = 2'b11;
                  rdest_sel = 1'b1;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              LSLI :
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b1;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b01;
                  rsrcB_sel = 2'b01;
                  rdest_sel = 1'b0;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              LSRI :
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b1;
                  shift = 1'b1;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b01;
                  rsrcB_sel = 2'b01;
                  rdest_sel = 1'b0;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              ASRI :
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b010;
                  sh_dir = 1'b1;
                  shift = 1'b1;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b01;
                  rsrcB_sel = 2'b01;
                  rdest_sel = 1'b0;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              LDRI :
                begin
                  alu_sel = `ALU_ADD;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b1;
                  store = 1'b0;
                  rsrcA_sel = 2'b01;
                  rsrcB_sel = 2'b01;
                  rdest_sel = 1'b0;
                  WR = 1'b1;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              STRI :
                begin
                  alu_sel = `ALU_ADD;
                  immed_sel = 1'b1;
                  br = 1'b0;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b1;
                  store = 1'b1;
                  rsrcA_sel = 2'b01;
                  rsrcB_sel = 2'b01;
                  rdest_sel = 1'b0;
                  WR = 1'b0;
                  pc_offset_sel = 1'b0;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              BL :
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b1;
                  br = 1'b1;
                  link = 1'b1;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b00;
                  rsrcB_sel = 2'b00;
                  rdest_sel = 1'b0;
                  WR = 1'b0;
                  pc_offset_sel = 1'b1;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              BAL :
                begin
                  alu_sel = `ALU_NOP;
                  immed_sel = 1'b1;
                  br = 1'b1;
                  link = 1'b0;
                  sh_func = 3'b100;
                  sh_dir = 1'b0;
                  shift = 1'b0;
                  mem_inst = 1'b0;
                  store = 1'b0;
                  rsrcA_sel = 2'b00;
                  rsrcB_sel = 2'b00;
                  rdest_sel = 1'b0;
                  WR = 1'b0;
                  pc_offset_sel = 1'b1;
                  mult = 1'b0;
                  PC_wr = 1'b0;
                end
              default :
                begin
                  case(inst_in[15:9])
                    ADD :
                      begin
                        alu_sel = `ALU_ADD;
                        immed_sel = 1'b0;
                        br = 1'b0;
                        link = 1'b0;
                        sh_func = 3'b100;
                        sh_dir = 1'b0;
                        shift = 1'b0;
                        mem_inst = 1'b0;
                        store = 1'b0;
                        rsrcA_sel = 2'b10;
                        rsrcB_sel = 2'b01;
                        rdest_sel = 1'b0;
                        WR = 1'b1;
                        pc_offset_sel = 1'b0;
                        mult = 1'b0;
                        PC_wr = 1'b0;
                      end
                    SUB :
                      begin
                        alu_sel = `ALU_SUB;
                        immed_sel = 1'b0;
                        br = 1'b0;
                        link = 1'b0;
                        sh_func = 3'b100;
                        sh_dir = 1'b0;
                        shift = 1'b0;
                        mem_inst = 1'b0;
                        store = 1'b0;
                        rsrcA_sel = 2'b10;
                        rsrcB_sel = 2'b01;
                        rdest_sel = 1'b0;
                        WR = 1'b1;
                        pc_offset_sel = 1'b0;
                        mult = 1'b0;
                        PC_wr = 1'b0;
                      end
                    LDR :
                      begin
                        alu_sel = `ALU_ADD;
                        immed_sel = 1'b0;
                        br = 1'b0;
                        link = 1'b0;
                        sh_func = 3'b100;
                        sh_dir = 1'b0;
                        shift = 1'b0;
                        mem_inst = 1'b1;
                        store = 1'b0;
                        rsrcA_sel = 2'b10;
                        rsrcB_sel = 2'b01;
                        rdest_sel = 1'b0;
                        WR = 1'b1;
                        pc_offset_sel = 1'b0;
                        mult = 1'b0;
                        PC_wr = 1'b0;
                      end
                    STR :
                      begin
                        alu_sel = `ALU_ADD;
                        immed_sel = 1'b0;
                        br = 1'b0;
                        link = 1'b0;
                        sh_func = 3'b100;
                        sh_dir = 1'b0;
                        shift = 1'b0;
                        mem_inst = 1'b1;
                        store = 1'b1;
                        rsrcA_sel = 2'b10;
                        rsrcB_sel = 2'b01;
                        rdest_sel = 1'b0;
                        WR = 1'b0;
                        pc_offset_sel = 1'b0;
                        mult = 1'b0;
                        PC_wr = 1'b0;
                      end
                    default :            
                      begin
                        case(inst_in[15:6])
                          CMP :
                            begin
                              alu_sel = `ALU_CMP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b0;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          AND :
                            begin
                              alu_sel = `ALU_AND;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          ORR :
                            begin
                              alu_sel = `ALU_ORR;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          EOR :
                            begin
                              alu_sel = `ALU_EOR;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          MOV :
                            begin
                              alu_sel = `ALU_MOV;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b01;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          LSL :
                            begin
                              alu_sel = `ALU_NOP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b1;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          LSR :
                            begin
                              alu_sel = `ALU_NOP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b1;
                              shift = 1'b1;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          ASR :
                            begin
                              alu_sel = `ALU_NOP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b010;
                              sh_dir = 1'b1;
                              shift = 1'b1;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          ROR :
                            begin
                              alu_sel = `ALU_NOP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b001;
                              sh_dir = 1'b1;
                              shift = 1'b1;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b0;
                              PC_wr = 1'b0;
                            end
                          MUL:
                            begin
                              alu_sel = `ALU_NOP;
                              immed_sel = 1'b0;
                              br = 1'b0;
                              link = 1'b0;
                              sh_func = 3'b100;
                              sh_dir = 1'b0;
                              shift = 1'b0;
                              mem_inst = 1'b0;
                              store = 1'b0;
                              rsrcA_sel = 2'b01;
                              rsrcB_sel = 2'b00;
                              rdest_sel = 1'b0;
                              WR = 1'b1;
                              pc_offset_sel = 1'b0;
                              mult = 1'b1;
                              PC_wr = 1'b0;
                            end
                          default :
                            if (inst_in == RET)
                              begin
                                alu_sel = `ALU_NOP;
                                immed_sel = 1'b0;
                                br = 1'b0;
                                link = 1'b0;
                                sh_func = 3'b100;
                                sh_dir = 1'b0;
                                shift = 1'b0;
                                mem_inst = 1'b0;
                                store = 1'b0;
                                rsrcA_sel = 2'b00;
                                rsrcB_sel = 2'b00;
                                rdest_sel = 1'b0;
                                WR = 1'b0;
                                pc_offset_sel = 1'b0;
                                mult = 1'b0;
                                PC_wr = 1'b1;  /**/
                              end
                            else
                              begin
                                alu_sel = `ALU_NOP;
                                immed_sel = 1'b0;
                                br = 1'b0;
                                link = 1'b0;
                                sh_func = 3'b100;
                                sh_dir = 1'b0;
                                shift = 1'b0;
                                mem_inst = 1'b0;
                                store = 1'b0;
                                rsrcA_sel = 2'b00;
                                rsrcB_sel = 2'b00;
                                rdest_sel = 1'b0;
                                WR = 1'b0;
                                pc_offset_sel = 1'b0;
                                mult = 1'b0;
                                PC_wr = 1'b0;
                              end
                          endcase
                      end
                  endcase
                end
            endcase
          end
      endcase
    end

endmodule

