--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- top heading test package of User Logic of TM FASTs                         --
--                                                                            --
-- filename    TFL_FAST_USER_INC_ENC_p.vhd                                    --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- version     see TFL_FAST_USER_p.vhd                                        --
--                                                                            --
-- history     see TFL_FAST_USER_HISTORY.txt                                  --
--                                                                            --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package TFL_FAST_USER_INC_ENC_p is
                
  -- definition of Incremental encoder logic counter register width				
  constant COUNT_BIT_WIDTH: positive:= 32;                -- counter with 32 bits (possible values: 16 or 32 Bits)
  
  -- Channel Selection for the A/B/N and HOLDHW Signals
  constant CH_A : natural range 0 to 11 := 0;  -- DI(0)
  constant CH_B : natural range 0 to 11 := 1;  -- DI(1)
  constant CH_N : natural range 0 to 11 := 2;  -- DI(2)

  constant CH_HOLDHW : natural range 0 to 11 := 3; -- DI(3) 
   --------------------------
	-- Count mode Selection --
	--------------------------
	-- Count mode Single       = "00" 
	-- Count mode Double       = "01"
	-- Count mode Quadruple    = "10"  
	-- Count mode Pulse/Dir    = "11"  --single
  constant   COUNT_MODE:       std_logic_vector := "00";  

	--------------------------
	-- Count type Selection --
	--------------------------
	-- Count type continuous  = "00"
	-- Count type periodic    = "01"
	-- Count type single      = "10"
  constant   COUNT_TYPE:       std_logic_vector := "00"; 

	-- main count direction: counting up (0) or counting down (1)
  constant   COUNT_DIR:        std_logic        :=  '0';            -- main count direction
	-- invert pulse polarity of Signal A: not inverted: 0 / inverted: 1
  constant  INV_A_PULSE_POL:  std_logic         :=  '0';            -- invert pulse polarity of Signal A
	-- invert pulse polarity of Signal B: not inverted: 0 / inverted: 1
  constant  INV_B_DIR_POL:    std_logic         :=  '0';            -- invert pulse polarity of Signal B
	-- invert pulse polarity of Signal N: not inverted: 0 / inverted: 1
  constant  INV_N_ZERO_POL:   std_logic         :=  '0';            -- invert pulse polarity of Signal N

	--------------------------
	-- Holdsource Selection --
	--------------------------
	-- HOLDHW                   = "001"
	-- SW_HOLD_LAT              = "010"
	-- HOLDHW and SW_HOLD_LAT   = "011"
	-- HOLDHW or SW_HOLD_LAT    = "100"
	-- none                     = others
  constant  HOLDSOURCE:       std_logic_vector := "000";  -- holdsource

	---------------------------
	-- Resetsource Selection --
	---------------------------
	-- RESETHW                   = "001"
	-- SW_RESET_LAT              = "010"
	-- RESETHW and SW_RESET_LAT  = "011"
	-- RESETHW or SW_RESET_LAT   = "100"
	-- none                      = others
  constant  RESETSOURCE:      std_logic_vector := "001"; -- resetsource
  
  


  -- Incremental encoder max. value register
  constant   MAX_VALUE:        std_logic_vector := x"0000FFFF";
  -- Incremental encoder min. value register
  constant   MIN_VALUE:        std_logic_vector := x"00000000";
  -- Incremental encoder reset value register
  constant   RESET_VALUE:      std_logic_vector := x"000000FF";
  -- Incremental encoder load value register
  constant   LOAD_VALUE:       std_logic_vector := x"00000000";



end package TFL_FAST_USER_INC_ENC_p;
