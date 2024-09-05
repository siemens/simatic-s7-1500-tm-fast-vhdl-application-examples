--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT                                               --
-- top heading test architecture of User Logic of TM FASTs                    --
--                                                                            --
-- filename    TFL_FAST_USER_INC_ENC_a.vhd                                    --
--                                                                            --
-- copyright   Siemens Industry, Inc                                          --
--                                                                            --
-- version     see TFL_FAST_USER_INC_ENC_p.vhd                                --
--                                                                            --
-- history     see TFL_FAST_USER_HISTORY.txt                                  --
--                                                                            --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.TFL_FAST_USER_INC_ENC_p.all;


architecture TFL_FAST_USER_INC_ENC_a of TFL_FAST_USER_e is
  
  
  -- Incremental encoder status
  alias   STATUS:      std_logic_vector is FB_IF(0);                                       -- Incremental encoder statusregister
  alias   INC_ENC_COUNT_VALUE: std_logic_vector is FB_IF(1)((COUNT_BIT_WIDTH-1) downto 0); -- Incremental encoder counter value
  
  
  -- DI / DQ Status
  alias   DI_STAT:             std_logic_vector is STATUS(11 downto 0);             -- DI status register
  alias   DI_DIAG_STAT:        std_logic_vector is STATUS(23 downto 12);
  alias   INC_ENC_STATUS:      std_logic_vector is STATUS(30 downto 26);
   
   alias   LASTCOUNTDIR:        std_logic    is INC_ENC_STATUS(26);                  -- Direction of last count pulse
   alias   HOME:                std_logic    is INC_ENC_STATUS(27);                  -- home
   alias   HOMED:               std_logic    is INC_ENC_STATUS(28);                  -- homed
   alias   UNDERFLOW:           std_logic    is INC_ENC_STATUS(29);                  -- Underflow occured
   alias   OVERFLOW:            std_logic    is INC_ENC_STATUS(30);                  -- Overflow occured

  
  -- Diagnosis status
  alias   DIAG_STAT_CPU_STOP:  std_logic     is STATUS(24);    -- status of CPU_STOP
  alias   DIAG_STAT_LP_QI:     std_logic     is STATUS(25);    -- status of the quality information of L+ supply
  
  --Incremental Encoder Parameters
  alias INC_CTRL: std_logic_vector is CTRL_IF(0);     -- CTRL_IF(0) is selected to setup the INC_CTRL parameters
    -- Incremental encoder control register
  alias   PULSECLEAR:        std_logic       is INC_CTRL(0);            -- clear counter value
  alias   LOAD:              std_logic       is INC_CTRL(1);             -- load signal
  alias   EDGE:              std_logic       is INC_CTRL(2);             -- edge signal
  alias   HOLDSW:            std_logic       is INC_CTRL(3);             -- SW-Hold
  alias   RESETSW:           std_logic       is INC_CTRL(4);             -- HW-Hold

  
  -- other signals
  signal  DI_MSK:            std_logic_vector ( ( DI_QUANTITY - 1 ) downto 0 ); -- Digital Inputs masked by quality information of digital process inputs (DIs)

  -- incremental encoder signals                                  -- Reset for Incremental Encoder Logic
  signal  ENCODERCOUNT:      std_logic_vector ((COUNT_BIT_WIDTH-1) downto 0);   -- Encoder Counter Value
  signal  A_PULSE_POL_VAL:   std_logic := '1';                                  -- a_pulse polarity value
  signal  B_DIR_POL_VAL:     std_logic := '1';                                  -- b_dir polarity value
  signal  N_ZERO_POL_VAL:    std_logic := '1';                                  -- n_zero polarity value



