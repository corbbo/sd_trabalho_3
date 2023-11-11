module parity_check (
    input wire [15:0] data_2,
    output wire parity
);

always @(data_2) begin
    parity = ~^data_2;
end

endmodule