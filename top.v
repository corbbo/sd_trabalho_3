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
wire f_en, t_en;
reg [15:0] f_out, t_out, data_1, data_2;
reg [2:0] prog_reg;
assign data_1_en = f_valid | t_valid;
fibonacci fibonacci (
  .rst(rst),
  .clk(clk_1),
  .f_en(start_ed_f),
  .f_valid(f_valid),
  .f_out(f_out)
);

timer timer (
  .rst(rst),
  .clk(clk_1),
  .t_en(start_ed_t),
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
  .modulo(),
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
wire start_ed_f, start_ed_t, stop_ed_f_t, update_ed;
edge_detector_sintese ed_start_f(
  .clk(clk),
  .rst(rst),
  .din(start_f),
  .rising(start_ed_f)
);

edge_detector_sintese ed_start_t(
  .clk(clk),
  .rst(rst),
  .din(start_t),
  .rising(start_ed_t)
);

edge_detector_sintese ed_stop_f_t(
  .clk(clk),
  .rst(rst),
  .din(stop_f_t),
  .rising(stop_ed_f_t)
);

edge_detector_sintese ed_update(
  .clk(clk),
  .rst(rst),
  .din(update),
  .rising(update_ed)
);

localparam 3'b000 = S_IDLE;
localparam 3'b001 = S_COMM_F;
localparam 3'b010 = S_COMM_T;
localparam 3'b011 = S_WAIT_F;
localparam 3'b100 = S_WAIT_T;
localparam 3'b101 = S_BUF_EMPTY;

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
    parity <= 0;
    led <= 0;
  end
  else begin
    case (EA)
      S_IDLE: begin
        
      end
      S_COMM_F: begin
        
      end
    endcase
  end
end

endmodule