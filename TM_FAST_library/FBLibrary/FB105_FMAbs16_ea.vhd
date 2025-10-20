----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB105_FMAbs16_e - FB105_FMAbs16_a
-- Description:    The ABS operation writes the absolute value of the number
--                 supplied at the IN input to the OUT output. The absolute
--                 value of a number is the number without its sign.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB105_FMAbs16_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB105_FMAbs16_e;

architecture FB105_FMAbs16_a of FB105_FMAbs16_e is

begin

    abs16_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= x"0000";
        elsif rising_edge(CLK) then
            if (CLKEN = '1') then
                OUT1 <= std_logic_vector(abs(signed(IN1)));
            end if;
        end if;
    end process abs16_p;

end FB105_FMAbs16_a;

