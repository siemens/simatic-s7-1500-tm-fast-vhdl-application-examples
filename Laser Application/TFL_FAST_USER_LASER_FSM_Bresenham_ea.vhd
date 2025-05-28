--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of FSM of Bresenham algorithm	                      --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_FSM_Bresenham.vhd                   		  --
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
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
-- state machine for interpolation/ bresenham algorithm
entity FSM_BRESENHAM_e is
port(
    CK : in std_logic;
    START : in std_logic;
    LAST : in std_logic;
    LOAD1 : out std_logic;
    LOAD2 : out std_logic;
    CALC : out std_logic;
    DONE : out std_logic;
    READY : out std_logic
);
end FSM_BRESENHAM_e;
--------------------------------------------------------------------------------
architecture FSM_BRESENHAM_a of FSM_BRESENHAM_e is 
    
    type state_type is (ST0, ST1, ST2, ST3, ST4);    -- ST0 := IDLE, ST1 := LOAD1, ST2 := LOAD2, ST3 := CALC, ST4 := DONE
    signal state, nxt_state : state_type;
    signal out_LOAD1, out_LOAD2, out_CALC, out_DONE, out_READY : std_logic;
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
next_state_proc : process (CK, START, LAST, state)
begin
    case state is
        when ST0 =>
            if (START = '1') then
                nxt_state <= ST1;
            else nxt_state <= ST0;
            end if;
        when ST1 => nxt_state <= ST2;
        when ST2 => nxt_state <= ST3;
        when ST3 => 
            if (LAST = '1') then
                nxt_state <= ST4;
            else nxt_state <= ST3;
            end if;
        when ST4 => nxt_state <= ST0;
        when others => nxt_state <= ST0;
    end case;
end process next_state_proc;
--------------------------------------------------------------------------------
with nxt_state select
    out_LOAD1 <=
        '1' when ST1,
        '0' when others;
with nxt_state select
    out_LOAD2 <=
        '1' when ST2,
        '0' when others;
with nxt_state select
    out_CALC <=
        '1' when ST3,
        '0' when others;
with nxt_state select
    out_DONE <=
        '1' when ST4,
        '0' when others;
with nxt_state select
    out_READY <=
        '1' when ST0,
        '0' when others;
--------------------------------------------------------------------------------
CK_sync_proc : process(CK)
begin
    if rising_edge(CK) then
        state <= nxt_state;
        LOAD1 <= out_LOAD1;
        LOAD2 <= out_LOAD2;
        CALC <= out_CALC;
        DONE <= out_DONE;
        READY <= out_READY;
    end if;
end process CK_sync_proc;
--------------------------------------------------------------------------------
end architecture FSM_BRESENHAM_a;
                