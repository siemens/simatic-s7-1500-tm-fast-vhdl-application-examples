--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of Interpolation    				                  --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_Interpolation.vhd                      	  --
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
entity INTERPOLATION_e is
port(
    CK : in std_logic;
    CLEAR : in std_logic;
    MODE_ACTIVE : in std_logic;
    WRITE_EN : in std_logic;
    READ_EN : in std_logic;
    SEND : in std_logic;
    ADDRESS : in std_logic_vector(9 downto 0);
    DATA_IN : in std_logic_vector(31 downto 0);
    DATAX : out std_logic_vector(15 downto 0);
    DATAY : out std_logic_vector(15 downto 0)
);
end entity INTERPOLATION_e;
--------------------------------------------------------------------------------
architecture INTERPOLATION_a of INTERPOLATION_e is 

component DATA_e is
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
end component;

component EDGE_e is 
    port(
	    CK : in std_logic;
	    SIG_IN: in std_logic;
	    POS_EDGE: out std_logic;
        NEG_EDGE: out std_logic
    );
end component;

component BRESENHAM_e is
    port(
        CK : in std_logic;
        NEWIN : in std_logic; -- new points for interpolation
        xstart : in std_logic_vector(15 downto 0);
        ystart : in std_logic_vector(15 downto 0);
        xend : in std_logic_vector(15 downto 0);
        yend : in std_logic_vector(15 downto 0);
		  SEND_NEW : in std_logic;
        DONE : out std_logic; -- single point
        READY : out std_logic; -- for new interpolation
        NEWQ : out std_logic; -- new data point available
        XOUT : out std_logic_vector(15 downto 0);
        YOUT : out std_logic_vector(15 downto 0)
    );
end component;
--------------------------------------------------------------------------------
-- signals data cpu
signal SEND_CPU, RD_CPU, pos_send, pos_RD, SEND_DATA_pos, SENDandREAD : std_logic;
signal MAXVALUE : std_logic_vector(9 downto 0);
signal X_CPU, Y_CPU : std_logic_vector(15 downto 0);
signal neg_write : std_logic;
signal count : unsigned(3 downto 0) := (others => '0');
-- signals fill interpolation
signal xstart, ystart, xend, yend : std_logic_vector(15 downto 0);
signal doneINT, readyINT, newinINT : std_logic;
signal NEW_DATA_AV : std_logic;
signal newQ_pos, newQ_neg: std_logic;
-- signals write full stack of data in RAM
signal XY_INT, XY_DATA_INT : std_logic_vector(31 downto 0);
signal newDataInt : std_logic;
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
i_DATA : DATA_e
PORT MAP(
    CK => CK,
    RD_EN => RD_CPU,
    WR_EN => WRITE_EN, --i/o entity (negative edge)
    CLEAR => CLEAR, --i/o entity
    SEND_NEW => pos_send,								
    ADDRESS => ADDRESS, --i/o entity
    DATA => DATA_IN, --i/o entity
	 NEWDATA_AVA => NEW_DATA_AV,
    MAXVAL => open,
    DATAX => X_CPU,
    DATAY => Y_CPU
);

i_BRESENHAM : BRESENHAM_e
PORT MAP(
    CK => CK,
    NEWIN => newinINT,
    xstart => xstart,
    ystart => ystart,
    xend => xend,
    yend => yend,
	 SEND_NEW => SENDandREAD, 
    DONE => doneINT,
    READY => readyINT,
    NEWQ => newDataInt,
    XOUT => XY_INT(31 downto 16),
    YOUT => XY_INT(15 downto 0)
);

i_EDGE_WRITE_EN : EDGE_e
PORT MAP(
    CK => CK,
	SIG_IN => WRITE_EN,
    NEG_EDGE => neg_write
);

i_EDGE_SEND : EDGE_e
PORT MAP(
    CK => CK,
	SIG_IN => SEND,
	POS_EDGE => SEND_DATA_pos
);

i_EDGE_SEND_CPU : EDGE_e
PORT MAP(
    CK => CK,
	SIG_IN => SEND_CPU,
	POS_EDGE => pos_send
);

