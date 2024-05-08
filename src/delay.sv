module delay #(
    parameter int unsigned DELAY = 1,
    parameter int unsigned WIDTH = 1
) (
    input clk,
    input en,
    input rst,
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
  generate
    if (DELAY == 0) begin
      assign out = in;
    end else if (DELAY == 1) begin
      logic [WIDTH - 1:0] buffer = 0;
      assign out = buffer;

      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          buffer <= 0;
        end else if (en) begin
          buffer <= in;
        end
      end
    end else begin
      logic [DELAY-1:0][WIDTH-1:0] buffer = 0;
      assign out = buffer[DELAY-1];

      always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
          buffer <= 0;
        end else if (en) begin
          buffer[0] <= in;
          buffer[DELAY-1:1] <= buffer[DELAY-2:0];
        end
      end
    end
  endgenerate
endmodule
