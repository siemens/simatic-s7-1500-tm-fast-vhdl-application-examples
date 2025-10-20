----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    Move_B_e - Move_B_a
-- Description:    Move an 8 bit value from IN1 to OUT1.
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity Move_B_e is
    port (
        RST  : in  STD_LOGIC;
        CLK  : in  STD_LOGIC;
        CLKEN: in  STD_LOGIC;
        STOP : in  STD_LOGIC;
        EN   : in  STD_LOGIC;
        IN1  : in  STD_LOGIC_VECTOR ( 7 downto 0 );
        ENO  : out STD_LOGIC;
        OUT1 : out STD_LOGIC_VECTOR ( 7 downto 0 )
    );
end Move_B_e;

architecture Move_B_a of Move_B_e is

    component Move_e
        generic (
            IN_LENGTH : positive
            );
        Port (
            RST  : in  STD_LOGIC;
            CLK  : in  STD_LOGIC;
            CLKEN: in  STD_LOGIC;
            STOP : in  STD_LOGIC;
            EN   : in  STD_LOGIC;
            IN1  : in  STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 );
            ENO  : out STD_LOGIC;
            OUT1 : out STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 )
        );
    end component;

begin

    Move_B_m: Move_e
    generic map (
        IN_LENGTH => 8
    )
    port map (
        RST   => RST,
        CLK   => CLK,
        CLKEN => CLKEN,
        STOP  => STOP,
        EN    => EN,
        IN1   => IN1,
        ENO   => ENO,
        OUT1  => OUT1
    );



end Move_B_a;