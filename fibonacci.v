module fibonacci 
(
  input wire rst, clk, f_en,
  output wire f_valid,
  output wire [15:0] f_out
);

reg [15:0] f_soma, f_out_reg;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    f_out_reg <= 0;
    f_soma <= 0;
  end else if (f_en) begin
    if (f_out_reg == 0) begin
      f_out_reg <= 16'd1;
    end else if (f_soma == 0) begin
      f_soma <= 16'd1;
    end else begin
      f_out_reg <= f_out_reg + f_soma;
      f_soma <= f_out_reg;
    end
  end
end

assign f_valid = f_en;
assign f_out = f_en ? f_out_reg : 0;

endmodule