transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Programacion/Arqui1/9_8 {D:/Programacion/Arqui1/9_8/Shifter.sv}

