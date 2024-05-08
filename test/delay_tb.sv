module delay_tb;
  logic clk;
  logic rst;
  logic en = 1;
  logic [7:0] in;
  logic [7:0] out;

  clkgen #(
      .CYCLES(32)
  ) clkgen_i (
      .clk(clk),
      .rst(rst)
  );

  delay #(
      .DELAY(3),
      .WIDTH(8)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in),
      .out(out)
  );

  initial begin
    $dumpfile("traces/delay_tb.vcd");
    $dumpvars(0, delay_tb);
  end

  always_ff @(posedge clk) begin
    in = 8'($random);
  end
endmodule
