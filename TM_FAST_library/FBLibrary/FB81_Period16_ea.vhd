----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB81_Period16_e - FB81_Period16_a
-- Description:    Period Measurement Counter 16-Bit
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB81_Period16_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC;
        VALID: out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB81_Period16_e;

architecture FB81_Period16_a of FB81_Period16_e is

    signal enabled : std_logic := '0';
    signal reset   : std_logic := '0';
    signal history : std_logic := '0';
    signal edge    : std_logic := '0';
    signal cntload : std_logic := '0';
    signal timeval : std_logic_vector(15 downto 0) := x"0000";
    signal overflow: std_logic := '0';
    signal edgelat1: std_logic := '0';

begin

    enabled <= CLKEN and EN;
    reset <= STOP or (CLKEN and not(EN));
    edge <= IN1 and CLKEN and EN and not(history);
    cntload <= edge or reset;

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

    P_EDGE_LATCH1: process ( RST, CLK )
    begin
        if (RST = '1') then
            edgelat1 <= '0';
        elsif rising_edge ( CLK ) then
            if (reset = '1' or overflow = '1') then
                edgelat1 <= '0';
            elsif (edge = '1') then
                edgelat1 <= '1';
            end if;
        end if;
    end process P_EDGE_LATCH1;

    P_EDGE_LATCH2: process ( RST, CLK )
    begin
        if (RST = '1') then
            VALID <= '0';
        elsif rising_edge ( CLK ) then
            if (reset = '1'  or overflow = '1') then
                VALID <= '0';
            elsif (edge = '1') then
                VALID <= edgelat1;
            end if;
        end if;
    end process P_EDGE_LATCH2;

    P_OUTLATCH: process ( RST, CLK )
    begin
        if (RST = '1') then
            OUT1 <= x"0000";
        elsif rising_edge ( CLK ) then
            if (reset = '1') then
                OUT1 <= x"0000";
            elsif (edge = '1') then
                OUT1 <= timeval;
            end if;
        end if;
    end process P_OUTLATCH;

    FB81_Period16_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            timeval <= x"0000";
            overflow <= '0';
        elsif rising_edge ( CLK ) then
            if (cntload = '1') then
                timeval <= x"0001";
                overflow <= '0';
            elsif (enabled = '1') then
                if (timeval = x"FFFF") then
                    timeval <= x"0000";
                    overflow <= '0';
                else
                    timeval <= timeval + 1;
                    if (timeval = x"FFFF") then
                        overflow <= '1';
                    else
                        overflow <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process FB81_Period16_p;

end FB81_Period16_a;

