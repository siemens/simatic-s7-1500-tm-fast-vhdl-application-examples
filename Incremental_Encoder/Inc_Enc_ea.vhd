---------------------------------------------------------------------------------
-- © Siemens 2024
-- SPDX-License-Identifier: MIT
--                                                                            
-- Create Date:    04/06/2020 
-- Design Name:    TM FAST logic library
-- Module Name:    Inc_Enc_e - Inc_Enc_a
-- Description:    Encoder interface.
--
-- Revision: 
-- Revision 1.0 - File modified 05/20/2021
-- Additional Comments:                                    
--                                                                            
--------------------------------------------------------------------------------


LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

entity Inc_Enc_e is
    Generic (
        -- bit width of the counter value
        BIT_WIDTH : natural := 32
    );   
    
    Port ( 
        -- Logic-Clock and -Reset
        CLK          : in  std_logic;                                    -- clock of user logic (low-to-high-edge!)
        RST          : in  std_logic;                                    -- reset of user logic (high-active!)
        STOP         : in  std_logic;                                    -- CPU_STOP
		CLKEN        : in  std_logic;                                    -- clk_en 
        -- Counter Signals A/B/N
        A            : in  std_logic;                                    -- a_pulse
        B            : in  std_logic;                                    -- b_dir
        N            : in  std_logic;                                    -- n_zero     
        -- Control  Interface 
        A_PULSE_POL  : in  std_logic;                                    -- a_pulse polarity
        B_DIR_POL    : in  std_logic;                                    -- b_dir polarity
        N_ZERO_POL   : in  std_logic;                                    -- n_zero polarity
        PULSECLEAR   : in  std_logic;                                    -- clear counter value
        LOAD         : in  std_logic;                                    -- load signal    
        EDGE         : in  std_logic;                                    -- edge signal  
        MISSINGSUPPLY: in  std_logic;                                    -- quality information of L+ supply
        COUNT_MODE   : in  std_logic_vector (  1 downto 0 );             -- AB1, AB2, AB4 or PULSE/DIRECTION Count mode
        COUNT_TYPE   : in  std_logic_vector (  1 downto 0 );             -- three types of counting ( continuous, periodic, and single  )
        COUNT_DIR    : in  std_logic;                                    -- selects whether counting up (0) or counting down (1) is the main count direction
        HOLDSW       : in  std_logic;                                    -- SW-Hold       
        HOLDHW       : in  std_logic;
        HOLDSOURCE   : in  std_logic_vector (2 downto 0);                -- Holdsource selection 
        RESETSW      : in  std_logic;                                    -- SW-Reset     
        RESETSOURCE  : in  std_logic_vector (2 downto 0);                -- Resetsource selection
        MAX_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);    -- Count range Max-Value 
        MIN_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);    -- Count range Min-Value
        RESET_VALUE  : in  std_logic_vector ((BIT_WIDTH-1) downto 0);    -- Reset value
        LOAD_VALUE   : in  std_logic_vector ((BIT_WIDTH-1) downto 0);    -- Load value
        ENCODERCOUNT : out std_logic_vector ((BIT_WIDTH-1) downto 0);    -- Encoder Counter Value
        HOME         : out std_logic;                                    -- Home signal
        HOMED        : out std_logic;                                    -- Homed signal
        UNDERFLOW    : out std_logic;                                    -- Underflow occured
        OVERFLOW     : out std_logic;                                    -- Overflow occured
        LASTCOUNTDIR : out std_logic                                     -- Direction of the last count pulse
    );
end Inc_Enc_e;

architecture Inc_Enc_a of Inc_Enc_e is

component Encoder_e
    Generic ( 
        BIT_WIDTH : natural
    );
    
    Port ( 
        RST          : in  std_logic;
        CLK          : in  std_logic;
        STOP         : in  std_logic;
		  CLKEN        : in  std_logic;
        PULSECLEAR   : in  std_logic;
        LOAD         : in  std_logic;
        CD           : in  std_logic;
        CU           : in  std_logic;
        EDGE         : in  std_logic;
        MISSINGSUPPLY: in  std_logic;
        CNT_TYPE     : in  std_logic_vector(1 downto 0); 
        CNT_DIR      : in  std_logic;                    
        HOLDSW       : in  std_logic;
        HOLDHW       : in  std_logic;
        HOLDSOURCE   : in  std_logic_vector (2 downto 0);
        RESETSW      : in  std_logic;
        RESETHW      : in  std_logic;
        RESETSOURCE  : in  std_logic_vector (2 downto 0);
        MAX_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        MIN_VALUE    : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        RESET_VALUE  : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        LOAD_VALUE   : in  std_logic_vector ((BIT_WIDTH-1) downto 0);
        ENCODERCOUNT : out std_logic_vector ((BIT_WIDTH-1) downto 0);
        HOME         : out std_logic;
        HOMED        : out std_logic;
        UNDERFLOW    : out std_logic;
        OVERFLOW     : out std_logic;
        LASTCOUNTDIR : out std_logic
    );
