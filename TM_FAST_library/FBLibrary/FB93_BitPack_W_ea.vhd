----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB93_BitPack_W_e - FB93_BitPack_W_a
-- Description:    The BITPACK_W operation simply makes individual bits into a
--                 16 bit word.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB93_BitPack_W_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN0  : in  STD_LOGIC;
        IN1  : in  STD_LOGIC;
        IN2  : in  STD_LOGIC;
        IN3  : in  STD_LOGIC;
        IN4  : in  STD_LOGIC;
        IN5  : in  STD_LOGIC;
        IN6  : in  STD_LOGIC;
        IN7  : in  STD_LOGIC;
        IN8  : in  STD_LOGIC;
        IN9  : in  STD_LOGIC;
        IN10 : in  STD_LOGIC;
        IN11 : in  STD_LOGIC;
        IN12 : in  STD_LOGIC;
        IN13 : in  STD_LOGIC;
        IN14 : in  STD_LOGIC;
        IN15 : in  STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB93_BitPack_W_e;

architecture FB93_BitPack_W_a of FB93_BitPack_W_e is

    signal inp: std_logic_vector (15 downto 0);

begin

    inp(0)  <= IN0;
    inp(1)  <= IN1;
    inp(2)  <= IN2;
    inp(3)  <= IN3;
    inp(4)  <= IN4;
    inp(5)  <= IN5;
    inp(6)  <= IN6;
    inp(7)  <= IN7;
    inp(8)  <= IN8;
    inp(9)  <= IN9;
    inp(10) <= IN10;
    inp(11) <= IN11;
    inp(12) <= IN12;
    inp(13) <= IN13;
    inp(14) <= IN14;
    inp(15) <= IN15;

    FB93_BitPack_W_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= x"0000";
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                OUT1 <= x"0000";
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    OUT1 <= inp;
                end if;
            end if;
        end if;
    end process FB93_BitPack_W_p;

end FB93_BitPack_W_a;
