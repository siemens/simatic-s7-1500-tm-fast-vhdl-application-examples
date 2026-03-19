----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    SR_FF_e - SR_FF_a
-- Description:    SET-RESET Flip Flop
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity SR_FF_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        R    : in  STD_LOGIC;
        S    : in  STD_LOGIC;
        Q    : out STD_LOGIC
    );
end SR_FF_e;

architecture SR_FF_a of SR_FF_e is

begin

    SR_FF_p: process ( RST, CLK )
     begin
        if ( RST = '1') then
            Q <= '0';
        elsif rising_edge ( CLK ) then
            if ( STOP = '1' ) then
                Q <= '0';
            elsif (CLKEN = '1') then
                if (R = '1') then
                    Q <= '0';
                elsif (S = '1') then
                    Q <= '1';
                end if;
            end if;
        end if;
    end process SR_FF_p;

end SR_FF_a;

