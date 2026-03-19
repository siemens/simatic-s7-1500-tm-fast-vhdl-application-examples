----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB127_Shift8_e - FB127_Shift8_a
-- Description:    The shift 8-bit operation shifts 8 bits into a memory block of
--                 512x8 bits.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FB127_Shift8_e is
    Port (
        RST     : in  STD_LOGIC;
        CLK     : in  STD_LOGIC;
        CLKEN   : in  STD_LOGIC;
        EN      : in  STD_LOGIC;
        SH_CLK  : in  STD_LOGIC;
        SH_RESET: in  STD_LOGIC;
        DATA_IN : in  STD_LOGIC_VECTOR (7 downto 0);
        D_LENGTH: in  STD_LOGIC_VECTOR (15 downto 0);
        DATA_OUT: out STD_LOGIC_VECTOR (7 downto 0)
    );
end FB127_Shift8_e;

architecture FB127_Shift8_a of FB127_Shift8_e is

    component true_dual_port_ram_dual_clock
        generic (
            data_width: natural;
            mem_depth : natural
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

    signal inv_clk   : std_logic := '0';
    signal srreset   : std_logic := '0';
    signal srenable  : std_logic := '0';
    signal ramdataout: std_logic_vector (7 downto 0);
    signal dummyout  : std_logic_vector (7 downto 0);
    signal rd_addr   : std_logic_vector (8 downto 0);
    signal readaddr  : natural range 0 to 511 := 0;
    signal wr_addr   : std_logic_vector (8 downto 0);
    signal writeaddr : natural range 0 to 511 := 0;
    signal history   : std_logic := '0';
    signal willbefull: std_logic := '0';
    signal full      : std_logic := '0';
    signal full_d    : std_logic := '0';

begin

    inv_clk    <= not(CLK);
    srreset    <= (CLKEN and SH_RESET and EN) or RST;
    srenable   <= srreset or (SH_CLK and CLKEN and EN and not(SH_RESET) and not(history));
    full_d     <= full or willbefull;
    DATA_OUT   <= ramdataout when (full = '1') else (others => '0');
    willbefull <= '1' when (rd_addr = 0) else '0';
    readaddr   <= To_Integer(unsigned (rd_addr));
    writeaddr  <= To_Integer(unsigned (wr_addr));

    P_RDADDR: process ( CLK )
    begin
        if rising_edge( CLK ) then
            rd_addr <= wr_addr - D_LENGTH (8 downto 0) + 1;
        end if;
    end process P_RDADDR;

    P_WRADDR: process ( CLK )
    begin
        if rising_edge( CLK ) then
            if (srreset = '1') then
                wr_addr <= "000000000";
            elsif (srenable = '1') then
                if (wr_addr = "111111111") then
                    wr_addr <= "000000000";
                else
                    wr_addr <= wr_addr + 1;
                end if;
            end if;
        end if;
    end process P_WRADDR;

    P_FULL: process ( CLK )
    begin
        if rising_edge( CLK ) then
            if (srreset = '1') then
                full <= '0';
            elsif (srenable = '1') then
                full <= full_d;
            end if;
        end if;
    end process P_FULL;

    P_ENABLE: process ( CLK ) begin
        if rising_edge( CLK ) then
            if (CLKEN = '1' and EN = '1') then
                history <= SH_CLK;
            end if;
        end if;
    end process P_ENABLE;

    DPRAM512x8_m: true_dual_port_ram_dual_clock
        generic map(
            data_width => 8,
            mem_depth  => 512
        )
        port map (
            clr     => srreset,
            rdclk   => CLK,
            wrclk   => CLK,
            rdaddr  => readaddr,
            wraddr  => writeaddr,
            data_in => DATA_IN,
            rden    => srenable,
            wren    => srenable,
            q       => ramdataout
        );

end FB127_Shift8_a;

