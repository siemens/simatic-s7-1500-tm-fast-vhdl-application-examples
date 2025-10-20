----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB93_BitPack_W_U_e - FB93_BitPack_W_U_a
-- Description:    The BITPACK_W_U operation simply makes individual bits into a
--                 16 bit word (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB93_BitPack_W_U_e is
    Port (
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
end FB93_BitPack_W_U_e;

architecture FB93_BitPack_W_U_a of FB93_BitPack_W_U_e is
begin

    OUT1(0)  <= IN0;
    OUT1(1)  <= IN1;
    OUT1(2)  <= IN2;
    OUT1(3)  <= IN3;
    OUT1(4)  <= IN4;
    OUT1(5)  <= IN5;
    OUT1(6)  <= IN6;
    OUT1(7)  <= IN7;
    OUT1(8)  <= IN8;
    OUT1(9)  <= IN9;
    OUT1(10) <= IN10;
    OUT1(11) <= IN11;
    OUT1(12) <= IN12;
    OUT1(13) <= IN13;
    OUT1(14) <= IN14;
    OUT1(15) <= IN15;

end FB93_BitPack_W_U_a;
