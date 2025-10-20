----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB122_CTD16 - FB122_CTD16_a
-- Description:    16bit count down timer.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FB122_CTD16_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        CD   : in  STD_LOGIC;
        LOAD : in  STD_LOGIC;
        PV   : in  STD_LOGIC_VECTOR (15 downto 0);
        Q    : out STD_LOGIC;
        CV   : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB122_CTD16_e;

architecture FB122_CTD16_a of FB122_CTD16_e is

    signal count: integer range -32768 to 32767;
    signal LD   : STD_LOGIC;
    signal DN   : STD_LOGIC;
    signal CD_Q : STD_LOGIC := '0';


begin

    LD <= '1' when (EN = '1' and CLKEN = '1' and LOAD = '1') else '0';
    DN <= '1' when (EN = '1' and CLKEN = '1' and CD = '1') else '0';
    Q  <= '1' when (count <= 0) else '0';
    CV <= conv_std_logic_vector(count, CV'length);

    P_LATCH_DN: process (RST, CLK)
    begin
        if (RST = '1') then
            CD_Q <= '0';
        elsif rising_edge(CLK) then
            if (EN = '1' and CLKEN = '1') then
                if (CD = '1') then
                    CD_Q <= '1';
                else
                    CD_Q <= '0';
                end if;
            end if;
        end if;
    end process P_LATCH_DN;

    P_CTD16: process (RST, CLK)
    begin
        if (RST = '1') then
            count <= 0;
        elsif rising_edge(CLK) then
            if (LD = '1') then
                count <= conv_integer(signed(PV));
            elsif (DN = '1' and CD_Q = '0') then
                if (count  = -32768) then
                    count <= count;
                else
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process P_CTD16;

end FB122_CTD16_a;