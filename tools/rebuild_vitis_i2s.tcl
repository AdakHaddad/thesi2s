# XSCT script to refresh platform and rebuild hello_world for updated i2s5.xsa.
# Run from XSCT with:
#   cd D:/Vivado-projects/Basys3/sbml/microblazev_tutorial
#   source tools/rebuild_vitis_i2s.tcl

set ws "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/workspace"
set xsa "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/i2s5.xsa"
set spr "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/workspace/platformi2s5/platform.spr"
set xpfm "D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/workspace/platformi2s5/export/platformi2s5/platformi2s5.xpfm"
set platform_name "platformi2s5_fresh"
set app_name "hello_world"
set domain_name "standalone_microblaze_riscv_0"
set cpu_name "microblaze_riscv_0"

puts "=== rebuild_vitis_i2s.tcl v3 (force-clean platform flow) ==="

# This script must run in XSCT (not XSDB).
if {[llength [info commands platform]] == 0 || [llength [info commands app]] == 0} {
  puts "ERROR: This script must be sourced in XSCT, but current shell does not provide Vitis commands."
  puts "Run: xsct"
  puts "Then: source D:/Vivado-projects/Basys3/sbml/microblazev_tutorial/tools/rebuild_vitis_i2s.tcl"
  return -code error "Not running in XSCT"
}

# Support workspace command differences across tool versions.
if {[llength [info commands setws]] > 0} {
  setws $ws
} elseif {[llength [info commands workspace]] > 0} {
  workspace set $ws
} else {
  puts "ERROR: No workspace command available in this XSCT session."
  return -code error "Workspace command missing"
}

# Force-clean platform generation from current XSA.
catch {platform remove $platform_name}
if {[catch {
  platform create -name $platform_name -hw $xsa -out $ws -proc $cpu_name -os standalone
} cerr_fresh]} {
  puts "ERROR: Could not create platform '$platform_name'."
  puts "Details: $cerr_fresh"
  return -code error "Platform create failed"
}

if {[catch {platform active $platform_name} aerr_fresh]} {
  puts "ERROR: Platform '$platform_name' created but cannot be activated."
  puts "Details: $aerr_fresh"
  return -code error "Platform activate failed"
}

if {[catch {platform generate} gerr]} {
  puts "ERROR: Failed to generate platform '$platform_name'."
  puts "Details: $gerr"
  return -code error "Platform generate failed"
}

# Build app; create it if missing.
if {[catch {app config -name $app_name -platform $platform_name -domain $domain_name} aerr]} {
  puts "App '$app_name' not found/configurable. Trying create..."

  if {[catch {
    app create -name $app_name -platform $platform_name -domain $domain_name -template {Hello World}
  } acerr]} {
    puts "ERROR: Could not create app '$app_name'."
    puts "Details: $acerr"
    return -code error "App create failed"
  }

  if {[catch {app config -name $app_name -platform $platform_name -domain $domain_name} aerr2]} {
    puts "ERROR: App was created but cannot be configured."
    puts "Details: $aerr2"
    return -code error "App configure failed"
  }
}

if {[catch {app build -name $app_name} berr]} {
  puts "ERROR: Failed to build app '$app_name'."
  puts "Details: $berr"
  return -code error "App build failed"
}

puts "DONE: platform and app rebuilt."
puts "Active platform: $platform_name"
