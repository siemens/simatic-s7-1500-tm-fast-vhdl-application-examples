----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    ShiftRotate_W_e - ShiftRotate_W_a
-- Description:    The ShiftRotate operation shift or rotate, right or left a word,
--                 integer, double word, or double integer by N bits
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ShiftRotate_W_e is
    generic (
        MODE : string := "SLW"
    );
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR ( 15 downto 0);
        N    : in  STD_LOGIC_VECTOR ( 15 downto 0);
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR ( 15 downto 0)
    );
end ShiftRotate_W_e;

architecture ShiftRotate_W_a of ShiftRotate_W_e is

begin

    ShiftRotate_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            OUT1 <= ( others => '0' );
            ENO  <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                OUT1 <= ( others => '0' );
                ENO  <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    if   (MODE = "SLW") then
                        OUT1 <= std_logic_vector( shift_left(unsigned(IN1), to_integer( unsigned( N ) ) ) );
                        ENO  <= '1';
                    elsif (MODE = "SRW") then
                        OUT1 <= std_logic_vector( shift_right(unsigned(IN1), to_integer( unsigned( N ) ) ) );
                        ENO  <= '1';
                    elsif (MODE = "SRI") then
                        OUT1 <= std_logic_vector( shift_right(signed(IN1), to_integer( unsigned( N ) ) ) );
                        ENO  <= '1';
                    elsif (MODE = "RLW") then
                        OUT1 <= std_logic_vector( rotate_left(unsigned(IN1), to_integer( unsigned( N ) ) ) );
                        ENO  <= '1';
                    elsif (MODE = "RRW") then
                        OUT1 <= std_logic_vector( rotate_right(unsigned(IN1), to_integer( unsigned( N ) ) ) );
                        ENO  <= '1';
                    else
                        OUT1 <= ( others => '0' );
                        ENO  <= '0';
                    end if;
                else
                    ENO <= '0';
                end if;
            end if;
        end if;
    end process ShiftRotate_p;

end ShiftRotate_W_a;

