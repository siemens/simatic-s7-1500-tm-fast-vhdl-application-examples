----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB115_TOf32_e - FB115_TOf32_a
-- Description:    Timer Off-Delay 32bit
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB115_TOf32_e is
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
end FB115_TOf32_e;

architecture FB115_TOf32_a of FB115_TOf32_e is

    signal g_in     : std_logic;
    signal g_in_s   : std_logic;
    signal g_in_r   : std_logic;
    signal s1       : std_logic;
    signal s1_d     : std_logic;
    signal count    : std_logic_vector (31 downto 0) := x"00000000";
    signal count_en : std_logic;
    signal count_clr: std_logic;
    signal cmp_lt   : std_logic;
    signal out_q    : std_logic;
    signal out_d    : std_logic;
    signal out_r    : std_logic;

begin

    g_in_s    <= IN1 and CLKEN;
    g_in_r    <= not(IN1) and CLKEN;
    count_clr <= STOP or g_in;
    count_en  <= out_q and CLK100K and CLKEN and not(g_in) and not(s1);
    s1_d      <= s1 or not(cmp_lt);
    out_d     <= out_q or g_in;
    out_r     <= not(g_in) and not(cmp_lt) and not(s1);
    OUT1      <= out_q;
    ET        <= count;

    P_LATCH_IN: process (RST, CLK)
    begin
        if (RST = '1') then
            g_in <= '0';
        elsif rising_edge(CLK) then
            if (g_in_r = '1') then
                g_in <= '0';
            elsif (g_in_s = '1') then
                g_in <= '1';
            end if;
        end if;
    end process P_LATCH_IN;

    P_OUT: process (RST, out_r, CLK) begin
        if (RST = '1' or out_r = '1') then
            out_q <= '0';
        elsif rising_edge(CLK) then
            out_q <= out_d;
        end if;
    end process P_OUT;

    P_PULSE_RST: process (RST, count_clr, CLK)
    begin
        if (RST = '1' or count_clr = '1') then
            s1 <= '0';
        elsif rising_edge(CLK) then
            s1 <= s1_d;
        end if;
    end process P_PULSE_RST;

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


end FB115_TOf32_a;

