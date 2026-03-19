----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB120_CTUD32 - FB120_CTUD32_a
-- Description:    32bit count up/down timer.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB120_CTUD32_e is
    port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        CU   : in  STD_LOGIC;
        CD   : in  STD_LOGIC;
        R    : in  STD_LOGIC;
        LOAD : in  STD_LOGIC;
        PV   : in  STD_LOGIC_VECTOR (31 downto 0);
        QU   : out STD_LOGIC;
        QD   : out STD_LOGIC;
        CV   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB120_CTUD32_e;

architecture FB120_CTUD32_a of FB120_CTUD32_e is

    signal count: integer;
    signal LD   : STD_LOGIC;
    signal CLR  : STD_LOGIC;
    signal CD_Q : STD_LOGIC := '0';
    signal CU_Q : STD_LOGIC := '0';
    signal UP   : STD_LOGIC;
    signal DN   : STD_LOGIC;

begin

    DN <= '1' when (CLKEN = '1' and CD = '1' and CD_Q = '0') else '0';
    UP <= '1' when (CLKEN = '1' and CU = '1' and CU_Q = '0') else '0';
    LD <= '1' when (CLKEN = '1' and LOAD = '1') else '0';
    QD <= '1' when (count <= 0) else '0';
    QU <= '1' when (count >= conv_integer(signed(PV))) else '0';
    CV <= conv_std_logic_vector(count, CV'length);

    P_LATCH_CLR: process (RST, CLK)
    begin
        if (RST = '1') then
            CLR <= '0';
        elsif rising_edge(CLK) then
            if (CLKEN = '1') then
                CLR <= R;
            end if;
        end if;
    end process P_LATCH_CLR;

    P_LATCH_DN: process (RST, CLK)
    begin
        if (RST = '1') then
            CD_Q <= '0';
        elsif rising_edge(CLK) then
            if (CLKEN = '1') then
                if (CD = '1') then
                    CD_Q <= '1';
                else
                    CD_Q <= '0';
                end if;
            end if;
        end if;
    end process P_LATCH_DN;

    P_LATCH_UP: process (RST, CLK)
    begin
        if (RST = '1') then
            CU_Q <= '0';
        elsif rising_edge(CLK) then
            if (CLKEN = '1') then
                if (CU = '1') then
                    CU_Q <= '1';
                else
                    CU_Q <= '0';
                end if;
            end if;
        end if;
    end process P_LATCH_UP;

    P_CTUD32: process (RST, CLK)
    begin
        if (RST = '1') then
            count <= 0;
        elsif rising_edge(CLK) then
            if (CLR = '1') then
                count <= 0;
            elsif (EN = '1') then
                if (LD = '1') then
                    count <= conv_integer(signed(PV));
                elsif (UP = '1' and DN = '0') then
                    if (count = 2147483647) then
                        count <= count;
                    else
                        count <= count + 1;
                    end if;
                elsif (UP = '0' and DN = '1') then
                    if (count = -2147483648) then
                        count <= count;
                    else
                        count <= count - 1;
                    end if;
                else
                    count <= count;
                end if;
            end if;
        end if;
    end process P_CTUD32;

end FB120_CTUD32_a;