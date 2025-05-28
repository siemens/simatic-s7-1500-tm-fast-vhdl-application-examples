onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tfl_fast_user_te/INFO
add wave -noupdate /tfl_fast_user_te/CLK
add wave -noupdate /tfl_fast_user_te/DUT_i/CLK_2MHZ
add wave -noupdate /tfl_fast_user_te/RST
add wave -noupdate /tfl_fast_user_te/CPU_STOP

add wave -noupdate -expand -group {Laser Power} /tfl_fast_user_te/DQ(11)
add wave -noupdate -expand -group {Control SETUP} /tfl_fast_user_te/CTRL_IF0

add wave -noupdate -expand -group {Feedback Interface} /tfl_fast_user_te/FB_IF_USER0
add wave -noupdate -expand -group {Feedback Interface} /tfl_fast_user_te/FB_IF_USER1
add wave -noupdate -expand -group {Feedback Interface} /tfl_fast_user_te/FB_IF_USER4


add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/READY
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/START
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/DATAX_DIRECT
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/DATAY_DIRECT
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/DATAX
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/DATAY
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/XY_DATA_INT
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/X_CPU
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/Y_CPU
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/MODE_ACTIVE
add wave -noupdate -expand -group {DEBUG_INTPERPOLATION} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/SEND

add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/DATA_IN
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/ADDRESS
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/RD_CPU
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/pos_send
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/CLEAR
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/NEW_DATA_AV
add wave -noupdate -expand -group {DEBUG_DATA} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/SIG_XY


add wave -noupdate -expand -group {DEBUG_StateMachine} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/SEND_CPU
add wave -noupdate -expand -group {DEBUG_StateMachine} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/count 
add wave -noupdate -expand -group {DEBUG_StateMachine} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/newinINT
add wave -noupdate -expand -group {DEBUG_StateMachine} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/NEW_DATA_AV
add wave -noupdate -expand -group {DEBUG_StateMachine} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/RD_CPU

add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/DATA_IN
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/WRITE_EN
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/READ_EN
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/ADDRESS
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/ADDR
#add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/ADDR_COUNT
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/MAXVAL
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/SIG_XY
add wave -noupdate -expand -group {DEBUG_RAM} /tfl_fast_user_te/DUT_i/i_INTERPOLATION/i_DATA/OnePortRAM_inst/q

add wave -noupdate -expand -group {RS485_TX - XY2-100 outputs} /tfl_fast_user_te/RS485_TX(0)
add wave -noupdate -expand -group {RS485_TX - XY2-100 outputs} /tfl_fast_user_te/RS485_TX(1)
add wave -noupdate -expand -group {RS485_TX - XY2-100 outputs} /tfl_fast_user_te/RS485_TX(4)
add wave -noupdate -expand -group {RS485_TX - XY2-100 outputs} /tfl_fast_user_te/RS485_TX(5)



TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ms} 0}
quietly wave cursor active 1
configure wave -namecolwidth 364
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {983 ns} {1844 ns}
