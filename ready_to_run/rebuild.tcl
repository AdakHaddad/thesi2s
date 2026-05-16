# rebuild.tcl
# Reconstructs the nobufgmux project with the fixed I2S IP and MicroBlaze software.

set script_dir [file dirname [file normalize [info script]]]
set project_name "nobufgmux_fix"
set part "xc7a35tcpg236-1"
set board_part "digilentinc.com:basys3:part0:1.2"

cd $script_dir

# Create project
if {[file exists $project_name]} {
    file delete -force $project_name
}
create_project $project_name ./$project_name -part $part -force
set_property board_part $board_part [current_project]

# Set IP repository
set_property ip_repo_paths ./ip_repo [current_project]
update_ip_catalog

# Add Block Design
add_files -norecurse ./proj/bdesign_clock_core.bd
open_bd_design ./proj/bdesign_clock_core.bd

# Generate Wrapper
set wrapper_file [make_wrapper -files [get_files bdesign_clock_core.bd] -top]
add_files -norecurse $wrapper_file
set_property top bdesign_clock_core_wrapper [current_fileset]

# Add Constraints
add_files -fileset constrs_1 -norecurse ./proj/constrn.xdc

# Update compile order
update_compile_order -fileset sources_1

puts ""
puts "=============================================="
puts "Project $project_name rebuilt successfully!"
puts "=============================================="
puts "Next steps:"
puts "1. Run Synthesis/Implementation/Generate Bitstream"
puts "2. Export Hardware (XSA)"
puts "3. Open Vitis and use the helloworld.c in sw/"
puts "=============================================="
