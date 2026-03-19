----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB78_BitSum_e - FB78_BitSum_a
-- Description:    The BITSUM operation adds the number of bits set to a 1 in a
--                 double word provided at Input.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB78_BitSum_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB78_BitSum_e;

architecture FB78_BitSum_a of FB78_BitSum_e is

    signal BitSumVal : std_logic_vector (5 downto 0) := "000000";

begin

    BitSum_p: process ( IN1 ) variable count : unsigned(5 downto 0) := "000000";
    begin
        count := "000000";
        for i in 0 to 31 loop
            count := count + ("00000" & IN1(i));
        end loop;
        BitSumVal <= std_logic_vector( count );
    end process BitSum_p;

    FB78_BitSum_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            OUT1 <= x"0000";
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                OUT1 <= x"0000";
            elsif (CLKEN = '1' and EN = '1') then
                OUT1(5 downto 0) <= BitSumVal;
                OUT1(15 downto 6) <= ( others => '0' );
            end if;
        else
        end if;
    end process FB78_BitSum_p;

end FB78_BitSum_a;
