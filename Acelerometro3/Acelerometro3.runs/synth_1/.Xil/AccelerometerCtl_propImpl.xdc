set_property SRC_FILE_INFO {cfile:C:/Users/carlo/Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/constraints/Nexys4DDR_C.xdc rfile:../../../../../../Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/constraints/Nexys4DDR_C.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk_i }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
set_property src_info {type:XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk_i}];
set_property src_info {type:XDC file:1 line:188 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { miso }]; #IO_L11P_T1_SRCC_15 Sch=acl_miso
set_property src_info {type:XDC file:1 line:189 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports { mosi }]; #IO_L5N_T0_AD9N_15 Sch=acl_mosi
set_property src_info {type:XDC file:1 line:190 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { sclk }]; #IO_L14P_T2_SRCC_15 Sch=acl_sclk
set_property src_info {type:XDC file:1 line:191 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { ss }]; #IO_L12P_T1_MRCC_15 Sch=acl_csn
