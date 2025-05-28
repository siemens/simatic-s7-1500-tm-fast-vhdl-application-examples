--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- heading architecture of User Application Laser			                  --
--                                                                            --
-- filename    TFL_FAST_USER_LASER_a.vhd						   			  --
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
use work.TFL_FAST_USER_PUBLIC2_p.all;
use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;
use work.TFL_FAST_USER_IP_CONF_p.all;
--------------------------------------------------------------------------------
architecture LASER_a of TFL_FAST_USER_e is
-- declaration of the used components
component XY2_e is
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
end component;
--------------------------------------------------------------------------------
component EDGE_e is 
port(
	CK       : in std_logic;
	SIG_IN   : in std_logic;
	POS_EDGE : out std_logic;
    NEG_EDGE: out std_logic
);
end component;
--------------------------------------------------------------------------------
component INTERPOLATION_e is
port(
    CK          : in std_logic;
    CLEAR       : in std_logic;
    MODE_ACTIVE : in std_logic;
    WRITE_EN    : in std_logic;
    READ_EN     : in std_logic;
    SEND        : in std_logic;
    ADDRESS     : in std_logic_vector(9 downto 0);
    DATA_IN     : in std_logic_vector(31 downto 0);
    DATAX : out std_logic_vector(15 downto 0);
    DATAY : out std_logic_vector(15 downto 0)
);
end component;
--------------------------------------------------------------------------------
alias SETUP is CTRL_IF0;
alias START_BIT is SETUP(0);	-- Start and stop of transmission
--constant START_BIT : std_logic := '1';
alias CLEAR is SETUP(2);
alias MODE_DIRECT is SETUP(0);
alias DATA is FB_IF4; -- Coordinates XY from CPU
alias DATA_X is DATA(31 downto 16);
alias DATA_Y is DATA(15 downto 0);
--------------------------------------------------------------------------------
signal SYNC : std_logic;
signal START, START_INIT: std_logic;
signal READY, LDAC : std_logic;
signal RS422_X, RS422_Y : std_logic;
signal COUNT : unsigned(5 downto 0) := ( others => '0' ); -- clock divider
signal CLK_2MHZ : std_logic := '0';
signal DATAX, DATAY, DATAX_DIRECT, DATAY_DIRECT  : std_logic_vector(15 downto 0);
signal ADDR_INT, ADDR_DIRECT, ADDRESS_CNT : std_logic_vector(9 downto 0);
signal ADDR_DATA : std_logic_vector(11 downto 0);
signal READY_EDGE, STARTBIT_EDGE, READY2SEND : std_logic;
--------------------------------------------------------------------------------
--Added Signal for GitHub
type t_array_mux is array (0 to 13) of std_logic_vector(31 downto 0);
signal DATA_MAN  : t_array_mux;
signal DATA_to_RAM : std_logic_vector(31 downto 0) := ( others => '0' );
signal WR_enable_auto : std_logic;


begin

--------------------------------------------------------------------------------
-- instantiation

--Given Coordonates

DATA_MAN(0) <= x"8057763C";
DATA_MAN(1) <= x"91417FFF";
DATA_MAN(2) <= x"91416C77";
DATA_MAN(3) <= x"8057763C";



i_SEND_DATA : XY2_e
	Port map(
		CK     => CLK_2MHZ,
		START  => START,
		DATAX  => DATAX,
		DATAY  => DATAY,
		RS422X => RS422_X,
		RS422Y => RS422_Y,
		SYNC   => SYNC,
		LDAC   => open,
		READY  => READY
	);
	
i_EDGE_READY : EDGE_e
	Port map(
	CK       => CLK,
	SIG_IN   => READY,
	POS_EDGE => READY_EDGE
	);
	
i_EDGE_STARTBIT : EDGE_e
	Port map(
	CK       => CLK,
	SIG_IN   => START_BIT,
	POS_EDGE => STARTBIT_EDGE
	);
	
i_INTERPOLATION : INTERPOLATION_e
	Port map(
		CK           => CLK,
		CLEAR        => CLEAR,
		MODE_ACTIVE  => MODE_DIRECT,
		WRITE_EN     => WR_enable_auto, --WR_enable,
		READ_EN      => START,
		SEND         => READY2SEND,
		ADDRESS      => ADDR_DIRECT,
		DATA_IN      => DATA_to_RAM, --DATA,
		DATAX        => DATAX_DIRECT,
		DATAY        => DATAY_DIRECT
	);
