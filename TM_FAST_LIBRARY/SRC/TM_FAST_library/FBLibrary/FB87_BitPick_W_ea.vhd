----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB87_BitPick_W_e - FB87_BitPick_W_a
-- Description:    The BITPICK_W operation outputs a bit in a word specified by
--                 BITSELECT.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB87_BitPick_W_e is
    Port (
        RST      : in  STD_LOGIC;
        CLK      : in  STD_LOGIC;
        CLKEN    : in  STD_LOGIC;
        STOP     : in  STD_LOGIC;
        EN       : in  STD_LOGIC;
        IN1      : in  STD_LOGIC_VECTOR (15 downto 0);
        BITSELECT: in  STD_LOGIC_VECTOR (15 downto 0);
        OUT1     : out STD_LOGIC
    );
end FB87_BitPick_W_e;

architecture FB87_BitPick_W_a of FB87_BitPick_W_e is

    signal BitPos: Integer;

begin

    BitPos <= to_integer(signed(BITSELECT));

    FB87_BitPick_W_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= '0';
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                OUT1 <= '0';
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    if (BitPos < 16) and (BitPos >= 0) then
                        OUT1 <= IN1(BitPos);
                    else
                        OUT1 <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process FB87_BitPick_W_p;

end FB87_BitPick_W_a;
