module timer 
(
  input wire rst, clk, t_en,
  output wire t_valid,
  output reg [15:0] t_out
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    t_out <= 0;
  end else begin
    if (t_en) begin
      t_out <= t_out + 1;
    end
  end
end

assign t_valid = t_en;

endmodule