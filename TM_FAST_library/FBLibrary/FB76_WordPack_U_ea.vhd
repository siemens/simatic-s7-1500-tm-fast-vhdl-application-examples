----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB76_WordPack_U_e - FB76_WordPack_U_a
-- Description:    The WORDPACK operation creates a 32bit double word by concatenating
--                 two separate 16 bit words (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB76_WordPack_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        IN2  : in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB76_WordPack_U_e;

architecture FB76_WordPack_U_a of FB76_WordPack_U_e is

begin

        OUT1(31 downto 16) <= IN1;
        OUT1(15 downto 0)  <= IN2;

end FB76_WordPack_U_a;
