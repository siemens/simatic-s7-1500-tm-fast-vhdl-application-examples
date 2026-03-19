----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB109_FMSub16_e - FB109_FMSub16_a
-- Description:    FMSub subtracts the value at the IN_B input from the value at the
--                 IN_A input and writes the result to the OUT output. The OVF output
--                 is set to logic "1" if an overflow occurs; otherwise, it is logic
--                 "0".
--                 If 2 Two's Complement numbers are subtracted, and their signs are
--                 different, then overflow occurs if and only if the result has the
--                 same sign as the subtrahend.
--                 Overflow occurs if
--                 (+A) - (-B) = -C
--                 (-A) - (+B) = +C
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity FB109_FMSub16_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        IN2  : in  STD_LOGIC_VECTOR (15 downto 0);
        OVF  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB109_FMSub16_e;

architecture FB109_FMSub16_a of FB109_FMSub16_e is

    component ADSU_e
        generic (
            data_width : natural
        );
        port (
            rst     : in  std_logic;
            clk     : in  std_logic;
            enable  : in  std_logic;
            add_sub : in  std_logic;
            dataa   : in  std_logic_vector ((data_width - 1) downto 0);
            datab   : in  std_logic_vector ((data_width - 1) downto 0);
            overflow: out std_logic;
            result  : out std_logic_vector ((data_width - 1) downto 0)
        );
    end component;


begin

    M_ADSU : ADSU_e
        generic map (
            data_width => 16
        )
        port map (
            rst      => RST,
            clk      => CLK,
            enable   => CLKEN,
            add_sub  => '0',
            dataa    => IN1,
            datab    => IN2,
            overflow => OVF,
            result   => OUT1
        );

end FB109_FMSub16_a;

