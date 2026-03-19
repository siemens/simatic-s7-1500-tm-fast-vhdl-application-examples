----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    ShiftRotate_W_U_e - ShiftRotate_W_U_a
-- Description:    The ShiftRotate operation shift or rotate, right or left a word,
--                 integer, double word, or double integer by N bits (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ShiftRotate_W_U_e is
    generic (
        MODE : string := "SLW"
    );
    Port (
        IN1  : in  STD_LOGIC_VECTOR ( 15 downto 0);
        N    : in  STD_LOGIC_VECTOR ( 15 downto 0);
        OUT1 : out STD_LOGIC_VECTOR ( 15 downto 0)
    );
end ShiftRotate_W_U_e;

architecture ShiftRotate_W_U_a of ShiftRotate_W_U_e is

begin

   OUT1 <= std_logic_vector( shift_left(unsigned(IN1),   to_integer( unsigned( N ) ) ) ) when (MODE = "SLW") else
           std_logic_vector( shift_right(unsigned(IN1),  to_integer( unsigned( N ) ) ) ) when (MODE = "SRW") else
           std_logic_vector( shift_right(signed(IN1),    to_integer( unsigned( N ) ) ) ) when (MODE = "SRI") else
           std_logic_vector( rotate_left(unsigned(IN1),  to_integer( unsigned( N ) ) ) ) when (MODE = "RLW") else
           std_logic_vector( rotate_right(unsigned(IN1), to_integer( unsigned( N ) ) ) ) when (MODE = "RRW") else
           ( others => '0' );
    

end ShiftRotate_W_U_a;

