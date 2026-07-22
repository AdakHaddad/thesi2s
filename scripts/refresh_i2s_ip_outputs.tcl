# Refresh generated Vivado files after editing the local I2S IP repo.
#
# Why this exists:
# Vivado copies packaged IP sources from ip_repo into generated BD/ipshared
# folders.  If an IP RTL file is edited, synthesis can keep using an older
# generated copy unless the IP/BD products and affected OOC runs are reset.
#
# Usage:
#   vivado -mode batch -source scripts/refresh_i2s_ip_outputs.tcl

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]
set project_file [file join $project_dir project_1.xpr]

open_project $project_file

# Make Vivado rescan local IP repositories and update catalog metadata.
set_property ip_repo_paths [file join $project_dir ip_repo] [current_project]
update_ip_catalog -rebuild

# Refresh the block design and regenerate all generated HDL wrappers/products.
open_bd_design [file join $project_dir project_1.srcs sources_1 bd design_1 design_1.bd]
validate_bd_design
save_bd_design

# Upgrade/refresh IP metadata if Vivado thinks anything is stale.
set stale_ips [get_ips -quiet -all]
if {[llength $stale_ips] > 0} {
  upgrade_ip -quiet $stale_ips
}

generate_target all [get_files [file join $project_dir project_1.srcs sources_1 bd design_1 design_1.bd]]
export_ip_user_files -of_objects [get_files [file join $project_dir project_1.srcs sources_1 bd design_1 design_1.bd]] -no_script -sync -force -quiet

# Reset the runs that commonly hold stale generated copies.  Missing runs are OK.
foreach run_name {
  design_1_i2s_0_0_synth_1
  design_1_i2s_0_1_synth_1
  design_1_i2s_filter_bridge_0_0_synth_1
  synth_1
} {
  set run_obj [get_runs -quiet $run_name]
  if {[llength $run_obj] > 0} {
    reset_run $run_obj
  }
}

puts "INFO: I2S IP/BD generated outputs refreshed. Re-run synthesis now."

close_project
