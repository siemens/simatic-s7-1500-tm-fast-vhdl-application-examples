----------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST_FPGA
-- Module Name:    SSI_Input_e - SSI_Input_a
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;

entity SSI_Input_e is
    Generic (
        BIT_WIDTH   : integer range 10 to 64 := 16;
        SHIFT_DIR   : string                 := "right";
        SHIFT_COUNT : integer range  0 to 64 :=  0;
        CLOCKSEL    : integer                :=  0;
        FRAME_WIDTH : integer range 10 to 64 := 13
    );
    Port (
        RST          : in  STD_LOGIC;
        CLK          : in  STD_LOGIC;
        LISTEN       : in  STD_LOGIC;
        GRAY_BIN_N   : in  STD_LOGIC;
        SSICLOCK     : in  STD_LOGIC;
        SSI_LATCH    : in  STD_LOGIC;
        SSI_DATA_IN  : in  STD_LOGIC;
        ENCODERCOUNT : out STD_LOGIC_VECTOR ((BIT_WIDTH - 1) downto 0);
        DATAAVAILABLE: out STD_LOGIC;
        FRAME_OVERRUN: out STD_LOGIC

    );
end SSI_Input_e;

architecture SSI_Input_a of SSI_Input_e is

     signal SSI_VALUE       : std_logic_vector((FRAME_WIDTH - 1) downto 0)  := (others => '0');
     signal FALL_EDGE       : std_logic_vector(1 downto 0)                  := (others => '0');
     signal REG             : std_logic_vector(FRAME_WIDTH downto 0)        := (others => '0');
     signal CNV_VALUE       : std_logic_vector((FRAME_WIDTH - 1) downto 0)  := (others => '0');
     signal SSI_LATCH_EDGE  : std_logic_vector(1 downto 0) := (others => '0');
     signal SSI_CLOCK_EDGE  : std_logic_vector(1 downto 0) := (others => '0');
     signal CRC             : std_logic_vector((BIT_WIDTH - FRAME_WIDTH -1) downto 0):= (others => '0');
     signal START_FRAME     : std_logic := '1';
     signal END_FRAME           : std_logic := '1';
     signal RISING_CNT      : integer := 0;
     signal CLK_DIV     : natural;
     signal CLK_DIV_STD : unsigned(8 downto 0) := (others => '0');
     signal SSI_LATCH_L : std_logic := '0';
     signal SSI_LATCH_Q : std_logic := '0';




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

    CLK_DIV_STD  <= to_unsigned(CLK_DIV, CLK_DIV_STD'length);
    SSI_LATCH_Q  <= SSI_LATCH_L when (LISTEN = '1') else SSI_LATCH;

    CLK_DIV   <=  20   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 0) else
                  60  when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 0) else
                      100  when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 0) else
                      200  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 0) else
                      300  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 0) else
                      --Clk counter for 250KHz Clockout
                      10   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 1) else
                 30   when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 1) else
                      50  when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 1) else
                      100  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 1) else
                      150  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 1) else
                      --Clk counter for 500KHz Clockout
                      5   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 2) else
                 15   when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 2) else
                      25   when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 2) else
                      50  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 2) else
                      75  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 2) else
                      --Clk counter for 1MHz Clockout
                      2    when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 3) else
                 7    when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 3) else
                      12   when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 3) else
                      25   when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 3) else
                      37;


   SSI_LATCH_L_p: PROCESS(CLK, RST)
    variable rising_cnt : natural := 0;
    variable cnt : natural := 0;
    BEGIN
        if RST = '1' then
            SSI_LATCH_L <= '0';
            cnt := 0;
            rising_cnt := 0;
        elsif rising_edge(CLK) then
            RISING_CNT := rising_cnt;
            if SSI_CLOCK_EDGE = "01" then
                cnt := 0;
                rising_cnt := rising_cnt + 1;
            else
                cnt := cnt + 1;
            end if;
            if cnt > shift_left(CLK_DIV_STD, 1) then
                rising_cnt := 0;
            end if;
           if rising_cnt = (FRAME_WIDTH + 1) then
               if cnt >= CLK_DIV then
                    SSI_LATCH_L <= '1';
                else
                    SSI_LATCH_L <= '0';
                end if;
            else
                SSI_LATCH_L <= '0';
            end if;
        end if;
    END PROCESS;


    START_END_FRAME_p: PROCESS(CLK, RST)
    variable cnt_frame : integer := 0;
    variable cnt_rising: integer := 0;
    variable cnt_end_frame : integer := 0;
    BEGIN
        if RST = '1' then
            SSI_CLOCK_EDGE <= (others => '0');
            DATAAVAILABLE <= '0';
            FRAME_OVERRUN <= '0';
            START_FRAME   <= '0';
            END_FRAME     <= '0';
            cnt_frame := 0;
            cnt_end_frame:= 0;
        elsif rising_edge(CLK) then
            SSI_CLOCK_EDGE(1) <= SSI_CLOCK_EDGE(0);
            SSI_CLOCK_EDGE(0) <= SSICLOCK;
            if SSI_LATCH_EDGE = "10" then
                cnt_frame  := 0;
                cnt_end_frame := 0;
                START_FRAME <= '0';
                END_FRAME   <= '0';
            elsif SSI_CLOCK_EDGE(1) = NOT(SSI_CLOCK_EDGE(0)) then
                cnt_frame := cnt_frame + 1;
            end if;
            if cnt_frame = 1 and SSI_DATA_IN = '0' then
                START_FRAME <= '1';
            end if;
            if RISING_CNT = (FRAME_WIDTH +1) and SSI_DATA_IN = '1' then
                cnt_end_frame := cnt_end_frame + 1;
                if cnt_end_frame > CLK_DIV then
                    END_FRAME <= '1';
                end if;
            end if;
            if SSI_LATCH_Q = '1' then
                FRAME_OVERRUN <= START_FRAME or END_FRAME;
            end if;
            DATAAVAILABLE <= NOT(FRAME_OVERRUN);
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
        cnt := 0;
     elsif rising_edge(CLK) then
        FALL_EDGE(1) <= FALL_EDGE(0);
        FALL_EDGE(0) <= SSICLOCK;
        SSI_LATCH_EDGE(1) <= SSI_LATCH_EDGE(0);
        SSI_LATCH_EDGE(0) <= SSI_LATCH_Q;
        if SSI_LATCH_EDGE = "10" then
            cnt := FRAME_WIDTH;
            if FRAME_OVERRUN = '0' then
                SSI_VALUE <= REG((FRAME_WIDTH - 1) downto 0);
            else
                SSI_VALUE <= SSI_VALUE;
            end if;
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

end SSI_Input_a;

