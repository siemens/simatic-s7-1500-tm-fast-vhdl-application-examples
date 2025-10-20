----------------------------------------------------------------------------------
-- Company:        Siemens AG, Digital Industries, Factory Automation
-- Create Date:    04/03/2025
-- Design Name:    TM FAST logic library
-- Module Name:    Move_DW_U_e - Move_DW_U_a
-- Description:    Move an 32 bit value from IN1 to OUT1 (combinatorial logic).
-- Revision:       see TFL_FAST_USER_LIB_p.vhd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity Move_DW_U_e is
    port (
        IN1  : in  STD_LOGIC_VECTOR ( 31 downto 0 );
        OUT1 : out STD_LOGIC_VECTOR ( 31 downto 0 )
    );
end Move_DW_U_e;

architecture Move_DW_U_a of Move_DW_U_e is

    component Move_U_e
        generic (
            IN_LENGTH : positive
            );
        Port (
            IN1  : in  STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 );
            OUT1 : out STD_LOGIC_VECTOR ( ( IN_LENGTH - 1 ) downto 0 )
        );
    end component;

begin

    Move_B_U_m: Move_U_e
    generic map (
        IN_LENGTH => 32
    )
    port map (
        IN1   => IN1,
        OUT1  => OUT1
    );

end Move_DW_U_a;