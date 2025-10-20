----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- © Siemens 2024																	  --
-- SPDX-License-Identifier: MIT														  --
--                                                                                    --
-- top heading: heading SSI example of User Logic of TM FAST                          --
--                                                                                    --
-- filename:    TFL_FAST_USER_EXAMPLE_SSI_p.vhd                                       --
--                                                                                    --
-- revision:    V1.0                                                                  --	
--                                                                                    --
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;


package TFL_FAST_USER_EXAMPLE_SSI_p is
   -------------------------------
	--SSI I/O channel selection  --
	-------------------------------
	constant SSI_CLOCK_RX        : integer range 0 to 7   :=  0;
	constant SSI_DATA_IN_RX      : integer range 0 to 7   :=  4;
   --SSI whole frame length 
	constant COUNT_BIT_WIDTH     : integer range 13 to 32 := 16;   
	--SSI position value length
	constant FRAME_BIT_WIDTH     : integer range 13 to 32 := 13; 
	---------------------------
	--SSI Baudrate Selection --
	---------------------------
	-- 0 -> 125 KHz
	-- 1 -> 250 KHz
	-- 2 -> 500 KHz
	-- 3 ->   1 MHz
	constant CLOCKSEL            : integer  range 0 to 3 :=  0;
	-------------------------------------
	--Gray or Binary displayed value   --
	-------------------------------------
	-- 0 --> Gray Code to Absolute Binary 
	-- 1 --> no conversion
	constant GRAY_BIN_N_CTRL     : std_logic  :=   '1'; 
  ---------------------------------------------------------             
  -- Selection of feedback interface(FB_IF) DWORD        --              
  --------------------------------------------------------- 
	--constant FB_IF_SSI_VAL         : integer range 0 to 7  :=   0;
	
	--constant FB_IF_DATAAVAILABLE_W : integer range 0 to 7  :=   1;
	
	constant FB_IF_DATAAVAILABLE_B : integer range 0 to 31  :=  0;
	
	--constant FB_IF_FRAME_OVERRUN_W : integer range 0 to 7  :=   1;
	
	constant FB_IF_FRAME_OVERRUN_B : integer range 0 to 31  :=  1;	
  ---------------------------------------------------------             
  -- definitions of the justification in the FB_IF       --              
  ---------------------------------------------------------
  	--  right or left
	constant SHIFT_DIR           : string := "right";
	-- Number of bits to shift 0 to FRAME_BIT_WIDTH
	constant SHIFT_COUNT         : integer range 0 to (FRAME_BIT_WIDTH - 1)  :=   0;  
	

end package TFL_FAST_USER_EXAMPLE_SSI_p;