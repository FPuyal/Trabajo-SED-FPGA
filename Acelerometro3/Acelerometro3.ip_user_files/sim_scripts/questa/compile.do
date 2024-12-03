vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xbip_utils_v3_0_13
vlib questa_lib/msim/c_reg_fd_v12_0_9
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vlib questa_lib/msim/xbip_pipe_v3_0_9
vlib questa_lib/msim/xbip_dsp48_addsub_v3_0_9
vlib questa_lib/msim/xbip_addsub_v3_0_9
vlib questa_lib/msim/c_addsub_v12_0_18
vlib questa_lib/msim/xbip_bram18k_v3_0_9
vlib questa_lib/msim/mult_gen_v12_0_21
vlib questa_lib/msim/axi_utils_v2_0_9
vlib questa_lib/msim/cordic_v6_0_22
vlib questa_lib/msim/xil_defaultlib

vmap xbip_utils_v3_0_13 questa_lib/msim/xbip_utils_v3_0_13
vmap c_reg_fd_v12_0_9 questa_lib/msim/c_reg_fd_v12_0_9
vmap xbip_dsp48_wrapper_v3_0_6 questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vmap xbip_pipe_v3_0_9 questa_lib/msim/xbip_pipe_v3_0_9
vmap xbip_dsp48_addsub_v3_0_9 questa_lib/msim/xbip_dsp48_addsub_v3_0_9
vmap xbip_addsub_v3_0_9 questa_lib/msim/xbip_addsub_v3_0_9
vmap c_addsub_v12_0_18 questa_lib/msim/c_addsub_v12_0_18
vmap xbip_bram18k_v3_0_9 questa_lib/msim/xbip_bram18k_v3_0_9
vmap mult_gen_v12_0_21 questa_lib/msim/mult_gen_v12_0_21
vmap axi_utils_v2_0_9 questa_lib/msim/axi_utils_v2_0_9
vmap cordic_v6_0_22 questa_lib/msim/cordic_v6_0_22
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -work xbip_utils_v3_0_13  -93  \
"../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_9  -93  \
"../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6  -93  \
"../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_9  -93  \
"../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_addsub_v3_0_9  -93  \
"../../ipstatic/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \

vcom -work xbip_addsub_v3_0_9  -93  \
"../../ipstatic/hdl/xbip_addsub_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_18  -93  \
"../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work xbip_bram18k_v3_0_9  -93  \
"../../ipstatic/hdl/xbip_bram18k_v3_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_21  -93  \
"../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_9  -93  \
"../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work cordic_v6_0_22  -93  \
"../../ipstatic/hdl/cordic_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../Acelerometro3.gen/sources_1/ip/square_root/sim/square_root.vhd" \
"../../../../../../Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/hdl/ADXL362Ctrl.vhd" \
"../../../../../../Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/hdl/AccelArithmetics.vhd" \
"../../../../../../Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/hdl/SPI_If.vhd" \
"../../../../../../Downloads/Nexys-4-DDR-OOB-2016.4-2/Nexys-4-DDR-OOB/src/hdl/AccelerometerCtl.vhd" \

