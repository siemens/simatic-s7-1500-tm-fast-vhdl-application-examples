----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB97_FIFO16 - FB97_FIFO16_a
-- Description:    First-In-First-Out 16 bit wide memory, 256x16 bits.  
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB97_FIFO16_e is
    Port (
        RST      : in  STD_LOGIC;
        CLK      : in  STD_LOGIC;
        CLKEN    : in  STD_LOGIC;
        EN       : in  STD_LOGIC;
        WR       : in  STD_LOGIC;
        RD_NEXT  : in  STD_LOGIC;
        FIFORESET: in  STD_LOGIC;
        DATA_IN  : in  STD_LOGIC_VECTOR (15 downto 0);
        FULL     : out STD_LOGIC;
        EMPTY    : out STD_LOGIC;
        ENTRIES  : out STD_LOGIC_VECTOR (15 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB97_FIFO16_e;

architecture FB97_FIFO16_a of FB97_FIFO16_e is

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
    signal fifo_reset: std_logic;
    signal rd_addr   : std_logic_vector (7 downto 0);
    signal readaddr  : natural range 0 to 255 := 0;
    signal wr_addr   : std_logic_vector (7 downto 0);
    signal writeaddr : natural range 0 to 255 := 0;
    signal addrdiff  : std_logic_vector (7 downto 0);
    signal dummyout  : std_logic_vector (15 downto 0);
    signal ra_inc    : std_logic;
    signal empty_buff: std_logic;
    signal wa_inc    : std_logic;
    signal full_buff : std_logic;
    signal we        : std_logic;
    signal msb_s     : std_logic;
    signal msb_r     : std_logic;
    signal msb       : std_logic;
    signal wa_eq_ra  : std_logic;
    signal zerodiff  : std_logic;

begin

    --inv_clk <= not(CLK);
    fifo_reset           <= (FIFORESET and EN and CLKEN) or RST;
    ra_inc               <= RD_NEXT and CLKEN and EN and not(empty_buff);
    we                   <= EN and WR and CLKEN and not(full_buff);
    wa_inc               <= we and ( not(empty_buff) or not(RD_NEXT) );
    zerodiff             <= '1' when (addrdiff = x"00") else '0';
    msb_s                <= wa_inc and wa_eq_ra and not(ra_inc);
    msb_r                <= ra_inc or fifo_reset;
    empty_buff           <= wa_eq_ra and not(msb);
    full_buff            <=  wa_eq_ra and msb;
    EMPTY                <= empty_buff;
    FULL                 <= full_buff;
    ENTRIES(7 downto 0)  <= addrdiff;
    ENTRIES(8)           <= full_buff;
    ENTRIES(15 downto 9) <= "0000000";
    readaddr             <= To_Integer(unsigned (rd_addr));
    writeaddr            <= To_Integer(unsigned (wr_addr));


    Entry_p: process ( RST, CLK )
    begin
        if (RST = '1') then
            addrdiff <= x"00";
            wa_eq_ra <= '1';
        elsif rising_edge ( CLK ) then
            addrdiff <= wr_addr - rd_addr;
            wa_eq_ra <= zerodiff;
        end if;
    end process Entry_p;

    MSB_p: process ( RST, CLK )
    begin
        if (RST = '1') then
            msb <= '0';
        elsif rising_edge ( CLK ) then
            if (msb_r = '1') then
                msb <= '0';
            elsif (msb_s= '1') then
                msb <= '1';
            end if;
        end if;
    end process MSB_p;


    RDADRS_p: process ( RST, CLK )
    begin
        if (RST = '1') then
            rd_addr <= x"00";
        elsif  rising_edge ( CLK ) then
            if (fifo_reset = '1') then
                rd_addr <= x"00";
            elsif (ra_inc = '1') then
                if (rd_addr = x"FF") then
                    rd_addr <= x"00";
                else
                    rd_addr <= rd_addr + 1;
                end if;
            end if;
        end if;
    end process RDADRS_p;

    WRADRS_p: process ( RST, CLK )
    begin
        if (RST = '1') then
            wr_addr <= x"00";
        elsif  rising_edge ( CLK ) then
            if (fifo_reset = '1') then
                wr_addr <= x"00";
            elsif (wa_inc = '1') then
                if (wr_addr = x"FF") then
                    wr_addr <= x"00";
                else
                    wr_addr <= wr_addr + 1;
                end if;
            end if;
        end if;
    end process WRADRS_p;

    DPRAM256x16_m: true_dual_port_ram_dual_clock
        generic map(
            data_width => 16,
            mem_depth  => 256
        )
        port map (
            clr     => fifo_reset,
            rdclk   => CLK,
            wrclk   => CLK,
            rdaddr  => readaddr,
            wraddr  => writeaddr,
            data_in => DATA_IN,
            rden    => '1',
            wren    => we,
            q       => DATA_OUT
        );

end FB97_FIFO16_a;

