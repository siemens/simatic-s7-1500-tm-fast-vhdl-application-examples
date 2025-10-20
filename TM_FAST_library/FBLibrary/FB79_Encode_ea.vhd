----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB79_Encode_e - FB79_Encode_a
-- Description:    The ENCODE operation converts the Input to a binary number
--                 corresponding to the bit position of the left most set bit
--                 in Input.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FB79_Encode_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        OUT1 : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB79_Encode_e;

architecture FB79_Encode_a of FB79_Encode_e is

    signal BYTESEL0: STD_LOGIC_VECTOR (7 downto 0);
    signal BYTESEL1: STD_LOGIC_VECTOR (7 downto 0);
    signal BYTESEL2: STD_LOGIC_VECTOR (7 downto 0);
    signal SEL0    : STD_LOGIC;
    signal SEL1    : STD_LOGIC;
    signal SEL2    : STD_LOGIC;
    signal SEL3    : STD_LOGIC;
    signal SEL4    : STD_LOGIC;
    signal SEL5    : STD_LOGIC;
    signal SEL6    : STD_LOGIC;
    signal SEL7    : STD_LOGIC;
    signal SEL8    : STD_LOGIC;
    signal E       : STD_LOGIC_VECTOR (15 downto 0) := x"0000";

begin

    SEL0     <= '0' when IN1(31 downto 24) = x"00" else '1';
    BYTESEL0 <= IN1(23 downto 16) when SEL0 = '0' else IN1(31 downto 24);
    SEL1     <= '0' when IN1(15 downto 8) = x"00" else '1';
    BYTESEL1 <= IN1(7 downto 0) when SEL1 = '0' else IN1(15 downto 8);
    SEL2     <= '0' when BYTESEL0 = x"00" else '1';
    BYTESEL2 <= BYTESEL1 when SEL2 = '0' else BYTESEL0;
    E(3)     <= SEL1 when SEL2 = '0' else SEL0;
    E(4)     <= SEL2;
    SEL3     <= '0' when BYTESEL2(7 downto 4) = "0000" else '1';
    E(2)     <= SEL3;
    SEL4     <= BYTESEL2(3) when SEL3 = '0' else BYTESEL2(7);
    SEL5     <= BYTESEL2(2) when SEL3 = '0' else BYTESEL2(6);
    SEL6     <= BYTESEL2(1) when SEL3 = '0' else BYTESEL2(5);
    SEL7     <= (SEL4 OR SEL5);
    E(1)     <= SEL7;
    SEL8     <= SEL6 when SEL7 = '0' else SEL4;
    E(0)     <= SEL8;

    FB79_Encode_p: process ( RST, CLK )
    begin
        if ( RST = '1' ) then
            OUT1 <= x"0000";
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                OUT1 <= x"0000";
            elsif (CLKEN = '1' and EN = '1') then
                OUT1 <= (0 => E(0),
                         1 => E(1),
                         2 => E(2),
                         3 => E(3),
                         4 => E(4),
                         others => '0');
            end if;
        end if;
    end process FB79_Encode_p;

end FB79_Encode_a;
