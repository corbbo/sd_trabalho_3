module wrapper 
(
  input wire clk_1, clk_2, rst, data_1_en,
  input reg [15:0] data_1,
  output reg [15:0] data_2,
  output wire buffer_empty, buffer_full, data_2_valid
);

reg [15:0] t_buffer [0:7];
reg [2:0] pointer_w, pointer_r;
reg [15:0] output_data;

assign buffer_empty = pointer_w == pointer_r ? 1 : 0;
assign buffer_full = pointer_w == 3'd7 & pointer_r < 3'd7 ? 1 : 0;
assign data_2_valid = pointer_w != pointer_r ? 1 : 0;

//logica de escrever
always @(posedge clk_1 or posedge rst) begin
  if (rst) begin
    pointer_w <= 3'd0;
  end
  else if (data_1_en) begin
    if (pointer_w < 3'd7) begin
      t_buffer[pointer_w] <= data_1;
      pointer_w <= pointer_w + 3'd1;
    end
    else if (pointer_w == pointer_r - 3'd1) begin // pointer_w = 7, pointer_r = 6, leu a ultima coisa que tinha (t_buffer[6]), pode comecar a escrever no inicio de novo
      pointer_w <= 3'd0;
      t_buffer[pointer_w] <= data_1;
    end
  end
end

//logica de ler
always @(posedge clk_2 or posedge rst) begin
  if (rst) begin
    pointer_r <= 3'd0;
    data_2 <= 0;
  end
  else if (~buffer_empty) begin
    data_2 <= t_buffer[pointer_r];
    pointer_r <= pointer_r + 3'd1;
    if (pointer_r >= 3'd7) begin
      pointer_r <= 3'd0;
      data_2 <= 0;
    end
  end
end
  
endmodule
