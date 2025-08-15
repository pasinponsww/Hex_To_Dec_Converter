// Main: stream ASCII hex -> decimal BCD with validation check

// External Source: bin2bcd_dd.v
// Binary -> BCD (double-dabble / shift-and-add-3), combinational
// Adapted from: Ameer Abdelhadi's Binary-to-BCD-Converter (BSD-3-Clause)
//Idea/algorithm reference and inspiration only; fresh implementation and API.
//Repo: A. Abdelhadi, "Parametric Binary to BCD Converter Using Double Dabble"

module ascii_hex_to_dec_core #(
    parameter integer BIN_WIDTH = 32, 
    parameter integer DIGITS    = 10
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [7:0]           ascii_i,
    input  wire                 valid_i,
    input  wire                 last_i,
    output wire                 ready_o,
    output reg                  done_o,
    output reg                  err_o,
    output reg  [DIGITS*4-1:0]  bcd_o,
    output reg  [DIGITS-1:0]    digit_en_o
);
// ASCII HEX ? Binary Setup
    wire [BIN_WIDTH-1:0] bin_w;
    wire [5:0]           nibbles_w; // number of nibbles received
    wire                 acc_ready_w, acc_word_ready_w; // ready for next ASCII char
    wire                 acc_err_w;  // invalid char seen in current number

// Instantiate to takes ASCII bytes and create binary value 
    hex_to_bin #(.WIDTH(BIN_WIDTH)) u_hex2bin (
        .clk(clk), .rst_n(rst_n),
        .ascii_i(ascii_i), .valid_i(valid_i), .last_i(last_i),
        .ready_o(acc_ready_w), .err_o(acc_err_w),
        .bin_o(bin_w), .nibble_count_o(nibbles_w), .word_ready_o(acc_word_ready_w)
    );

    assign ready_o = acc_ready_w; // pass through accumulator's ready
    
// Binary ? BCD (Binary-Coded Decimal) 
    reg start_bcd;
    wire bcd_busy, bcd_done; //status of the bin_to_bcd
    wire [DIGITS*4-1:0] bcd_w; // raw BCD output (all digits, with zeros)
    
// Instantiate with double-dabble algorithm to get BCD from binary
    bin_to_bcd #(.IN_WIDTH(BIN_WIDTH), .DIGITS(DIGITS)) u_b2b (
        .clk(clk), .rst_n(rst_n),
        .start_i(start_bcd), .bin_i(bin_w),
        .busy_o(bcd_busy), .done_o(bcd_done), .bcd_o(bcd_w)
    );

    reg converting; // active-high while binary?BCD conversion is in progress
    
    // Main control FSM for conversion process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset State
            start_bcd <= 1'b0; converting <= 1'b0; done_o <= 1'b0; err_o <= 1'b0;
            bcd_o <= 0; digit_en_o <= 0;
        end else begin
            done_o <= 1'b0; // Clear all of the finish/done pulse
            // If conditional statement is true, therefore, BCD conversion will start 
            if (acc_word_ready_w && !converting) begin
                err_o <= acc_err_w; // Check if theirs any Error
                start_bcd <= 1'b1;  // Pulse starting with bin_to_bcd module 
                converting <= 1'b1; // Mark that it's currently converting
            end else begin
                start_bcd <= 1'b0; // only pulse for 1 cycle
            end
            if (bcd_done && converting) begin
                converting <= 1'b0; // done converting
                bcd_o <= bcd_w;     // latch final BCD digits
                digit_en_o <= lz_mask(bcd_w); // Enable mask for non-leading-zero digits
                
                // A special case if # is zero, enable only the last digit
                if (is_zero(bcd_w)) begin
                    digit_en_o <= {{(DIGITS-1){1'b0}}, 1'b1};
                end
                done_o <= 1'b1;
            end
        end
    end
   
    // This function exist to given BCD digits, outputs a bitmask marking which digits to display.
    // Suppresses leading zeros.
    function [DIGITS-1:0] lz_mask(input [DIGITS*4-1:0] b);
        integer k;
        reg seen;
        begin
            seen = 1'b0;
            for (k = DIGITS-1; k >= 0; k = k - 1) begin
                if (!seen && b[k*4 +: 4] == 4'd0) lz_mask[k] = 1'b0;
                else begin
                    seen = 1'b1;
                    lz_mask[k] = 1'b1;
                end
            end
        end
    endfunction
 
    // This function exist to returns 1 if all BCD digits are 0
    function is_zero(input [DIGITS*4-1:0] b);
        integer k;
        begin
            is_zero = 1'b1;
            for (k = 0; k < DIGITS; k = k + 1) begin
                if (b[k*4 +: 4] != 4'd0) is_zero = 1'b0;
            end
        end
    endfunction
endmodule
