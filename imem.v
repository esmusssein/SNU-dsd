module imem (
  input             clk,
  input      [15:0] imem_addr,

  output reg [15:0] imem_data
);

  reg [15:0] imem [8000:0];
  
  initial
    begin
      $readmemh("imem_data.txt", imem);
    end
  
  always@(posedge clk)
    begin
      imem_data <= imem[imem_addr];
    end

endmodule

