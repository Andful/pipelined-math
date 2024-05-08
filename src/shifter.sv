module shifter #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned CHUNK = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
  generate
    for (genvar i = 0; i < ceil_division(WIDTH, CHUNK); i += 1) begin
      localparam W = min(CHUNK, WIDTH - i * CHUNK);
      delay #(
          .DELAY(i),
          .WIDTH(W)
      ) delay_i (
          .clk(clk),
          .en (en),
          .rst(rst),
          .in (in[i*CHUNK+:W]),
          .out(out[i*CHUNK+:W])
      );
    end
  endgenerate
endmodule
