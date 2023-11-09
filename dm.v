module dm 
(
  input wire rst, clk,
  input reg [2:0] prog,
  input reg [1:0] modulo,
  input reg [15:0] data_2,
  output wire [7:0] an, dec_ddp
);

dspl_drv_NexysA7 driver (
  .reset(rst), 
  .clock(clk), 
  .d1(data_2 menos significativo), 
  .d2(data_2), 
  .d3(data_2), 
  .d4(data_2 mais significativo), 
  .d5(0), 
  .d6(modulo), 
  .d7(0), 
  .d8(prog), 
  .an(an), 
  .dec_cat(dec_ddp)
);

endmodule