onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib axi_quad_spi_0_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi_quad_spi_0.udo}

run 1000ns

quit -force
