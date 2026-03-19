----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB86_BitPick_DW_U_e - FB86_BitPick_DW_U_a
-- Description:    The BITPICK_DW operation outputs a bit in a double word specified
--                 by BITSELECT(combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB86_BitPick_DW_U_e is
    Port (
        IN1      : in  STD_LOGIC_VECTOR (31 downto 0);
        BITSELECT: in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1     : out STD_LOGIC
    );
end FB86_BitPick_DW_U_e;

architecture FB86_BitPick_DW_U_a of FB86_BitPick_DW_U_e is
begin
    
    OUT1 <= IN1(to_integer(signed(BITSELECT))) when (to_integer(signed(BITSELECT)) < 32) and (to_integer(signed(BITSELECT)) >= 0) else
            '0';

end FB86_BitPick_DW_U_a;
