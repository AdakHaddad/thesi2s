# Rebuild script for Basys3 I2S project.
# Fixes audio reset polarity wiring, regenerates bitstream, and exports XSA.
# Run from Vivado TCL console with:
#   cd D:/Vivado-projects/Basys3/sbml/microblazev_tutorial
#   source tools/rebuild_i2s_audio.tcl

set proj_path "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/microblazev_tutorial.xpr"
set bd_name "design_mysoc"
set run_synth "synth_1"
set run_impl "impl_1"
set xsa_out "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/i2s5.xsa"

puts "=== Ensuring correct project is open ==="
set open_projs [get_projects -quiet]
if {[llength $open_projs] == 0} {
  open_project $proj_path
} else {
  set current_proj [lindex $open_projs 0]
  set current_proj_path [get_property DIRECTORY $current_proj]
  set wanted_proj_dir [file dirname [file normalize $proj_path]]

  if {[file normalize $current_proj_path] ne $wanted_proj_dir} {
    puts "Closing currently open project: $current_proj"
    close_project
    open_project $proj_path
  } else {
    puts "Project already open: $current_proj"
  }
}

puts "=== Opening block design ==="
open_bd_design [get_files "*/${bd_name}.bd"]

set i2s_rst_pin [get_bd_pins -quiet i2s_0/audio_rst]
set rst_p_pin   [get_bd_pins -quiet rst_clk_wiz_0_audio/peripheral_reset]

if {$i2s_rst_pin eq ""} {
  error "Could not find i2s_0/audio_rst in BD."
}
if {$rst_p_pin eq ""} {
  error "Could not find rst_clk_wiz_0_audio/peripheral_reset in BD."
}

# Connect audio reset safely (idempotent).
set i2s_rst_net [get_bd_nets -quiet -of_objects $i2s_rst_pin]
set rst_p_net   [get_bd_nets -quiet -of_objects $rst_p_pin]

if {$rst_p_net eq ""} {
  error "peripheral_reset pin is not attached to any net."
}

if {$i2s_rst_net ne ""} {
  if {$i2s_rst_net eq $rst_p_net} {
    puts "audio_rst already connected to peripheral_reset; skipping reconnect."
  } else {
    puts "Rewiring audio_rst from [get_property NAME $i2s_rst_net] to [get_property NAME $rst_p_net]"
    disconnect_bd_net $i2s_rst_net $i2s_rst_pin
    connect_bd_net $rst_p_pin $i2s_rst_pin
  }
} else {
  connect_bd_net $rst_p_pin $i2s_rst_pin
}

puts "=== Validating and saving BD ==="
validate_bd_design
save_bd_design

puts "=== Regenerating output products ==="
generate_target all [get_files "*/${bd_name}.bd"]

puts "=== Updating HDL wrapper ==="
make_wrapper -files [get_files "*/${bd_name}.bd"] -top
add_files -norecurse [glob "./microblazev_tutorial.gen/sources_1/bd/${bd_name}/hdl/${bd_name}_wrapper.v"]

puts "=== Running synthesis ==="
reset_run $run_synth
launch_runs $run_synth -jobs 8
wait_on_run $run_synth

puts "=== Running implementation + bitstream ==="
reset_run $run_impl
launch_runs $run_impl -to_step write_bitstream -jobs 8
wait_on_run $run_impl

puts "=== Exporting XSA ==="
write_hw_platform -fixed -force -include_bit -file $xsa_out

puts "=== DONE ==="
puts "Exported: $xsa_out"
