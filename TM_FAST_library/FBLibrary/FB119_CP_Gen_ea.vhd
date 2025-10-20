----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB119_CP_Gen - FB119_CP_Gen_a
-- Description:    The clock pulse generator (FB119) allows you to output a pulse
--                 at a specified frequency from less than 1 Hz to a maximum of 50 kHz.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB119_CP_Gen_e is
    port ( 
        RST    : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        CLK100k: in  STD_LOGIC;
        ENABLE : in  STD_LOGIC;
        PERIOD : in  STD_LOGIC_VECTOR (15 downto 0);
        Q      : out STD_LOGIC
    );
end FB119_CP_Gen_e;

architecture FB119_CP_Gen_a of FB119_CP_Gen_e is

    signal count       : std_logic_vector(15 downto 0);
    signal pulse       : STD_LOGIC:= '0';
    signal clk100k_edge: std_logic;
    signal clk100k_old : std_logic;

begin

    Q <= pulse;

    P_100K_EDGE: process (RST, CLK) 
    begin
        if (RST = '1') then
            clk100k_old <= '0';
            clk100k_edge <= '0';
        elsif rising_edge( CLK ) then
            if (CLK100K = '1') and (clk100k_old = '0') then
                clk100k_edge <= '1';
            else
                clk100k_edge <= '0';
            end if;
            clk100k_old <= CLK100K;
        end if;
    end process P_100K_EDGE;
    

    FB119_CP_Gen_p: process (RST, CLK)
    begin
        if (RST = '1') then
            pulse <= '0';
            count <= (others => '0');
        elsif rising_edge(CLK) then
            if (ENABLE = '1') then
                if (clk100k_edge = '1') then
                    count <= count - 1;
                    if (count = x"0000") then
                        pulse <= not(pulse);
                        count <= (PERIOD - 1);
                    end if;
                end if;
            else
                pulse <= '0';
                count <= (PERIOD - 1);
            end if;
        end if;
    end process FB119_CP_Gen_p;


 end FB119_CP_Gen_a;