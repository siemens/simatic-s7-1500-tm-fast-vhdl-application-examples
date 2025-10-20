----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    WordLogic_DW_U_e - WordLogic_DW_U_a
-- Description:    The WordLogic operation performs a word or double word based
--                 AND, OR, or XOR operation(combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity WordLogic_DW_U_e is
    generic (
        MODE : string := "WAND"
    );
    Port (
        IN1  : in  STD_LOGIC_VECTOR ( 31 downto 0);
        IN2  : in  STD_LOGIC_VECTOR ( 31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR ( 31 downto 0)
    );
end WordLogic_DW_U_e;

architecture WordLogic_DW_U_a of WordLogic_DW_U_e is

begin

   OUT1 <= IN1 and IN2 when (MODE = "WAND") else
           IN1  or IN2 when (MODE = "WOR")  else
           IN1 xor IN2 when (MODE = "WXOR") else
           ( others => '0' );
 

end WordLogic_DW_U_a;

