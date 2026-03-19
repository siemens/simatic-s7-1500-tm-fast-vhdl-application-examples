----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB90_BitCast_DW_e - FB90_BitCast_DW_a
-- Description:    The BITCAST_DW operation simply makes the bits of a bus available
--                 for use individually.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB90_BitCast_DW_e is
    Port (
        RST   : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        CLKEN : in  STD_LOGIC;
        STOP  : in  STD_LOGIC;
        EN    : in  STD_LOGIC;
        IN1   : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT0  : out STD_LOGIC;
        OUT1  : out STD_LOGIC;
        OUT2  : out STD_LOGIC;
        OUT3  : out STD_LOGIC;
        OUT4  : out STD_LOGIC;
        OUT5  : out STD_LOGIC;
        OUT6  : out STD_LOGIC;
        OUT7  : out STD_LOGIC;
        OUT8  : out STD_LOGIC;
        OUT9  : out STD_LOGIC;
        OUT10 : out STD_LOGIC;
        OUT11 : out STD_LOGIC;
        OUT12 : out STD_LOGIC;
        OUT13 : out STD_LOGIC;
        OUT14 : out STD_LOGIC;
        OUT15 : out STD_LOGIC;
        OUT16 : out STD_LOGIC;
        OUT17 : out STD_LOGIC;
        OUT18 : out STD_LOGIC;
        OUT19 : out STD_LOGIC;
        OUT20 : out STD_LOGIC;
        OUT21 : out STD_LOGIC;
        OUT22 : out STD_LOGIC;
        OUT23 : out STD_LOGIC;
        OUT24 : out STD_LOGIC;
        OUT25 : out STD_LOGIC;
        OUT26 : out STD_LOGIC;
        OUT27 : out STD_LOGIC;
        OUT28 : out STD_LOGIC;
        OUT29 : out STD_LOGIC;
        OUT30 : out STD_LOGIC;
        OUT31 : out STD_LOGIC
    );
end FB90_BitCast_DW_e;

architecture FB90_BitCast_DW_a of FB90_BitCast_DW_e is

    signal dout: std_logic_vector(31 downto 0);

begin

    OUT0  <= dout(0);
    OUT1  <= dout(1);
    OUT2  <= dout(2);
    OUT3  <= dout(3);
    OUT4  <= dout(4);
    OUT5  <= dout(5);
    OUT6  <= dout(6);
    OUT7  <= dout(7);
    OUT8  <= dout(8);
    OUT9  <= dout(9);
    OUT10 <= dout(10);
    OUT11 <= dout(11);
    OUT12 <= dout(12);
    OUT13 <= dout(13);
    OUT14 <= dout(14);
    OUT15 <= dout(15);
    OUT16 <= dout(16);
    OUT17 <= dout(17);
    OUT18 <= dout(18);
    OUT19 <= dout(19);
    OUT20 <= dout(20);
    OUT21 <= dout(21);
    OUT22 <= dout(22);
    OUT23 <= dout(23);
    OUT24 <= dout(24);
    OUT25 <= dout(25);
    OUT26 <= dout(26);
    OUT27 <= dout(27);
    OUT28 <= dout(28);
    OUT29 <= dout(29);
    OUT30 <= dout(30);
    OUT31 <= dout(31);

    FB90_BitCast_DW_p: process (RST, CLK)
    begin
        if (RST = '1') then
            dout <= x"00000000";
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                dout <= x"00000000";
            elsif (CLKEN = '1') then
                if (EN = '1') then
                    dout <= IN1;
                end if;
            end if;
        end if;
    end process FB90_BitCast_DW_p;

end FB90_BitCast_DW_a;
