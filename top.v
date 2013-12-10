module top ();
  reg         clk;
  reg         resetn;

  wire [15:0] imem_addr;
  wire [15:0] imem_data;
  wire [15:0] dmem_addr;
  wire [31:0] dmem_data_write;
  wire [31:0] dmem_data_read;
  wire dmem_wr;
  
  dsd_processor u_dsd_processor (
    .clk            (clk                     ), 
    .resetn         (resetn                  ), 
    .dmem_data_in   (dmem_data_read          ),
    .imem_data      (imem_data               ), 
    
    .dmem_addr_exst (dmem_addr               ),
    .dmem_data_out  (dmem_data_write         ),
    .dmem_wr_exst   (dmem_wr                 ), 
    .imem_addr      (imem_addr               ) 
  );
  
  imem u_imem (
    .clk           (~clk                    ),
    .imem_addr     ({1'b0, imem_addr[15:1]} ),

    .imem_data     (imem_data               )
  );
  
  dmem u_dmem (
    .clk           (~clk                    ),
    .dmem_addr     ({2'b00, dmem_addr[15:2]}),
    .dmem_data_in  (dmem_data_write         ),
    .dmem_wr       (dmem_wr                 ),

    .dmem_data_out (dmem_data_read          )
  );
  
  initial
    begin
      resetn = 1'b0;
      clk    = 1'b1;
      #15 
      resetn = 1'b1;
    end
  
  initial
    begin
      forever
        begin
          #5 clk = ~clk;
        end
    end

endmodule

