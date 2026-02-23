# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "D:\\Vivado-projects\\Basys3\\sbml\\microblazev_tutorial\\workspace\\platform_mysoc_v2\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\sleep.h"
  "D:\\Vivado-projects\\Basys3\\sbml\\microblazev_tutorial\\workspace\\platform_mysoc_v2\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xiltimer.h"
  "D:\\Vivado-projects\\Basys3\\sbml\\microblazev_tutorial\\workspace\\platform_mysoc_v2\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xtimer_config.h"
  "D:\\Vivado-projects\\Basys3\\sbml\\microblazev_tutorial\\workspace\\platform_mysoc_v2\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\lib\\libxiltimer.a"
  )
endif()
