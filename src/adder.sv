module adder #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned CHUNK = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [WIDTH:0] out
);
  localparam CARRY_WIDTH = ceil_division(WIDTH, CHUNK);
  logic [CARRY_WIDTH-1:0] carry_buffer = 0;
  logic [CARRY_WIDTH-1:0] shifted_carry_buffer;

  logic [CARRY_WIDTH-1:0] carry_buffer_nxt;

  generate
    for (genvar i = 0; i < CARRY_WIDTH; i += 1) begin
      localparam LB = i * CHUNK;
      localparam W = min(CHUNK, WIDTH - i * CHUNK);
      assign {carry_buffer_nxt[i], out[LB +: W]} = in1[LB +: W] + in2[LB +: W] + W'(shifted_carry_buffer[i]);
    end
  endgenerate

  generate
    if (WIDTH == 1) begin
      assign out   = in1 ^ in2;
      assign carry = in1 & in2;
    end else if (WIDTH > 1) begin
      assign out[WIDTH] = (WIDTH % CHUNK) == 0 ? carry_buffer[CARRY_WIDTH-1] : carry_buffer_nxt[CARRY_WIDTH-1];
      assign shifted_carry_buffer = {carry_buffer[CARRY_WIDTH-2:0], 1'b0};

      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          carry_buffer <= 0;
        end else if (en) begin
          carry_buffer <= carry_buffer_nxt;
        end
      end
    end
  endgenerate
endmodule
