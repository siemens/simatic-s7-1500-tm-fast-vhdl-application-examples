----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB91_BitCast_W_U_e - FB91_BitCast_W_U_a
-- Description:    The BITCAST_W_U operation simply makes the bits of a bus available
--                 for use individually (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB91_BitCast_W_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        OUT0 : out STD_LOGIC;
        OUT1 : out STD_LOGIC;
        OUT2 : out STD_LOGIC;
        OUT3 : out STD_LOGIC;
        OUT4 : out STD_LOGIC;
        OUT5 : out STD_LOGIC;
        OUT6 : out STD_LOGIC;
        OUT7 : out STD_LOGIC;
        OUT8 : out STD_LOGIC;
        OUT9 : out STD_LOGIC;
        OUT10: out STD_LOGIC;
        OUT11: out STD_LOGIC;
        OUT12: out STD_LOGIC;
        OUT13: out STD_LOGIC;
        OUT14: out STD_LOGIC;
        OUT15: out STD_LOGIC
    );
end FB91_BitCast_W_U_e;

architecture FB91_BitCast_W_U_a of FB91_BitCast_W_U_e is
begin

    OUT0  <= IN1(0);
    OUT1  <= IN1(1);
    OUT2  <= IN1(2);
    OUT3  <= IN1(3);
    OUT4  <= IN1(4);
    OUT5  <= IN1(5);
    OUT6  <= IN1(6);
    OUT7  <= IN1(7);
    OUT8  <= IN1(8);
    OUT9  <= IN1(9);
    OUT10 <= IN1(10);
    OUT11 <= IN1(11);
    OUT12 <= IN1(12);
    OUT13 <= IN1(13);
    OUT14 <= IN1(14);
    OUT15 <= IN1(15);

end FB91_BitCast_W_U_a;
