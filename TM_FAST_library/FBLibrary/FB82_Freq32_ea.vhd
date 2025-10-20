----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB82_Freq32_e - FB82_Freq32_a
-- Description:    Frequency Measurement Counter 32-Bit
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity FB82_Freq32_e is
    Port (
        RST   : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        CLKEN : in  STD_LOGIC;
        STOP  : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        IN1   : in  STD_LOGIC;
        PERIOD: in  STD_LOGIC_VECTOR (31 downto 0);
        VALID : out STD_LOGIC;
        OUT1  : out STD_LOGIC_VECTOR (31 downto 0)
         );
end FB82_Freq32_e;

architecture FB82_Freq32_a of FB82_Freq32_e is

    signal freqcnt    : std_logic_vector(31 downto 0) := x"00000000";
    signal timecnt    : std_logic_vector(31 downto 0) := x"00000000";
    signal reset      : std_logic;
    signal enabled    : std_logic;
    signal history    : std_logic;
    signal edge       : std_logic;
    signal count_clear: std_logic;
    signal time_reset : std_logic;
    signal time_load  : std_logic;
    signal timed_out  : std_logic;
    signal to_lat1    : std_logic;
    signal en_lat     : std_logic;

begin

    enabled   <= CLKEN and EN;
    --reset <= STOP or (CLKEN and not(EN));
    reset     <= STOP or not(en_lat);
    edge      <= IN1 and CLKEN and EN and not(history);
    time_load <= timed_out and EN;

    P_EN_LAT: process ( RST, CLK )
    begin
        if (RST = '1') then
            en_lat <= '0';
        elsif rising_edge ( CLK ) then
            if (CLKEN = '1') then
                en_lat <= EN;
            end if;
        end if;
    end process P_EN_LAT;

    P_TO_LAT2: process ( RST, CLK )
    begin
        if (RST = '1') then
            VALID <= '0';
        elsif rising_edge ( CLK ) then
            if (reset = '1') then
                VALID <= '0';
            elsif (timed_out = '1') then
                VALID <= to_lat1;
            end if;
        end if;
    end process P_TO_LAT2;

    P_TO_LAT1: process ( RST, CLK )
    begin
        if (RST = '1') then
            to_lat1 <= '0';
        elsif rising_edge ( CLK ) then
            if (reset = '1') then
                to_lat1 <= '0';
            elsif (timed_out = '1') then
                to_lat1 <= '1';
            end if;
        end if;
    end process P_TO_LAT1;

    P_FREQ_LAT: process ( RST, CLK )
    begin
        if (RST = '1') then
            OUT1 <= x"00000000";
        elsif rising_edge ( CLK ) then
            if (reset = '1') then
                OUT1 <= x"00000000";
            elsif (timed_out = '1') then
                OUT1 <= freqcnt;
            end if;
        end if;
    end process P_FREQ_LAT;

    P_FCOUNT: process ( RST, CLK )
    begin
        if (RST = '1') then
            freqcnt <= x"00000000";
        elsif rising_edge ( CLK ) then
            if (count_clear = '1') then
                freqcnt <= x"00000000";
            elsif (edge = '1') then
                if (freqcnt = x"FFFFFFFF") then
                    freqcnt <= x"00000000";
                else
                    freqcnt <= freqcnt + 1;
                end if;
            end if;
        end if;
    end process P_FCOUNT;

    P_PERCNTDN: process ( RST, time_reset, CLK )
    begin
        if (RST = '1' or time_reset = '1') then
            timecnt <= x"00000000";
            timed_out <= '0';
        elsif rising_edge ( CLK ) then
            if (time_load = '1') then
                timecnt <= PERIOD;
                count_clear <= '1';
            elsif (enabled = '1') then
                timecnt <= timecnt - 1;
                count_clear <= '0';
            end if;
            if (timecnt = x"00000000") then
                timed_out <= '1';
            else
                timed_out <= '0';
            end if;
        end if;
    end process P_PERCNTDN;

    P_TIMERST: process (CLK)
    begin
        if rising_edge ( CLK ) then
            time_reset <= reset;
        end if;
    end process P_TIMERST;

    P_EDGE: process ( RST, CLK )
    begin
        if (RST = '1') then
            history <= '0';
        elsif rising_edge ( CLK ) then
            if (reset = '1') then
                history <= '0';
            elsif (enabled = '1') then
                history <= IN1;
            end if;
        end if;
    end process P_EDGE;

end FB82_Freq32_a;

