----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB89_BitShift_W_e - FB89_BitShift_W_a
-- Description:    The BITSHIFT_W operation shifts the output data register
--                 by 1 location while shifting the value at IN1 at the LSB.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB89_BitShift_W_e is
    Port (
        RST     : in    STD_LOGIC;
        CLK     : in    STD_LOGIC;
        CLKEN   : in    STD_LOGIC;
        EN      : in    STD_LOGIC;
        IN1     : in    STD_LOGIC;
        SHIFT   : in    STD_LOGIC;
        SH_RESET: in    STD_LOGIC;
        OUT1    : inout STD_LOGIC_VECTOR (15 downto 0)
    );
end FB89_BitShift_W_e;

architecture FB89_BitShift_W_a of FB89_BitShift_W_e is

    signal sh_rst     : std_logic;
    signal shiftenable: std_logic;

begin

    sh_rst      <= (CLKEN and SH_RESET and EN);
    shiftenable <= (CLKEN and SHIFT and EN);

    FB89_BitShift_W_p: process (RST, CLK)
    begin
        if (RST = '1') then
            OUT1 <= x"0000";
        elsif rising_edge(CLK) then
            if (sh_rst = '1') then
                OUT1 <= x"0000";
            elsif (shiftenable = '1') then
                OUT1(15 downto 1) <= OUT1(14 downto 0);
                OUT1(0) <= IN1;
            end if;
        end if;
    end process FB89_BitShift_W_p;

end FB89_BitShift_W_a;
