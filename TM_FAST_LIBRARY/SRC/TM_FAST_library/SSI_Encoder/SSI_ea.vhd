----------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST_FPGA
-- Module Name:    SSI_e - SSI_a
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity SSI_e is
    Generic (
        BIT_WIDTH   : integer range 10 to 64 := 13;
        MONOFLOPSEL : integer range  0 to 3  :=  0;
        CLOCKSEL    : integer range  0 to 3  :=  0;
        SHIFT_DIR   : string                 := "right";
        SHIFT_COUNT : integer range  0 to 64 :=  0;
        FRAME_WIDTH : integer range 10 to 64 := 13
    );
    Port (
        RST          : in  STD_LOGIC;
        CLK          : in  STD_LOGIC;
        GRAY_BIN_N   : in  STD_LOGIC;
        SSI_DATA_IN  : in  STD_LOGIC;
        ENCODERCOUNT : out STD_LOGIC_VECTOR ( (BIT_WIDTH - 1) downto 0 );
        SSI_CLOCK    : out STD_LOGIC;
        DATAAVAILABLE: out STD_LOGIC;
        FRAME_OVERRUN: out STD_LOGIC
    );
end SSI_e;

architecture SSI_a of SSI_e is

    component SSI_ClockOut_e is
        Generic (
            BIT_WIDTH   : integer;
            MONOFLOPSEL : integer;
            CLOCKSEL    : integer;
            FRAME_WIDTH : integer
        );
        Port (
            RST        : in  STD_LOGIC;
            CLK        : in  STD_LOGIC;
            SSICLOCK   : out STD_LOGIC;
            SSI_LATCH  : out STD_LOGIC
        );
    end component;

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

     signal SSI_CLOCK_INPUT : STD_LOGIC;
     signal SSI_LATCH_SIGNAL: STD_LOGIC;

begin


  -- check if BIT_WIDTH >= FRAME_WIDTH
  assert BIT_WIDTH >= FRAME_WIDTH
  report " TFL_FAST_USER_LIB: SSI_ENCODER: BIT_WIDTH should be greater than or equal to the FRAME_WIDTH!"
  severity failure;




   SSI_CLOCK <= SSI_CLOCK_INPUT;

    SSIClockOut_m: SSI_ClockOut_e
    generic map (
        BIT_WIDTH   => BIT_WIDTH,
        MONOFLOPSEL => MONOFLOPSEL,
        CLOCKSEL    => CLOCKSEL,
        FRAME_WIDTH => FRAME_WIDTH
    )
    port map (
        RST         => RST,
        CLK         => CLK,
        SSICLOCK    => SSI_CLOCK_INPUT,
        SSI_LATCH   => SSI_LATCH_SIGNAL
    );

    SSIInput_m: SSI_Input_e
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
        GRAY_BIN_N    => GRAY_BIN_N,
        SSICLOCK      => SSI_CLOCK_INPUT,
        SSI_LATCH     => SSI_LATCH_SIGNAL,
        SSI_DATA_IN   => SSI_DATA_IN,
        ENCODERCOUNT  => ENCODERCOUNT,
        DATAAVAILABLE => DATAAVAILABLE,
        FRAME_OVERRUN => FRAME_OVERRUN,
        LISTEN        => '0'
    );

end SSI_a;

