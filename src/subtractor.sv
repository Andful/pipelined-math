module subtractor #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned CHUNK = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output logic [WIDTH-1:0] out,
    output logic borrow
);
  localparam BORROW_WIDTH = ceil_division(WIDTH, CHUNK);
  logic [BORROW_WIDTH-1:0] borrow_buffer = 0;
  logic [BORROW_WIDTH-1:0] shifted_borrow_buffer;

  logic [BORROW_WIDTH-1:0] borrow_buffer_nxt;
  logic [WIDTH-1:0] out_nxt;

  generate
    for (genvar i = 0; i < BORROW_WIDTH; i += 1) begin
      localparam LB = i * CHUNK;
      localparam W = min(CHUNK, WIDTH - i * CHUNK);
      assign {borrow_buffer_nxt[i], out_nxt[LB +: W]} = in1[LB +: W] - in2[LB +: W] - W'(shifted_borrow_buffer[i]);
    end
  endgenerate

  generate
    if (WIDTH == 1) begin
      assign out = in1 ^ in2;
      assign borrow = in1 & in2;
    end else if (WIDTH > 1) begin
      always_comb begin
        borrow = borrow_buffer[BORROW_WIDTH-1];
        shifted_borrow_buffer = {borrow_buffer[BORROW_WIDTH-2:0], 1'b0};
      end

      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          out <= 0;
          borrow_buffer <= 0;
        end else if (en) begin
          out <= out_nxt;
          borrow_buffer <= borrow_buffer_nxt;
        end
      end
    end
  endgenerate
endmodule
