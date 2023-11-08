module fibonacci 
(
  input wire rst, clk, f_en,
  output wire f_valid,
  output reg [15:0] f_out
);

reg [15:0] f_n1, f_n2;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    f_out <= 0;
    f_n1 <= 0;
    f_n2 <= 0;
  end else if (f_en) begin
    if (f_out == 0) begin
      f_out <= 16'd1;
    end else if (f_out == 16'd1) begin
      f_out <= 16'd1;
      f_n1 <= 16'd1;
    end else begin
      f_out <= f_n1 + f_n2;
      f_n2 <= f_n1;
      f_n1 <= f_out;
    end
  end
end

assign f_valid = f_en;

endmodule