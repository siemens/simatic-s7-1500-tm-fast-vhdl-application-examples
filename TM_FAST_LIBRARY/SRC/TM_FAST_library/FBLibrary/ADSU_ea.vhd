-------------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    ADSU_e - ADSU_a
-- Description:    Addition or Subtraction of signed values with width of data_width
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADSU_e is
    generic (
        data_width : natural := 32
    );
    port (
        rst     : in  std_logic;
        clk     : in  std_logic;
        enable  : in  std_logic;
        add_sub : in  std_logic;
        dataa   : in  std_logic_vector ((data_width - 1) downto 0);
        datab   : in  std_logic_vector ((data_width - 1) downto 0);
        overflow: out std_logic;
        result  : out std_logic_vector ((data_width - 1) downto 0)
    );
end ADSU_e;

architecture ADSU_a of ADSU_e is

    signal in_a      : signed ((data_width - 1) downto 0);
    signal in_b      : signed ((data_width - 1) downto 0);
    signal result_val: signed ((data_width - 1) downto 0);
    
begin
    
    in_a <= signed(dataa);
    in_b <= signed(datab);
    
    ADSU_p: process (rst, clk)
    begin
        if (rst = '1') then
          result <= (others => '0');
          overflow <= '0';
        elsif rising_edge (clk) then
          if (enable = '1') then
            if (add_sub = '1') then  --add
                result_val <= in_a + in_b;
                if ((dataa(data_width - 1) = '0') and (datab(data_width - 1) = '0') and (result_val(data_width - 1) = '1')) then
                    overflow <= '1';
                elsif ((dataa(data_width - 1) = '1') and (datab(data_width - 1) = '1') and (result_val(data_width - 1) = '0')) then
                    overflow <= '1';
                else
                    overflow <= '0';
                end if;
            else  -- subtract
                result_val <= in_a - in_b;
                if ((dataa(data_width - 1) = '0') and (datab(data_width - 1) = '1') and (result_val(data_width - 1) = '1')) then
                    overflow <= '1';
                elsif ((dataa(data_width - 1) = '1') and (datab(data_width - 1) = '0') and (result_val(data_width - 1) = '0')) then
                    overflow <= '1';
                else
                    overflow <= '0';
                end if;
            end if;
          end if;
          result <= std_logic_vector(result_val);
        end if;
    end process ADSU_p;
    
end ADSU_a;

