----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    Move_e - Move_a
-- Description:    Move a 8bit byte to another 8bit location.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity Move_e is
    generic (
        IN_LENGTH : positive
        );
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 );
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 )
    );
end Move_e;

architecture Move_a of Move_e is

begin

    Move_p: process ( RST, CLK ) begin
        if ( RST = '1' ) then
            OUT1 <= ( others => '0' );
            ENO  <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                OUT1 <= ( others => '0' );
                ENO <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    OUT1 <= IN1;
                    ENO <= '1';
                else
                    ENO <= '0';
                end if;
            end if;
        end if;
    end process Move_p;

end Move_a;

