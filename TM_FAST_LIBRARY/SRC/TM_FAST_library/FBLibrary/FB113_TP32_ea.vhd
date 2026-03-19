----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB113_TP32_e - FB113_TP32_a
-- Description:    Timer Pulse 32bit
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB113_TP32_e is
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
end FB113_TP32_e;

architecture FB113_TP32_a of FB113_TP32_e is

    signal g_in      : std_logic;
    signal g_in_s    : std_logic;
    signal g_in_r    : std_logic;
    signal s1        : std_logic;
    signal s1_d      : std_logic;
    signal enable    : std_logic;
    signal enable_clr: std_logic;
    signal count     : std_logic_vector(31 downto 0) := x"00000000";
    signal count_en  : std_logic;
    signal count_clr : std_logic;
    signal cmp_lt    : std_logic;

begin

    g_in_s     <= IN1 and CLKEN and not(STOP);
    g_in_r     <= STOP or (not(IN1) and CLKEN);
    enable_clr <= STOP or s1;
    count_clr  <= STOP or (s1 and not(g_in));
    count_en   <= enable and CLK100K and CLKEN;
    s1_d       <= s1 or (enable and not(cmp_lt));
    OUT1       <= enable and cmp_lt;
    ET         <= count;

     P_PULSE_RST: process (RST, count_clr, CLK)
     begin
         if (RST = '1' or count_clr = '1') then
             s1 <= '0';
         elsif rising_edge(CLK) then
             s1 <= s1_d;
         end if;
     end process P_PULSE_RST;

    P_ENABLE: process (RST, enable_clr, CLK)
     begin
        if (RST = '1' or enable_clr = '1') then
            enable <= '0';
        elsif rising_edge(CLK) then
              if (g_in ='1') then
                    enable <= '1';
                end if;
        end if;
    end process P_ENABLE;

    P_LATCH_IN:
    process (RST, CLK) begin
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


end FB113_TP32_a;

