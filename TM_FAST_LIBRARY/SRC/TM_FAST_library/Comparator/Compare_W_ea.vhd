----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    Compare_W_e - Compare_W_a
-- Description:    16bit Compare (A is equal to B)
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Compare_W_e is
	generic (
		    MODE : string := "EQ"
	);

	port (
            RST  : in  STD_LOGIC;
            CLK  : in  STD_LOGIC;
            CLKEN: in  STD_LOGIC;
            STOP : in  STD_LOGIC;
            EN   : in  STD_LOGIC;
            IN1  : in  STD_LOGIC_VECTOR ( 15 downto 0 );
            IN2  : in  STD_LOGIC_VECTOR ( 15 downto 0 );
            ENO  : out STD_LOGIC := '0'
        );
end Compare_W_e;


architecture Compare_W_a of Compare_W_e is

begin

	Compare_p: process ( RST, CLK )
	begin
		if RST = '1' then
			ENO <= '0';
		elsif rising_edge ( CLK ) then
			if STOP = '1' then
				ENO <= '0';
			elsif CLKEN = '1' then
				if EN = '1' then
					if  ( (signed(IN1)  = signed(IN2)) and MODE = "EQ" ) or
						( (signed(IN1) /= signed(IN2)) and MODE = "NE" ) or
						( (signed(IN1) >= signed(IN2)) and MODE = "GE" ) or
						( (signed(IN1) >  signed(IN2)) and MODE = "GT" ) or
						( (signed(IN1) <= signed(IN2)) and MODE = "LE" ) or
						( (signed(IN1) <  signed(IN2)) and MODE = "LT" ) then
						ENO <= '1';
					else
						ENO <= '0';
					end if;
				else
					ENO <= '0';
				end if;
			end if;
		end if;
	end process Compare_p;

end Compare_W_a;