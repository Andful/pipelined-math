module mask_tb;
  logic clk;
  logic rst;
  logic en = 1;
  logic [7:0] in = 0;
  logic [7:0] shifted_in;
  logic mask;
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
      .in (in),
      .out(shifted_in)
  );

  mask #(
      .WIDTH(WIDTH),
      .CHUNK(CHUNK)
  ) mask_i (
      .clk(clk),
      .en(en),
      .rst(rst),
      .in(shifted_in),
      .in_mask(mask),
      .out(shifted_out)
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
      .DELAY(ceil_division(WIDTH, CHUNK) - 1),
      .WIDTH(WIDTH)
  ) delay_i (
      .clk(clk),
      .en (en),
      .rst(rst),
      .in (in & {WIDTH{mask}}),
      .out(out_ref)
  );

  initial begin
    $dumpfile("traces/mask_tb.vcd");
    $dumpvars(0, mask_tb);
  end

  always_ff @(posedge clk) begin
    in   = WIDTH'($random);
    mask = 1'($random);
    //assert (out == out_ref);
  end
endmodule
