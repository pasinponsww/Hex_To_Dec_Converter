# FPGA-Based ASCII Hex → Decimal 

This is a minimal, synthesizable Verilog design that converts a stream of ASCII hex characters into decimal (BCD) digits.
It includes input validation, leading-zero suppression, and a clean handshaking interface. A sample XDC is provided for Vivado.

## License & Attribution

Copyright © Bex Sawetrattanathumrong

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

All source code in this repository was written by Bex Sawetrattanathumrong, with the exception of a single algorithmic concept used in `bin_to_bcd.v`.  
That module’s logic is based on the publicly documented double-dabble algorithm, as described in:

A. Abdelhadi, Binary-to-BCD-Converter (BSD-3-Clause License)  
GitHub: https://github.com/AmeerAbdelhadi/Binary-to-BCD-Converter  

The referenced algorithm was adapted and completely re-implemented by Bex Sawetrattanathumrong to fit this project’s requirements.


## Modules
- `ascii_hex_digit.v`: ASCII (0–9, A–F, a–f) → 4-bit nibble + valid flag
- `hex_to_bin.v`: Streams ASCII hex into a binary value
- `bin_to_bcd.v`: Double-dabble converter (binary → BCD), iterative and synthesizable
- `ascii_hex_to_dec_core.v`: Top core that ties everything together; no UART; stream in ASCII, get BCD out
- `ascii_hex_to_dec_core_tb.v`: Simple testbench you can run in Vivado simulator

## Interface (ascii_hex_to_dec_core)
```
input  wire        clk
input  wire        rst_n
input  wire [7:0]  ascii_i      // ASCII byte
input  wire        valid_i      // strobe with ascii_i
input  wire        last_i       // mark last byte of the number (e.g., after final hex digit)
output wire        ready_o      // core ready for more ascii_i
output wire        done_o       // pulses when BCD output is valid
output wire        err_o        // 1 if invalid ASCII was seen for this number
output wire [39:0] bcd_o        // 10 BCD digits, MS digit at [39:36]
output wire [9:0]  digit_en_o   // which digits are non-leading-zero (1=show)
```
## How to run the code
Set `ascii_hex_to_dec_core.v` as the top (or wrap it in your own I/O top).
Simulate using `ascii_hex_to_dec_core_tb.v`.
Synthesize/implement for your board when ready.

> Note: The provided XDC is a **template**. Replace `<PIN>` placeholders with your board’s actual pins.


