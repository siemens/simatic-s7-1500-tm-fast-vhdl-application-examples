
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signed_mult is
    generic (
        data_width : natural := 32
    );
    port (
        a     : in  signed ((data_width - 1) downto 0);
        b     : in  signed ((data_width - 1) downto 0);
        result: out signed (((data_width * 2) - 1) downto 0)
    );
end signed_mult;

architecture rtl of signed_mult is

begin
    result <= a * b;
end rtl;

    