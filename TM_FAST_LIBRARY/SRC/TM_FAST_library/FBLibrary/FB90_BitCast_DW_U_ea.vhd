----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB90_BitCast_DW_U_e - FB90_BitCast_DW_U_a
-- Description:    The BITCAST_DW_U operation simply makes the bits of a bus available
--                 for use individually (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB90_BitCast_DW_U_e is
    Port (
        IN1   : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT0  : out STD_LOGIC;
        OUT1  : out STD_LOGIC;
        OUT2  : out STD_LOGIC;
        OUT3  : out STD_LOGIC;
        OUT4  : out STD_LOGIC;
        OUT5  : out STD_LOGIC;
        OUT6  : out STD_LOGIC;
        OUT7  : out STD_LOGIC;
        OUT8  : out STD_LOGIC;
        OUT9  : out STD_LOGIC;
        OUT10 : out STD_LOGIC;
        OUT11 : out STD_LOGIC;
        OUT12 : out STD_LOGIC;
        OUT13 : out STD_LOGIC;
        OUT14 : out STD_LOGIC;
        OUT15 : out STD_LOGIC;
        OUT16 : out STD_LOGIC;
        OUT17 : out STD_LOGIC;
        OUT18 : out STD_LOGIC;
        OUT19 : out STD_LOGIC;
        OUT20 : out STD_LOGIC;
        OUT21 : out STD_LOGIC;
        OUT22 : out STD_LOGIC;
        OUT23 : out STD_LOGIC;
        OUT24 : out STD_LOGIC;
        OUT25 : out STD_LOGIC;
        OUT26 : out STD_LOGIC;
        OUT27 : out STD_LOGIC;
        OUT28 : out STD_LOGIC;
        OUT29 : out STD_LOGIC;
        OUT30 : out STD_LOGIC;
        OUT31 : out STD_LOGIC
    );
end FB90_BitCast_DW_U_e;

architecture FB90_BitCast_DW_U_a of FB90_BitCast_DW_U_e is
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
    OUT16 <= IN1(16);
    OUT17 <= IN1(17);
    OUT18 <= IN1(18);
    OUT19 <= IN1(19);
    OUT20 <= IN1(20);
    OUT21 <= IN1(21);
    OUT22 <= IN1(22);
    OUT23 <= IN1(23);
    OUT24 <= IN1(24);
    OUT25 <= IN1(25);
    OUT26 <= IN1(26);
    OUT27 <= IN1(27);
    OUT28 <= IN1(28);
    OUT29 <= IN1(29);
    OUT30 <= IN1(30);
    OUT31 <= IN1(31);

end FB90_BitCast_DW_U_a;
