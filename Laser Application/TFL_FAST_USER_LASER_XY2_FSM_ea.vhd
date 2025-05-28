--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of FSM of XY2-100 protocol			                  	--
--                                                                            --
-- filename    TFL_FAST_USER_LASER_XY2_FSM.vhd                     		      --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- version     V2.21042023  (Nummer.Datum)                                    --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity FSM_XY2_e is
port(
		CK : in std_logic;
		START : in std_logic;
		CTR : in std_logic_vector(4 downto 0);
		LD_SEND_REG : out std_logic;
		SHIFT_SYNC: out std_logic;
		SHIFT_DATA: out std_logic;
		LDAC: out std_logic;
		READY: out std_logic;
		PARITY: out std_logic
);
end FSM_XY2_e;
--------------------------------------------------------------------------------
architecture FSM_XY2_a of FSM_XY2_e is
	type state_type is (ST0, ST1, ST2, ST3, ST4); -- states of transmission XY2-100: ST0 := IDLE, ST1 := LOAD, ST2:= STARTBIT+DATA, ST3:= PARITY, ST4:= LDAC
--------------------------------------------------------------------------------	
	signal state, nxt_state : state_type; -- signals to coordinate through FSM (Moore'sche Finite State Machine)
	signal OUT_LD_SEND_REG : std_logic; -- load new data -> call REG 
	signal OUT_SHIFT_DATA, OUT_SHIFT_SYNC : std_logic; -- starts shift process: serial transmission of bits
	signal OUT_LDAC : std_logic; -- load acknowlede: transmission done
	signal OUT_READY : std_logic; -- ready for new task
	signal OUT_PARITY : std_logic;-- parity ready to send 
--------------------------------------------------------------------------------	
begin
--------------------------------------------------------------------------------
next_state: process (START, state, CTR)
begin
	case state is
		when ST0 => 
			if (START = '1') then -- start fsm
				nxt_state <= ST1;
			else nxt_state <= ST0;
			end if;
		when ST1 => nxt_state <= ST2; -- load data
		when ST2 => 
			if(CTR = "10010") then -- count 0 to 18 (19 bit)
				nxt_state <= ST3;
			else nxt_state <= ST2;
			end if;
		when ST3 => nxt_state <= ST4;-- parity
		when ST4 => nxt_state <= ST0;-- transmission done
		when others => nxt_state <= ST0;
	end case;
end process next_state;
--------------------------------------------------------------------------------
-- set signals

with nxt_state select
	OUT_LD_SEND_REG <=
		'1' when ST1,
		'0' when others; 
with nxt_state select -- shift active in ST2 und ST3 -> 20 bit (sync = x"FFFE") instead 19 bit (data in ST2) + 1 bit (parity in ST3)
	OUT_SHIFT_SYNC <=
		'1' when ST2,
		'1' when ST3,
		'0' when others; 
with nxt_state select
	OUT_SHIFT_DATA <=
		'1' when ST2,
		'0' when others;
with nxt_state select
	OUT_LDAC <=
		'1' when ST4,
		'0' when others;
with nxt_state select
	OUT_READY <=
		'1' when ST0,
		'0' when others;
with nxt_state select
	OUT_PARITY <= 
		'1' when ST3,
		'0' when others;
--------------------------------------------------------------------------------
-- assign outputs
CK_SYNC : process(CK)
Begin
	if rising_edge(CK) then
		state <= nxt_state;
		LD_SEND_REG <= OUT_LD_SEND_REG;
		SHIFT_SYNC <= OUT_SHIFT_SYNC;
		SHIFT_DATA <= OUT_SHIFT_DATA;
		LDAC <= OUT_LDAC;
		READY <= OUT_READY;
		PARITY <= OUT_PARITY;
	end if;
end process CK_SYNC;
--------------------------------------------------------------------------------		
end architecture FSM_XY2_a;