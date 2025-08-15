// ASCII hex -> binary accumulator
// Collects nibbles until `last_i` is asserted, then outputs the binary word.

module hex_to_bin #(
    parameter integer WIDTH = 32
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  ascii_i,
    input  wire        valid_i,
    input  wire        last_i,
    output wire        ready_o,        
    output reg         err_o,          
    output reg  [WIDTH-1:0] bin_o,     
    output reg  [5:0]  nibble_count_o, 
    output reg         word_ready_o    
);
    // Instantiate ASCII -> nibble
    // Converts a single ASCII hex digit (0-9, A-F, a-f) into a 4-bit nibble.
    wire [3:0] nib;
    wire       nib_valid;
    ascii_hex_digit u_d(.ch_i(ascii_i), .nibble_o(nib), .valid_o(nib_valid));
    
    
    localparam integer MAX_NIBBLES = WIDTH/4; // Max number of nibbles (4)
    reg in_word; // (1) while accumulating current number

    // Always ready unless we would overflow WIDTH
    assign ready_o = (nibble_count_o < MAX_NIBBLES) || !in_word;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset State
            in_word         <= 1'b0;
            err_o           <= 1'b0;
            bin_o           <= {WIDTH{1'b0}};
            nibble_count_o  <= 6'd0;
            word_ready_o    <= 1'b0;
        end else begin
            word_ready_o <= 1'b0; // default
            if (!in_word && valid_i) begin
                in_word        <= 1'b1;
                bin_o          <= {WIDTH{1'b0}};
                nibble_count_o <= 6'd0;
                err_o          <= 1'b0;
            end

            // Start accumulating a word
            if (in_word && valid_i) begin
                if (!nib_valid) err_o <= 1'b1;
                // Shift in nibble if within width limit
                if (nibble_count_o < MAX_NIBBLES) begin
                    // Shift left by 4 bits and append new nibble
                    bin_o <= (bin_o << 4) | nib;
                    nibble_count_o <= nibble_count_o + 1'b1;
                end
                // End of current word
                if (last_i) begin
                    word_ready_o <= 1'b1;
                    in_word <= 1'b0; // Exit accumulation state
                end
            end
        end
    end
endmodule
