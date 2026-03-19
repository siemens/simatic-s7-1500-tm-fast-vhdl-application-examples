----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    PosEdge_e - PosEdge_a
-- Description:    Positive RLO edge detection.  Compare EN and M_BIT(stored value
--                 of EN) if positive edge detected, ENO is set.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity PosEdge_e is
    Port (
        RST  : in    STD_LOGIC;
        CLK  : in    STD_LOGIC;
        CLKEN: in    STD_LOGIC;
        STOP : in    STD_LOGIC;
        EN   : in    STD_LOGIC;
        M_BIT: inout STD_LOGIC;
        ENO  : inout STD_LOGIC
    );
end PosEdge_e;

architecture PosEdge_a of PosEdge_e is

begin

    PosEdge_p: process (RST, CLK)
    begin
        if ( RST = '1' ) then
            ENO <= '0';
            M_BIT <= '0';
        elsif rising_edge ( CLK ) then
            if ( STOP = '1' ) then
                ENO <= '0';
                M_BIT <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1' and M_BIT = '0') then
                    ENO <= '1';
                else
                    ENO <= '0';
                end if;
                M_BIT <= EN;
            end if;
        end if;
    end process PosEdge_p;

end PosEdge_a;

