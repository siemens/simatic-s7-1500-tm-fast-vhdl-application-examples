----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB92_BitPack_DW_e - FB92_BitPack_DW_a
-- Description:    The BITPACK_DW operation simply makes individual bits into a
--                 32 bit DWord.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity FB92_BitPack_DW_e is
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
        IN16 : in  STD_LOGIC;
        IN17 : in  STD_LOGIC;
        IN18 : in  STD_LOGIC;
        IN19 : in  STD_LOGIC;
        IN20 : in  STD_LOGIC;
        IN21 : in  STD_LOGIC;
        IN22 : in  STD_LOGIC;
        IN23 : in  STD_LOGIC;
        IN24 : in  STD_LOGIC;
        IN25 : in  STD_LOGIC;
        IN26 : in  STD_LOGIC;
        IN27 : in  STD_LOGIC;
        IN28 : in  STD_LOGIC;
        IN29 : in  STD_LOGIC;
        IN30 : in  STD_LOGIC;
        IN31 : in  STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB92_BitPack_DW_e;

architecture FB92_BitPack_DW_a of FB92_BitPack_DW_e is

    signal inp: std_logic_vector (31 downto 0);

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
    inp(16) <= IN16;
    inp(17) <= IN17;
    inp(18) <= IN18;
    inp(19) <= IN19;
    inp(20) <= IN20;
    inp(21) <= IN21;
    inp(22) <= IN22;
    inp(23) <= IN23;
    inp(24) <= IN24;
    inp(25) <= IN25;
    inp(26) <= IN26;
    inp(27) <= IN27;
    inp(28) <= IN28;
    inp(29) <= IN29;
    inp(30) <= IN30;
    inp(31) <= IN31;

    FB92_BitPack_DW_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= x"00000000";
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                OUT1 <= x"00000000";
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    OUT1 <= inp;
                end if;
            end if;
        end if;
    end process FB92_BitPack_DW_p;

end FB92_BitPack_DW_a;
