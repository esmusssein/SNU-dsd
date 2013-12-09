module EXtoMEM_reg (
  input         clk,
  input         resetn,
  input         EXtoMEM_Wen,
  input  [15:0] mem_addr_in,
  input  [2:0]  rdest_addr_in,
  input  [31:0] rdest_data_in,
  input         store_in,
  
  output [15:0] mem_addr_out,
  output [2:0]  rdest_addr_out,
  output [31:0] rdest_data_out,
  output        store_out
);

  reg  [15:0] mem_addr;
  reg  [2:0]  rdest_addr;
  reg  [31:0] rdest_data;
  reg         store;
  
  wire [15:0] next_mem_addr;
  wire [2:0]  next_rdest_addr;
  wire [31:0] next_rdest_data;
  wire        next_store;
  
  always@(posedge clk, negedge resetn)
    begin
      if(resetn == 1'b0) 
        begin
          mem_addr   <= 15'h0000;
          rdest_addr <= 3'h0;
          rdest_data <= 32'h0000;
          store      <= 1'b0;
        end 
      else 
        begin
          mem_addr   <= next_mem_addr;
          rdest_addr <= next_rdest_addr;
          rdest_data <= next_rdest_data;
          store      <= next_store;
        end
    end
  
  assign next_mem_addr   = (EXtoMEM_Wen == 1'b1) ? mem_addr_in : mem_addr;
  assign next_store      = (EXtoMEM_Wen == 1'b1) ? store_in : store;
  assign next_rdest_data = (EXtoMEM_Wen == 1'b1) ? rdest_data_in : rdest_data;
  assign next_rdest_addr = (EXtoMEM_Wen == 1'b1) ? rdest_addr_in : rdest_addr;
  
  assign mem_addr_out    = mem_addr;
  assign store_out       = store;
  assign rdest_data_out  = rdest_data;
  assign rdest_addr_out  = rdest_addr;

endmodule

