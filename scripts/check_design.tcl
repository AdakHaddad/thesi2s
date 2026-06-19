set root_dir [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root_dir project_1.xpr]
open_bd_design [file join $root_dir project_1.srcs sources_1 bd design_1 design_1.bd]
validate_bd_design
save_bd_design

set synth_run [get_runs synth_1]
reset_run $synth_run
launch_runs $synth_run -jobs 4
wait_on_run $synth_run
set synth_status [get_property STATUS $synth_run]
puts "SYNTH_STATUS=$synth_status"
if {![string match "*Complete*" $synth_status]} {
    error "Synthesis did not complete: $synth_status"
}
close_project
