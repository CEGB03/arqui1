transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Programacion/Arqui1/10_20/ARM {D:/Programacion/Arqui1/10_20/ARM/arm.sv}

