module multiplier #(
    parameter int unsigned WIDTH1 = 1,
    parameter int unsigned WIDTH2 = 1,
    parameter int unsigned CHUNK1 = 1,
    parameter int unsigned CHUNK2 = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH1-1:0] in1,
    input [WIDTH2-1:0] in2,
    output logic [WIDTH1 + WIDTH2 - 1:0] out
);
  logic [WIDTH2-1:0][WIDTH1-1:0] partial_sum;
  logic [WIDTH2-1:0][WIDTH1-1:0] delayed_in1;

  shift_register #(
      .WIDTH(WIDTH1),
      .DEPTH(WIDTH2)
  ) shift_register_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in1),
      .out(delayed_in1)
  );

  generate
    for (genvar i = 0; i < WIDTH2; i += 1) begin
      logic [WIDTH1-1:0] masked;
      mask #(
          .WIDTH(WIDTH1)
      ) mask_i (
          .clk(clk),
          .en(en),
          .rst(rst),
          .in(delayed_in1[i]),
          .in_mask(in2[i]),
          .out({masked})
      );

      if (i == 0) begin
        assign {partial_sum[i], out[0]} = {1'b0, masked};
      end else begin
        adder #(
            .WIDTH(WIDTH1)
        ) adder_i (
            .clk(clk),
            .en (en),
            .rst(rst),
            .in1(masked),
            .in2(partial_sum[i-1]),
            .out({partial_sum[i], out[i]})
        );
      end
    end
    assign out[WIDTH1+WIDTH2-1-:WIDTH2] = partial_sum[WIDTH2-1];

  endgenerate
endmodule
