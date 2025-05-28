--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- architecture of edge detection advanced (pos+neg)			              --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_Edge_adv.vhd              	    		  --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- version     V2.21042023                                                    --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity EDGE_e is 
port(
	CK : in std_logic;
	SIG_IN: in std_logic;
	POS_EDGE: out std_logic;
    NEG_EDGE: out std_logic
);
end entity EDGE_e;
--------------------------------------------------------------------------------
architecture EDGE_a of EDGE_e is 
--------------------------------------------------------------------------------
signal SIG : std_logic := '0';
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
ASSIGN : process(CK, SIG_IN)
begin
	if rising_edge(CK) then
		SIG <= SIG_IN;
	end if;
end process ASSIGN;
--------------------------------------------------------------------------------
DETECTION : process(CK, SIG_IN)
begin
	if rising_edge(CK) then
		if (((SIG xor SIG_IN) = '1') AND (SIG_IN = '1')) then -- edge detection positive
			POS_EDGE <= '1';
            NEG_EDGE <= '0';
        elsif (((SIG xor SIG_IN) = '1') AND (SIG_IN = '0')) then -- edge detection negative
            NEG_EDGE <= '1';
            POS_EDGE <= '0';
		else
            NEG_EDGE <= '0';
			POS_EDGE <= '0';
		end if;
	end if;
end process DETECTION;
--------------------------------------------------------------------------------
end EDGE_a;