--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- heading architecture of Bresenham Algorithmus                              --
--                                                                            --
-- filename TFL_FAST_USER_Bresenham.vhd                          	          --
--                                                                            --  
-- copyright    (c) Siemens AG, Automation Systems                            --  
--                                                                            --
-- version      V2.21042023                                                   --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity BRESENHAM_e is
port(
    CK : in std_logic;
    NEWIN : in std_logic;
    xstart : in std_logic_vector(15 downto 0);
    ystart : in std_logic_vector(15 downto 0);
    xend : in std_logic_vector(15 downto 0);
    yend : in std_logic_vector(15 downto 0);
	 SEND_NEW : in std_logic;
    DONE : out std_logic;
    READY : out std_logic;
    NEWQ : out std_logic;
    XOUT : out std_logic_vector(15 downto 0);
    YOUT : out std_logic_vector(15 downto 0)
);
end entity BRESENHAM_e;
--------------------------------------------------------------------------------
architecture BRESENHAM_a of BRESENHAM_e is
--------------------------------------------------------------------------------
component FSM_BRESENHAM_e is
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
end component;
--------------------------------------------------------------------------------
signal u_xstart, u_ystart, u_xend, u_yend : unsigned(15 downto 0);
signal t : unsigned(15 downto 0) := (others => '0');
signal dsdir, dfdir : unsigned(15 downto 0);
signal pdx, pdy, ddx, ddy : signed (1 downto 0);
signal ic : unsigned(3 downto 0);
signal LAST, LOAD1, LOAD2, CALC : std_logic;
signal wait_calc : std_logic;
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
i_FSM : FSM_BRESENHAM_e
port map(
    CK => CK,
    START => NEWIN,
    LAST => LAST,
    LOAD1 => LOAD1,
    LOAD2 => LOAD2,
    CALC => CALC,
    DONE => DONE,
    READY => READY
);
--------------------------------------------------------------------------------
load_proc : process(CK, LOAD1, NEWIN)
variable incx, incy : signed(1 downto 0) := (others => '0');
variable dx, dy : unsigned(15 downto 0) := (others => '0');
begin
    if rising_edge(CK) then
        if (NEWIN = '1') then
            u_xstart <= unsigned(xstart);
		    u_ystart <= unsigned(ystart);
		    u_xend <= unsigned(xend);
		    u_yend <= unsigned(yend);

        elsif (LOAD1 = '1') then
                if (u_xend > u_xstart) then
                    dx := u_xend - u_xstart;
                    incx := "01";
                else
                    dx := u_xstart - u_xend;
                    incx := "11"; -- (-1)dec
                end if;

                if (u_yend > u_ystart) then
                    dy := u_yend - u_ystart;
                    incy := "01";
                else
                    dy := u_ystart - u_yend;
                    incy := "11"; -- (-1)dec
                end if;

                if (dx > dy) then
                    pdx <= incx;
                    pdy <= "00";
                    ddx <= incx;
                    ddy <= incy;
                    dsdir <= dy;
                    dfdir <= dx;
                else
                    pdx <= "00";
                    pdy <= incy;
                    ddx <= incx;
                    ddy <= incy;
                    dsdir <= dx;
                    dfdir <= dy;
                end if;
        end if;
    end if;
end process load_proc;
--------------------------------------------------------------------------------
calc_proc : process (CK, LOAD2, CALC)
variable err : signed (16 downto 0) := (others => '0');
variable x, y : signed(16 downto 0) := (others => '0');
begin
    if rising_edge(CK) then
        if (LOAD2 = '1') then
            x := signed('0' & std_logic_vector(u_xstart));
            y := signed('0' & std_logic_vector(u_ystart));
            ic <= (others => '0');
            t <= (others => '0');
            err := signed("00" & std_logic_vector(dfdir(15 downto 1)));
			wait_calc <= '0';
        elsif (CALC = '1' AND wait_calc = '0') then
            if ((t <= dfdir)) then
                err := err - signed(dsdir);
                if (err < ('0' & x"0000")) then
                    err := err + signed(dfdir);
                    x := x + ddx;
                    y := y + ddy;
                else
                    x := x + pdx;
                    y := y + pdy;
                end if;

                if (ic = x"F") then
                    ic <= (others => '0');
                    NEWQ <= '1';
						  wait_calc <= '1';
                    XOUT <= std_logic_vector(x(15 downto 0));
                    YOUT <= std_logic_vector(y(15 downto 0));
                else
                    NEWQ <= '0';
                    ic <= ic + x"1";
                end if;

                t <= t + x"1";
                LAST <= '0';
            else
                NEWQ <= '1';
					 wait_calc <= '1';
                XOUT <= std_logic_vector(u_xend);
                YOUT <= std_logic_vector(u_yend);
            end if;
			elsif (CALC = '1' AND wait_calc = '1') then
				if (SEND_NEW = '1' and (t<=dfdir)) then
					wait_calc <= '0';
				elsif (SEND_NEW = '1' and not(t<=dfdir)) then
					LAST <= '1';
					wait_calc <= '0';
				end if;
			else
				t <= (others => '0');
				LAST <= '0';
            NEWQ <= '0';
        end if;
		  
    end if;
end process calc_proc;
--------------------------------------------------------------------------------                
end architecture BRESENHAM_a;