end component;

component QuadDec_e
    Port ( 
        RST    : in     std_logic;
        CLK    : in     std_logic;
        A      : in     std_logic;
        B      : in     std_logic;
        N      : in     std_logic;
        Inv_A  : in     std_logic;
        Inv_B  : in     std_logic;
        Inv_N  : in     std_logic;
        CU1    : buffer std_logic;
        CU2    : buffer std_logic;
        CU4    : out    std_logic;
        CD1    : buffer std_logic;
        CD2    : buffer std_logic;
        CD4    : out    std_logic;
        RESETHW: out    std_logic
    );
end component;

    -- quaddec signals                                                   
    signal CU1  : std_logic := '0';    -- count up AB1
    signal CU2  : std_logic := '0';    -- count up AB2
    signal CU4  : std_logic := '0';    -- count up AB4
    signal CD1  : std_logic := '0';    -- count down AB1
    signal CD2  : std_logic := '0';    -- count down AB2
    signal CD4  : std_logic := '0';    -- count down AB4
    signal HWRST: std_logic := '0';    -- Reset count value (n_zero pulse)
    -- common ENCODER signals    
    signal CD   : std_logic := '0';    -- count down 
    signal CU   : std_logic := '0';    -- count up

begin

    -- wire QUADDEC to ENCODER32
    CU <= CU1 when COUNT_DIR = '0' and COUNT_MODE = "00" else
          CU2 when COUNT_DIR = '0' and COUNT_MODE = "01" else
          CU4 when COUNT_DIR = '0' and COUNT_MODE = "10" else
          CU2 when COUNT_DIR = '0' and B = '0' and COUNT_MODE = "11" else 
          -- main direction inverted
          CD1 when COUNT_DIR = '1' and COUNT_MODE = "00" else
          CD2 when COUNT_DIR = '1' and COUNT_MODE = "01" else
          CD4 when COUNT_DIR = '1' and COUNT_MODE = "10" else
          CD2 when COUNT_DIR = '1' and B = '1' and COUNT_MODE = "11" else
          '0';

            
    CD <= CD1 when COUNT_DIR = '0' and COUNT_MODE = "00" else
          CD2 when COUNT_DIR = '0' and COUNT_MODE = "01" else
          CD4 when COUNT_DIR = '0' and COUNT_MODE = "10" else
          CD2 when COUNT_DIR = '0' and B = '1' and COUNT_MODE = "11" else
          -- main direction inverted
          CU1 when COUNT_DIR = '1' and COUNT_MODE = "00" else
          CU2 when COUNT_DIR = '1' and COUNT_MODE = "01" else          
          CU4 when COUNT_DIR = '1' and COUNT_MODE = "10" else          
          CU2 when COUNT_DIR = '1' and B = '0' and COUNT_MODE = "11" else          
          '0';

    QUADDEC_M: QuadDec_e
        PORT MAP (
            RST     => RST,           -- reset
            CLK     => CLK,           -- clock
            A       => A,             -- a_pulse
            B       => B,             -- b_dir
            N       => N,             -- n_zero 
            INV_A   => A_PULSE_POL,   -- a_pulse polarity
            INV_B   => B_DIR_POL,     -- b_dir polarity
            INV_N   => N_ZERO_POL,    -- n_zero polarity
            CU1     => CU1,
            CU2     => CU2,
            CU4     => CU4,
            CD1     => CD1,
            CD2     => CD2,
            CD4     => CD4,
            RESETHW => HWRST          -- ResetHW Signal generated by N_ZERO 
    );

    ENCODER_M: Encoder_e
    GENERIC MAP( BIT_WIDTH => BIT_WIDTH ) 
        PORT MAP (
            RST           => RST,          -- asynchronous reset
            CLK           => CLK,
            STOP          => STOP,         -- CPU_STOP 	
			CLKEN 		  => '1',
            PULSECLEAR    => PULSECLEAR, 
            LOAD          => LOAD, 
            CD            => CD, 
            CU            => CU, 
            EDGE          => EDGE, 
            MISSINGSUPPLY => MISSINGSUPPLY,   
            CNT_TYPE      => COUNT_TYPE,   
            CNT_DIR       => COUNT_DIR,
            HOLDSW        => HOLDSW, 
            HOLDHW        => HOLDHW, 
            HOLDSOURCE    => HOLDSOURCE, 
            RESETSW       => RESETSW, 
            RESETHW       => HWRST, 
            RESETSOURCE   => RESETSOURCE, 
            MAX_VALUE     => MAX_VALUE, 
            MIN_VALUE     => MIN_VALUE, 
            RESET_VALUE   => RESET_VALUE, 
            LOAD_VALUE    => LOAD_VALUE, 
            ENCODERCOUNT  => ENCODERCOUNT,
            HOME          => HOME,
            HOMED         => HOMED,
            UNDERFLOW     => UNDERFLOW,
            OVERFLOW      => OVERFLOW,
            LASTCOUNTDIR  => LASTCOUNTDIR    
    );
    
end Inc_Enc_a;