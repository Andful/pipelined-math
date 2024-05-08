module shifter_tb;
  logic clk;
  logic rst;
  logic en = 1;
  logic [7:0] in;
  logic [7:0] between;
  logic [7:0] out;
  logic [7:0] out_ref;

  clkgen #(
      .CYCLES(32)
  ) clkgen_i (
      .clk(clk),
      .rst(rst)
  );

  shifter #(
      .WIDTH(8),
      .CHUNK(2)
  ) shifter_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in),
      .out(between)
  );

  unshifter #(
      .WIDTH(8),
      .CHUNK(2)
  ) unshifter_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (between),
      .out(out)
  );

  delay #(
      .DELAY(3),
      .WIDTH(8)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in),
      .out(out_ref)
  );

  initial begin
    $dumpfile("traces/shifter_tb.vcd");
    $dumpvars(0, shifter_tb);
  end
  always_ff @(posedge clk) begin
    in = 8'($random);
  end
endmodule
