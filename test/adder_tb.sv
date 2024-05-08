`ifndef WIDTH
`define WIDTH 8
`endif
`ifndef CHUNK
`define CHUNK 3
`endif

module adder_tb #(
    parameter integer unsigned WIDTH = `WIDTH,
    parameter integer unsigned CHUNK = `CHUNK
);
  logic clk;
  logic rst;
  logic en = 1;
  logic [7:0] in1;
  logic [7:0] in2;
  logic [7:0] shifted_in1;
  logic [7:0] shifted_in2;
  logic [8:0] shifted_out;
  logic [8:0] out;
  logic [8:0] out_ref;

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

  adder #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) adder_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in1(shifted_in1),
      .in2(shifted_in2),
      .out(shifted_out)
  );

  unshifter #(
      .WIDTH(WIDTH + 1),
      .CHUNK(CHUNK)
  ) unshifter_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (shifted_out),
      .out(out)
  );

  delay #(
      .DELAY(ceil_division(WIDTH, CHUNK) - 1),
      .WIDTH(WIDTH + 1)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in ((WIDTH + 1)'(in1) + (WIDTH + 1)'(in2)),
      .out(out_ref)
  );

  string df = $sformatf("traces/%m.vcd");
  string format;
  logic  err = 0;
  initial begin
    $dumpfile(df);
    $dumpvars(0, adder_tb);
    wait (err);
    $timeformat(-3, 2, " ms", 10);
    format = $sformatf("%0d != %0d at %t", out, out_ref, $realtime);
    $error(format);
    $fatal;
  end

  always_ff @(posedge clk) begin
    in1 = WIDTH'($random);
    in2 = WIDTH'($random);
    if (out != out_ref) begin
      err = 1;
    end
  end
endmodule
