----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB77_WordCast_U_e - FB77_WordCast_U_a
-- Description:    The WORDCAST operation creates two separate 16 bit words from a
--                 single 32bit double word(combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB77_WordCast_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0);
        OUT2 : out STD_LOGIC_VECTOR (15 downto 0) );
end FB77_WordCast_U_e;

architecture FB77_WordCast_U_a of FB77_WordCast_U_e is

begin

    OUT1 <= IN1(31 downto 16);
    OUT2 <= IN1(15 downto 0);

end FB77_WordCast_U_a;
