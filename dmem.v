module dmem (
  input             clk,
  input      [15:0] dmem_addr,
  input      [31:0] dmem_data_in,
  input             dmem_wr,
  
  output reg [31:0] dmem_data_out
);

  reg [31:0] dmem [255:0];
  
  always @(posedge clk)
    begin
      dmem_data_out <= dmem[dmem_addr];
      if(dmem_wr == 1'b1) 
        begin
          dmem[dmem_addr] <= dmem_data_in;
        end
    end

endmodule

