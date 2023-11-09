module dm 
(
  input wire rst, clk,
  input reg [2:0] prog,
  input reg [1:0] modulo,
  input reg [15:0] data_2,
  output wire [7:0] an, dec_ddp
);
wire [3:0] d1, d2, d3, d4;
assign d1 = data_2 % 10;
assign d2 = (data_2 / 10) % 10;
assign d3 = (data_2 / 100) % 10;
assign d4 = (data_2 / 1000) % 10;
dspl_drv_NexysA7 driver (
  .reset(rst), 
  .clock(clk), 
  .d1({1'b1, d1, 1'b0}), 
  .d2({1'b1, d2, 1'b0}), 
  .d3({1'b1, d3, 1'b0}), 
  .d4({1'b1, d4, 1'b0}), 
  .d5(6'd0), 
  .d6({1'b1, modulo, 1'b0}), 
  .d7(6'd0), 
  .d8({1'b1, prog, 1'b0}), 
  .an(an), 
  .dec_cat(dec_ddp)
);

endmodule
