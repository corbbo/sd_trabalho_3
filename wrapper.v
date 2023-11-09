module wrapper 
(
  input wire clk_1, clk_2, rst, data_1_en,
  input reg [15:0] data_1,
  output reg [15:0] data_2,
  output wire buffer_empty, buffer_full, data_2_valid
);

reg [15:0] t_buffer [0:7]
reg [2:0] buffer_rd, buffer_wr
  reg [15:0] output_data

//lógica de escrever
  always@(posedge clk_1 or posedge rst) begin
    if (rst) begin
      buffer_wr <= 2'd0;
      buffer_empty <= 1'd1;
    end
    else if (data_1_en & ~buffer_full) begin //se o buffer não tá cheio (tem espaço pra escrever)
      t_buffer[buffer_wr] <= data_1; //coloca data_1 na primeira posição do t_buffer
      buffer_wr <= buffer_wr + 2'd1; //incrementa o ponteiro de escrita
      buffer_empty <= 1'd0;
    end
    if (buffer_wr == buffer_rd - 1) begin //se o buffer chegar no final
      buffer_full <= 1'b1; //buffer_full = 1
    end
  end

//lógica de ler
  always@(posedge clk_2 or posedge rst) begin
    if (rst) begin
      buffer_rd <= 2'd0;
      output_data <= 0;
    end
    else if (~buffer_empty) begin //se o buffer não estiver vazio (tem coisa pra ler)
      output_data <= t_buffer[buffer_rd]; //output_data recebe o valor dentro de tbuffer
      buffer_rd <= buffer_rd + 2'd1; //incrementa o ponteiro de leitura
      buffer_full <= 1'd0; //indica que o buffer não está cheio
    end
  end

  assign data_2 = output_data;
  assign data_2_valid = (~buffer_empty) ? 1 : 0;
  
endmodule
