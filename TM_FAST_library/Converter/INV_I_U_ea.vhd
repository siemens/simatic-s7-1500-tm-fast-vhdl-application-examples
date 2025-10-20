-------------------------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    INV_I_U_e - INV_I_U_a
-- Description:    The INV_I_U performs a ones compliment on an integer input (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
-------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity INV_I_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end INV_I_U_e;

architecture INV_I_U_a of INV_I_U_e is

begin

   OUT1 <= IN1 xor x"FFFF";

end INV_I_U_a;

