# =========================================================
# Vivado Build Script
# Usage: vivado -mode batch -source scripts/build.tcl
# =========================================================

# Set project variables
set proj_name "ascii_hex_to_dec_proj"
set proj_dir "./proj_dir"
set part "xc7a35tcpg236-1"   ;# <-- change to your FPGA part number
set top_module "ascii_hex_to_dec_core_tb"

# Clean old project if it exists
if { [file exists $proj_dir] } {
    file delete -force $proj_dir
}

# Create project
create_project $proj_name $proj_dir -part $part -force

# Add RTL source files
add_files [glob ./src/*.v]
add_files [glob ./src/*.sv]

# Add testbench files
add_files -fileset sim_1 [glob ./tb/*.v]
add_files -fileset sim_1 [glob ./tb/*.sv]

# Add constraints (if any exist)
if {[llength [glob ./constraints/*.*]()]()
