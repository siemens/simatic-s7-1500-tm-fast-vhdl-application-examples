
# clean work lib
quietly catch { vmap -del work }
quietly catch { vdel -all -lib work }
quietly vlib work
quietly vmap work work

# compile Siemens TM FAST system library files
vcom ../../../SRC/TFL_FAST_USER_PUBLIC1_p.vhd -2008
vcom ../../../SRC/TFL_FAST_USER_PUBLIC2_p.vhd -2008
vcom ../../../SRC/IP_CONF/TFL_FAST_USER_IP_CONF_MP_FAST_1_p.vhd -2008
vcom ../TFL_FAST_USER_IP_CONF_LASER_MP_FAST_1_p.vhd -2008
vcom ../../../SRC/CTRL_FB_IF/TFL_FAST_USER_CTRL_FB_IF_e.vhd -2008
vcom ../../../SRC/CTRL_FB_IF/TFL_FAST_USER_CTRL_FB_IF_a.vhd -2008