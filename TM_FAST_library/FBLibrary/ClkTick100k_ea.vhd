----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    ClkTick100k_e - ClkTick100k_a
-- Description:    100Khz clock tick required for all timer blocks and CP_Gen block.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ClkTick100k_e is
    port (
        RST        : in  STD_LOGIC;
        CLK        : in  STD_LOGIC;
        CLKEN      : in  STD_LOGIC;
        CLKEN100KHZ: OUT STD_LOGIC
    );
end ClkTick100k_e;

architecture ClkTick100k_a of ClkTick100k_e is

    signal count: integer;

begin


    ClkTick100k_p: process (RST, CLK)
    begin
       if (RST = '1') then
            if     PHASE_QUANTITY = 14      then count <=   9; -- Phases used: F_CLK_USER = 15_000_000 with one active Phase of 15
            elsif  PHASE_QUANTITY = 0         then               -- Phases not used
              if    F_CLK_USER =  5_000_000 then count <=  49;
              elsif F_CLK_USER = 15_000_000 then count <= 149;
              elsif F_CLK_USER = 25_000_000 then count <= 249;
              elsif F_CLK_USER = 50_000_000 then count <= 499;
              elsif F_CLK_USER = 75_000_000 then count <= 749;
              end if;
            end if;

              CLKEN100KHZ <= '0';

        elsif rising_edge(CLK) then
            if (CLKEN = '1') then
                count <= count - 1;
                if (count = 0) then
                    CLKEN100KHZ <= '1';

                  if     PHASE_QUANTITY = 14      then count <=   9; -- Phases used: F_CLK_USER = 15_000_000 with one active CLKEN of 15
                  elsif  PHASE_QUANTITY = 0       then               -- Phases not used
                    if    F_CLK_USER =  5_000_000 then count <=  49;
                    elsif F_CLK_USER = 15_000_000 then count <= 149;
                    elsif F_CLK_USER = 25_000_000 then count <= 249;
                    elsif F_CLK_USER = 50_000_000 then count <= 499;
                    elsif F_CLK_USER = 75_000_000 then count <= 749;
                    end if;
                  end if;

                else
                    CLKEN100KHZ <= '0';
                end if;
            end if;
        end if;
    end process ClkTick100k_p;

 end ClkTick100k_a;