--------------------------------------------------------------------------------
-- Assignment of RS485_TX channel, RST integrated
RS485_OE <= ( others => '0' );

ASSIGN_PROC : process(CLK, RST)
	begin
		if RST = '1' then
		   
			RS485_TX <= ( others => '0' );
			DQ       <= ( others => '0' );			
			
		elsif rising_edge(CLK) then
		   RS485_TX(7 downto 6) <= (others => '0');
			DQ(10 downto 0)      <= (others => '0');
			
			RS485_TX(0) <= CLK_2MHZ;
			RS485_TX(1) <= SYNC;
			RS485_TX(4) <= RS422_X;
			RS485_TX(5) <= RS422_Y;
			DQ(11)      <= '1';   
			
			START               <= START_INIT; -- start transmission
			READY2SEND          <= READY_EDGE OR STARTBIT_EDGE; -- write out new data 
			FB_IF4              <= DATA_to_RAM; --DATA; -- data control
			FB_IF1(9 downto 0)  <= ADDRESS_CNT; --CTRL_IF1(11 downto 0);
		end if;
end process ASSIGN_PROC;
--------------------------------------------------------------------------------
-- Clock divider 50 MHz down to 2 MHz
CLOCKDIV_PROC : process (CLK, RST)
	begin
		if RST = '1'  then
		
		CLK_2MHZ <= '0';
		COUNT <= ( others => '0' );
		
		elsif rising_edge(CLK) then
			if(COUNT = x"B") then -- positive ('1') share of 12 clocks 
				CLK_2MHZ <= '1';
				COUNT <= COUNT + 1;
			elsif (COUNT = x"18") then -- negative ('0') share of 13 clocks
				COUNT <= ( others => '0' );
				CLK_2MHZ <= '0';
			else
				COUNT <= COUNT + x"1";
			end if;
		end if;
end process CLOCKDIV_PROC;
--------------------------------------------------------------------------------
-- condition start transmission: ready (channel is ready for transmission) and START_BIT(CTRL_IF CPU)
START_TX_PROC : process (CLK , RST)
	begin
		if RST = '1'  then

			START_INIT <= '0';
		
		elsif rising_edge(CLK) then 
			if (CLK_2MHZ = '1') then
				if (READY = '1' and START_BIT = '1') then
					START_INIT <= '1';
				elsif SYNC = '1' then
					START_INIT <= '0';
				end if;
			end if;
		end if;
end process START_TX_PROC;
--------------------------------------------------------------------------------
mode_proc : process (CLK, RST) -- change from interpolation to transmitt data directly from cpu
	begin
	   if RST = '1'  then
			DATAX <= (others => '0');
			DATAY <= (others => '0');
			ADDR_DIRECT <= (others => '0');
		elsif rising_edge(CLK) then
		--	if MODE_DIRECT = '0' then
		--		DATAX <= DATA_X;
		--		DATAY <= DATA_Y;
		--	else
				DATAX <= DATAX_DIRECT;
				DATAY <= DATAY_DIRECT;
				ADDR_DIRECT <= ADDRESS_CNT; --CTRL_IF1(9 downto 0);
		--	end if;
		end if;
end process mode_proc;
--------------------------------------------------------------------------------
ram_init : process ( CLK, RST)
   variable count : integer := 0;
	variable latch : std_logic := '0';
	begin
	if RST = '1' then
		ADDRESS_CNT <= ( others => '0' );
		DATA_to_RAM	<= ( others => '0' );
		count := 0;
	elsif rising_edge(CLK) then
		if latch = '1' then
			WR_enable_auto <= '0';
			latch := '0';
		else
			if count >2 then
				count := 0;
			else
				WR_enable_auto <= '1';
				ADDRESS_CNT <= std_logic_vector(to_unsigned(count, ADDRESS_CNT'length));
				DATA_to_RAM <= DATA_MAN(count);
				count := count + 1;
				latch := '1';
			end if;
		end if;
	end if;
end process ram_init;



end architecture LASER_a;