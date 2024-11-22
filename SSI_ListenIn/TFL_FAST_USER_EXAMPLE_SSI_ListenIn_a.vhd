----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- © Siemens 2024																	  --
-- SPDX-License-Identifier: MIT														  --
--                                                                                    --
-- top heading: top heading SSI example architecture of User Logic of TM FAST         --
--                                                                                    --
-- filename:    TFL_FAST_USER_EXAMPLE_SSI_a.vhd                                       --
--                                                                                    --
-- revision:    V1.0                                                                  --
--                                                                                    --
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

use ieee.numeric_std.all;
use ieee.math_real.all;
use work.TFL_FAST_USER_EXAMPLE_SSI_p.all;


architecture TFL_FAST_USER_EXAMPLE_SSI_a of TFL_FAST_USER_e is
  
  --SSI FB_IF ALIASES--
  alias   SSI_VALUE_IF     : std_logic_vector is FB_IF(FB_IF_SSI_VAL)((COUNT_BIT_WIDTH - 1) downto 0);
  --SIGNALS     
  signal ENCODERCOUNT      : std_logic_vector ((COUNT_BIT_WIDTH - 1) downto 0);
  signal DATAAVAILABLE     : std_logic;
  signal FRAME_OVERRUN     : std_logic;

begin

  --Unused I/O null
  DQ <= ( others => '0' );
  
 
  --GENERATE SSI Module--
  SSI_ListenIn: entity work.SSIListenIn_e(SSIListenIn_a)
  GENERIC MAP (
        BIT_WIDTH   => COUNT_BIT_WIDTH,
		  SHIFT_DIR   => SHIFT_DIR,
		  SHIFT_COUNT => SHIFT_COUNT,
		  CLOCKSEL    => CLOCKSEL,
        FRAME_WIDTH => FRAME_BIT_WIDTH        
				)
  PORT MAP (
        RST           => RST,
        CLK           => CLK,
        GRAY_BIN_N    => GRAY_BIN_N_CTRL,
        SSICLOCK      => RS485_RX(SSI_CLOCK_RX),
        SSI_DATA_IN   => RS485_RX(SSI_DATA_IN_RX),
        ENCODERCOUNT  => ENCODERCOUNT,
		  DATAAVAILABLE => DATAAVAILABLE,
		  FRAME_OVERRUN => FRAME_OVERRUN
    );
	 
RX_PROC: PROCESS(CLK, RST)
  BEGIN
  if RST = '1' then 
	  RS485_OE <= ( others => '0' );
  elsif Rising_edge(CLK) then
	  if CPU_STOP = '1' then
			RS485_OE <= ( others => '0' );
	  end if;
	  RS485_OE(SSI_CLOCK_RX)   <= '0';       -- CLOCK OUT
	  RS485_OE(SSI_DATA_IN_RX) <= '0';       -- DATA IN
  end if;
  END PROCESS;
	 
	 
  
  MIRROR_PROC: PROCESS(CLK, RST)
  BEGIN
  if RST = '1' then
		FB_IF <= ( others => ( others => '0' ));
  elsif Rising_edge(CLK) then
		if CPU_STOP = '1' then
			FB_IF(0) <= ( others => '0' );
			FB_IF(1) <= ( others => '0' );
		else
			SSI_VALUE_IF((COUNT_BIT_WIDTH - 1) downto 0)             <=     ENCODERCOUNT;
			FB_IF(1)(FB_IF_DATAAVAILABLE_B) <= DATAAVAILABLE ;
			FB_IF(1)(FB_IF_FRAME_OVERRUN_B) <= FRAME_OVERRUN ;
		end if;
  end if;
  END PROCESS;
  
  

end architecture TFL_FAST_USER_EXAMPLE_SSI_a;
