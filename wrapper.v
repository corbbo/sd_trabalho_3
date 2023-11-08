module wrapper 
(
  input wire clk_1, clk_2, rst, data_1_en,
  input reg [15:0] data_1,
  output reg [15:0] data_2,
  output wire buffer_empty, buffer_full, data_2_valid
);

reg [15:0] t_buffer [0:7]

endmodule