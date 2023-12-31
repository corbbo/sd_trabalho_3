module dcm 
(
  input wire rst, clk, update,
  input wire [2:0] prog,
  output wire [2:0] prog_out,
  output wire clk_1, clk_2
);

reg [2:0] prog_reg;
reg [31:0] counter_clk_1, counter_clk_2;

// prog_out <= prog;
always @(posedge clk or posedge rst) begin
  if (rst) begin
    prog_reg <= 0;
  end else if (update) begin
    prog_reg <= prog;
  end
end

// Divisores de clock
reg clock, clock_1;
reg [31:0] counter;
always@(posedge clk or posedge rst) begin
  if (rst) begin
    clock <= 0;
    counter <= 0;
  end
  else begin
    case (prog_reg)
      3'b000: begin
        //clock de 0.1 segundos; counter_clkc_2 = conversao
              if (counter >= 32'd4999999) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end

      3'b001: begin
        //clock de 0.2 segundos; counter_clk_2 = conversao
              if (counter >= 32'd9999998) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end

      3'b010: begin
        //clock de 0.4 segundos; counter_clk_2 = conversao
              if (counter >= 32'd19999996) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end

      3'b011: begin
        //clock de 1 segundo; counter_clk_2 = conversao
              if (counter >= 32'd49999999) begin
                 clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end

      3'b100: begin
        //clock de 1.6 segundos; counter_clk_2 = conversao
              if (counter >= 32'd79999999) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end
      
      3'b101: begin
        //clock de 3.2 segundos; counter_clk_2 = conversao
              if (counter >= 32'd159999998) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end
    
      3'b110: begin
        //clock de 6.4 segundos; counter_clk_2 = conversao
              if (counter >= 32'd329999996) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
              end
            end
      
      3'b111: begin
        //clock de 12.8 segundos; counter_clk_2 = conversao
              if (counter >= 32'd639999992) begin
                clock <= ~clock;
                counter <= 32'd0;
              end
              else begin
                counter <= counter + 32'd1;
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
    counter_clk_1 <= 0;
  end
  else begin
    if (counter_clk_1 >= 32'd4999999) begin
      clock_1 <= ~clock_1;
      counter_clk_1 <= 32'd0;
    end
    else begin
      counter_clk_1 <= counter_clk_1 + 32'd1;
    end
  end
end

assign prog_out = prog_reg;
assign clk_1 = clock_1;
assign clk_2 = clock;

endmodule
