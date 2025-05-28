--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of XY2_100 protocol 					              --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_XY2.vhd    		                          --
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
entity XY2_e is
	port( 
		CK     : in std_logic;
		START  : in std_logic;
		DATAX  : in std_logic_vector(15 downto 0);
		DATAY  : in std_logic_vector(15 downto 0);
		RS422X : out std_logic;
		RS422Y : out std_logic;
		SYNC   : out std_logic;
		LDAC   : out std_logic;
		READY  : out std_logic
	);
end XY2_e;
--------------------------------------------------------------------------------
architecture XY2_a of XY2_e is
--------------------------------------------------------------------------------
component FSM_XY2_e is
port(
		CK    : in std_logic;
		START : in std_logic;
		CTR   : in std_logic_vector(4 downto 0);
		LD_SEND_REG : out std_logic;
		SHIFT_SYNC  : out std_logic;
		SHIFT_DATA  : out std_logic;
		LDAC        : out std_logic;
		READY       : out std_logic;
		PARITY      : out std_logic
);
end component;

component REG_e is
generic (REG_WIDTH : natural := 16);
port(
		CK  		: in  STD_LOGIC;
		LD_REG	: in  STD_LOGIC;
		DATA_IN 	: in  STD_LOGIC_VECTOR (REG_WIDTH - 1 downto 0);
		DATA_OUT : out  STD_LOGIC_VECTOR (REG_WIDTH - 1 downto 0)
);
end component;

component PARITY_e is
	generic (N : positive);
	port (
		INPUT  : in std_logic_vector(N-1 downto 0);
		OUTPUT : out std_logic
		);
end component;
--------------------------------------------------------------------------------
signal LD_SEND_REG, SHIFT_DATA, SHIFT_SYNC, SEND_PARITY : std_logic;
signal CTR : std_logic_vector(4 downto 0) := '0' & x"0";
-- Buffer of data x and y
signal BUFFER_X, BUFFER_Y : std_logic_vector(15 downto 0);
-- Data with start bits "001"
signal SEND_REG_X, SEND_REG_Y : std_logic_vector(18 downto 0);
-- data to check parity
signal CHECK_REG_X, CHECK_REG_Y : std_logic_vector(18 downto 0);
-- signals for component and signal for targeted assignment 
signal PARCHECK_X,  PARCHECK_Y : std_logic := '0';
signal PARITY_X, PARITY_Y : std_logic;
-- Sync
signal SEND_REG_SYNC : std_logic_vector(19 downto 0);
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
i_FSM : FSM_XY2_e port map(
		CK          => CK,          -- Input von XY2_100_e
		START       => START,       -- Input von XY2_100_e
		CTR         => CTR,         -- Signal
		LD_SEND_REG => LD_SEND_REG, -- Signal
		SHIFT_SYNC  => SHIFT_SYNC,  --Signal
		SHIFT_DATA  => SHIFT_DATA,  -- Signal
		LDAC        => LDAC,        -- Output von XY2_100_e
		READY       => READY,       -- Output von XY2_100_e
		PARITY      => SEND_PARITY  --Signal
		);
--------------------------------------------------------------------------------
i_REG_DATA_X : REG_e
		generic map (REG_WIDTH => 16)
		Port map (
			CK  		=> CK,
			LD_REG	=> START,
			DATA_IN 	=> DATAX,
			DATA_OUT => BUFFER_X
		);

i_REG_DATA_Y : REG_e
		generic map (REG_WIDTH => 16)
		Port map (
			CK  		=> CK,
			LD_REG	=> START,
			DATA_IN 	=> DATAY,
			DATA_OUT => BUFFER_Y
		);
--------------------------------------------------------------------------------
i_PARCHECK_X : PARITY_e
	generic map(19)
	port map(
		INPUT  => CHECK_REG_X,
		OUTPUT => PARCHECK_X
		);
		
i_PARCHECK_Y : PARITY_e
	generic map(19)
	port map(
		INPUT  => CHECK_REG_Y,
		OUTPUT => PARCHECK_Y
		);	
--------------------------------------------------------------------------------
-- Counter Data
CTR_DATA : process(CK)
	begin
	if rising_edge(CK) then
		if (LD_SEND_REG = '1') then
			CTR <= '0' & x"0";
		else
			if SHIFT_DATA = '1' then
				CTR <= CTR + x"1"; -- possible with unsigned lib
			end if;
		end if;
	end if;
end process CTR_DATA;
--------------------------------------------------------------------------------
-- Sending data xy bit by bit
XY2_100_SEND_XY : process(CK)
	begin
	if rising_edge(CK) then
		if LD_SEND_REG = '1' then
			SEND_REG_X <= "001" & BUFFER_X;
			SEND_REG_Y <= "001" & BUFFER_Y;
		elsif SHIFT_DATA = '1' then
			SEND_REG_X(18 downto 1) <= SEND_REG_X(17 downto 0);
			SEND_REG_X(0) <= '0';
			SEND_REG_Y(18 downto 1) <= SEND_REG_Y(17 downto 0);
			SEND_REG_Y(0) <= '0';
		end if;
	end if;
end process XY2_100_SEND_XY;
--------------------------------------------------------------------------------
-- Sending SYNC bit by bit
XY2_SEND_SYNC : process(CK)
	begin
	if rising_edge(CK) then
		if LD_SEND_REG = '1' then
			SEND_REG_SYNC <= x"FFFFE";
		elsif SHIFT_SYNC = '1' then
			SEND_REG_SYNC(19 downto 1) <= SEND_REG_SYNC(18 downto 0);
			SEND_REG_SYNC(0) <= '0';
		end if;
	end if;
end process XY2_SEND_SYNC;
--------------------------------------------------------------------------------
-- Parity Check
ASSIGN_PARITY_CHECK : process(CK)
	begin
	if rising_edge(CK) then
		if LD_SEND_REG = '1' then
			CHECK_REG_X <= "001" & BUFFER_X; -- &-Operator: Concatenation, Verknüpfung von "001" und Data
			CHECK_REG_Y <= "001" & BUFFER_Y;
		elsif CTR = "10010" then -- SEND_PARITY = '1'
			PARITY_X <= PARCHECK_X;
			PARITY_Y <= PARCHECK_Y;
		end if;
	end if;
end process ASSIGN_PARITY_CHECK;
------------------------------------------------------		
-- "MUX" RS422: dependent on state of FSM (ST2, ST3) sending of data or parity		
RS422X <= SEND_REG_X(18) when SHIFT_DATA = '1' else
				PARITY_X when SEND_PARITY = '1' else	
				'0';	
		
RS422Y <= SEND_REG_Y(18) when SHIFT_DATA = '1' else
				PARITY_Y when SEND_PARITY = '1' else	
				'0';		

SYNC <= 		SEND_REG_SYNC(19) when SHIFT_SYNC = '1' else
				'0';
------------------------------------------------------
end XY2_a;		

		
















	 