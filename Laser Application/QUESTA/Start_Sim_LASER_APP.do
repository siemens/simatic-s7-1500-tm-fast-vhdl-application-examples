
# start simulation Test HELLO_WORLD
vsim work.tfl_fast_user_te(TFL_FAST_USER_LASER_ta)
log -r *
do w_LASER_APP.do
run -all