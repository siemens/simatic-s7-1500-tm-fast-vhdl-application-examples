----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB94_BitInsert32_e - FB94_BitInsert32_a
-- Description:    The BITINSERT32 operation changes a bit in a double word to the
--                 BIT_IN value at the location specified by SEL_IN.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB94_BitInsert32_e is
    Port (
        RST   : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        CLKEN : in  STD_LOGIC;
        STOP  : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        IN1   : in  STD_LOGIC_VECTOR (31 downto 0);
        SEL_IN: in  STD_LOGIC_VECTOR (15 downto 0);
        BIT_IN: in  STD_LOGIC;
        OUT1  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB94_BitInsert32_e;

architecture FB94_BitInsert32_a of FB94_BitInsert32_e is

    signal dout  : STD_LOGIC_VECTOR (31 downto 0);
    signal BitPos: Integer;

begin

    BitPos <= to_integer(signed(SEL_IN));
    OUT1   <= dout;

    FB94_BitInsert32_p: process (RST, CLK)
    begin
        if (RST = '1') then
            dout <= x"00000000";
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                dout <= x"00000000";
            elsif (CLKEN = '1' and EN = '1') then
                if (Bitpos = 0) then
                    dout(0) <= BIT_IN;
                else
                    dout(0) <= IN1(0);
                end if;
                if (Bitpos = 1) then
                    dout(1) <= BIT_IN;
                else
                    dout(1) <= IN1(1);
                end if;
                if (Bitpos = 2) then
                    dout(2) <= BIT_IN;
                else
                    dout(2) <= IN1(2);
                end if;
                if (Bitpos = 3) then
                    dout(3) <= BIT_IN;
                else
                    dout(3) <= IN1(3);
                end if;
                if (Bitpos = 4) then
                    dout(4) <= BIT_IN;
                else
                    dout(4) <= IN1(4);
                end if;
                if (Bitpos = 5) then
                    dout(5) <= BIT_IN;
                else
                    dout(5) <= IN1(5);
                end if;
                if (Bitpos = 6) then
                    dout(6) <= BIT_IN;
                else
                    dout(6) <= IN1(6);
                end if;
                if (Bitpos = 7) then
                    dout(7) <= BIT_IN;
                else
                    dout(7) <= IN1(7);
                end if;
                if (Bitpos = 8) then
                    dout(8) <= BIT_IN;
                else
                    dout(8) <= IN1(8);
                end if;
                if (Bitpos = 9) then
                    dout(9) <= BIT_IN;
                else
                    dout(9) <= IN1(9);
                end if;
                if (Bitpos = 10) then
                    dout(10) <= BIT_IN;
                else
                    dout(10) <= IN1(10);
                end if;
                if (Bitpos = 11) then
                    dout(11) <= BIT_IN;
                else
                    dout(11) <= IN1(11);
                end if;
                if (Bitpos = 12) then
                    dout(12) <= BIT_IN;
                else
                    dout(12) <= IN1(12);
                end if;
                if (Bitpos = 13) then
                    dout(13) <= BIT_IN;
                else
                    dout(13) <= IN1(13);
                end if;
                if (Bitpos = 14) then
                    dout(14) <= BIT_IN;
                else
                    dout(14) <= IN1(14);
                end if;
                if (Bitpos = 15) then
                    dout(15) <= BIT_IN;
                else
                    dout(15) <= IN1(15);
                end if;
                if (Bitpos = 16) then
                    dout(16) <= BIT_IN;
                else
                    dout(16) <= IN1(16);
                end if;
                if (Bitpos = 17) then
                    dout(17) <= BIT_IN;
                else
                    dout(17) <= IN1(17);
                end if;
                if (Bitpos = 18) then
                    dout(18) <= BIT_IN;
                else
                    dout(18) <= IN1(18);
                end if;
                if (Bitpos = 19) then
                    dout(19) <= BIT_IN;
                else
                    dout(19) <= IN1(19);
                end if;
                if (Bitpos = 20) then
                    dout(20) <= BIT_IN;
                else
                    dout(20) <= IN1(20);
                end if;
                if (Bitpos = 21) then
                    dout(21) <= BIT_IN;
                else
                    dout(21) <= IN1(21);
                end if;
                if (Bitpos = 22) then
                    dout(22) <= BIT_IN;
                else
                    dout(22) <= IN1(22);
                end if;
                if (Bitpos = 23) then
                    dout(23) <= BIT_IN;
                else
                    dout(23) <= IN1(23);
                end if;
                if (Bitpos = 24) then
                    dout(24) <= BIT_IN;
                else
                    dout(24) <= IN1(24);
                end if;
                if (Bitpos = 25) then
                    dout(25) <= BIT_IN;
                else
                    dout(25) <= IN1(25);
                end if;
                if (Bitpos = 26) then
                    dout(26) <= BIT_IN;
                else
                    dout(26) <= IN1(26);
                end if;
                if (Bitpos = 27) then
                    dout(27) <= BIT_IN;
                else
                    dout(27) <= IN1(27);
                end if;
                if (Bitpos = 28) then
                    dout(28) <= BIT_IN;
                else
                    dout(28) <= IN1(28);
                end if;
                if (Bitpos = 29) then
                    dout(29) <= BIT_IN;
                else
                    dout(29) <= IN1(29);
                end if;
                if (Bitpos = 30) then
                    dout(30) <= BIT_IN;
                else
                    dout(30) <= IN1(30);
                end if;
                if (Bitpos = 31) then
                    dout(31) <= BIT_IN;
                else
                    dout(31) <= IN1(31);
                end if;
            end if;
        end if;
    end process FB94_BitInsert32_p;

end FB94_BitInsert32_a;
