--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of parity check     						          --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_Parity.vhd                          		  --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- version     V2.21042023  (Nummer.Datum)                                    --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--------------------------------------------------------------------------------
entity PARITY_e is
	generic (N:positive);
	port (
	INPUT: in std_logic_vector (N-1 downto 0);
	OUTPUT: out std_logic -- y='1' if uneven, else '0'
	); 
end PARITY_e;
--------------------------------------------------------------------------------
-- Check of parity even

architecture PARITY_a of PARITY_e is
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
process(INPUT)
variable temp: std_logic;
begin
	temp :='0';
	for i in INPUT'range loop
		temp := temp XOR INPUT(i); --XOR with every single bit
	end loop;
	OUTPUT <= temp;
end process;
--------------------------------------------------------------------------------
end PARITY_a;