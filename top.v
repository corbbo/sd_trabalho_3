module top 
(
  input wire clk, rst, start_f, start_t, stop_f_t, update,
  input reg [2:0] prog,
  output wire [7:0] an, dec_ddp,
  output wire [5:0] led,
  output wire parity
);

// modules
wire f_valid, t_valid, data_2_valid, data_1_en, buffer_empty, buffer_full, clk_1, clk_2;
wire start_ed_f, start_ed_t, stop_ed_f_t, update_ed;
reg f_en, t_en, parity_out;
wire [1:0] modulo;
wire [15:0] f_out, t_out, data_1, data_2;
reg [2:0] prog_reg;

assign data_1_en = f_valid | t_valid;
assign modulo = f_en ? 2'b10 : (t_en ? 2'b01 : 2'b00);
assign parity = parity_out; 

fibonacci fibonacci (
  .rst(rst),
  .clk(clk_1),
  .f_en(f_en),
  .f_valid(f_valid),
  .f_out(f_out)
);

timer timer (
  .rst(rst),
  .clk(clk_1),
  .t_en(t_en),
  .t_valid(t_valid),
  .t_out(t_out)
);

dcm dcm (
  .rst(rst),
  .clk(clk),
  .update(update_ed),
  .prog_in(prog),
  .prog_out(prog_reg),
  .clk_1(clk_1),
  .clk_2(clk_2)
);

dm dm (
  .rst(rst),
  .clk(clk),
  .prog(prog_reg),
  .modulo(modulo),
  .data_2(data_2),
  .an(an),
  .dec_ddp(dec_ddp)
);

wrapper wrapper (
  .clk_1(clk_1),
  .clk_2(clk_2),
  .rst(rst),
  .data_1_en(data_1_en),
  .data_1(data_1),
  .data_2(data_2),
  .buffer_empty(buffer_empty),
  .buffer_full(buffer_full),
  .data_2_valid(data_2_valid)
);


// edge detectors
edge_detector_sim ed_start_f(
  .clk(clk),
  .rst(rst),
  .din(start_f),
  .rising(start_ed_f)
);

edge_detector_sim ed_start_t(
  .clk(clk),
  .rst(rst),
  .din(start_t),
  .rising(start_ed_t)
);

edge_detector_sim ed_stop_f_t(
  .clk(clk),
  .rst(rst),
  .din(stop_f_t),
  .rising(stop_ed_f_t)
);

edge_detector_sim ed_update(
  .clk(clk),
  .rst(rst),
  .din(update),
  .rising(update_ed)
);

localparam S_IDLE = 3'b000;
localparam S_COMM_F = 3'b001;
localparam S_COMM_T = 3'b010;
localparam S_WAIT_F = 3'b011;
localparam S_WAIT_T = 3'b100;
localparam S_BUF_EMPTY = 3'b101;

//Máquina de Estados
reg [2:0] EA, PE;
always @(posedge clk or posedge rst) begin
  if (rst) begin
    EA <= S_IDLE;
  end
  else begin
    EA <= PE;
  end
end

//Lógica de troca de estados
always @(*) begin
  case (EA)
    S_IDLE: begin
      if (start_ed_f) begin
        PE <= S_COMM_F;
      end
      else if (start_ed_t) begin
        PE <= S_COMM_T;
      end
      else begin
        PE <= EA;
      end
    end
    S_COMM_F: begin
      if (stop_ed_f_t) begin
        PE <= S_BUF_EMPTY;
      end
      else if (buffer_full) begin
        PE <= S_WAIT_F;
      end
      else begin
        PE <= EA;
      end
    end
    S_COMM_T: begin
      if (stop_ed_f_t) begin
        PE <= S_BUF_EMPTY;
      end
      else if (buffer_full) begin
        PE <= S_WAIT_T;
      end
      else begin
        PE <= EA;
      end
    end
    S_WAIT_F: begin
      if (stop_ed_f_t) begin
        PE <= S_BUF_EMPTY;
      end
      else if (~buffer_full) begin
        PE <= S_COMM_F;
      end
      else begin
        PE <= EA;
      end
    end
    S_WAIT_T: begin
      if (stop_ed_f_t) begin
        PE <= S_BUF_EMPTY;
      end
      else if (~buffer_full) begin
        PE <= S_COMM_T;
      end
      else begin
        PE <= EA;
      end
    end
    S_BUF_EMPTY: begin
      if (buffer_empty & ~data_2_valid) begin
        PE <= S_IDLE;
      end
    end
  endcase
end

//Lógica de estados
always @(posedge clk or posedge rst) begin
  if (rst) begin
    f_en <= 0;
    t_en <= 0;
  end
  else begin
    case (EA)
      S_IDLE: begin
        f_en <= 0;
        t_en <= 0;
      end
      S_COMM_F: begin
        f_en <= 1;
      end
      S_COMM_T: begin
        t_en <= 1;
      end
      S_WAIT_F: begin
        f_en <= 0;
      end
      S_WAIT_T: begin
        t_en <= 0;
      end
      S_BUF_EMPTY: begin
        t_en <= 0;
        f_en <= 0;
      end
    endcase
  end
end

reg helper;
integer i;
always @(*) begin
  helper <= data_2[15] ^ data_2[14];
  for (i = 13; i > -1; i = i - 1) begin
    helper <= helper ^ data_2[i];
  end
  parity_out <= helper;
end

endmodule