begin
  
  -- Digital Inputs masked by quality information of digital process inputs (DIs)
  DI_MASKING_g: for i in 0 to (DI_QUANTITY-1) generate
    DI_MSK(i) <= DI(i) when ( DI_QI_BAD(i) = '0' ) else '0';
  end generate DI_MASKING_g;


  -- Incremental Encoder
  INC_ENC: entity work.INC_ENC_e(INC_ENC_a)
  GENERIC MAP(
    BIT_WIDTH => COUNT_BIT_WIDTH
	)

  PORT MAP (
    -- Logic-Clock and -Reset
   CLK           => CLK,             -- clock of user logic (low-to-high-edge!)
	RST           => RST,             -- reset of user logic (high-active!)
	STOP          => CPU_STOP,        -- CPU_STOP
	CLKEN	      => '1',
	-- Counter Signals A/B/N
	A             => DI_MSK(CH_A),       -- a_pulse
	B             => DI_MSK(CH_B),       -- b_dir
	N             => DI_MSK(CH_N),       -- n_zero
    -- Control Interface
	A_PULSE_POL   => A_PULSE_POL_VAL, -- a_pulse polarity
	B_DIR_POL     => B_DIR_POL_VAL,   -- b_dir polarity
	N_ZERO_POL    => N_ZERO_POL_VAL,  -- n_zero polarity
   PULSECLEAR    => PULSECLEAR,      -- clear counter value
	LOAD          => LOAD,            -- load signal
	EDGE          => EDGE,            -- edge signal
	MISSINGSUPPLY => LP_QI_BAD,       -- quality information of L+ supply
	COUNT_MODE    => COUNT_MODE,      -- AB1, AB2, AB4 or PULSE/DIRECTION Count mode
	COUNT_TYPE    => COUNT_TYPE,      -- three types of counting ( continuous, periodic, and single  )
	COUNT_DIR     => COUNT_DIR,       -- selects whether counting up (0) or counting down (1) is the main count direction
	HOLDSW        => HOLDSW,          -- SW-Hold
	HOLDHW        => DI_MSK(CH_HOLDHW),       -- HW-Hold
	HOLDSOURCE    => HOLDSOURCE,      -- Holdsource selection
	RESETSW       => RESETSW,         -- SW-Reset
	RESETSOURCE   => RESETSOURCE,     -- Resetsource selection
	MAX_VALUE     => MAX_VALUE,       -- Count range Max-Value
	MIN_VALUE     => MIN_VALUE,       -- Count range Min-Value
	RESET_VALUE   => RESET_VALUE,     -- Reset value
	LOAD_VALUE    => LOAD_VALUE,      -- Load value
    -- Feedback Interface
	ENCODERCOUNT  => ENCODERCOUNT,    -- Encoder Counter Value
	HOME          => HOME,            -- Home signal
	HOMED         => HOMED,           -- Homed signal
	UNDERFLOW     => UNDERFLOW,       -- Underflow occured
	OVERFLOW      => OVERFLOW,        -- Overflow occured
	LASTCOUNTDIR  => LASTCOUNTDIR     -- Direction of the last count pulse
	);


  -- invert polarity of the A/B/N Signals
  A_PULSE_POL_VAL <= '1' when INV_A_PULSE_POL = '0' else '0';
  B_DIR_POL_VAL   <= '1' when INV_B_DIR_POL   = '0' else '0';
  N_ZERO_POL_VAL  <= '1' when INV_N_ZERO_POL  = '0' else '0';


  -- fill INC_ENC_COUNT_VALUE
  INC_ENC_COUNT_VALUE_g: for I in 16 to 32 generate
    INC_ENC_COUNT_VALUE_16: if COUNT_BIT_WIDTH = 16 generate
	    INC_ENC_COUNT_VALUE(ENCODERCOUNT'range) <= ENCODERCOUNT;
	  end generate;

	  INC_ENC_COUNT_VALUE_32: if COUNT_BIT_WIDTH = 32 generate
	    INC_ENC_COUNT_VALUE(ENCODERCOUNT'range) <= ENCODERCOUNT;
	  end generate;
  end generate;


  TEST_p: process ( RST, CLK, CTRL_IF )
  begin
    -- asynchron reset
    if RST = '1' then
	  FB_IF(2)              <= ( others => '0' ); -- unused register
	  FB_IF(3)              <= ( others => '0' ); -- unused register
	  FB_IF(4)              <= ( others => '0' ); -- unused register
	  FB_IF(5)              <= ( others => '0' ); -- unused register
	  FB_IF(6)              <= ( others => '0' ); -- unused register
	  FB_IF(7)              <= ( others => '0' ); -- unused register

    -- no reset and rising edge on clk
    elsif rising_edge ( CLK ) then
		
      -- defaults
		FB_IF(2)              <= ( others => '0' ); -- unused register
	   FB_IF(3)              <= ( others => '0' ); -- unused register
	   FB_IF(4)              <= ( others => '0' ); -- unused register
	   FB_IF(5)              <= ( others => '0' ); -- unused register
	   FB_IF(6)              <= ( others => '0' ); -- unused register
	   FB_IF(7)              <= ( others => '0' ); -- unused register

       ------------------------------------
  	   -- fill feedback interface(FB_IF)  --
       ------------------------------------

	   -- fill feedback interface(FB_IF) diagnosis status register
		-- quality information of CPU_STOP
	    if ( CPU_STOP = '1' ) then DIAG_STAT_CPU_STOP <=  '1'; -- quality information of CPU_STOP is bad
	    else                       DIAG_STAT_CPU_STOP <=  '0'; -- quality information of CPU_STOP is good
	    end if;

	    -- quality information of L+ supply
	    if ( LP_QI_BAD = '1' ) then DIAG_STAT_LP_QI <=  '1'; -- quality information of L+ supply is bad
	    else                        DIAG_STAT_LP_QI <=  '0'; -- quality information of L+ supply is good
	    end if;

		-- quality information of digital process inputs (DIs)
		for I in DI_QI_BAD'range loop
		  if ( DI_QI_BAD(I) = '1' ) then DI_DIAG_STAT(I + 12) <=  '1'; -- quality information of digital process input (DI) is bad
		  else                           DI_DIAG_STAT(I + 12) <=  '0'; -- quality information of digital process input (DI) is good
		  end if;
		end loop;


	    -- fill feedback interface(FB_IF) DI & DQ status register
        -- DI status register
	    for I in DI'range loop
		  DI_STAT(I) <= DI_MSK(I); -- all DIs
	    end loop;
		 -- fill unused bits with '0'
       -- DI_STAT( DI_STAT'left downto DI_QUANTITY) <= ( others => '0' );

    end if;

  end process TEST_p;

end architecture TFL_FAST_USER_INC_ENC_a;
