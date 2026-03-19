-- megafunction wizard: %RAM: 2-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altsyncram 

-- ============================================================
-- File Name: true_dual_port_ram_dual_clock.vhd
-- ************************************************************

--Copyright (C) 1991-2014 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity true_dual_port_ram_dual_clock is
    generic (
        data_width : natural := 32;
        mem_depth  : natural := 256
    );
    
    port
    (
        clr     : IN  STD_LOGIC  := '0';
        rdclk   : IN  STD_LOGIC  := '1';
        wrclk   : IN  STD_LOGIC ;
        rdaddr  : IN  natural range 0 to (mem_depth- 1);
        wraddr  : IN  natural range 0 to (mem_depth - 1);
        data_in : IN  STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0);
        rden    : IN  STD_LOGIC  := '1';
        wren    : IN  STD_LOGIC  := '0';
        q       : OUT STD_LOGIC_VECTOR ((data_width - 1) DOWNTO 0)
    );
end true_dual_port_ram_dual_clock;


architecture rtl OF true_dual_port_ram_dual_clock is
    --Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector ( (data_width - 1 ) downto 0);
    type memory_t is array(( mem_depth - 1 ) downto 0) of word_t;
    --Declare the RAM signal
    signal ram : memory_t;    
    
begin

    PortA_p: process ( rdclk )
    begin
        if (rising_edge (rdclk)) then
            if (clr = '1') then
                if (rden = '1') then
                    q <= (others => '0');
                end if;
            else
                if (rden = '1') then
                    q <= ram(rdaddr);
                end if;
            end if;
        end if;
    end process PortA_p;
                
    PortB_p: process ( wrclk )
    begin
        if (rising_edge (wrclk)) then
            if (wren = '1') then
                    ram(wraddr) <= data_in;
            end if;
        end if;
    end process PortB_p;

end rtl;

