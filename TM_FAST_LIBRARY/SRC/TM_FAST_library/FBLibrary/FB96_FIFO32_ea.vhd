----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB96_FIFO32_e - FB96_FIFO32_a
-- Description:    First-In-First-Out 32 bit wide memory, 256x32 bits.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

ENTITY FB96_FIFO32_e IS
    PORT (
        RST      : IN  STD_LOGIC;
        CLK      : IN  STD_LOGIC;
        CLKEN    : IN  STD_LOGIC;
        EN       : IN  STD_LOGIC;
        WR       : IN  STD_LOGIC;
        RD_NEXT  : IN  STD_LOGIC;
        FIFORESET: IN  STD_LOGIC;
        DATA_IN  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        FULL     : OUT STD_LOGIC;
        EMPTY    : OUT STD_LOGIC;
        ENTRIES  : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        DATA_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END FB96_FIFO32_e;

ARCHITECTURE FB96_FIFO32_a OF FB96_FIFO32_e IS

    COMPONENT true_dual_port_ram_dual_clock
        GENERIC (
            data_width : NATURAL;
            mem_depth  : NATURAL
        );
        PORT (
            clr    : IN  STD_LOGIC := '0';
            rdclk  : IN  STD_LOGIC := '1';
            wrclk  : IN  STD_LOGIC;
            rdaddr : IN  NATURAL RANGE 0 TO (mem_depth - 1);
            wraddr : IN  NATURAL RANGE 0 TO (mem_depth - 1);
            data_in: IN  STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0);
            rden   : IN  STD_LOGIC := '1';
            wren   : IN  STD_LOGIC := '0';
            q      : OUT STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0)
        );
    END COMPONENT;

    --signal inv_clk: std_logic;
    SIGNAL fifo_reset: STD_LOGIC;
    SIGNAL rd_addr   : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL readaddr  : NATURAL RANGE 0 TO 255 := 0;
    SIGNAL wr_addr   : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL writeaddr : NATURAL RANGE 0 TO 255 := 0;
    SIGNAL addrdiff  : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL dummyout  : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL ra_inc    : STD_LOGIC;
    SIGNAL empty_buff: STD_LOGIC;
    SIGNAL wa_inc    : STD_LOGIC;
    SIGNAL full_buff : STD_LOGIC;
    SIGNAL we        : STD_LOGIC;
    SIGNAL msb_s     : STD_LOGIC;
    SIGNAL msb_r     : STD_LOGIC;
    SIGNAL msb       : STD_LOGIC;
    SIGNAL wa_eq_ra  : STD_LOGIC;
    SIGNAL zerodiff  : STD_LOGIC;

BEGIN

    --inv_clk <= not(CLK);
    fifo_reset           <= (FIFORESET AND EN AND CLKEN) OR RST;
    ra_inc               <= RD_NEXT AND CLKEN AND EN AND NOT(empty_buff);
    we                   <= EN AND WR AND CLKEN AND NOT(full_buff);
    wa_inc               <= we AND (NOT(empty_buff) OR NOT(RD_NEXT));
    zerodiff             <= '1' WHEN (addrdiff = x"00") ELSE '0';
    msb_s                <= wa_inc AND wa_eq_ra AND NOT(ra_inc);
    msb_r                <= ra_inc OR fifo_reset;
    empty_buff           <= wa_eq_ra AND NOT(msb);
    full_buff            <= wa_eq_ra AND msb;
    EMPTY                <= empty_buff;
    FULL                 <= full_buff;
    ENTRIES(7 DOWNTO 0)  <= addrdiff;
    ENTRIES(8)           <= full_buff;
    ENTRIES(15 DOWNTO 9) <= "0000000";
    readaddr             <= To_Integer(unsigned (rd_addr));
    writeaddr            <= To_Integer(unsigned (wr_addr));

    Entry_p : PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            addrdiff <= x"00";
            wa_eq_ra <= '1';
        ELSIF rising_edge (CLK) THEN
            addrdiff <= wr_addr - rd_addr;
            wa_eq_ra <= zerodiff;
        END IF;
    END PROCESS Entry_p;

    MSB_p : PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            msb <= '0';
        ELSIF rising_edge (CLK) THEN
            IF (msb_r = '1') THEN
                msb <= '0';
            ELSIF (msb_s = '1') THEN
                msb <= '1';
            END IF;
        END IF;
    END PROCESS MSB_p;

    RDADRS_p : PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            rd_addr <= x"00";
        ELSIF rising_edge (CLK) THEN
            IF (fifo_reset = '1') THEN
                rd_addr <= x"00";
            ELSIF (ra_inc = '1') THEN
                IF (rd_addr = x"FF") THEN
                    rd_addr <= x"00";
                ELSE
                    rd_addr <= rd_addr + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS RDADRS_p;

    WRADRS_p : PROCESS (RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            wr_addr <= x"00";
        ELSIF rising_edge (CLK) THEN
            IF (fifo_reset = '1') THEN
                wr_addr <= x"00";
            ELSIF (wa_inc = '1') THEN
                IF (wr_addr = x"FF") THEN
                    wr_addr <= x"00";
                ELSE
                    wr_addr <= wr_addr + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS WRADRS_p;

    DPRAM256x32_m : true_dual_port_ram_dual_clock
    GENERIC MAP(
        data_width => 32,
        mem_depth  => 256
    )
    PORT MAP(
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

END FB96_FIFO32_a;