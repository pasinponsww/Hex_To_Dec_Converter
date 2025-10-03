`timescale 1ns/1ps
module ascii_hex_to_dec_core_tb;

  // 100 MHz clock
  reg clk = 1'b0;
  always #5 clk = ~clk;

  reg        rst_n;
  reg  [7:0] ascii_i;
  reg        valid_i, last_i;
  wire       ready_o, done_o, err_o;
  wire [39:0] bcd_o;
  wire [9:0]  digit_en_o;

  ascii_hex_to_dec_core #(.BIN_WIDTH(32), .DIGITS(10)) dut (
    .clk(clk), .rst_n(rst_n),
    .ascii_i(ascii_i), .valid_i(valid_i), .last_i(last_i),
    .ready_o(ready_o), .done_o(done_o), .err_o(err_o),
    .bcd_o(bcd_o), .digit_en_o(digit_en_o)
  );

  initial begin
    // init
    rst_n   = 0;
    ascii_i = 8'h00;
    valid_i = 0;
    last_i  = 0;

    // reset + settle
    repeat (4) @(posedge clk);
    rst_n = 1;
    repeat (10) @(posedge clk);

    // Byte 1: '1' (0x31)
    @(posedge clk); while(!ready_o) @(posedge clk);
    ascii_i <= 8'h31; valid_i <= 1; last_i <= 0;
    @(posedge clk);   valid_i <= 0; last_i <= 0;

    // Byte 2: 'A' (0x41)
    @(posedge clk); while(!ready_o) @(posedge clk);
    ascii_i <= 8'h41; valid_i <= 1; last_i <= 0;
    @(posedge clk);   valid_i <= 0; last_i <= 0;

    // Byte 3: '3' (0x33)
    @(posedge clk); while(!ready_o) @(posedge clk);
    ascii_i <= 8'h33; valid_i <= 1; last_i <= 0;
    @(posedge clk);   valid_i <= 0; last_i <= 0;

    // Byte 4: 'F' (0x46)  
    @(posedge clk); while(!ready_o) @(posedge clk);
    ascii_i <= 8'h46; valid_i <= 1; last_i <= 1;
    @(posedge clk);   valid_i <= 0; last_i <= 0;

    // wait for binary->BCD (~32 clocks @100 MHz)
    repeat (80) @(posedge clk);

    $display("Result: BCD=%h EN=%b ERR=%b", bcd_o, digit_en_o, err_o);
    repeat (20) @(posedge clk);
    $finish;
  end

endmodule
