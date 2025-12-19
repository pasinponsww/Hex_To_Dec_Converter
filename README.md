
# ASCII Hex to Decimal (FPGA)

Minimal, synthesizable Verilog modules to convert ASCII hex streams to decimal (BCD), with input validation and handshaking. Includes testbenches.

## Modules
- `ascii_hex_digit.v`: ASCII hex to 4-bit nibble
- `hex_to_bin.v`: ASCII hex stream to binary
- `bin_to_bcd.v`: Binary to BCD (double-dabble)
- `ascii_hex_to_dec_core.v`: Top-level core (ASCII in, BCD out)
- `ascii_hex_to_dec_core_tb.v`: Testbench

## Usage
Integrate modules as needed. See testbenches for examples.

## License
MIT License. See LICENSE.txt.
## How to run the code
Set `ascii_hex_to_dec_core.v` as the top (or wrap it in your own I/O top).
Simulate using `ascii_hex_to_dec_core_tb.v`.
Synthesize/implement for your board when ready.

> Note: The provided XDC is a **template**. Replace `<PIN>` placeholders with your board’s actual pins.


