----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    WordLogic_DW_e - WordLogic_DW_a
-- Description:    The WordLogic operation performs a word or double word based
--                 AND, OR, or XOR operation.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity WordLogic_DW_e is
    generic (
        MODE     : string := "WAND"
    );
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC := '1';
        STOP : in  STD_LOGIC := '0';
        EN   : in  STD_LOGIC := '1';
        IN1  : in  STD_LOGIC_VECTOR ( 31 downto 0);
        IN2  : in  STD_LOGIC_VECTOR ( 31 downto 0);
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR ( 31 downto 0)
    );
end WordLogic_DW_e;

architecture WordLogic_DW_a of WordLogic_DW_e is

begin

    WordLogic_p: process ( RST, CLK )
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
                    if    (MODE = "WAND") then
                        OUT1 <= IN1 and IN2;
                        ENO  <= '1';
                    elsif (MODE = "WOR") then
                        OUT1 <= IN1 or IN2;
                        ENO  <= '1';
                    elsif (MODE = "WXOR") then
                        OUT1 <= IN1 xor IN2;
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
    end process WordLogic_p;

end WordLogic_DW_a;

