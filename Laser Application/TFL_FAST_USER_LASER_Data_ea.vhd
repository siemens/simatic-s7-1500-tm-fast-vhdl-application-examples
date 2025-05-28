--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of Data Memory Storage				                  --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_Data.vhd                      	          --
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
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity DATA_e is
    port(
        CK : in std_logic;
        RD_EN : in std_logic;
        WR_EN : in std_logic;
        CLEAR : in std_logic;
        SEND_NEW : in std_logic;								-- edge ready or edge startbit
        ADDRESS : in std_logic_vector(9 downto 0);
        DATA: in std_logic_vector(31 downto 0);
        NEWDATA_AVA : out std_logic;
        MAXVAL : out std_logic_vector(9 downto 0);
        DATAX: out std_logic_vector(15 downto 0);
        DATAY: out std_logic_vector(15 downto 0)	
    );
end entity DATA_e;
--------------------------------------------------------------------------------
architecture DATA_a of DATA_e is

    component OnePortRam is
		PORT
		(
			aclr		: IN STD_LOGIC  := '0';
			address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rden		: IN STD_LOGIC  := '1';
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
--------------------------------------------------------------------------------
signal SIG_XY : std_logic_vector(31 downto 0) := (others => '0');
signal maxVALUE : std_logic_vector(9 downto 0) := (others => '0');
signal ADDR_COUNT : std_logic_vector(9 downto 0) := (others => '0');
signal ADDR : std_logic_vector(9 downto 0) := (others => '0');
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
OnePortRAM_inst : OnePortRam 
PORT MAP (
        aclr	 => CLEAR,
        address	 => ADDR,
        clock	 => CK,
        data	 => DATA,
        rden	 => RD_EN,
        wren	 => WR_EN,
        q	 => SIG_XY
        );
--------------------------------------------------------------------------------
ADDR_proc : process(CK, CLEAR, WR_EN, RD_EN, SEND_NEW)
begin
    if CLEAR = '1' then
        ADDR_COUNT <= (others => '0');
        ADDR <= (others => '0');
    elsif rising_edge(CK) then
        if WR_EN = '1' then
            ADDR <= ADDRESS;
            ADDR_COUNT <= (others => '0');
        elsif (RD_EN and SEND_NEW) = '1' then
            if ADDR_COUNT = maxVALUE then
				ADDR <= ADDR_COUNT;
                ADDR_COUNT <= (others => '0');
            else    
                ADDR <= ADDR_COUNT;
                ADDR_COUNT <= ADDR_COUNT + x"1";
            end if;
        end if;
    end if;
end process ADDR_proc;
--------------------------------------------------------------------------------
-- calculate the highes number of the ram entry
maxValue_proc: process(CK, CLEAR, WR_EN)
begin
    if CLEAR = '1' then
        maxVALUE <= (others => '0');
    elsif rising_edge(CK) then
        if WR_EN = '1' then
            maxVALUE <= ADDRESS;
        end if;
		MAXVAL <= maxValue;
    end if; 
end process maxValue_proc;
--------------------------------------------------------------------------------
assign_proc : process(CK, RD_EN, SEND_NEW)
begin
	if rising_edge(CK) then
		if (RD_EN and SEND_NEW) = '1' then
			DATAX <= SIG_XY(31 downto 16);
			DATAY <= SIG_XY(15 downto 0);
			NEWDATA_AVA <= '1';
		else
			NEWDATA_AVA <= '0';
		end if;
	end if;
end process assign_proc;
--------------------------------------------------------------------------------
end architecture DATA_a;
