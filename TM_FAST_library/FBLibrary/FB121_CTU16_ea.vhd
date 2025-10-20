----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB121_CTU16 - FB121_CTU16_a
-- Description:    16bit count up timer.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB121_CTU16_e is
    port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        CU   : in  STD_LOGIC;
        R    : in  STD_LOGIC;
        PV   : in  STD_LOGIC_VECTOR (15 downto 0);
        Q    : out STD_LOGIC;
        CV   : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB121_CTU16_e;

architecture FB121_CTU16_a of FB121_CTU16_e is

    signal count: integer range -32768 to 32767;
    signal RESET: STD_LOGIC;
    signal UP   : STD_LOGIC;
    signal CU_Q : std_logic := '0';

begin

    RESET <= '1' when (EN = '1' AND CLKEN = '1' AND R = '1') else '0';
    UP    <= '1' when (EN = '1' AND CLKEN = '1' AND CU = '1') else '0';
    Q     <= '1' when (count >= conv_integer(signed(PV))) else '0';
    CV    <= conv_std_logic_vector(count, CV'length);

    P_LATCH_UP: process (RST, CLK)
    begin
        if (RST = '1') then
            CU_Q <= '0';
        elsif rising_edge(CLK) then
            if (EN = '1' and CLKEN = '1') then
                if (CU = '1') then
                    CU_Q <= '1';
                else
                    CU_Q <= '0';
            end if;
            end if;
        end if;
    end process P_LATCH_UP;

    P_CTU16: process (RST, CLK)
    begin
        if (RST = '1') then
            count <= 0;
        elsif rising_edge(CLK) then
            if (RESET = '1') then
                count <= 0;
            elsif (UP = '1' and CU_Q = '0') then
                if (count = 32767) then
                    count <= count;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process P_CTU16;

end FB121_CTU16_a;