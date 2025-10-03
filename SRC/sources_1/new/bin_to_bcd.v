// Binary -> BCD Conversion
// Converts a binary input word into packed BCD digits using the add-3/shift method.
//
// Inspired by the "double dabble" algorithm as seen in various public FPGA/Verilog from:
//  A. Abdelhadi, "Binary-to-BCD-Converter" (BSD-3-Clause)
//  https://github.com/AmeerAbdelhadi/Binary-to-BCD-Converter

module bin_to_bcd #(

    parameter integer IN_WIDTH = 32,
    parameter integer DIGITS   = 10
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 start_i,
    input  wire [IN_WIDTH-1:0]  bin_i,
    output reg                  busy_o,
    output reg                  done_o,
    output reg  [DIGITS*4-1:0]  bcd_o
);
// Width of the counter needed to count down from IN_WIDTH
    localparam integer CNT_W = $clog2(IN_WIDTH+1);

    reg [IN_WIDTH-1:0] shift_reg;   // Holds binary bits yet to be processed
    reg [DIGITS*4-1:0] bcd_reg;     // Holds intermediate and final BCD digits
    reg [CNT_W-1:0]    cnt;         // Counts remaining bits to process
    
    integer d; //loop
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset State
            busy_o <= 1'b0; done_o <= 1'b0; shift_reg <= 0; bcd_reg <= 0; cnt <= 0; bcd_o <= 0;
        end else begin
            done_o <= 1'b0; //default
            // Start conversion if active and idle
            if (start_i && !busy_o) begin
                busy_o <= 1'b1;
                shift_reg <= bin_i;
                bcd_reg <= {DIGITS*4{1'b0}};
                cnt <= IN_WIDTH[CNT_W-1:0];
             // Main Conversion process
            end else if (busy_o) begin
                for (d = 0; d < DIGITS; d = d + 1) begin
                    if (bcd_reg[d*4 +: 4] >= 5)
                        bcd_reg[d*4 +: 4] <= bcd_reg[d*4 +: 4] + 4'd3;
                end
                bcd_reg   <= {bcd_reg[DIGITS*4-2:0], shift_reg[IN_WIDTH-1]};
                shift_reg <= {shift_reg[IN_WIDTH-2:0], 1'b0};
                cnt <= cnt - 1'b1;
                // If all bits processed, finish conversion
                if (cnt == 0) begin
                    busy_o <= 1'b0;
                    done_o <= 1'b1;
                    bcd_o  <= bcd_reg;
                end
            end
        end
    end
endmodule
