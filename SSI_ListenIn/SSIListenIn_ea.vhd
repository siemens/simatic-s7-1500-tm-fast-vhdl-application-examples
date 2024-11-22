----------------------------------------------------------------------------------
-- Company:        Siemens Industry, Inc
-- Create Date:    16:47:58 10/12/2018 
-- Design Name:    SSIListening
-- Module Name:    SSIListenIn_e - SSIListenIn_a
-- Project Name:   TM FAST SSIListening
-- Description:    SSIListenIn logic
--
-- Revision: 
-- Revision 1.0 - File Created
-- Additional Comments: FRAME_OVERRUN is a set if there are more clocks than programmed or a frame error.
--        Data will be presented at the first SCAN after the clock times out.
--        Times out when a clock pulse is not received in 1.25x period of last.
--        Note: the firs clock period is timed against FE to allow a timeout for glitches.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity SSIListenIn_e is
        Generic (
            BIT_WIDTH   : integer;
			   SHIFT_DIR   : string;
		      SHIFT_COUNT : integer;
				CLOCKSEL    : integer;
            FRAME_WIDTH : integer
        );
    Port ( 
        RST          : in  STD_LOGIC;
        CLK          : in  STD_LOGIC;
        GRAY_BIN_N   : in  STD_LOGIC;
        SSICLOCK     : in  STD_LOGIC;
        SSI_DATA_IN  : in  STD_LOGIC;
        ENCODERCOUNT : out STD_LOGIC_VECTOR ((BIT_WIDTH - 1) downto 0);
        FRAME_OVERRUN: out STD_LOGIC;
        DATAAVAILABLE: out STD_LOGIC
    );
end SSIListenIn_e;

architecture SSIListenIn_a of SSIListenIn_e is
	 
	 
    component SSI_Input_e is
        Generic (
            BIT_WIDTH   : integer;
			   SHIFT_DIR   : string;
		      SHIFT_COUNT : integer;
				CLOCKSEL    : integer;
            FRAME_WIDTH : integer
        );
        Port (
            RST          : in  STD_LOGIC;
            CLK          : in  STD_LOGIC;
				LISTEN       : in  STD_LOGIC;
            GRAY_BIN_N   : in  STD_LOGIC;
            SSICLOCK     : in  STD_LOGIC;
            SSI_LATCH    : in  STD_LOGIC;
            SSI_DATA_IN  : in  STD_LOGIC;
            ENCODERCOUNT : out STD_LOGIC_VECTOR ((BIT_WIDTH - 1) downto 0);
			   DATAAVAILABLE: out STD_LOGIC;
			   FRAME_OVERRUN: out STD_LOGIC
				
        );
    end component;
    
begin
    

    SSIListenIn_m: SSI_Input_e
    generic map (
        BIT_WIDTH   => BIT_WIDTH,
		  SHIFT_DIR   => SHIFT_DIR,
		  SHIFT_COUNT => SHIFT_COUNT,
		  CLOCKSEL    => CLOCKSEL,
        FRAME_WIDTH => FRAME_WIDTH
    )
    port map (
        RST           => RST,
        CLK           => CLK,
		  LISTEN        => '1',
        GRAY_BIN_N    => GRAY_BIN_N,
        SSICLOCK      => SSICLOCK,
        SSI_LATCH     => '0',
        SSI_DATA_IN   => SSI_DATA_IN,
        ENCODERCOUNT  => ENCODERCOUNT,
		  DATAAVAILABLE => DATAAVAILABLE,
		  FRAME_OVERRUN => FRAME_OVERRUN
		  
    );
    
end SSIListenIn_a;

