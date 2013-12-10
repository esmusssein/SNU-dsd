/*
 * Stack Top - Parse stack-related instruction,
 * make appropriate control signals for dsd_processor,
 * modify stack pointer.
 */
module ST_top(
  input        clk,              // done
  input        resetn,           // done
  input [6:0]  immed7,           // done
  input [7:0]  immed8,           // done
  input [15:0] LR,
  input [8:0]  RL,               // done
  input [2:0]  Rd0,              // done
  input [2:0]  Rd1,              // done

  output wire [15:0] dmem_addr,  // done
  output wire [2:0]  rdest_addr, // done
  output wire [31:0] dout,       // done
  output wire        store,      // done
  output wire        mem_inst,   // done
  output wire        mem_force,  // done
  output wire        dmem_wr,    // done
  output wire        PC_wr,      // done
  output wire        RF_wr,      // done
  output wire        st_inst     // done
);

  /* operation indicator via hot encoding */
  wire [7:0]  op_sel;
  /* stack pointer */
  wire [15:0] SP;
  /* data_out from datapath */
  wire [31:0] dout_dp;

  /* decode instruction */
  ST_inst_decoder u_inst_decoder(
    .inst_in(inst_in),    // done

    .op_sel(op_sel),      // done
    .mem_inst(mem_inst),  // done
    .store(store),        // done
    .st_inst(st_inst)     // done
  );
  
  /* datapath */
  ST_datapath u_datapath(
    .data_in(SP),       // done
    .op_sel(op_sel),    // done
    .immed7(immed7),    // done
    .immed8(immed8),    // done

    .data_out(dout_dp)  // done
  );

  /* controller */
  ST_controller u_controller(
    .clk(clk),           // done
    .resetn(resetn),     // done
    .data_in(dout_dp),   // done
    .op_sel(op_sel),     // done
    .RL(RL),             // done
    .Rd0(Rd0),           // done
    .Rd1(Rd1),           // done

    .rdest_addr(rdest_addr), // done
    .dmem_addr(dmem_addr),   // done
    .mem_force(mem_force),   // done
    .dmem_wr(dmem_wr),       // done
    .PC_wr(PC_wr),
    .RF_wr(RF_wr),
    .SP_out(SP)              // done
  );

  assign dout = dout_dp;

endmodule