----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    INV_DI_e - INV_DI_a
-- Description:    The INV_DI performs a ones compliment on a double integer input.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity INV_DI_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end INV_DI_e;

architecture INV_DI_a of INV_DI_e is

begin

    INV_DI_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            OUT1 <= x"00000000";
            ENO  <= '0';
        elsif rising_edge ( CLK ) then
            if ( STOP = '1' ) then
                OUT1 <= x"00000000";
                ENO  <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    OUT1 <= IN1 xor x"FFFFFFFF";
                    ENO  <= '1';
                else
                    ENO  <= '0';
                end if;
            end if;
        end if;
    end process INV_DI_p;

end INV_DI_a;
