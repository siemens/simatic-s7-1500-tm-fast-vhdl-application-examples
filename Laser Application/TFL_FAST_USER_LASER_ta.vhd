--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- top heading Hello World example testbench of User Logic of TM FASTs        --
--             without use of latch of control and feedback interface         --
--                                                                            --
-- filename    TFL_FAST_USER_TEST_HELLO_WORLD_ta.vhd                          --
--                                                                            --
-- copyright   (c) Siemens AG, Automation Systems                             --
--                                                                            --
-- SPDX-License-Identifier: MIT                                               --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TFL_FAST_USER_IP_CONF_p.all;
use work.TFL_FAST_USER_PUBLIC1_p.all;
use work.TFL_FAST_USER_PUBLIC2_p.all;
use work.TFL_FAST_USER_IP_CONF_PUBLIC_p.all;
use work. TFL_FAST_USER_IP_CONF_p.all;


architecture TFL_FAST_USER_LASER_ta of TFL_FAST_USER_te is

  --------------------------------------------
  -- signals of User Logic TFL_FAST_USER_e --
  --------------------------------------------
  -- Logic-Clock and -Reset
  signal  CLK:          std_logic           := '0';                             -- clock of user logic (high edge!)
  signal  PHASE:        std_logic_vector ( PHASE_MAX_QUANTITY downto 0 ):= ( others => '0' ); -- clock phases for boolean library components
  signal  RST_N:        std_logic           := '1';                             -- reset (low-active!)
  signal  RST:          std_logic           := '0';                             -- reset of user logic (high-active!)
  -- Process I/Os
  signal  DI:           std_logic_vector ( ( DI_QUANTITY - 1 ) downto 0 )    := ( others => '0' );               -- digital process inputs (DIs) (inputs are already filtered)
  signal  DQ:           std_logic_vector ( ( DQ_QUANTITY - 1 ) downto 0 )    := ( others => '0' );               -- digital process outputs (DQs)
  -- RS485 I/Os
  signal  RS485_RX:     RS485_TYPE          := ( others => '1' );               -- receive data
  signal  RS485_TX:     RS485_TYPE          := ( others => '1' );               -- transmit data
  signal  RS485_OE:     RS485_TYPE          := ( others => '0' );               -- transmit output enable
  -- quality informations (QI)
  signal  LP_QI_BAD:    std_logic             := '0';                             -- quality information of L+ supply
  signal  DI_QI_BAD:    std_logic_vector ( ( DI_QUANTITY - 1 ) downto 0 ) := ( others => '0' ); -- quality information of digital process inputs (DIs)
  signal  DQ_QI_BAD:    std_logic_vector ( ( DQ_QUANTITY - 1 ) downto 0 ) := ( others => '0' ); -- quality information of digital process outputs (DQs)
  signal  RS485_QI_BAD: RS485_TYPE          := ( others => '1' );               -- quality information of RS485 channels
  -- CPU_STOP Output DISable of Process Outputs
  signal  CPU_STOP:     std_logic           := '0';                             -- output disable of process outputs
  -- Isochronous Signals
  signal  T_DC:         std_logic     := '0';                                   -- Tdc leading time mark (high for only one CLK!)
  signal  T_I:          std_logic     := '0';                                   -- Ti time mark          (high for only one CLK!)
  signal  T_O:          std_logic     := '0';                                   -- To time mark          (high for only one CLK!)
  signal  T_I_LATCH:      std_logic     := '0';                                   -- T_I_LATCH time mark     (high for only one CLK!)
  signal  T_O_LATCH:      std_logic     := '0';                                   -- T_O_LATCH time mark     (high for only one CLK!)

  -----------------------------
  -- local testbench signals --
  -----------------------------
  -- Logic-Clock and -Reset
  signal  CLK_ENABLE:               boolean             := true;                            -- clock enable for logic clock generator

  -- INFO text
  signal  INFO:                     string ( 1 to 100 ) := ( others => ' ' );               -- info text

  -- Control and Feedback Interface
  signal  CTRL_IF0:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF1:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF2:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF3:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF4:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF5:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF6:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF7:                  DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER0:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER1:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER2:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER3:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER4:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER5:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER6:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER7:             DWORD := ( others => '0' ); -- control interface to user logic
  signal  CTRL_IF_USER_LATCH0:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH1:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH2:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH3:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH4:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH5:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH6:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  CTRL_IF_USER_LATCH7:       DWORD := ( others => '0' ); -- latched control interface to user logic
  signal  FB_IF0:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF1:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF2:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF3:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF4:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF5:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF6:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF7:                    DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER0:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER1:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER2:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER3:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER4:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER5:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER6:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_USER7:               DWORD := ( others => '0' ); -- feedback interface of user logic
  signal  FB_IF_SYS_LATCH0:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH1:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH2:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH3:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH4:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH5:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH6:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  FB_IF_SYS_LATCH7:          DWORD := ( others => '0' ); -- latched feedback interface to system logic
  signal  SET_CTRL_IF:              std_logic           := '0';  -- set control interface tic @ user clock domain
  signal  GET_FB_IF:                std_logic           := '0';  -- get feedback interface tic @ user clock domain
  signal  SET_CTRL_IF_TOGGLE:       std_logic           := '0';  -- set control interface tic @ user clock domain
  signal  GET_FB_IF_TOGGLE:         std_logic           := '0';  -- get feedback interface tic @ user clock domain
  signal  SET_CTRL_IF_LAST:         std_logic           := '0';  -- set control interface tic @ user clock domain
  signal  GET_FB_IF_LAST:           std_logic           := '0';  -- get feedback interface tic @ user clock domain
  signal  CTRL_FB_IF_LATCH_ENABLE:  boolean             := false;-- enable to used latch of control & feedback interface

  -- Read and Write Record
  signal  WR_REC00:                 DWORD := ( others => '0' ); -- Write Record
  signal  RD_REC00:                 DWORD := ( others => '0' ); -- Read Record
  signal  WR_REC_NEW:               std_logic           := '0'; -- Tic signal for new write record to user logic
  signal  RD_REC_BUSY:              std_logic           := '0'; -- Tic signal for new read record from user logic


  -- LaserApp Signals
  type t_array_mux is array (0 to 6) of std_logic_vector(31 downto 0);
  signal DATA_MAN  : t_array_mux;

  signal Adress:                 std_logic_vector ( 11 downto 0 ) := ( others => '0' ); 

  begin


  ------------------------------------------------------------
  -- Instantiation of User Logic as device under test (DUT) --
  ------------------------------------------------------------
  DUT_i: entity work.TFL_FAST_USER_e(LASER_a)

  -- if you want to simulate genenerated VHDL of of a QUARTUS SCHEMATIC user logic file use the following line
  --  DUT_i: entity work.TFL_FAST_USER_e(bdf_type)

  port map (
    -- Logic-Clock and -Reset
    CLK           => CLK,           -- clock of user logic (low-to-high-edge!)
    PHASE         => PHASE,         -- clock phases for boolean library components
    RST           => RST,           -- reset of user logic (high-active!)
    -- Control and Feedback Interface
    CTRL_IF0       => CTRL_IF_USER0,  -- control interface
    CTRL_IF1       => CTRL_IF_USER1,  -- control interface
    CTRL_IF2       => CTRL_IF_USER2,  -- control interface
    CTRL_IF3       => CTRL_IF_USER3,  -- control interface
    CTRL_IF4       => CTRL_IF_USER4,  -- control interface
    CTRL_IF5       => CTRL_IF_USER5,  -- control interface
    CTRL_IF6       => CTRL_IF_USER6,  -- control interface
    CTRL_IF7       => CTRL_IF_USER7,  -- control interface
    FB_IF0         => FB_IF_USER0,    -- feedback interface
    FB_IF1         => FB_IF_USER1,    -- feedback interface
    FB_IF2         => FB_IF_USER2,    -- feedback interface
    FB_IF3         => FB_IF_USER3,    -- feedback interface
    FB_IF4         => FB_IF_USER4,    -- feedback interface
    FB_IF5         => FB_IF_USER5,    -- feedback interface
    FB_IF6         => FB_IF_USER6,    -- feedback interface
    FB_IF7         => FB_IF_USER7,    -- feedback interface
    -- Control and Feedback Interface
    WR_REC00       => WR_REC00,   -- Write Record
    WR_REC01       => ( others => '0' ),
    WR_REC02       => ( others => '0' ),
    WR_REC03       => ( others => '0' ),
    WR_REC04       => ( others => '0' ),
    WR_REC05       => ( others => '0' ),
    WR_REC06       => ( others => '0' ),
    WR_REC07       => ( others => '0' ),
    WR_REC08       => ( others => '0' ),
    WR_REC09       => ( others => '0' ),
    WR_REC10       => ( others => '0' ),
    WR_REC11       => ( others => '0' ),
    WR_REC12       => ( others => '0' ),
    WR_REC13       => ( others => '0' ),
    WR_REC14       => ( others => '0' ),
    WR_REC15       => ( others => '0' ),
    WR_REC16       => ( others => '0' ),
    WR_REC17       => ( others => '0' ),
    WR_REC18       => ( others => '0' ),
    WR_REC19       => ( others => '0' ),
    WR_REC20       => ( others => '0' ),
    WR_REC21       => ( others => '0' ),
    WR_REC22       => ( others => '0' ),
    WR_REC23       => ( others => '0' ),
    WR_REC24       => ( others => '0' ),
    WR_REC25       => ( others => '0' ),
    WR_REC26       => ( others => '0' ),
    WR_REC27       => ( others => '0' ),
    WR_REC28       => ( others => '0' ),
    WR_REC29       => ( others => '0' ),
    WR_REC30       => ( others => '0' ),
    WR_REC31       => ( others => '0' ),

    RD_REC00       => RD_REC00,   -- Read Record
    RD_REC01       => open,
    RD_REC02       => open,
    RD_REC03       => open,
    RD_REC04       => open,
    RD_REC05       => open,
    RD_REC06       => open,
    RD_REC07       => open,
    RD_REC08       => open,
    RD_REC09       => open,
    RD_REC10       => open,
    RD_REC11       => open,
    RD_REC12       => open,
    RD_REC13       => open,
    RD_REC14       => open,
    RD_REC15       => open,
    RD_REC16       => open,
    RD_REC17       => open,
    RD_REC18       => open,
    RD_REC19       => open,
    RD_REC20       => open,
    RD_REC21       => open,
    RD_REC22       => open,
    RD_REC23       => open,
    RD_REC24       => open,
    RD_REC25       => open,
    RD_REC26       => open,
    RD_REC27       => open,
    RD_REC28       => open,
    RD_REC29       => open,
    RD_REC30       => open,
    RD_REC31       => open,

    WR_REC_NEW    => WR_REC_NEW,    -- Write Record New
    RD_REC_BUSY   => RD_REC_BUSY,    -- Read Record New
    -- Process I/Os
    DI            => DI,            -- digital process inputs (DIs) (inputs are already filtered)
    DQ            => DQ,            -- digital process outputs (DQs)
    -- RS485 I/Os
    RS485_RX      => RS485_RX,      -- receive data
    RS485_TX      => RS485_TX,      -- transmit data
    RS485_OE      => RS485_OE,      -- transmit output enable
    -- quality informations (QI) 1=BAD 0=GOOD
    LP_QI_BAD     => LP_QI_BAD,     -- quality information of L+ supply
    DI_QI_BAD     => DI_QI_BAD,     -- quality information of digital process inputs (DIs)
    DQ_QI_BAD     => DQ_QI_BAD,     -- quality information of digital process outputs (DQs)
    RS485_QI_BAD  => RS485_QI_BAD,  -- quality information of RS485 channels
    -- SIMATIC CPU STOP
    CPU_STOP      => CPU_STOP,      -- SIMATIC CPU status 1=STOP 0=RUN
    -- Isochronous Signals
    T_DC          => T_DC,          -- Tdc time mark        (high for only one CLK!)
    T_I           => T_I,           -- Ti time mark         (high for only one CLK!)
    T_O           => T_O,           -- To time mark         (high for only one CLK!)
    T_I_LATCH       => T_I_LATCH,       -- T_I_LATCH time mark     (high for only one CLK!)
    T_O_LATCH       => T_O_LATCH        -- T_O_LATCH time mark     (high for only one CLK!)
  );


  -------------------------------------
  -- logic clock and phase generator --
  -------------------------------------
  CLK_GEN_p: process
  begin
    while CLK_ENABLE loop
      wait for ( 1 sec / F_CLK_USER / 2 );
      CLK <= not CLK;
    end loop;
    wait;
  end process CLK_GEN_p;

  PHASE_p: process ( RST, CLK )
    variable PHASE_v: unsigned ( PHASE'range );
  begin
    if RST = '1' then
      PHASE   <= ( PHASE'low => '1', others => '0' );
    elsif rising_edge ( CLK ) then
      PHASE_v := shift_left ( unsigned ( PHASE ), 1 );
      if PHASE_v = 0 then
        PHASE_v ( PHASE_v'low ) := '1';
      end if;
      PHASE <= std_logic_vector ( PHASE_v );
    end if;
  end process PHASE_p;


  RST_N <= not RST;

  ---------------------------------------------------------------
  -- latch of control & feedback interface @ user clock domain --
  ---------------------------------------------------------------

  -- latch of control & feedback interface @ user clock domain
  -- all CTRL_IF registers will be latched together for consistent CTRL_IF data and
  -- all FB_IF registers will be latched together for consistent FB_IF data
  USER_CTRL_FB_IF_i: entity work.TFL_FAST_USER_CTRL_FB_IF_e(TFL_FAST_USER_CTRL_FB_IF_a)
  port map (
    -- Logic-Clock and -Reset
    CLK_USER          => CLK,                 -- clock of user logic (low-to-high-edge!)
    RST_USER          => RST,                 -- reset of user logic (high-active!)
    -- Control and Feedback Interface
    CTRL_IF_SYS0      => CTRL_IF0,             -- control interface from system logic
    CTRL_IF_SYS1      => CTRL_IF1,             -- control interface from system logic
    CTRL_IF_SYS2      => CTRL_IF2,             -- control interface from system logic
    CTRL_IF_SYS3      => CTRL_IF3,             -- control interface from system logic
    CTRL_IF_SYS4      => CTRL_IF4,             -- control interface from system logic
    CTRL_IF_SYS5      => CTRL_IF5,             -- control interface from system logic
    CTRL_IF_SYS6      => CTRL_IF6,             -- control interface from system logic
    CTRL_IF_SYS7      => CTRL_IF7,             -- control interface from system logic
    CTRL_IF_USER0     => CTRL_IF_USER_LATCH0,  -- latched control interface to user logic
    CTRL_IF_USER1     => CTRL_IF_USER_LATCH1,  -- latched control interface to user logic
    CTRL_IF_USER2     => CTRL_IF_USER_LATCH2,  -- latched control interface to user logic
    CTRL_IF_USER3     => CTRL_IF_USER_LATCH3,  -- latched control interface to user logic
    CTRL_IF_USER4     => CTRL_IF_USER_LATCH4,  -- latched control interface to user logic
    CTRL_IF_USER5     => CTRL_IF_USER_LATCH5,  -- latched control interface to user logic
    CTRL_IF_USER6     => CTRL_IF_USER_LATCH6,  -- latched control interface to user logic
    CTRL_IF_USER7     => CTRL_IF_USER_LATCH7,  -- latched control interface to user logic
    SET_CTRL_IF_USER  => SET_CTRL_IF,         -- set control interface data for user logic
    FB_IF_USER0       => FB_IF_USER0,          -- feedback interface from user logic
    FB_IF_USER1       => FB_IF_USER1,          -- feedback interface from user logic
    FB_IF_USER2       => FB_IF_USER2,          -- feedback interface from user logic
    FB_IF_USER3       => FB_IF_USER3,          -- feedback interface from user logic
    FB_IF_USER4       => FB_IF_USER4,          -- feedback interface from user logic
    FB_IF_USER5       => FB_IF_USER5,          -- feedback interface from user logic
    FB_IF_USER6       => FB_IF_USER6,          -- feedback interface from user logic
    FB_IF_USER7       => FB_IF_USER7,          -- feedback interface from user logic
    FB_IF_SYS0        => FB_IF_SYS_LATCH0,     -- latched feedback interface to system logic
    FB_IF_SYS1        => FB_IF_SYS_LATCH1,     -- latched feedback interface to system logic
    FB_IF_SYS2        => FB_IF_SYS_LATCH2,     -- latched feedback interface to system logic
    FB_IF_SYS3        => FB_IF_SYS_LATCH3,     -- latched feedback interface to system logic
    FB_IF_SYS4        => FB_IF_SYS_LATCH4,     -- latched feedback interface to system logic
    FB_IF_SYS5        => FB_IF_SYS_LATCH5,     -- latched feedback interface to system logic
    FB_IF_SYS6        => FB_IF_SYS_LATCH6,     -- latched feedback interface to system logic
    FB_IF_SYS7        => FB_IF_SYS_LATCH7,     -- latched feedback interface to system logic

    GET_FB_IF_USER    => GET_FB_IF            -- get feedback interface data of user logic
  );

  -- procedure to handle set/get control/feedback latching
  SET_CTRL_GET_FB_IF_p: process ( RST, CLK ) is
  begin
    if RST = '1' then
      SET_CTRL_IF_LAST  <= '0';
      GET_FB_IF_LAST    <= '0';
    elsif rising_edge ( CLK ) then
      SET_CTRL_IF_LAST  <= SET_CTRL_IF_TOGGLE;
      GET_FB_IF_LAST    <= GET_FB_IF_TOGGLE;
    end if;
  end process SET_CTRL_GET_FB_IF_p;

  SET_CTRL_IF   <= SET_CTRL_IF_TOGGLE xor SET_CTRL_IF_LAST;
  GET_FB_IF     <= GET_FB_IF_TOGGLE   xor GET_FB_IF_LAST;


  CTRL_IF_USER0  <= CTRL_IF_USER_LATCH0 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF0;
  CTRL_IF_USER1  <= CTRL_IF_USER_LATCH1 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF1;
  CTRL_IF_USER2  <= CTRL_IF_USER_LATCH2 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF2;
  CTRL_IF_USER3  <= CTRL_IF_USER_LATCH3 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF3;
  CTRL_IF_USER4  <= CTRL_IF_USER_LATCH4 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF4;
  CTRL_IF_USER5  <= CTRL_IF_USER_LATCH5 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF5;
  CTRL_IF_USER6  <= CTRL_IF_USER_LATCH6 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF6;
  CTRL_IF_USER7  <= CTRL_IF_USER_LATCH7 when CTRL_FB_IF_LATCH_ENABLE else CTRL_IF7;

  FB_IF0        <= FB_IF_SYS_LATCH0    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER0;
  FB_IF1        <= FB_IF_SYS_LATCH1    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER1;
  FB_IF2        <= FB_IF_SYS_LATCH2    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER2;
  FB_IF3        <= FB_IF_SYS_LATCH3    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER3;
  FB_IF4        <= FB_IF_SYS_LATCH4    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER4;
  FB_IF5        <= FB_IF_SYS_LATCH5    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER5;
  FB_IF6        <= FB_IF_SYS_LATCH6    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER6;
  FB_IF7        <= FB_IF_SYS_LATCH7    when CTRL_FB_IF_LATCH_ENABLE else FB_IF_USER7;


  ---------------
  -- testbench --
  ---------------
  TESTBENCH_p: process


    -- procedure to set the INFO string
    procedure SET_INFO ( s: string ) is
    begin
      -- visible in waveform
      INFO <= ( others => ' ' );
      INFO ( s'range ) <= s;
	  -- visible in QUESTA Transcript
      report INFO;
    end procedure SET_INFO;


    -- procedure to wait a given quantity of logic clocks
    procedure WAIT_CLK ( n: positive := 1 ) is
    begin
      for i in 1 to n loop
        wait until rising_edge ( CLK );
      end loop;
      wait for ( 1 sec / F_CLK_USER / 3 );
    end procedure WAIT_CLK;


    -- procedure to do a logic reset for a given quantity of logic clocks
    procedure RESET ( n: positive := 1 ) is
    begin
      SET_INFO ( "RESET" );
      -- reset Control and Feedback Interface
      CTRL_IF0                <= ( others => '0' );
      CTRL_IF1                <= ( others => '0' );
      CTRL_IF2                <= ( others => '0' );
      CTRL_IF3                <= ( others => '0' );
      CTRL_IF4                <= ( others => '0' );
      CTRL_IF5                <= ( others => '0' );
      CTRL_IF6                <= ( others => '0' );
      CTRL_IF7                <= ( others => '0' );
      CTRL_FB_IF_LATCH_ENABLE <= false;
      SET_CTRL_IF_TOGGLE      <= '0';
      GET_FB_IF_TOGGLE        <= '0';
      -- reset Process I/Os
      DI                      <= ( others => '0' );               -- digital process inputs (DIs) (inputs are already filtered)
      -- reset quality informations (QI)
      LP_QI_BAD               <= '1';                             -- quality information of L+ supply
      DI_QI_BAD               <= ( others => '1' );               -- quality information of digital process inputs (DIs)
      DQ_QI_BAD               <= ( others => '1' );               -- quality information of digital process outputs (DQs)
      -- set CPU to stop
      CPU_STOP                <= '1';                             -- output disable of process outputs
      -- do the reset
      RST                     <= '1';
      WAIT_CLK(n);
      RST                     <= '0';
      wait for ( 1 sec / F_CLK_USER / 100 );
    end procedure RESET;


    -- procedure set control interface at next user clock for consistent CTRL_IF data
    procedure SET_CTRL_IF_NEXT_CLK is
    begin
      SET_CTRL_IF_TOGGLE      <= not SET_CTRL_IF_LAST;
      CTRL_FB_IF_LATCH_ENABLE <= true;
    end procedure SET_CTRL_IF_NEXT_CLK;


    -- procedure get feedback interface at next user clock for consistent FB_IF data
    procedure GET_FB_IF_NEXT_CLK is
    begin
      GET_FB_IF_TOGGLE <= not GET_FB_IF_LAST;
      CTRL_FB_IF_LATCH_ENABLE <= true;
    end procedure GET_FB_IF_NEXT_CLK;
	



  ------------------------
  -- begin of testbench --
  ------------------------

  begin


  -- DATA_MAN(0) <= x"763C8057";
  -- DATA_MAN(1) <= x"89C48057";
  -- DATA_MAN(2) <= x"93889141";
  -- DATA_MAN(3) <= x"89C4A22B";
  -- DATA_MAN(4) <= x"763CA22B";
  -- DATA_MAN(5) <= x"6C779141";
  -- DATA_MAN(6) <= x"763C8057";
    -- do basic checks
    assert DI_QUANTITY = 12 report "unexpected DI_QUANTITY!" severity failure;
    assert DQ_QUANTITY = 12 report "unexpected DQ_QUANTITY!" severity failure;

    -- do logic reset
    SET_INFO ( "do logic reset" );
    WAIT_CLK(5);
    RESET;

    ----------------------------------------------------------
    -- set all quality informations to good and clear CPU_STOP
    ----------------------------------------------------------
    SET_INFO ( "set all quality informations to good and clear CPU_STOP" );
    -- set LP_QI_BAD to '0' (quality information of L+ supply is good)
    LP_QI_BAD <= '0';
    -- set DI_QI_BAD to '0' (quality information of the DIs is good)
    DI_QI_BAD <= ( others => '0' );
    -- set DQ_QI_BAD to '0' (quality information of the DQs is good)
    DQ_QI_BAD <= ( others => '0' );
    -- set LP_QI_BAD to '0' (clear CPU_STOP)
    CPU_STOP      <= '0';
    
    WAIT_CLK(5);


    --------------------------------------------------
    -- stimuli and check: DQ11 for Laser power and SETUP Bits
    --------------------------------------------------
    SET_INFO ( "Check DQ11 for Laser power and SETUP" );
        
      --  CTRL_IF0(7) <= '1'; -- Mode Manual
    WAIT_CLK(5);
	 CTRL_IF0(0) <= '1'; -- Start and stop of transmission
	 
    WAIT_CLK(10);
	--CTRL_IF0(7) <= '0'; -- Mode Manual
	 
    --assert DQ(11) = '0' report "unexpected DQ11!" severity Warning;

    --------------------------------------------------
    -- check SEND Coordonates from CTRL_IF
    --------------------------------------------------

    SET_INFO ( "SEND Coordonates from CTRL_IF" );
    
    --for i in 0 to 6 loop
    --  CTRL_IF1(11 downto 0) <= std_logic_vector(to_unsigned(i, Adress'length)); -- Coordinates Adress for RAM
    --  CTRL_IF4 <= DATA_MAN(i); -- Coordonates XY for the RAM
	--  CTRL_IF0(3) <= '1'; --WR_enable
	--  WAIT_CLK(10);
	--  CTRL_IF0(3) <= '0'; --WR_enable
    --  WAIT_CLK(25);
    --end loop;
    --assert RS485_OE = "00000000" report "unexpected RS485_OE" severity failure;
    --WAIT_CLK(5);
	--CTRL_IF0(1) <= '1'; -- Switch laser on and off
      WAIT_CLK(1000000);

  -----------------------------------------------
  -- testbench part2 STOP and Start Again--------
  -----------------------------------------------
	--CTRL_IF0(7) <= '0'; -- Mode Manual
  --     WAIT_CLK(50);
  --     CTRL_IF0(0) <= '0'; -- Start and stop of transmission
  --     WAIT_CLK(5000);
	--     CTRL_IF0(0) <= '1'; -- Start and stop of transmission
  --     WAIT_CLK(5000); 
       -- CTRL_IF0(7) <= '1'; -- Mode Manual
  --    WAIT_CLK(200000);
    --------------------------------------------------
    -- stimuli and check: Turn Off laser
    --------------------------------------------------
    SET_INFO ( "Check Turn Off Laser" );
    CTRL_IF0(0) <= '0'; -- Start and stop of transmission
    WAIT_CLK(1);
    --CTRL_IF0(1) <= '0'; -- Switch laser on and off
    WAIT_CLK(1);
   -- CTRL_IF0(7) <= '0'; -- Mode Manual
	  WAIT_CLK(5);
    --assert DQ(11) = '0' report "unexpected DQ11!" severity Warning;
    -------------------
    -- end of testbench
	-------------------
    SET_INFO ( "end of testbench" );
    WAIT_CLK(5);
    CLK_ENABLE <= false;  -- switch off logic clock generator
    wait;

  end process TESTBENCH_p;


end architecture TFL_FAST_USER_LASER_ta;
