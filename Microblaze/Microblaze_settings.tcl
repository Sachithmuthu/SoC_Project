
################################################################
# This is a generated script based on design: MicroBlaze
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
#set scripts_vivado_version 2016.1
#set current_vivado_version [version -short]

#if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
#   puts ""
#   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

#   return 1
#}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source MicroBlaze_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tfbg676-2
   set_property BOARD_PART xilinx.com:ac701:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name MicroBlaze

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.6 microblaze_0 ]
  set_property -dict [ list \
CONFIG.C_CACHE_BYTE_SIZE {32768} \
CONFIG.C_DCACHE_ALWAYS_USED {1} \
CONFIG.C_DCACHE_BASEADDR {0x0000000080000000} \
CONFIG.C_DCACHE_BYTE_SIZE {32768} \
CONFIG.C_DCACHE_HIGHADDR {0x00000000FFFFFFFF} \
CONFIG.C_DCACHE_LINE_LEN {8} \
CONFIG.C_DEBUG_ENABLED {1} \
CONFIG.C_D_AXI {1} \
CONFIG.C_D_LMB {1} \
CONFIG.C_ICACHE_ALWAYS_USED {1} \
CONFIG.C_ICACHE_BASEADDR {0x80000000} \
CONFIG.C_ICACHE_HIGHADDR {0xFFFFFFFF} \
CONFIG.C_ICACHE_LINE_LEN {8} \
CONFIG.C_INTERCONNECT {3} \
CONFIG.C_I_LMB {1} \
CONFIG.C_USE_BARREL {1} \
CONFIG.C_USE_DCACHE {1} \
CONFIG.C_USE_DIV {1} \
CONFIG.C_USE_FPU {1} \
CONFIG.C_USE_HW_MUL {1} \
CONFIG.C_USE_ICACHE {1} \
 ] $microblaze_0

  # Create port connections

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port reset -pg 1 -y 160 -defaultsOSRD
preplace port sys_diff_clock -pg 1 -y 360 -defaultsOSRD
preplace inst microblaze_0_axi_periph -pg 1 -lvl 3 -y 260 -defaultsOSRD
preplace inst mdm_1 -pg 1 -lvl 1 -y 240 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 1 -y 50 -defaultsOSRD
preplace inst rst_clk_wiz_1_100M -pg 1 -lvl 2 -y 180 -defaultsOSRD
preplace inst microblaze_0_local_memory -pg 1 -lvl 3 -y 470 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 1 -y 370 -defaultsOSRD
preplace inst system_cache_0 -pg 1 -lvl 2 -y 400 -defaultsOSRD
preplace netloc microblaze_0_Clk 1 0 3 10 320 510 60 900
preplace netloc sys_diff_clock_1 1 0 1 20
preplace netloc microblaze_0_ilmb_1 1 1 2 NJ 30 920
preplace netloc microblaze_0_axi_periph_M00_AXI 1 0 4 30 170 NJ 90 NJ 90 1230
preplace netloc microblaze_0_M_AXI_DP 1 1 2 NJ 50 940
preplace netloc microblaze_0_M_ACE_DC 1 1 1 480
preplace netloc rst_clk_wiz_1_100M_interconnect_aresetn 1 1 2 530 80 910
preplace netloc rst_clk_wiz_1_100M_bus_struct_reset 1 2 1 880
preplace netloc rst_clk_wiz_1_100M_peripheral_aresetn 1 0 3 30 310 NJ 310 890
preplace netloc rst_clk_wiz_1_100M_mb_reset 1 0 3 30 140 NJ 70 880
preplace netloc microblaze_0_dlmb_1 1 1 2 NJ 10 930
preplace netloc microblaze_0_M_ACE_IC 1 1 1 500
preplace netloc microblaze_0_debug 1 0 2 20 150 490
preplace netloc reset_1 1 0 2 NJ 160 NJ
preplace netloc mdm_1_debug_sys_rst 1 1 1 520
levelinfo -pg 1 -10 260 720 1100 1270 1310 -top -30 -bot 560
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

