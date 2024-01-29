transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vmap -link {C:/Users/LarsvanLeeuwen/Documents/Persoonlijk/FPGA/ws/cmod-s7-oob/hw.cache/compile_simlib/activehdl}
vlib activehdl/dist_mem_gen_v8_0_13
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/fifo_generator_v13_2_8
vlib activehdl/lib_fifo_v1_0_17
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/interrupt_control_v3_1_4
vlib activehdl/axi_quad_spi_v3_2_27
vlib activehdl/xil_defaultlib

vlog -work dist_mem_gen_v8_0_13  -v2k5 -l dist_mem_gen_v8_0_13 -l lib_pkg_v1_0_2 -l lib_cdc_v1_0_2 -l lib_srl_fifo_v1_0_2 -l fifo_generator_v13_2_8 -l lib_fifo_v1_0_17 -l axi_lite_ipif_v3_0_4 -l interrupt_control_v3_1_4 -l axi_quad_spi_v3_2_27 -l xil_defaultlib \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vcom -work lib_pkg_v1_0_2 -93  \
"../../../ipstatic/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93  \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93  \
"../../../ipstatic/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_8  -v2k5 -l dist_mem_gen_v8_0_13 -l lib_pkg_v1_0_2 -l lib_cdc_v1_0_2 -l lib_srl_fifo_v1_0_2 -l fifo_generator_v13_2_8 -l lib_fifo_v1_0_17 -l axi_lite_ipif_v3_0_4 -l interrupt_control_v3_1_4 -l axi_quad_spi_v3_2_27 -l xil_defaultlib \
"../../../ipstatic/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_8 -93  \
"../../../ipstatic/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_8  -v2k5 -l dist_mem_gen_v8_0_13 -l lib_pkg_v1_0_2 -l lib_cdc_v1_0_2 -l lib_srl_fifo_v1_0_2 -l fifo_generator_v13_2_8 -l lib_fifo_v1_0_17 -l axi_lite_ipif_v3_0_4 -l interrupt_control_v3_1_4 -l axi_quad_spi_v3_2_27 -l xil_defaultlib \
"../../../ipstatic/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_17 -93  \
"../../../ipstatic/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work axi_lite_ipif_v3_0_4 -93  \
"../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_4 -93  \
"../../../ipstatic/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_quad_spi_v3_2_27 -93  \
"../../../ipstatic/hdl/axi_quad_spi_v3_2_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../../hw.gen/sources_1/ip/axi_quad_spi_0_1/sim/axi_quad_spi_0.vhd" \


vlog -work xil_defaultlib \
"glbl.v"

