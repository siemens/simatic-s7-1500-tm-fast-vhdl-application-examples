----------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
--
-- Create Date:    04/06/2020 
-- Design Name:    TM FAST logic library
-- Module Name:    Encoder_e - Encoder_a
-- Description:    Encoder interface.
--
-- Revision: 
-- Revision 1.0 - File modified 05/20/2021
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Encoder_e is
    Generic ( 
        BIT_WIDTH : natural
    );
    
    Port (
        RST          : in  std_logic;
        CLK          : in  std_logic;
        STOP         : in  std_logic;
		CLKEN  		 : in  std_logic;
        PULSECLEAR   : in  std_logic;
        LOAD         : in  std_logic;
        CD           : in  std_logic;
        CU           : in  std_logic;
        EDGE         : in  std_logic;
        MISSINGSUPPLY: in  std_logic;
        CNT_TYPE     : in  std_logic_vector(1 downto 0); 
        CNT_DIR      : in  std_logic;   -- selects whether counting up (0) or counting down (1) is the main count direction
        HOLDSW       : in  std_logic;
        HOLDHW       : in  std_logic;
        HOLDSOURCE   : in  std_logic_vector (2 downto 0);
        RESETSW      : in  std_logic;
        RESETHW      : in  std_logic;
        RESETSOURCE  : in  std_logic_vector (2 downto 0);
        MAX_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        MIN_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        RESET_VALUE  : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        LOAD_VALUE   : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        ENCODERCOUNT : out std_logic_vector ((BIT_WIDTH-1) downto 0);
        HOME         : out std_logic;
        HOMED        : out std_logic;
        UNDERFLOW    : out std_logic;
        OVERFLOW     : out std_logic;
        LASTCOUNTDIR : out std_logic
    );
end Encoder_e;

architecture Encoder_a of Encoder_e is
    constant ZERO      : std_logic_vector ((BIT_WIDTH-1) downto 0):= (others => '0');
    constant FULL      : std_logic_vector ((BIT_WIDTH-1) downto 0):= (others => '1');
    
    signal D           : std_logic_vector ((BIT_WIDTH-1) downto 0):= ZERO;
    signal CV          : std_logic_vector ((BIT_WIDTH-1) downto 0):= ZERO;
    signal ATMAX       : std_logic := '0';
    signal ATMIN       : std_logic := '0';
    signal LOAD_N      : std_logic := '0';
    signal RESET       : std_logic := '0';
    signal HOLD        : std_logic := '0';
    signal LOADLATCHED : std_logic := '0';
    signal SW_RESET_LAT: std_logic := '0';
    signal SW_HOLD_LAT : std_logic := '0';
    signal RESETSEL    : std_logic := '0';
    signal RESETOUT    : std_logic := '0';
    signal HOLDSEL     : std_logic := '0';
    signal UP          : std_logic := '0';
    signal DOWN        : std_logic := '0';
    signal LC0         : std_logic := '0';
    signal LC1         : std_logic := '0';
    signal CONTINUOUS  : std_logic := '0';
    signal GOINGOVER   : std_logic := '0';
    signal GOINGUNDER  : std_logic := '0';
    signal ENCODERLOAD : std_logic := '0';
    signal INC_EN      : std_logic := '0';
    signal UP_EN       : std_logic := '0';
    signal DN_EN       : std_logic := '0';
    signal SINGLE      : std_logic := '0';
    signal D_FDR       : std_logic := '0';
    signal Q_FDR       : std_logic := '0';
    signal Q_HOME      : std_logic := '0';
    signal Q_HOMED     : std_logic := '0';
    signal Q_OF        : std_logic := '0';
    signal Q_UF        : std_logic := '0';
    signal Q_GO_OVER   : std_logic := '0';
    signal D_GO_OVER   : std_logic := '0';
    signal Q_GO_UNDER  : std_logic := '0';
    signal D_GO_UNDER  : std_logic := '0';
    signal Q_FDC       : std_logic := '0';
    signal D_FDC       : std_logic := '0';
    signal count       : std_logic_vector((BIT_WIDTH-1) downto 0):= ZERO;
     
begin

