----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    RS_FF_e - RS_FF_a
-- Description:    Reset-Set Flip Flop
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RS_FF_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        R    : in  STD_LOGIC;
        S    : in  STD_LOGIC;
        Q    : out STD_LOGIC
    );
end RS_FF_e;

architecture RS_FF_a of RS_FF_e is

begin

    RS_FF_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            Q <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q <= '0';
            elsif (CLKEN = '1') then
                if (S = '1') then
                    Q <= '1';
                elsif (R = '1') then
                    Q <= '0';
                end if;
            end if;
        end if;
    end process RS_FF_p;

end RS_FF_a;

