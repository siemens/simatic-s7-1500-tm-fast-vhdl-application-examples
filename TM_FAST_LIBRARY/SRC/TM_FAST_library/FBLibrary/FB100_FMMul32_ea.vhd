----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB100_FMMul32_e - FB100_FMMul32_a
-- Description:    FMMul32 multiplies the 32-bit integer value at the IN_A input by
--                 the 32-bit integer value at the IN_B input and writes the 32-bit
--                 integer result to the OUT output. The DONE output signals that the
--                 result is available. The valid range for inputs IN_A and IN_B is
--                 -2147483648 to +2147483647.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity FB100_FMMul32_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        REQ  : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (31 downto 0);
        IN2  : in  STD_LOGIC_VECTOR (31 downto 0);
        DONE : out STD_LOGIC;
        OVF  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0));
end FB100_FMMul32_e;


architecture FB100_FMMul32_a of FB100_FMMul32_e is

    component signed_mult
        generic (
            data_width: natural
        );
        port (
            a     : in  signed ((data_width - 1) downto 0);
            b     : in  signed ((data_width - 1) downto 0);
            result: out signed (((data_width * 2) - 1) downto 0)
        );
    end component;

    signal in_a      : signed (31 downto 0);
    signal in_b      : signed (31 downto 0);
    signal out_val   : signed (63 downto 0);
    signal reqprime  : std_logic;
    signal reqprime2 : std_logic;
    signal start     : std_logic;
    signal multiply  : std_logic;
    signal mult_d    : std_logic;
    signal mult_r    : std_logic;
    signal done_d    : std_logic;
    signal count_done: std_logic;
    signal counter   : std_logic_vector (7 downto 0);


begin

    start  <= REQ and not(reqprime2);
    mult_d <= (start or multiply) and REQ;
    mult_r <= (count_done and not(start)) or STOP;
    done_d <= REQ and REQprime2 and count_done and not(multiply);

    ReqPrime_p: process (RST, CLK)
    begin
        if (RST = '1') then
            reqprime  <= '0';
            reqprime2 <= '0';
        elsif rising_edge (CLK) then
            if (STOP = '1') then
                reqprime  <= '0';
                reqprime2 <= '0';
            elsif (CLKEN = '1') then
                reqprime2 <= reqprime;
                reqprime  <= REQ;
            end if;
        end if;
    end process ReqPrime_p;

    Multiply_p: process (RST, CLK)
    begin
        if (RST = '1') then
            multiply <= '0';
        elsif rising_edge (CLK) then
            if (mult_r = '1') then
                multiply <= '0';
            else
                multiply <= mult_d;
            end if;
        end if;
    end process Multiply_p;

    Done_p: process (RST, CLK)
    begin
        if (RST = '1') then
            DONE <= '0';
            OUT1 <= (others => '0');
            OVF  <= '0';
        elsif (rising_edge (CLK)) then
            if (CLKEN = '1') then
                DONE <= done_d;
                if ((out_val > 2147483647) or (out_val < -2147483648)) then
                    OVF  <= '1';
                    OUT1 <= (others => '0');
                else
                    OVF  <= '0';
                    OUT1 <= std_logic_vector(out_val(31 downto 0));
                end if;
            end if;
        end if;
    end process Done_p;

    FB100_FMMul32_p: process (RST, CLK)
    begin
        if (RST = '1') then
            in_a       <= x"00000000";
            in_b       <= x"00000000";
            counter    <= x"00";
            count_done <= '0';
        elsif rising_edge (CLK) then
            if (STOP = '1') then
                in_a       <= x"00000000";
                in_b       <= x"00000000";
                counter    <= x"00";
                count_done <= '0';
            elsif (REQ = '0') then
                counter    <= x"00";
                count_done <= '0';
            elsif (multiply = '1') then
                in_a <= signed (IN1);
                in_b <= signed (IN2);
                if (counter > x"18") then
                    count_done <= '1';
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process FB100_FMMul32_p;


    FB100_FMMul32_m: signed_mult
        generic map (
            data_width => 32
        )
        port map (
            a      => in_a,
            b      => in_b,
            result => out_val
        );

end FB100_FMMul32_a;

