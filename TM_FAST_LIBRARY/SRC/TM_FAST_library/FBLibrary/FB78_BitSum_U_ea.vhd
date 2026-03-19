----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB78_BitSum_U_e - FB78_BitSum_U_a
-- Description:    The BITSUM operation adds the number of bits set to a 1 in a
--                 double word provided at Input(combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB78_BitSum_U_e is
    Port (
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB78_BitSum_U_e;

architecture FB78_BitSum_U_a of FB78_BitSum_U_e is
begin

    BitSum_p: process ( IN1 ) 
      variable count : unsigned(5 downto 0) := "000000";
    begin
        count := "000000";
        for i in 0 to 31 loop
            count := count + ("00000" & IN1(i));
        end loop;
        
        OUT1( 5 downto 0) <= std_logic_vector( count );
        OUT1(15 downto 6) <= ( others => '0' );
    end process BitSum_p;

end FB78_BitSum_U_a;
