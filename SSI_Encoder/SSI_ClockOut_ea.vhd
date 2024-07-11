----------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
-- 
-- Create Date:    16:14:51 30/05/2023 
-- Design Name:    SSI_ClockOut_FPGA
-- Module Name:    SSI_ClockOut_e - SSI_ClockOut_a
-- Project Name:   TM FAST FPGA DESIGN
-- Dependencies: 
--
-- Revision: 
-- Revision 1.0 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;


entity SSI_ClockOut_e is
    Generic (
          BIT_WIDTH   : integer;
		    MONOFLOPSEL : integer;
		    CLOCKSEL    : integer;
          FRAME_WIDTH : integer
    );
    Port ( 
        RST        : in  STD_LOGIC;
        CLK        : in  STD_LOGIC;		  
        SSICLOCK   : out STD_LOGIC;
        SSI_LATCH  : out STD_LOGIC := '0'
    );
end SSI_ClockOut_e;

architecture SSI_ClockOut_a of SSI_ClockOut_e is


signal CLK_CNT     : natural;
Signal CLK_CNT_STD : unsigned (11 downto 0);
signal MONOFLOP    : natural;
signal CLK_OUT     : std_logic := '0';

type Clk_Zykl is (Start, Idlestate, Monoflopstate, Delay);
signal State : Clk_Zykl;

    
begin
   
    SSICLOCK    <= CLK_OUT;
	CLK_CNT_STD <= to_unsigned(CLK_CNT, CLK_CNT_STD'length);
	
	--CLOCK Signal division factor
					  --Clk counter for 125KHz Clockout  
	CLK_CNT   <=  40   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 0) else 
                 120  when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 0) else
					  200  when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 0) else
					  400  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 0) else
					  600  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 0) else
					  --Clk counter for 250KHz Clockout
					  20   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 1) else 
                 60   when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 1) else
					  100  when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 1) else
					  200  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 1) else
					  300  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 1) else
					  --Clk counter for 500KHz Clockout
					  10   when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 2) else 
                 30   when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 2) else
					  50   when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 2) else
					  100  when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 2) else
					  150  when (F_CLK_USER = 75_000_000) AND (CLOCKSEL = 2) else
					  --Clk counter for 1MHz Clockout
					  5    when (F_CLK_USER = 5_000_000 ) AND (CLOCKSEL = 3) else 
                 15   when (F_CLK_USER = 15_000_000) AND (CLOCKSEL = 3) else
					  25   when (F_CLK_USER = 25_000_000) AND (CLOCKSEL = 3) else
					  50   when (F_CLK_USER = 50_000_000) AND (CLOCKSEL = 3) else
					  75;
	
	
	               --Monoflop for 16us
	MONOFLOP   <=  78   when (F_CLK_USER = 5_000_000)  AND (MONOFLOPSEL = 0) else  
                  233  when (F_CLK_USER = 15_000_000) AND (MONOFLOPSEL = 0) else  
                  388  when (F_CLK_USER = 25_000_000) AND (MONOFLOPSEL = 0) else
					   775  when (F_CLK_USER = 50_000_000) AND (MONOFLOPSEL = 0) else  
					   1163 when (F_CLK_USER = 75_000_000) AND (MONOFLOPSEL = 0) else
						--Monoflop for 32us
						158  when (F_CLK_USER = 5_000_000)  AND (MONOFLOPSEL = 1) else
                  473  when (F_CLK_USER = 15_000_000) AND (MONOFLOPSEL = 1) else
                  788  when (F_CLK_USER = 25_000_000) AND (MONOFLOPSEL = 1) else 
					   1575 when (F_CLK_USER = 50_000_000) AND (MONOFLOPSEL = 1) else
					   2363 when (F_CLK_USER = 75_000_000) AND (MONOFLOPSEL = 1) else 
						--Monoflop for 48us
						238  when (F_CLK_USER = 5_000_000)  AND (MONOFLOPSEL = 2) else 
                  713  when (F_CLK_USER = 15_000_000) AND (MONOFLOPSEL = 2) else 
                  1188 when (F_CLK_USER = 25_000_000) AND (MONOFLOPSEL = 2) else
					   2375 when (F_CLK_USER = 50_000_000) AND (MONOFLOPSEL = 2) else  
					   3563 when (F_CLK_USER = 75_000_000) AND (MONOFLOPSEL = 2) else
						--Monoflop for 64us
						318  when (F_CLK_USER = 5_000_000)  AND (MONOFLOPSEL = 3) else
                  953  when (F_CLK_USER = 15_000_000) AND (MONOFLOPSEL = 3) else
                  1588 when (F_CLK_USER = 25_000_000) AND (MONOFLOPSEL = 3) else
					   3175 when (F_CLK_USER = 50_000_000) AND (MONOFLOPSEL = 3) else
					   4763;
					  

					  					
	CLK_DIV: PROCESS(CLK,RST)
	variable cnt          : natural := 0;
	variable counter      : natural := 0;
	variable counter_Hz   : natural := 0;
	BEGIN
		if RST = '1' then
			CLK_OUT <= '1';
		elsif rising_edge(CLK) then
			case State is
				when Start =>  ----------------------------------START STATE----------------           
				   SSI_LATCH <= '0';
					CLK_OUT   <= '1';
					State     <= Idlestate;
					counter    := FRAME_WIDTH + 1 ; 
                    counter_Hz := CLK_CNT - 1;							
				when Idlestate =>  ------------------------------IDLE STATE-----------------
					SSI_LATCH <= '0';
	                CLK_OUT   <= '0';				     	
					if counter < 1 then
						counter := MONOFLOP - 1 ;
						cnt     := CLK_CNT - 1;
						State   <= Monoflopstate;
					else
						if counter_Hz = 0 then
						   counter_Hz := CLK_CNT - 1;
						   counter := counter - 1;
						elsif counter_Hz <= shift_right(CLK_CNT_STD, 1) then 
							counter_Hz := counter_Hz - 1;
							CLK_OUT <= '0';
						else 
						   CLK_OUT <= '1';
						   counter_Hz := counter_Hz - 1;
						end if;
					end if;
				when Monoflopstate =>  ---------------------------MONOFLOP STATE--------------
                    CLK_OUT <= '1';						
					if counter < 1 then
						counter := MONOFLOP - 1 ;
						State   <= Delay;
					else	
						counter := counter - 1;
					end if;
					
					if cnt < 1 then
						SSI_LATCH <= '0';
					elsif cnt <= shift_right(CLK_CNT_STD, 1) and cnt > 0 then
						SSI_LATCH <= '1';
						cnt := cnt - 1;
					else 
						SSI_LATCH <= '0';
						cnt := cnt - 1;
					end if;
					
				when Delay => -------------------------------------DELAY STATE-----------------
                    CLK_OUT <= '1';				
					if counter < 1 then
						counter := FRAME_WIDTH + 1;
						State   <= Idlestate;
					else	
						counter := counter - 1;
					end if;
			end case;		
		 end if;
	END PROCESS;   
 	  

end SSI_ClockOut_a;

