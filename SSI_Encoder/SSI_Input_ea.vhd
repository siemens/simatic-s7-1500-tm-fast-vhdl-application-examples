----------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
-- 
-- Create Date:    16:47:58 10/06/2023 
-- Design Name:    TM FAST_FPGA
-- Module Name:    SSI_Input_e - SSI_Input_a
-- Project Name:   TM FAST FPGA REDESIGN
--
-- Revision: 
-- Revision 1.0 - File Created
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SSI_new_Input_e is
    Generic (
        BIT_WIDTH   : integer range 13 to 32;
		SHIFT_DIR   : string;
		SHIFT_COUNT : integer range  0 to 32;
        FRAME_WIDTH : integer range 13 to 32
    );
    Port ( 
        RST          : in  STD_LOGIC;
        CLK          : in  STD_LOGIC;
        GRAY_BIN_N   : in  STD_LOGIC;
        SSICLOCK     : in  STD_LOGIC;
        SSI_LATCH    : in  STD_LOGIC;
        SSI_DATA_IN  : in  STD_LOGIC;
        ENCODERCOUNT : out STD_LOGIC_VECTOR ((BIT_WIDTH - 1) downto 0);
		DATAAVAILABLE: out STD_LOGIC;
		FRAME_OVERRUN: out STD_LOGIC
    );
end SSI_new_Input_e;

architecture SSI_new_Input_a of SSI_new_Input_e is

	 signal SSI_VALUE       : std_logic_vector((FRAME_WIDTH - 1) downto 0)  := (others => '0');
	 signal LAST_SSI_VALUE  : std_logic_vector((FRAME_WIDTH - 1) downto 0)  := (others => '0');
     signal FALL_EDGE       : std_logic_vector(1 downto 0)                  := (others => '0');
     signal REG             : std_logic_vector(FRAME_WIDTH downto 0)        := (others => '0');
	 signal CNV_VALUE       : std_logic_vector((FRAME_WIDTH - 1) downto 0)  := (others => '0');
	 signal NEW_ACQ         : std_logic := '0';
	 signal SSI_LATCH_EDGE  : std_logic_vector(1 downto 0) := (others => '0');
	 signal CRC             : std_logic_vector((BIT_WIDTH - FRAME_WIDTH -1) downto 0):= (others => '0');

	 
	 Function Gray_to_Bin(gray_val : unsigned) return unsigned is
		  variable i : integer;
		  variable bin_val : unsigned((gray_val'length - 1) downto 0);
	 begin
		  bin_val(gray_val'length - 1) := gray_val(gray_val'length - 1);
		  for i in (gray_val'length-2) downto 0 loop
				bin_val(i) := bin_val(i + 1) xor gray_val(i);
		  end loop;
		 
		 return bin_val;
	end Function;
	 
begin

    FRAME_OVERRUN <= NEW_ACQ;
    DATAAVAILABLE <= not(NEW_ACQ);
   --DATA AVAILABLE VALID--
    VALID_p: PROCESS(CLK, RST)
    BEGIN
    if RST = '1' then
		NEW_ACQ <= '0';
    elsif rising_edge(CLK) then
    	if LAST_SSI_VALUE = SSI_VALUE then
			NEW_ACQ <= '0';
		else
			NEW_ACQ <= '1';
		end if;
    end if;
    END PROCESS;
	
	
   --Reading Value PROCESS-- 
	 INPUT_PROC: PROCESS(CLK,RST)
	 variable cnt : integer := FRAME_WIDTH; 
	 BEGIN
	  if RST = '1' then
		SSI_VALUE <= (others => '0');
		FALL_EDGE <= (others => '0');
		REG <= (others => '0');
		LAST_SSI_VALUE <= (others => '0');
	 elsif rising_edge(CLK) then
		FALL_EDGE(1) <= FALL_EDGE(0);
		FALL_EDGE(0) <= SSICLOCK;
		SSI_LATCH_EDGE(1) <= SSI_LATCH_EDGE(0);
		SSI_LATCH_EDGE(0) <= SSI_LATCH;
		if SSI_LATCH_EDGE = "10" then
			cnt := FRAME_WIDTH;
            LAST_SSI_VALUE <= SSI_VALUE;
			SSI_VALUE <= REG((FRAME_WIDTH - 1) downto 0);
		else	
		   if cnt < 0 then
				cnt := cnt;
			elsif FALL_EDGE = "10" then
				REG(cnt) <= SSI_DATA_IN;
				cnt := cnt - 1;
			end if;
		end if;	
	 end if;
    END PROCESS;
	 
	 --Grey or Binary Value--
	 OUTPUT_VALUE: PROCESS(CLK, RST)
	 BEGIN
		if RST = '1' then
			CNV_VALUE <= (others => '0');
		elsif rising_edge(CLK) then
			if GRAY_BIN_N = '0' then
				CNV_VALUE <= std_logic_vector(Gray_to_bin(unsigned(SSI_VALUE))); --conversion before justification Gray to Binary
			else
				CNV_VALUE <= SSI_VALUE;
			end if;
		end if;
	 END PROCESS;
    
	 --Position Value is shifted after the conversion
	 JUSTIFY_VALUE: PROCESS(CLK,RST)
	 BEGIN
		if RST = '1' then
			ENCODERCOUNT <= (others => '0');
		elsif rising_edge(CLK) then
		   if SHIFT_DIR = "right" then
				ENCODERCOUNT <= CRC & std_logic_vector(shift_right(unsigned(CNV_VALUE), SHIFT_COUNT));
			else
				ENCODERCOUNT <= CRC & std_logic_vector(shift_left(unsigned(CNV_VALUE), SHIFT_COUNT));
			end if;
		end if;
	 END PROCESS;
    
end SSI_new_Input_a;