i_EDGE_RD_CPU : EDGE_e
PORT MAP(
    CK => CK,
	SIG_IN => RD_CPU,
	POS_EDGE => pos_RD
);

i_EDGE_NEWQ : EDGE_e
PORT MAP(
    CK => CK,
	SIG_IN => newDataInt,
	POS_EDGE => newQ_pos
);
--------------------------------------------------------------------------------
SENDandREAD <= '1' when (READ_EN = '1' and SEND = '1') else
					'0';
--------------------------------------------------------------------------------
DataToInt_proc : process(CK, CLEAR, X_CPU, Y_CPU, neg_write, RD_CPU, pos_RD, doneINT, readyINT)
begin
    if CLEAR = '1' then
      RD_CPU <= '0';
      count <= (others => '0');
      SEND_CPU <= '0';
      newinINT <= '0';
	 elsif rising_edge(CK) then 
			if MODE_ACTIVE = '1' then
            if neg_write = '1' then
                RD_CPU <= '1';
            end if;
      
            if pos_RD = '1' then
                SEND_CPU <= '1';
                count <= "0001";
            elsif count = "0001" then
                SEND_CPU <= '0';
                count <= "0010";
            elsif count = "0010" then
                if NEW_DATA_AV = '1' and readyINT = '1' then
                    xstart <= X_CPU;
                    ystart <= Y_CPU;
                    SEND_CPU <= '1';
                    count <= "0011";
                end if;
            elsif count = "0011" then
                SEND_CPU <= '0';
                count <= "0100";
            elsif count = "0100" then
                if NEW_DATA_AV = '1' and readyINT = '1' then
                    xend <= X_CPU;
                    yend <= Y_CPU;
                    count <= "0101";
                end if;
            elsif count = "0101" then
                newinINT <= '1';
                count <= "0110";
			
            elsif count = "0110" and doneINT = '1' and RD_CPU = '1' then
                xstart <= X_CPU;
                ystart <= Y_CPU;
                SEND_CPU <= '1';
                count <= "0111";
            elsif count = "0111" then
                SEND_CPU <= '0';
                count <= "1000";
            elsif count = "1000" and readyINT = '1' and RD_CPU = '1' then
                if NEW_DATA_AV = '1' then
                    xend <= X_CPU;
                    yend <= Y_CPU;
                    count <= "1001";
                end if;
            elsif count = "1001" then
                newinINT <= '1';
                count <= "0110";
            else
                newinINT <= '0';
                SEND_CPU <= '0';
            end if;
			else
            RD_CPU <= '0';
            count <= (others => '0');
            SEND_CPU <= '0';
            newinINT <= '0';
			end if;
    end if;
end process DataToInt_proc;
--------------------------------------------------------------------------------
Interpol_out_proc : process(CK, CLEAR, newinINT, newDataInt, READ_EN)
begin
    if CLEAR = '1' then
			XY_DATA_INT <= (others => '0');
	 elsif rising_edge(CK) then
		if MODE_ACTIVE = '1' then
				if count = "0010" AND NEW_DATA_AV = '1' and readyINT = '1' then
					XY_DATA_INT <= X_CPU & Y_CPU;
            elsif RD_CPU = '1' and READ_EN = '1' then
                if count = "0010" then
                    XY_DATA_INT <= X_CPU & Y_CPU;
                elsif newQ_pos = '1' then
                    XY_DATA_INT <= XY_INT;
                end if;
            end if;
        end if;
    end if;
end process Interpol_out_proc;
--------------------------------------------------------------------------------
Output_proc : process (CK, CLEAR, SEND_DATA_pos, XY_DATA_INT, READ_EN)
begin
	if rising_edge(CK) then
		if SEND_DATA_pos = '1' and READ_EN = '1' then
			DATAX <= XY_DATA_INT(31 downto 16);
			DATAY <= XY_DATA_INT(15 downto 0);
		end if;
	end if;
end process Output_proc;
--------------------------------------------------------------------------------
end architecture INTERPOLATION_a;
