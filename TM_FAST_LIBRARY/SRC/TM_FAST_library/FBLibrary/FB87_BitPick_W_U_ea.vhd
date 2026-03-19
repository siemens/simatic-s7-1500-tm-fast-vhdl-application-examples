----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB87_BitPick_W_U_e - FB87_BitPick_W_a
-- Description:    The FB87_BitPick_W_U operation outputs a bit in a word specified by
--                 BITSELECT (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB87_BitPick_W_U_e is
    Port (
        IN1      : in  STD_LOGIC_VECTOR (15 downto 0);
        BITSELECT: in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1     : out STD_LOGIC
    );
end FB87_BitPick_W_U_e;

architecture FB87_BitPick_W_U_a of FB87_BitPick_W_U_e is
begin

    OUT1 <= IN1(to_integer(signed(BITSELECT))) when (to_integer(signed(BITSELECT)) < 16) and (to_integer(signed(BITSELECT)) >= 0) else
            '0';

end FB87_BitPick_W_U_a;
