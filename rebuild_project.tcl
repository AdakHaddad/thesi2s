# =============================================================================
# Rebuild Vivado Project Script
# =============================================================================
# Project: micblaze
# Board:   Digilent Basys3 (xc7a35tcpg236-1)
#
# Usage:
#   Option 1: Open Vivado, go to Tools -> Run Tcl Script, select this file
#   Option 2: From command line: vivado -mode batch -source rebuild_project.tcl
#   Option 3: From Vivado Tcl Console: source rebuild_project.tcl
#
# This script recreates the Vivado project from source files after cloning.
# =============================================================================

# Get the directory where this script is located
set script_dir [file dirname [file normalize [info script]]]

# Project settings
set project_name "micblaze"
set part "xc7a35tcpg236-1"
set board_part "digilentinc.com:basys3:part0:1.2"

# Change to script directory
cd $script_dir

# Remove existing project if it exists (clean rebuild)
if {[file exists "${project_name}.xpr"]} {
    puts "Removing existing project..."
    file delete -force "${project_name}.xpr"
    file delete -force "${project_name}.cache"
    file delete -force "${project_name}.gen"
    file delete -force "${project_name}.hw"
    file delete -force "${project_name}.ip_user_files"
    file delete -force "${project_name}.runs"
    file delete -force "${project_name}.sim"
}

# Create new project
puts "Creating project: $project_name"
create_project $project_name $script_dir -part $part -force

# Set board part
set_property board_part $board_part [current_project]

# Set project properties
set_property target_language Verilog [current_project]

# =============================================================================
# Add Block Design
# =============================================================================
puts "Adding block design..."

set bd_file "${script_dir}/${project_name}.srcs/sources_1/bd/design_soc/design_soc.bd"
if {[file exists $bd_file]} {
    add_files -norecurse $bd_file

    # Open and validate block design
    open_bd_design $bd_file
    validate_bd_design

    # Generate HDL wrapper
    set wrapper_file [make_wrapper -files [get_files design_soc.bd] -top]
    add_files -norecurse $wrapper_file

    # Set wrapper as top module
    set_property top design_soc_wrapper [current_fileset]
} else {
    puts "WARNING: Block design not found at $bd_file"
}

# =============================================================================
# Add Constraints
# =============================================================================
puts "Adding constraints..."

set xdc_file "${script_dir}/${project_name}.srcs/constrs_1/new/microblaze.xdc"
if {[file exists $xdc_file]} {
    add_files -fileset constrs_1 -norecurse $xdc_file
} else {
    puts "WARNING: Constraints file not found at $xdc_file"
}

# =============================================================================
# Add any additional HDL sources (if you have custom RTL)
# =============================================================================
# Uncomment and modify if you have custom Verilog/VHDL files:
# set hdl_files [glob -nocomplain "${script_dir}/${project_name}.srcs/sources_1/*.v"]
# if {[llength $hdl_files] > 0} {
#     add_files -norecurse $hdl_files
# }

# =============================================================================
# Update and refresh
# =============================================================================
puts "Updating compile order..."
update_compile_order -fileset sources_1

# Generate IP outputs (this may take a while)
puts "Generating block design outputs..."
generate_target all [get_files design_soc.bd]

# =============================================================================
# Done
# =============================================================================
puts ""
puts "=============================================="
puts "Project rebuild complete!"
puts "=============================================="
puts ""
puts "Next steps:"
puts "  1. Run Synthesis: launch_runs synth_1 -jobs 4"
puts "  2. Run Implementation: launch_runs impl_1 -to_step write_bitstream -jobs 4"
puts "  3. Export Hardware: write_hw_platform -fixed -include_bit -force design_soc_wrapper.xsa"
puts ""
puts "To build everything in one go:"
puts "  launch_runs impl_1 -to_step write_bitstream -jobs 4"
puts "  wait_on_run impl_1"
puts ""
