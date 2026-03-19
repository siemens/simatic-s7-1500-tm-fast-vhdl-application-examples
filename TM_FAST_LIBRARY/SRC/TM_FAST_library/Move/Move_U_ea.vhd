----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    Move_U_e - Move_U_a
-- Description:    Move a 8bit byte to another 8bit location(combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity Move_U_e is
    generic (
        IN_LENGTH : positive
        );
    Port (
        IN1  : in  STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 );
        OUT1 : out STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 )
         );
end Move_U_e;

architecture Move_U_a of Move_U_e is

begin

    OUT1 <= IN1;

end Move_U_a;

