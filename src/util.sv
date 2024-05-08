function integer unsigned ceil_division(integer unsigned x, integer unsigned y);
  return (x + y - 1) / y;
endfunction

function integer unsigned max(integer unsigned x, integer unsigned y);
  if (x > y) begin
    return x;
  end else begin
    return y;
  end
endfunction

function integer unsigned min(integer unsigned x, integer unsigned y);
  if (x > y) begin
    return y;
  end else begin
    return x;
  end
endfunction

module clkgen #(
    parameter CYCLES = 32
) (
    output logic clk = 0,
    output logic rst = 0
);
  initial begin
    for (int i = 0; i < 2 * CYCLES; i += 1) begin
      #5 clk = ~clk;
    end
  end
  initial begin
    #1 rst = 1;
    #1 rst = 0;
  end
endmodule
