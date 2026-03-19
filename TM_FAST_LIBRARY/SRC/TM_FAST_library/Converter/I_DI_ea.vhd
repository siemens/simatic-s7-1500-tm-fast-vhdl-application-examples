----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    I_DI_e - I_DI_a
-- Description:    Convert from 16 bit integer to a 32 bit integer.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity I_DI_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end I_DI_e;

architecture I_DI_a of I_DI_e is

begin

    I_DI_p: process ( RST, CLK, STOP, CLKEN, EN)
    begin
        if ( RST = '1' ) then
            OUT1 <= x"00000000";
            ENO  <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                OUT1 <= x"00000000";
                ENO  <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    OUT1 <= (0 => IN1(0),
                        1      => IN1(1),
                        2      => IN1(2),
                        3      => IN1(3),
                        4      => IN1(4),
                        5      => IN1(5),
                        6      => IN1(6),
                        7      => IN1(7),
                        8      => IN1(8),
                        9      => IN1(9),
                        10     => IN1(10),
                        11     => IN1(11),
                        12     => IN1(12),
                        13     => IN1(13),
                        14     => IN1(14),
                        others => IN1(15)
                    );
                    ENO <= '1';
                else
                    ENO <= '0';
                end if;
            end if;
        end if;
    end process I_DI_p;

end I_DI_a;

