----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    NegSignalEdge_e - NegSignalEdge_a
-- Description:    NEG (Address Negative Edge Detection) If M_Bit1 is compared to
--                 M_Bit2 (stored previous signal) detects a falling edge, set Q.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity NegSignalEdge_e is
    Port (
        RST  : in    STD_LOGIC;
        CLK  : in    STD_LOGIC;
        CLKEN: in    STD_LOGIC;
        STOP : in    STD_LOGIC;
        EN   : in    STD_LOGIC;
        EDGE : in    STD_LOGIC;
        M_BIT: inout STD_LOGIC;
        Q    : inout STD_LOGIC
    );
end NegSignalEdge_e;

architecture NegSignalEdge_a of NegSignalEdge_e is

begin

    NegSignalEdge_p:    process (RST, CLK)
    begin
        if (RST = '1') then
            Q <= '0';
            M_BIT <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q <= '0';
                M_BIT <= '0';
            elsif (CLKEN = '1' and EN = '1') then
                if (EDGE = '0' and M_BIT = '1') then
                    Q <= '1';
                else
                    Q <= '0';
                end if;
                M_BIT <= EDGE;
            end if;
        end if;
    end process NegSignalEdge_p;

end NegSignalEdge_a;