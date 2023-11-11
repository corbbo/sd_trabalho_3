module edge_detector_sim
(
  input clk, rst, din,
  output rising
);

  reg din_reg;

  assign rising = (din_reg == 1'b0 && din == 1'b1) ? 1'b1 : 1'b0;

  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1) begin
      din_reg <= 1'b0;
    end
    else begin
      din_reg <= din;
    end
  end

endmodule