-- standard logic code
    SINGLE     <= '1' when (CNT_TYPE = "10") else '0';
    CONTINUOUS <= '1' when (CNT_TYPE = "00") else '0';
    
            --Periodic occurs when not single and not continuous     
    LOAD_N       <= NOT(LOADLATCHED);
    LASTCOUNTDIR <= LC1;
    D_FDR        <= (Q_FDR or GOINGOVER or GOINGUNDER);
    --D_FDC        <= (RESET or Q_FDC or not(Q_HOME));
    UP           <= (CU and not(HOLD or (SINGLE and Q_FDR)));
    DOWN         <= (CD and not(HOLD or (SINGLE and Q_FDR)));
    GOINGOVER    <= ATMAX and UP and (CONTINUOUS or not(CNT_DIR));
    D_GO_OVER    <= GOINGOVER or (Q_GO_OVER and (Q_GO_OVER nand CLKEN)); 
    D_GO_UNDER   <= GOINGUNDER or (Q_GO_UNDER and (Q_GO_UNDER nand CLKEN));
    GOINGUNDER   <= ATMIN and DOWN and (CONTINUOUS or CNT_DIR);
    ENCODERLOAD  <= (LOADLATCHED or RESET or GOINGOVER or GOINGUNDER);
    UP_EN        <= UP and not(DOWN);
    DN_EN        <= not(UP) and DOWN;
    INC_EN       <= (UP_EN or DN_EN or ENCODERLOAD);
    CV           <= count;
    HOME         <= Q_HOME;
    HOMED        <= Q_HOMED;
    OVERFLOW     <= Q_OF;
    UNDERFLOW    <= Q_UF;

