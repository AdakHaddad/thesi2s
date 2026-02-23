# 2026-02-24T00:21:00.093761700
import vitis

client = vitis.create_client()
client.set_workspace(path="workspace")

platform = client.create_platform_component(name = "platform_mysoc",hw_design = "$COMPONENT_LOCATION/../../design_mysoc_wrapper_hw.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0",compiler = "gcc")

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform_mysoc/export/platform_mysoc/platform_mysoc.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

platform = client.create_platform_component(name = "platform_mysoc_v2",hw_design = "$COMPONENT_LOCATION/../../design_mysoc_wrapper_hw_v2.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0",compiler = "gcc")

comp = client.create_app_component(name="hello_world_switch_led",platform = "$COMPONENT_LOCATION/../platform_mysoc_v2/export/platform_mysoc_v2/platform_mysoc_v2.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

