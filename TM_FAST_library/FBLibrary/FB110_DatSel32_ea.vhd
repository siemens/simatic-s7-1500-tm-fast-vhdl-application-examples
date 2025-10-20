----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB110_DatSel32_e - FB110_DatSel32_a
-- Description:    Transfers one of both 32Bit inputs to the output
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB110_DatSel32_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        SEL  : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        IN2  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB110_DatSel32_e;

architecture FB110_DatSel32_a of FB110_DatSel32_e is

begin

   DatSel32_p: process (RST, CLK)
    begin
       if (RST = '1') then
           OUT1 <= x"00000000";
        elsif rising_edge(CLK) then
           if (CLKEN = '1') then
               if (SEL = '0') then
                  OUT1 <= IN1;
                else
                  OUT1 <= IN2;
               end if;
            end if;
        end if;
   end process DatSel32_p;

end FB110_DatSel32_a;