-- Latch LOAD, RESETSW, and HOLDSW 
    P_LOAD: process (CLK, RST) 
    begin
        if (RST = '1') then
            LOADLATCHED  <= '0';
            SW_RESET_LAT <= '0';
            SW_HOLD_LAT  <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                LOADLATCHED  <= '0';
                SW_RESET_LAT <= '0';
                SW_HOLD_LAT  <= '0';
            else
                LOADLATCHED  <= LOAD;
                SW_RESET_LAT <= RESETSW;
                SW_HOLD_LAT  <= HOLDSW;
            end if;
        end if;
    end process P_LOAD;

    -- select Counter Load value
    P_LOADSEL: process (RESET, LOAD_N, ATMAX, RESET_VALUE, LOAD_VALUE, MIN_VALUE, MAX_VALUE) 
    begin
        if (RESET = '1') then
            D <= RESET_VALUE;
        elsif (LOAD_N = '0') then
            D <= LOAD_VALUE;
        elsif (ATMAX = '1') then
            D <= MIN_VALUE;
        else
            D <= MAX_VALUE;
        end if;
    end process P_LOADSEL;
     

    -- Reset source selection
    RESETSEL <= RESETHW                    when (RESETSOURCE = "001") else
                SW_RESET_LAT               when (RESETSOURCE = "010") else
                (RESETHW and SW_RESET_LAT) when (RESETSOURCE = "011") else
                (RESETHW or SW_RESET_LAT)  when (RESETSOURCE = "100") else
                '0';
    
    -- Hold source selection
    HOLDSEL <= HOLDHW                   when (HOLDSOURCE = "001") else   
               SW_HOLD_LAT              when (HOLDSOURCE = "010") else  
               (HOLDHW and SW_HOLD_LAT) when (HOLDSOURCE = "011") else  
               (HOLDHW or SW_HOLD_LAT)  when (HOLDSOURCE = "100") else 
               '0';

    -- Latch RESETSEL (reset source select)     
    P_RESET:    process (CLK, RST) 
    begin
        if (RST = '1') then
            RESETOUT <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                RESETOUT <= '0';
            else
                RESETOUT <= RESETSEL;
            end if;
        end if;
    end process P_RESET;
     
    -- RESET and HOLD     
    P_HOLDRST: process (EDGE,RESETOUT,HOLDSEL) 
    begin    
        if (EDGE = '1') then
            RESET <= RESETOUT and not(HOLDSEL);
            HOLD <= HOLDSEL;
        else
            RESET <= RESETOUT;
            HOLD <= HOLDSEL and not(RESETOUT);
        end if;
    end process P_HOLDRST;

    -- Min value reached?
    ATMIN <= '1' when (CV = MIN_VALUE) else '0';
    -- Max value reached?
    ATMAX <= '1' when (CV = MAX_VALUE) else '0';
     
    -- Last Count Direction
    P_LASTCNTDIR: process (CLK, RST) 
    begin
        if (RST = '1') then
            LC0 <= '0';
            LC1 <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                LC0 <= '0';
                LC1 <= '0';
            else
                if (UP = '1') then
                    LC0 <= '0';
                elsif (DOWN = '1') then
                    LC0 <= '1';
                end if;
				if (CLKEN = '1') then
					LC1 <= LC0;
				end if;
            end if;
        end if;                
    end process P_LASTCNTDIR;

    -- UP/DOWN Control
    P_UPDN:    process (CLK, RST) 
    begin
        if (RST = '1') then
            Q_FDR <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q_FDR <= '0';
            else
                if (PULSECLEAR = '1' or RESET = '1' or LOADLATCHED = '1') then
                    Q_FDR <= '0';
                else
                    Q_FDR <= D_FDR;
                end if;
            end if;
        end if;
    end process P_UPDN;
     
    -- HOME function
    P_HOME: process (CLK, RST) 
    begin
        if (RST = '1') then
            Q_HOME <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q_HOME <= '0';
            else
                if (MISSINGSUPPLY = '1') then
						  Q_HOME <= '0';
                elsif (CLKEN = '1') then
                    Q_HOME <= RESET;
                end if; 
            end if;
        end if;
    end process P_HOME;

    -- HOMED function
    P_HOMED: process (CLK, RST) 
    begin
        if (RST = '1') then
            Q_HOMED <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q_HOMED <= '0';
            else
                if (MISSINGSUPPLY = '1') then
                    Q_HOMED <= '0';
                elsif (CLKEN = '1') then
                    Q_HOMED <= Q_HOME or Q_HOMED;
				    end if;
            end if;
        end if;
    end process P_HOMED;


    -- OVERFLOW function
    P_OVERFLOW: process (CLK, RST) 
    begin
        if (RST = '1') then
            Q_OF      <= '0';
            Q_GO_OVER <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q_OF      <= '0';
                Q_GO_OVER <= '0';
            else
                Q_GO_OVER <= D_GO_OVER;
					 if (CLKEN = '1') then
							Q_OF <= Q_GO_OVER;
					 end if;
            end if;
        end if;
    end process P_OVERFLOW;


    -- UNDERFLOW function
    P_UNDERFLOW: process (CLK, RST) 
    begin
        if (RST = '1') then
            Q_UF       <= '0';
            Q_GO_UNDER <= '0';
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                Q_UF       <= '0';
                Q_GO_UNDER <= '0';
            else
                Q_GO_UNDER <= D_GO_UNDER;
					 if (CLKEN = '1') then
                    Q_UF <= Q_GO_UNDER;
                end if;
            end if;
        end if;
    end process P_UNDERFLOW;
     
    -- Encoder counting function
    Encoder_p: process(CLK, RST) 
    begin
        if (RST = '1') then
            count <= ZERO;
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                count <= ZERO;
            else
                if (PULSECLEAR = '1') then
                    count <= ZERO;
                else    
                    if (ENCODERLOAD = '1') then
                        count <= D;
                    elsif (INC_EN = '1') then
                        if (UP = '1') then
                            if (count = FULL ) then
                                count <= ZERO;
                            else
                                count <= count + 1;
                            end if;
                        else
                            if (count = ZERO) then
                                count <= FULL;
                            else
                                count <= count - 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;    
        end if;
    end process Encoder_p;

    -- Latch encoder value
    P_ENCCNTLATCH: process (CLK, RST) 
    begin
        if (RST = '1') then
            ENCODERCOUNT <= ZERO;
        elsif rising_edge ( CLK ) then
            if (STOP = '1') then
                ENCODERCOUNT <= ZERO;
            else
					 if (CLKEN = '1') then
                    ENCODERCOUNT <= CV;
                end if;
            end if;
        end if;
    end process P_ENCCNTLATCH;

end Encoder_a;

