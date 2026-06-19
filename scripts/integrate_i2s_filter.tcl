# Integrate the existing filter_coeff RTL into the block design without
# modifying the I2S or filter RTL.  Run with:
#   vivado -mode batch -source scripts/integrate_i2s_filter.tcl

set root_dir [file normalize [file join [file dirname [info script]] ..]]
set project_file [file join $root_dir project_1.xpr]
set bd_file [file join $root_dir project_1.srcs sources_1 bd design_1 design_1.bd]
set bridge_file [file join $root_dir project_1.srcs sources_1 new i2s_filter_bridge.v]
set filter_file [file join $root_dir ip_repo i2s_1_0 hdl filter_coeff.v]
set biquad_file [file join $root_dir ip_repo i2s_1_0 hdl filter_biquad.v]

open_project $project_file

# Remove stale absolute references from the machine where filter_coeff was
# first imported, then add the repository-local sources.
set existing_filter_files [concat \
    [get_files -quiet *filter_coeff.v] \
    [get_files -quiet *filter_biquad.v]]
foreach f $existing_filter_files {
    set normalized_f [file normalize $f]
    if {$normalized_f ne [file normalize $filter_file] &&
        $normalized_f ne [file normalize $biquad_file]} {
        remove_files $f
    }
}
foreach f [list $biquad_file $filter_file $bridge_file] {
    if {[llength [get_files -quiet $f]] == 0} {
        add_files -norecurse -fileset sources_1 $f
    }
}
update_compile_order -fileset sources_1

set_property ip_repo_paths [file join $root_dir ip_repo] [current_project]
update_ip_catalog -rebuild

open_bd_design $bd_file

# Recreate the I2S cell from its unchanged packaged RTL.  This removes the
# stale filter_sw metadata pin left by the previous, incomplete integration.
set i2s_cell [get_bd_cells -quiet i2s_0]
if {[llength $i2s_cell]} {
    delete_bd_objs $i2s_cell
}
create_bd_cell -type ip -vlnv xilinx.com:user:i2s:1.0 i2s_0

# Recreate both channel filters as visible module-reference blocks.
foreach cell_name {filter_coeff_0 filter_coeff_1 i2s_filter_bridge_0} {
    set old_cell [get_bd_cells -quiet $cell_name]
    if {[llength $old_cell]} {
        delete_bd_objs $old_cell
    }
}
create_bd_cell -type module -reference filter_coeff filter_coeff_0
create_bd_cell -type module -reference filter_coeff filter_coeff_1
create_bd_cell -type module -reference i2s_filter_bridge i2s_filter_bridge_0

# AXI and system-domain clock/reset connections remain the same as before.
connect_bd_intf_net [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins i2s_0/S00_AXI]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
    [get_bd_pins i2s_0/audio_clk] \
    [get_bd_pins i2s_0/s00_axi_aclk] \
    [get_bd_pins filter_coeff_0/clk] \
    [get_bd_pins filter_coeff_1/clk] \
    [get_bd_pins i2s_filter_bridge_0/clk]
connect_bd_net [get_bd_pins rst_clk_wiz_0_100M/peripheral_aresetn] \
    [get_bd_pins i2s_0/s00_axi_aresetn] \
    [get_bd_pins i2s_filter_bridge_0/resetn]

# Decode source I2S, filter left/right independently, and re-serialize it.
connect_bd_net [get_bd_pins i2s_filter_bridge_0/left_sample] \
    [get_bd_pins filter_coeff_0/x_in]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/left_valid] \
    [get_bd_pins filter_coeff_0/valid]
connect_bd_net [get_bd_pins filter_coeff_0/y_out] \
    [get_bd_pins i2s_filter_bridge_0/left_filtered]

connect_bd_net [get_bd_pins i2s_filter_bridge_0/right_sample] \
    [get_bd_pins filter_coeff_1/x_in]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/right_valid] \
    [get_bd_pins filter_coeff_1/valid]
connect_bd_net [get_bd_pins filter_coeff_1/y_out] \
    [get_bd_pins i2s_filter_bridge_0/right_filtered]

connect_bd_net [get_bd_ports filter_sw] \
    [get_bd_pins i2s_filter_bridge_0/filter_sw_in]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/filter_sw_out] \
    [get_bd_pins filter_coeff_0/sw] \
    [get_bd_pins filter_coeff_1/sw]

connect_bd_net [get_bd_pins i2s_0/i2s_mclk] \
    [get_bd_pins i2s_filter_bridge_0/i2s_mclk_in]
connect_bd_net [get_bd_pins i2s_0/i2s_bclk] \
    [get_bd_pins i2s_filter_bridge_0/i2s_bclk_in]
connect_bd_net [get_bd_pins i2s_0/i2s_ws] \
    [get_bd_pins i2s_filter_bridge_0/i2s_ws_in]
connect_bd_net [get_bd_pins i2s_0/i2s_data] \
    [get_bd_pins i2s_filter_bridge_0/i2s_data_in]

connect_bd_net [get_bd_pins i2s_filter_bridge_0/i2s_mclk_out] [get_bd_ports i2s_mclk_0]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/i2s_bclk_out] [get_bd_ports i2s_bclk_0]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/i2s_ws_out]   [get_bd_ports i2s_ws_0]
connect_bd_net [get_bd_pins i2s_filter_bridge_0/i2s_data_out] [get_bd_ports i2s_data_0]

# Preserve the original software-visible address.
assign_bd_address -offset 0x44A00000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces microblaze_riscv_0/Data] \
    [get_bd_addr_segs i2s_0/S00_AXI/S00_AXI_reg] -force

validate_bd_design
save_bd_design
generate_target all [get_files $bd_file]
update_compile_order -fileset sources_1
close_project
