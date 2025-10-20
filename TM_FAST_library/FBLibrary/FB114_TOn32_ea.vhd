----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB114_TOn32_e - FB114_TOn32_a
-- Description:    Timer On-Delay 32bit
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB114_TOn32_e is
    Port (
        RST    : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        CLKEN  : in  STD_LOGIC;
        CLK100K: in  STD_LOGIC;
        STOP   : in  STD_LOGIC;
        IN1    : in  STD_LOGIC;
        PT     : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1   : out STD_LOGIC;
        ET     : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB114_TOn32_e;

architecture FB114_TOn32_a of FB114_TOn32_e is

    signal g_in     : std_logic;
    signal g_in_s   : std_logic;
    signal g_in_r   : std_logic;
    signal s1       : std_logic;
    signal s1_d     : std_logic;
    signal count    : std_logic_vector(31 downto 0) := x"00000000";
    signal count_en : std_logic;
    signal count_clr: std_logic;
    signal cmp_lt   : std_logic;

begin

    g_in_s    <= IN1 and CLKEN;
    g_in_r    <= not(IN1) and CLKEN;
    count_clr <= STOP or g_in_r;
    count_en  <= CLK100K and CLKEN and g_in and not(s1);
    s1_d      <= s1 or (g_in and not(cmp_lt));
    OUT1      <= s1_d;
    ET        <= count;


    P_PULSE_RST: process (RST, count_clr, CLK)
    begin
        if (RST = '1' or count_clr = '1') then
            s1 <= '0';
        elsif rising_edge(CLK) then
            s1 <= s1_d;
        end if;
    end process P_PULSE_RST;

    P_LATCH_IN: process (RST, CLK)
    begin
        if (RST = '1') then
            g_in <= '0';
        elsif rising_edge(CLK) then
            if (g_in_r = '1') then
                g_in <= '0';
            elsif (g_in_s = '1') then
                g_in <= '1';
            else
                g_in <= g_in;
            end if;
        end if;
    end process P_LATCH_IN;

    P_COUNT: process (RST, count_clr, CLK)
    begin
        if (RST = '1' or count_clr = '1') then
            count <= x"00000000";
            cmp_lt <= '1';
        elsif rising_edge(CLK) then
            if (count_en = '1') then
                if (count = x"FFFFFFFF") then
                    count <= x"00000000";
                else
                    count <= count + 1;
                    if ((count + 1) < PT) then
                      cmp_lt <= '1';
                   else
                      cmp_lt <= '0';
                   end if;
                end if;
            end if;
        end if;
    end process P_COUNT;


end FB114_TOn32_a;

