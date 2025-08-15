// ASCII hex digit (0-9, A-F, a-f) to 4-bit nibble with valid flag 

// Converts a single ASCII hex character ('0'-'9', 'A'-'F', 'a'-'f') into its
// 4-bit binary nibble equivalent. Outputs `valid_o=1` if the input is a valid
// hex digit, otherwise `valid_o=0` and nibble_o=0.




module ascii_hex_digit(
    input  wire [7:0] ch_i,
    output reg  [3:0] nibble_o,
    output reg        valid_o
);
    always @* begin
        valid_o  = 1'b1;
        case (ch_i)
            8'h30: nibble_o = 4'h0; // '0'
            8'h31: nibble_o = 4'h1;
            8'h32: nibble_o = 4'h2;
            8'h33: nibble_o = 4'h3;
            8'h34: nibble_o = 4'h4;
            8'h35: nibble_o = 4'h5;
            8'h36: nibble_o = 4'h6;
            8'h37: nibble_o = 4'h7;
            8'h38: nibble_o = 4'h8;
            8'h39: nibble_o = 4'h9;
            8'h41,8'h61: nibble_o = 4'hA; // 'A'/'a'
            8'h42,8'h62: nibble_o = 4'hB; // 'B'/'b'
            8'h43,8'h63: nibble_o = 4'hC; // 'C'/'c'
            8'h44,8'h64: nibble_o = 4'hD; // 'D'/'d'
            8'h45,8'h65: nibble_o = 4'hE; // 'E'/'e'
            8'h46,8'h66: nibble_o = 4'hF; // 'F'/'f'
            default: begin nibble_o = 4'h0; valid_o = 1'b0; end
        endcase
    end
endmodule
