----------------------------------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    INV_DI_U_e - INV_DI_U_a
-- Description:    The INV_DI_U performs a ones compliment on a double integer input (combinatorial logic)
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity INV_DI_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end INV_DI_U_e;

architecture INV_DI_U_a of INV_DI_U_e is

begin

    OUT1 <= IN1 xor x"FFFFFFFF";

end INV_DI_U_a;
