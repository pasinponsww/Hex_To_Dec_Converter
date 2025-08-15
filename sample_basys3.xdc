
## Clock 100 MHz
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk -period 10.000 -waveform {0 5} [get_ports clk]

## Active-low reset (e.g., pushbutton) — replace pin with your board's reset source
set_property PACKAGE_PIN <PIN_RST> [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## Example streaming inputs (tie to GPIO or test header)
set_property PACKAGE_PIN <PIN_ASCII0> [get_ports {ascii_i[0]}]
set_property PACKAGE_PIN <PIN_ASCII1> [get_ports {ascii_i[1]}]
set_property PACKAGE_PIN <PIN_ASCII2> [get_ports {ascii_i[2]}]
set_property PACKAGE_PIN <PIN_ASCII3> [get_ports {ascii_i[3]}]
set_property PACKAGE_PIN <PIN_ASCII4> [get_ports {ascii_i[4]}]
set_property PACKAGE_PIN <PIN_ASCII5> [get_ports {ascii_i[5]}]
set_property PACKAGE_PIN <PIN_ASCII6> [get_ports {ascii_i[6]}]
set_property PACKAGE_PIN <PIN_ASCII7> [get_ports {ascii_i[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii_i[*]}]

set_property PACKAGE_PIN <PIN_VALID> [get_ports valid_i]
set_property PACKAGE_PIN <PIN_LAST>  [get_ports last_i]
set_property IOSTANDARD LVCMOS33 [get_ports {valid_i last_i}]

## Example outputs (hook to LEDs or header)
set_property PACKAGE_PIN <PIN_DONE> [get_ports done_o]
set_property PACKAGE_PIN <PIN_ERR>  [get_ports err_o]
set_property PACKAGE_PIN <PIN_READY> [get_ports ready_o]
set_property IOSTANDARD LVCMOS33 [get_ports {done_o err_o ready_o}]


