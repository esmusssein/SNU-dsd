module EXST_mux(r
  input        inst_st,
  input        dmem_wr_ex,
  input        dmem_wr_st,
  input [15:0] dmem_addr_ex,
  input [15:0] dmem_addr_st,
  input [31:0] dmem_data_ex,
  input [31:0] dmem_data_st,
  input        RF_wr_ex,
  input        RF_wr_st,
  input [15:0] RF_addr_ex,
  input [15:0] RF_addr_st,
  input [31:0] RF_data_ex,
  input [31:0] RF_data_st,

  output wire        dmem_wr,
  output wire [15:0] dmem_addr,
  output wire [31:0] dmem_data,
  output wire        RF_wr,
  output wire [15:0] RF_addr,
  output wire [31:0] RF_data
);

  assign dmem_wr = (inst_st == 1'b1) ? dmem_wr_st : dmem_wr_ex;
  assign dmem_addr = (inst_st == 1'b1) ? dmem_addr_st : dmem_addr_ex;
  assign dmem_data = (inst_st == 1'b1) ? dmem_data_st : dmem_data_ex;
  assign RF_wr = (inst_st == 1'b1) ? RF_wr_st : RF_wr_ex;
  assign RF_addr = (inst_st == 1'b1) ? RF_addr_st : RF_addr_ex;
  assign RF_data = (inst_st == 1'b1) ? RF_data_st : RF_data_ex;

endmodule