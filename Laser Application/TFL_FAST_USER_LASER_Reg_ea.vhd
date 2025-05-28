--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of overwriting register              				  --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_Reg.vhd                       		      --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- version     V2.21042023  (Nummer.Datum)                                    --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Copy data at a certain time
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------------------------------
entity REG_e is
	generic (REG_WIDTH : natural := 16);
    Port ( 		
	 CK  		: in  STD_LOGIC;
	 LD_REG	: in  STD_LOGIC;
	 DATA_IN 	: in  STD_LOGIC_VECTOR (REG_WIDTH - 1 downto 0);
	 DATA_OUT : out  STD_LOGIC_VECTOR (REG_WIDTH - 1 downto 0)
	 );
end REG_e;
--------------------------------------------------------------------------------
architecture REG_a of REG_e is
--------------------------------------------------------------------------------
signal REG : STD_LOGIC_VECTOR (REG_WIDTH - 1 downto 0) := (others => '0');
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
process(CK)
begin

if rising_edge(CK) then
	if LD_REG = '1' then
		REG <= DATA_IN;
	end if;
end if;
end process;
DATA_OUT <= REG;
--------------------------------------------------------------------------------
end REG_a;