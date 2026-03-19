----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB98_LIFO32_e - FB98_LIFO32_a
-- Description:    Last-In-First-Out 32 bit wide memory, 256x32 bits.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity FB98_LIFO32_e is
    Port (
        RST      : in  STD_LOGIC;
        CLK      : in  STD_LOGIC;
        CLKEN    : in  STD_LOGIC;
        EN       : in  STD_LOGIC;
        WR       : in  STD_LOGIC;
        RD_NEXT  : in  STD_LOGIC;
        LIFORESET: in  STD_LOGIC;
        DATA_IN  : in  STD_LOGIC_VECTOR (31 downto 0);
        FULL     : out STD_LOGIC;
        EMPTY    : out STD_LOGIC;
        ENTRIES  : out STD_LOGIC_VECTOR (15 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0)
    );
end FB98_LIFO32_e;

architecture FB98_LIFO32_a of FB98_LIFO32_e is

    component true_dual_port_ram_dual_clock
        generic (
            data_width : natural;
            mem_depth  : natural
        );
        port (
            clr    : IN  STD_LOGIC := '0';
            rdclk  : IN  STD_LOGIC := '1';
            wrclk  : IN  STD_LOGIC;
            rdaddr : IN  natural range 0 to (mem_depth - 1);
            wraddr : IN  natural range 0 to (mem_depth - 1);
            data_in: IN  STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0);
            rden   : IN  STD_LOGIC := '1';
            wren   : IN  STD_LOGIC := '0';
            q      : OUT STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0)
        );
    end component;

    --signal inv_clk: std_logic;
    signal lifo_reset : std_logic;
    signal rd_addr    : std_logic_vector (7 downto 0) := (others => '0');
    signal readaddr   : natural range 0 to 255 := 0;
    signal wr_addr    : std_logic_vector (7 downto 0) := (others => '0');
    signal writeaddr  : natural range 0 to 255 := 0;
    signal dummyout   : std_logic_vector (31 downto 0) := (others => '0');
    signal empty_buff : std_logic := '1';
    signal full_buff  : std_logic := '0';
    signal push       : std_logic;
    signal pop        : std_logic;
    signal cnt_up     : std_logic;
    signal cnt_en     : std_logic;
    signal oktopush   : std_logic;
    signal output_data: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin

    --inv_clk <= not(CLK);
    push       <= EN and WR and CLKEN;
    pop        <= EN and RD_NEXT and CLKEN;
    lifo_reset <= (LIFORESET and CLKEN and EN) or RST;
    cnt_up     <= push and not(pop);
    cnt_en     <= (push and pop and full_buff) or (pop and not(push) and not(empty_buff)) or (push and not(pop) and not(full_buff));
    oktopush   <= (push and not(pop) and not(full_buff)) or (pop and push and empty_buff);
    empty_buff <= '1' when ((wr_addr =  x"00") and (full_buff = '0')) else '0';

    readaddr  <= To_Integer(unsigned(rd_addr));
    writeaddr <= To_Integer(unsigned(wr_addr));

    Entry_p: process (RST, CLK)
    begin
        if (RST = '1') then
            ENTRIES  (7 downto 0) <= x"00";
            ENTRIES  (8) <= '0';
            ENTRIES  (15 downto 9) <= "0000000";
            DATA_OUT <= x"00000000";
            EMPTY    <= '1';
            FULL     <= '0';
            rd_addr  <= x"00";
        elsif (rising_edge ( CLK )) then
            ENTRIES  (7 downto 0) <= wr_addr;
            ENTRIES  (8) <= full_buff;
            ENTRIES  (15 downto 9) <= "0000000";
            DATA_OUT <= output_data;
            EMPTY    <= empty_buff;
            FULL     <= full_buff;
            if (empty_buff = '1') then
                rd_addr <= wr_addr + x"00" + x"00";
            else
                rd_addr <= wr_addr - x"00" - x"01";
            end if;
        end if;
    end process Entry_p;

    Adrs_gen_p: process (RST, CLK)
    begin
        if ( RST = '1' ) then
            wr_addr   <= x"00";
            full_buff <= '0';
        elsif rising_edge ( CLK ) then
            if (lifo_reset = '1') then
                wr_addr   <= x"00";
                full_buff <= '0';
            elsif (cnt_en = '1') then
                if (cnt_up = '1') then
                    if (wr_addr = x"FF") then
                        full_buff <= '1';
                    else
                        full_buff <= '0';
                    end if;
                    wr_addr <= wr_addr + 1;
                else
                    full_buff <= '0';
                    wr_addr   <= wr_addr - 1;
                end if;
            end if;
        end if;
    end process Adrs_gen_p;

    DPRAM256x32_m: true_dual_port_ram_dual_clock
        generic map(
            data_width => 32,
            mem_depth  => 256
        )
        port map (
            clr     => lifo_reset,
            rdclk   => CLK,
            wrclk   => CLK,
            rdaddr  => readaddr,
            wraddr  => writeaddr,
            data_in => DATA_IN,
            rden    => '1',
            wren    => oktopush,
            q       => output_data
        );

end FB98_LIFO32_a;

