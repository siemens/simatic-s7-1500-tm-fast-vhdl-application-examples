----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    FB103_FMDiv16_e - FB103_FMDiv16_a
-- Description:    FMresult16 resultides the 16-bit integer value at the IN_A
--                 input by the integer value at the IN_B input and writes the
--                 result to the OUT output and the remainder to the Remain output.
--                 The DONE output signals that the result is available. The valid
--                 range for the IN_A input is -2,147,483,648 to +2,147,483,647.
--                 The valid range for input IN_B and outputs OUT and Remain is
--                 -32768 to +32767. The output OVF is set to logic "1" if an
--                 overflow occurs; otherwise, it is "0". When OVF is "1", the OUT
--                 and Remain outputs are set to "0".
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity FB103_FMDiv16_e is
    Port (
        RST   : in  STD_LOGIC;
        CLK   : in  STD_LOGIC;
        CLKEN : in  STD_LOGIC;
        STOP  : in  STD_LOGIC;
        REQ   : in  STD_LOGIC;
        IN1   : in  STD_LOGIC_VECTOR (31 downto 0);
        IN2   : in  STD_LOGIC_VECTOR (15 downto 0);
        DONE  : out STD_LOGIC;
        OVF   : out STD_LOGIC;
        OUT1  : out STD_LOGIC_VECTOR (15 downto 0);
        REMAIN: out STD_LOGIC_VECTOR (15 downto 0)
    );
end FB103_FMDiv16_e;

architecture FB103_FMDiv16_a of FB103_FMDiv16_e is

    component lpm_div16
        PORT
        (
            aclr        : IN STD_LOGIC ;
            clken       : IN STD_LOGIC ;
            clock       : IN STD_LOGIC ;
            denom       : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            numer       : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            quotient    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            remain      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END component;

    signal OUT_CALC    : STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal REMAIN_CALC : STD_LOGIC_VECTOR (15 DOWNTO 0);

    signal reqprime : std_logic;
    signal reqprime2: std_logic;
    signal start    : std_logic;
    signal all_bits : std_logic := '0';
    signal done_d   : std_logic;
    signal over     : std_logic;
    signal count    : std_logic_vector (3 downto 0);

begin

    start    <= CLKEN and reqprime and not(reqprime2);
    DONE     <= done_d;
    OVF      <= over;
    OUT1     <= OUT_CALC(15 downto 0);
    REMAIN   <= REMAIN_CALC;

    P_COUNT:
    process (RST, CLK) begin
        if (RST = '1') then
                count <= "0000";
                done_d <= '0';
          elsif rising_edge(CLK) then
            if (start = '1') then
                count <= "0000";
                done_d <= '0';
            elsif (reqprime2 = '1') then
                if (count = "1111") then
                    done_d <= '1';
                else
                    count <= count + 1;
                end if;
            elsif (reqprime = '0') then
                done_d <= '0';
            end if;
        end if;
    end process P_COUNT;

    P_REQ:
    process (RST, CLK) begin
          if (RST = '1') then
                reqprime <= '0';
                reqprime2 <= '0';
        elsif rising_edge(CLK) then
            if (STOP = '1') then
                reqprime <= '0';
                reqprime2 <= '0';
            elsif (CLKEN = '1') then
                reqprime2 <= reqprime;
                reqprime <= REQ;
            end if;
        end if;
    end process P_REQ;

    OVERFLOW:
    process (RST, IN2) begin
        if (RST = '1') then
            over <= '0';
        elsif (IN2 = x"0000") then
            over <= '1';
        else
            over <= '0';
        end if;
    end process OVERFLOW;



lpm_div16_inst : lpm_div16 PORT MAP (
        aclr => RST,
        clken => reqprime2,
        clock => CLK,
        denom => IN2,
        numer => IN1,
        quotient => OUT_CALC,
        remain => REMAIN_CALC
    );


end FB103_FMDiv16_a;

