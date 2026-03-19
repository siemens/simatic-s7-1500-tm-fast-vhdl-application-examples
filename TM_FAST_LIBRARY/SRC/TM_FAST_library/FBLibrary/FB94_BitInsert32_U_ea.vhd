------------------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB94_BitInsert32_U_e - FB94_BitInsert32_U_a
-- Description:    The BITINSERT32 operation changes a bit in a double word to the
--                 BIT_IN value at the location specified by SEL_IN (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB94_BitInsert32_U_e is
    Port (
        IN1   : in  STD_LOGIC_VECTOR (31 downto 0);
        SEL_IN: in  STD_LOGIC_VECTOR (15 downto 0);
        BIT_IN: in  STD_LOGIC;
        OUT1  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB94_BitInsert32_U_e;

architecture FB94_BitInsert32_U_a of FB94_BitInsert32_U_e is
begin

    OUT1( 0) <= BIT_IN when to_integer(signed(SEL_IN)) = 0 else IN1(0);
    OUT1( 1) <= BIT_IN when to_integer(signed(SEL_IN)) = 1 else IN1(1);
    OUT1( 2) <= BIT_IN when to_integer(signed(SEL_IN)) = 2 else IN1(2);
    OUT1( 3) <= BIT_IN when to_integer(signed(SEL_IN)) = 3 else IN1(3);
    OUT1( 4) <= BIT_IN when to_integer(signed(SEL_IN)) = 4 else IN1(4);
    OUT1( 5) <= BIT_IN when to_integer(signed(SEL_IN)) = 5 else IN1(5);
    OUT1( 6) <= BIT_IN when to_integer(signed(SEL_IN)) = 6 else IN1(6); 
    OUT1( 7) <= BIT_IN when to_integer(signed(SEL_IN)) = 7 else IN1(7);

    OUT1( 8) <= BIT_IN when to_integer(signed(SEL_IN)) =  8 else IN1( 8);
    OUT1( 9) <= BIT_IN when to_integer(signed(SEL_IN)) =  9 else IN1( 9);
    OUT1(10) <= BIT_IN when to_integer(signed(SEL_IN)) = 10 else IN1(10);
    OUT1(11) <= BIT_IN when to_integer(signed(SEL_IN)) = 11 else IN1(11);
    OUT1(12) <= BIT_IN when to_integer(signed(SEL_IN)) = 12 else IN1(12);
    OUT1(13) <= BIT_IN when to_integer(signed(SEL_IN)) = 13 else IN1(13);
    OUT1(14) <= BIT_IN when to_integer(signed(SEL_IN)) = 14 else IN1(14);   
    OUT1(15) <= BIT_IN when to_integer(signed(SEL_IN)) = 15 else IN1(15);

    OUT1(16) <= BIT_IN when to_integer(signed(SEL_IN)) = 16 else IN1(16);
    OUT1(17) <= BIT_IN when to_integer(signed(SEL_IN)) = 17 else IN1(17);
    OUT1(18) <= BIT_IN when to_integer(signed(SEL_IN)) = 18 else IN1(18);
    OUT1(19) <= BIT_IN when to_integer(signed(SEL_IN)) = 19 else IN1(19);
    OUT1(20) <= BIT_IN when to_integer(signed(SEL_IN)) = 20 else IN1(20);
    OUT1(21) <= BIT_IN when to_integer(signed(SEL_IN)) = 21 else IN1(21);
    OUT1(22) <= BIT_IN when to_integer(signed(SEL_IN)) = 22 else IN1(22);   
    OUT1(23) <= BIT_IN when to_integer(signed(SEL_IN)) = 23 else IN1(23);

    OUT1(24) <= BIT_IN when to_integer(signed(SEL_IN)) = 24 else IN1(24);
    OUT1(25) <= BIT_IN when to_integer(signed(SEL_IN)) = 25 else IN1(25);
    OUT1(26) <= BIT_IN when to_integer(signed(SEL_IN)) = 26 else IN1(26);
    OUT1(27) <= BIT_IN when to_integer(signed(SEL_IN)) = 27 else IN1(27);
    OUT1(28) <= BIT_IN when to_integer(signed(SEL_IN)) = 28 else IN1(28);
    OUT1(29) <= BIT_IN when to_integer(signed(SEL_IN)) = 29 else IN1(29);
    OUT1(30) <= BIT_IN when to_integer(signed(SEL_IN)) = 30 else IN1(30);   
    OUT1(31) <= BIT_IN when to_integer(signed(SEL_IN)) = 31 else IN1(31);

end FB94_BitInsert32_U_a;
