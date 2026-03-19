---------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    QuadDec_e - QuadDec_a
-- Description:    Encoder interface.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity QuadDec_e is
    Port (
        RST    : in     std_logic;
        CLK    : in     std_logic;
        A      : in     std_logic;
        B      : in     std_logic;
        N      : in     std_logic;
        Inv_A  : in     std_logic;
        Inv_B  : in     std_logic;
        Inv_N  : in     std_logic;
        CU1    : buffer std_logic;
        CU2    : buffer std_logic;
        CU4    : out    std_logic;
        CD1    : buffer std_logic;
        CD2    : buffer std_logic;
        CD4    : out    std_logic;
        RESETHW: out    std_logic
    );
end QuadDec_e;

architecture QuadDec_a of QuadDec_e is

    signal ADELAY: std_logic := '0';
    signal BDELAY: std_logic := '0';
    signal APRIME: std_logic := '0';
    signal BPRIME: std_logic := '0';
    signal NPRIME: std_logic := '0';

begin

    APRIME  <= not A when Inv_A = '1' else A;
    BPRIME  <= not B when Inv_B = '1' else B;
    NPRIME  <= not N when Inv_N = '1' else N;

    RESETHW <= NPRIME;
    CD1     <= (ADELAY AND NOT(APRIME) AND NOT(BPRIME));
    CD2     <= ((APRIME AND BPRIME AND NOT(ADELAY)) OR CD1);
    CD4     <= ((BPRIME AND NOT(APRIME) AND NOT(BDELAY)) OR (APRIME AND BDELAY AND NOT(BPRIME)) OR CD2);
    CU1     <= (APRIME AND NOT(ADELAY) AND NOT(BPRIME));
    CU2     <= ((ADELAY AND BPRIME AND NOT(APRIME)) OR CU1);
    CU4     <= ((BDELAY AND NOT(APRIME) AND NOT(BPRIME)) OR (APRIME AND BPRIME AND NOT(BDELAY)) OR CU2);

 QuadDec_p:process(RST, CLK)
     begin
        if RST = '1' then
            ADELAY <= '0';
            BDELAY <= '0';
        elsif rising_edge ( CLK ) then
            ADELAY <= APRIME;
            BDELAY <= BPRIME;
        end if;
 end process QuadDec_p;

end QuadDec_a;

