############################################
# timing constraints for XY2-100 interface #
############################################

# create 2MHz CLK of XY2-100
create_generated_clock -divide_by 25 -source [ get_nets {*SYS_i*ALT_PLL_i*clk[1]} ] -name CLK_2MHZ [ get_registers {TFL_FAST_USER_e:USER_i|CLK_2MHZ} ] -add

# set false paths
set_false_path -from {CLK_2MHZ} -to {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[0]}
set_false_path -from {CLK_2MHZ} -to {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[2]}
set_false_path -from {CLK_2MHZ} -to {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[3]}

set_false_path -from {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[0]} -to {CLK_2MHZ}
set_false_path -from {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[2]} -to {CLK_2MHZ}
set_false_path -from {SYS_PUBLIC_i|SYS_i|CORE_i|ALT_CLK_RST_i|ALT_PLL_i|altpll_component|auto_generated|pll1|clk[3]} -to {CLK_2MHZ}

# setup and hold timings
set tsu_XY2_DATA 50
set th_XY2_DATA 100
set trace_delay_max 5
set trace_delay_min 0

#  KL1/2   = RS485_TX(0) = use port: PIO14
#  KL3/4   = RS485_TX(1) = use port: PIO12
#  KL10/11 = RS485_TX(2) = use port: PIO15
#  KL12/13 = RS485_TX(3) = use port: PIO13
#  KL21/22 = RS485_TX(4) = use port: PIO31
#  KL23/24 = RS485_TX(5) = use port: PIO29
#  KL30/31 = RS485_TX(6) = use port: PIO30
#  KL32/33 = RS485_TX(7) = use port: PIO28
# 
# used in the example: 
# RS485_TX(5) = PIO29 = SYNC, 
# RS485_TX(6) = PIO30 = RS422_X(DATA_X), 
# RS485_TX(7) = PIO28 = RS422_Y(DATA_Y),
#
set_output_delay -clock { CLK_2MHZ } -clock_fall -max [ expr $trace_delay_max + $tsu_XY2_DATA ] [get_ports {PIO[28] PIO[29] PIO[30]}]
set_output_delay -clock { CLK_2MHZ } -clock_fall -min [ expr $trace_delay_min - $th_XY2_DATA ] [get_ports {PIO[28] PIO[29] PIO[30]}]