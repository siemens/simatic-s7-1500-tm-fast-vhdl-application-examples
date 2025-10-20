----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB88_BitShift_DW_e - FB88_BitShift_DW_a
-- Description:    The BITSHIFT_DW operation shifts the output data register
--                 by 1 location while shifting the value at IN1 at the LSB.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB88_BitShift_DW_e is
    Port (
        RST     : in    STD_LOGIC;
        CLK     : in    STD_LOGIC;
        CLKEN   : in    STD_LOGIC;
        EN      : in    STD_LOGIC;
        IN1     : in    STD_LOGIC;
        SHIFT   : in    STD_LOGIC;
        SH_RESET: in    STD_LOGIC;
        OUT1    : inout STD_LOGIC_VECTOR (31 downto 0)
    );
end FB88_BitShift_DW_e;

architecture FB88_BitShift_DW_a of FB88_BitShift_DW_e is

    signal sh_rst     : std_logic;
    signal shiftenable: std_logic;

begin

    sh_rst      <= (CLKEN and SH_RESET and EN);
    shiftenable <= (CLKEN and SHIFT and EN);

    FB88_BitShift_DW_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= x"00000000";
        elsif rising_edge(CLK) then
            if (sh_rst = '1') then
                OUT1 <= x"00000000";
            elsif (shiftenable = '1') then
                OUT1(31 downto 1) <= OUT1(30 downto 0);
                OUT1(0) <= IN1;
            end if;
        end if;
    end process FB88_BitShift_DW_p;

end FB88_BitShift_DW_a;
