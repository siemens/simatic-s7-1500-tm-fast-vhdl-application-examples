----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB112_BiScale_e - FB112_BiScale_a
-- Description:    BiScale function
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity FB112_BiScale_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        CIN  : in  STD_LOGIC;
        OUT1 : out STD_LOGIC
    );
end FB112_BiScale_e;

architecture FB112_BiScale_a of FB112_BiScale_e is

    signal Q1: STD_LOGIC;
    signal Q2: STD_LOGIC;
    signal Q3: STD_LOGIC;

begin

    BiScale_p: process (RST, CLK)
    begin
        if (RST = '1') then
            Q1   <= '0';
            Q2   <= '0';
            Q3   <= '0';
            OUT1 <= '0';
        elsif rising_edge(CLK) then
            if (EN = '1') then
                Q2 <= Q1;
                if (CLKEN = '1') then
                    Q1 <= CIN;
                end if;
                if (Q1 = '1' and Q2 = '0') then
                    if (Q3 = '0') then
                        Q3 <= '1';
                    else
                        Q3 <= '0';
                    end if;
                end if;
            end if;
            OUT1 <= Q3;
        end if;
    end process BiScale_p;

end FB112_BiScale_a;

