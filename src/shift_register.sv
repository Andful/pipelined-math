module shift_register #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned DEPTH = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in,
    output logic [DEPTH-1:0][WIDTH-1:0] out
);
  generate
    if (DEPTH == 1) begin
      assign out[0] = in;
    end else begin
      logic [DEPTH-2:0][WIDTH-1:0] out_update;
      always_comb begin
        out = {out_update, in};
      end
      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          out_update <= 0;
        end else if (en) begin
          out_update <= out[DEPTH-2:0];
        end
      end
    end
  endgenerate
endmodule
