----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB101_FMMul16_e - FB101_FMMul16_a
-- Description:    FMMul16 multiplies the 16-bit integer value at the IN_A input
--                 by the integer value at the IN_B    input and writes the double
--                 integer result to the OUT output. The DONE output signals that
--                   the result is available. The valid range for inputs IN_A and
--                 IN_B is -32768 to +32767.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity FB101_FMMul16_e is
    Port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        REQ  : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR (15 downto 0);
        IN2  : in  STD_LOGIC_VECTOR (15 downto 0);
        DONE : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR (31 downto 0));
end FB101_FMMul16_e;


architecture FB101_FMMul16_a of FB101_FMMul16_e is

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


    signal in_a      : signed (15 downto 0);
    signal in_b      : signed (15 downto 0);
    signal out_val   : signed (31 downto 0);
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
        elsif rising_edge (CLK) then
            DONE <= done_d;
            OUT1 <= std_logic_vector(out_val(31 downto 0));
        end if;
    end process Done_p;

    FB101_FMMul16_p: process (RST, CLK)
    begin
        if (RST = '1') then
            in_a       <= x"0000";
            in_b       <= x"0000";
            counter    <= x"00";
            count_done <= '0';
        elsif rising_edge (CLK) then
            if (STOP = '1') then
                in_a       <= x"0000";
                in_b       <= x"0000";
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
    end process FB101_FMMul16_p;

    FB101_FMMul16_m: signed_mult
        generic map (
            data_width => 16
        )
        port map (
            a      => in_a,
            b      => in_b,
            result => out_val
        );

end FB101_FMMul16_a;

