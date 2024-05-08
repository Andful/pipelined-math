module mask #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned CHUNK = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in,
    input in_mask,
    output logic [WIDTH-1:0] out
);
  localparam MASK_WIDTH = ceil_division(WIDTH, CHUNK);
  logic [MASK_WIDTH-1:0] mask_buffer;

  shift_register #(
      .DEPTH(MASK_WIDTH),
      .WIDTH(1)
  ) shift_register_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in_mask),
      .out(mask_buffer)
  );

  generate
    for (genvar i = 0; i < WIDTH; i += 1) begin
      localparam integer unsigned MASK_INDEX = i / CHUNK;
      assign out[i] = in[i] & mask_buffer[MASK_INDEX];
    end
  endgenerate
endmodule
