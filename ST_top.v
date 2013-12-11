/*
 * Stack Top - Parse stack-related instruction,
 * make appropriate control signals for dsd_processor,
 * modify stack pointer.
 */
module ST_top(
  input        clk,
  input        resetn,
  input        ST_Wen,
  input [6:0]  immed7,
  input [7:0]  immed8,
  input [15:0] LR,
  input [8:0]  RL,
  input [2:0]  Rd0,
  input [2:0]  Rd1,
  input [15:0] inst_in,

  output wire [15:0] dmem_addr,
  output wire [2:0]  rdest_addr,
  output wire [31:0] dout,
  output wire        LR_sel,
  output wire        store,
  output wire        mem_inst,
  output wire        mem_force,
  output wire        dmem_wr,
  output wire        PC_wr,
  output wire        RF_wr,
  output wire        st_inst
);

  /* operation indicator via hot encoding */
  wire [7:0]  op_sel;
  /* stack pointer */
  wire [15:0] SP;
  wire [31:0] SP_ext;
  /* data_out from datapath */
  wire [31:0] dout_dp;

  /* decode instruction */
  ST_inst_decoder u_inst_decoder(
    .inst_in(inst_in),

    .op_sel(op_sel),
    .mem_inst(mem_inst),
    .store(store),
    .st_inst(st_inst)
  );

  /* datapath */
  ST_datapath u_datapath(
    .data_in(SP_ext),
    .op_sel(op_sel),
    .immed7(immed7),
    .immed8(immed8),

    .data_out(dout_dp)
  );

  /* controller */
  ST_controller u_controller(
    .clk(clk),
    .resetn(resetn),
    .ST_Wen(ST_Wen),
    .data_in(dout_dp),
    .op_sel(op_sel),
    .RL(RL),
    .Rd0(Rd0),
    .Rd1(Rd1),
    .LR(LR),

    .rdest_addr(rdest_addr),
    .dmem_addr(dmem_addr),
    .mem_force(mem_force),
    .dmem_wr(dmem_wr),
    .LR_sel(LR_sel),
    .PC_wr(PC_wr),
    .RF_wr(RF_wr),
    .SP_out(SP)
  );

  assign dout = dout_dp;
  assign SP_ext = {{16{1'b0}}, SP};

endmodule