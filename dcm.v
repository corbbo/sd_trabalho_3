module dcm 
(
  input wire rst, clk, update,
  input reg [2:0] prog,
  output wire [2:0] prog_out,
  output wire clk_1, clk_2
);

reg [2:0] prog_reg;
reg [31:0] counter_clk_1, counter_clk_2;

// prog_out <= prog;
always @(posedge clk or posedge rst) begin
  if (rst) begin
    prog <= 0;
  end else if (update) begin
    prog_reg <= prog;
  end
end

// Divisores de clock
wire clock, clock_1;
reg [31:0] counter, counter_clk_1;
always@(posedge clk or posedge rst) begin
  if (reset) begin
    clock <= 0;
    counter <= 0;
  end
  else if begin
    case (prog_reg)
      2'b000: begin
        //clock de 0.1 segundos; counter_clkc_2 = conversao
              if (counter >= 31'd4999999) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end

      2'b001: begin
        //clock de 0.2 segundos; counter_clk_2 = conversao
              if (counter >= 31'd9999998) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end

      2'b010: begin
        //clock de 0.4 segundos; counter_clk_2 = conversao
              if (counter >= 31'd19999996) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end

      2'b011: begin
        //clock de 1 segundo; counter_clk_2 = conversao
              if (counter >= 31'd49999999) begin
                 <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end

      2'b100: begin
        //clock de 1.6 segundos; counter_clk_2 = conversao
              if (counter >= 31'd79999999) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end
      
      2'b101: begin
        //clock de 3.2 segundos; counter_clk_2 = conversao
              if (counter >= 31'd159999998) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end
    
      2'b110: begin
        //clock de 6.4 segundos; counter_clk_2 = conversao
              if (counter >= 31'd319999996) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end
      
      2'b111: begin
        //clock de 12.8 segundos; counter_clk_2 = conversao
              if (counter >= 31'd639999992) begin
                clock <= ~clock;
                counter <= 31'd0;
              end
              else begin
                counter <= counter + 31'd1;
              end
            end
      
      default: begin
        //clock de 0 segundos; counter_clk_2 = 0
              clock <= 0;
              counter <= 0;
              end
    endcase
  end
end

always @(posedge clk or posedge rst) begin
  if (rst) begin
    clock_1 <= 0;
  end
  else begin
    if (counter_clk_1 >= 31'd4999999) begin
      clock_1 <= ~clock_1;
      counter_clk_1 <= 31'd0;
    end
    else begin
      counter_clk_1 <= counter_clk_1 + 31'd1;
    end
  end
end

assign prog_out = prog_reg;
assign clk_1 = clock_1;
assign clk_2 = clock;

endmodule