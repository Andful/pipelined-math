module multiplier_tb;

  localparam WIDTH1 = 3;
  localparam WIDTH2 = 3;

  logic clk;
  logic rst;
  logic en = 1;
  logic [WIDTH1-1:0] in1 = 0;
  logic [WIDTH2-1:0] in2 = 0;
  logic [WIDTH1-1:0] shifted_in1;
  logic [WIDTH2-1:0] shifted_in2;
  logic [WIDTH1+WIDTH2-1:0] shifted_out;
  logic [WIDTH1+WIDTH2-1:0] out;
  logic [WIDTH1+WIDTH2-1:0] out_ref;

  clkgen #(
      .CYCLES(64)
  ) clkgen_i (
      .clk(clk),
      .rst(rst)
  );

  shifter #(
      .WIDTH(WIDTH1)
  ) shifter1_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in1),
      .out(shifted_in1)
  );

  shifter #(
      .WIDTH(WIDTH2)
  ) shifter2_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in2),
      .out(shifted_in2)
  );

  multiplier #(
      .WIDTH1(WIDTH1),
      .WIDTH2(WIDTH2)
  ) multiplier_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in1(shifted_in1),
      .in2(shifted_in2),
      .out(shifted_out)
  );

  unshifter #(
      .WIDTH(WIDTH1 + WIDTH2)
  ) unshifter_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (shifted_out),
      .out(out)
  );

  delay #(
      .DELAY(WIDTH1 + WIDTH2),
      .WIDTH(WIDTH1 + WIDTH2)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in ((WIDTH1 + WIDTH2)'(in1) * (WIDTH1 + WIDTH2)'(in2)),
      .out(out_ref)
  );

  string df = $sformatf("traces/%m.vcd");
  string format;
  logic  err = 0;
  initial begin
    $dumpfile(df);
    $dumpvars(0, multiplier_tb);
    wait (err);
    $timeformat(-3, 2, " ms", 10);
    format = $sformatf("%0d != %0d at %t", out, out_ref, $realtime);
    $error(format);
    $fatal;
  end

  always_ff @(posedge clk) begin
    in1 = WIDTH1'($random);
    in2 = WIDTH2'($random);
    if (out != out_ref) begin
      err = 1;
    end
  end
endmodule
