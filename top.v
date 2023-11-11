module top 
(
  input wire clk, rst, start_f, start_t, stop_f_t, update,
  input wire [2:0] prog,
  output wire [7:0] an, dec_ddp,
  output wire [5:0] led,
  output wire parity
);

// modules
wire f_valid, t_valid, data_2_valid, data_1_en, buffer_empty, buffer_full, clk_1, clk_2;
wire start_ed_f, start_ed_t, stop_ed_f_t, update_ed;
reg f_en, t_en;
reg [1:0] modulo;
wire [15:0] f_out, t_out;
wire [15:0] data_1;
wire [15:0] data_2;
wire [2:0] prog_out;
wire [2:0] prog_reg;

assign data_1_en = f_valid | t_valid;
assign data_1 = f_en ? f_out : t_en ? t_out : 0;

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
  .prog(prog),
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

parity_check parity_check (
  .data_2(data_2),
  .parity(parity)
);


// edge detectors
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

localparam S_IDLE = 3'b000;
localparam S_COMM_F = 3'b001;
localparam S_COMM_T = 3'b010;
localparam S_WAIT_F = 3'b011;
localparam S_WAIT_T = 3'b100;
localparam S_BUF_EMPTY = 3'b101;

//Máquina de Estados
reg [2:0] EA; //PE
// always @(posedge clk or posedge rst) begin
//   if (rst) begin
//     EA <= S_IDLE;
//   end
//   else begin
//     EA <= PE;
//   end
// end

//Lógica de troca de estados
always @(posedge clk or posedge rst) begin
  if (rst) begin
    EA <= S_IDLE;
  end
  else begin
  case (EA)
    S_IDLE: begin
      if (start_ed_f == 1 & start_ed_t == 0) begin
        EA <= S_COMM_F;
      end
      else if (start_ed_t == 1 & start_ed_f == 0) begin
        EA <= S_COMM_T;
      end
      else begin
        EA <= EA;
      end
    end
    S_COMM_F: begin
      if (stop_ed_f_t) begin
        EA <= S_BUF_EMPTY;
      end
      else if (buffer_full) begin
        EA <= S_WAIT_F;
      end
      else begin
        EA <= EA;
      end
    end
    S_COMM_T: begin
      if (stop_ed_f_t) begin
        EA <= S_BUF_EMPTY;
      end
      else if (buffer_full) begin
        EA <= S_WAIT_T;
      end
      else begin
        EA <= EA;
      end
    end
    S_WAIT_F: begin
      if (stop_ed_f_t) begin
        EA <= S_BUF_EMPTY;
      end
      else if (~buffer_full) begin
        EA <= S_COMM_F;
      end
      else begin
        EA <= EA;
      end
    end
    S_WAIT_T: begin
      if (stop_ed_f_t) begin
        EA <= S_BUF_EMPTY;
      end
      else if (~buffer_full) begin
        EA <= S_COMM_T;
      end
      else begin
        EA <= EA;
      end
    end
    S_BUF_EMPTY: begin
      if (buffer_empty & ~data_2_valid) begin
        EA <= S_IDLE;
      end
    end
    default: begin
      EA <= S_IDLE;
    end
  endcase
  end
end

//Lógica de estados
always @(posedge clk or posedge rst) begin
  if (rst) begin
    f_en <= 0;
    t_en <= 0;
    modulo <= 0;
  end
  else begin
    case (EA)
      S_IDLE: begin
        f_en <= 0;
        t_en <= 0;
        modulo <= 0;
      end
      S_COMM_F: begin
        f_en <= 1;
        t_en <= 0;
        modulo <= 2'b01;
      end
      S_COMM_T: begin
        f_en <= 0;
        t_en <= 1;
        modulo <= 2'b10;
      end
      S_WAIT_F: begin
        f_en <= 0;
        t_en <= 0;
        modulo <= 2'b01;
      end
      S_WAIT_T: begin
        f_en <= 0;
        t_en <= 0;
        modulo <= 2'b10;
      end
      S_BUF_EMPTY: begin
        t_en <= 0;
        f_en <= 0;
        modulo <= 0;
      end
      default: begin
        t_en <= 0;
        f_en <= 0;
        modulo <= 0;
      end
    endcase
  end
end

assign led[0] = (EA == S_IDLE) ? 1'b1 : 0;
assign led[1] = (EA == S_COMM_F) ? 1'b1 : 0;
assign led[2] = (EA == S_COMM_T) ? 1'b1 : 0;
assign led[3] = (EA == S_WAIT_F) ? 1'b1 : 0;
assign led[4] = (EA == S_WAIT_T) ? 1'b1 : 0;
assign led[5] = (EA == S_BUF_EMPTY) ? 1'b1 : 0;

endmodule
