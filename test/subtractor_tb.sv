module subtractor_tb;
  logic clk;
  logic rst;
  logic en = 1;
  logic [7:0] in1;
  logic [7:0] in2;
  logic [7:0] shifted_in1;
  logic [7:0] shifted_in2;
  logic [7:0] shifted_out;
  logic [7:0] out;
  logic [7:0] out_ref;

  localparam WIDTH = 8;
  localparam CHUNK = 3;

  clkgen #(
      .CYCLES(32)
  ) clkgen_i (
      .clk(clk),
      .rst(rst)
  );

  shifter #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) shifter1_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in1),
      .out(shifted_in1)
  );

  shifter #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) shifter2_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in2),
      .out(shifted_in2)
  );

  subtractor #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) subtractor_i (
      .clk(clk),
      .en(en),
      .rst(rst),
      .in1(shifted_in1),
      .in2(shifted_in2),
      .out(shifted_out),
      .borrow()
  );

  unshifter #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) unshifter_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (shifted_out),
      .out(out)
  );

  delay #(
      .DELAY(ceil_division(WIDTH, CHUNK)),
      .WIDTH(WIDTH)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in1 - in2),
      .out(out_ref)
  );

  initial begin
    $dumpfile("traces/subtractor_tb.vcd");
    $dumpvars(0, shifter_tb);
  end

  always_ff @(posedge clk) begin
    in1 = WIDTH'($random);
    in2 = WIDTH'($random);
    assert (out == out_ref);
  end
endmodule
