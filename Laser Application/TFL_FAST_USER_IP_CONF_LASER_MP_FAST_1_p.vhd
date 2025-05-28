--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- top heading: IP-configuration-package of User Logic of S7-1500 TM FAST     --
--                                                                            --
-- filename:    TFL_FAST_USER_IP_CONF_PUBLIC_MP_FAST_1_p.vhd                  --
--                                                                            --
-- revision:    V1.0                                                          --
--                                                                            --
-- copyright:   Siemens AG, Digital Industries, Factory Automation            --
--                                                                            --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.TFL_FAST_USER_PUBLIC1_p.all;
use work.TFL_FAST_USER_PUBLIC2_p.all;
use work.TFL_FAST_USER_IP_CONF_p.all;


package TFL_FAST_USER_IP_CONF_PUBLIC_p is


  -- User logic version format: <LETTER><XX>.<YY>.<ZZ>
  -- User logic version letter: only R,B,V,P or T are allowed
  -- with XX: 1...99, YY: 0...99 and ZZ: 0...99
  -- for example: B01.02.43
  constant  USER_LOGIC_VERSION:   LOGIC_VERSION_TYPE  := ( LETTER => 'V', XX => 1, YY => 0, ZZ => 0 );

  -- User application ID
  -- 8 characters to describe your user logic application
  -- allowed values: letters, numbers and underscore character
  constant  APPLICATION_ID:       APPLICATION_ID_TYPE :=  ( 'A', 'P', 'P', 'L', 'a', 's', 'e', 'r');

  -- Function ID ( hex )
  -- Reserved for future use, set to x"00000000"
  constant  FUNCTION_ID:          FUNCTION_ID_TYPE    :=  x"00000000";

  -- Size of write record from CPU to TM FAST, in dwords
  --   32 (128 bytes, needs 2800 logic elements)
  --   16 ( 64 bytes, needs 1400 logic elements)
  --    8 ( 32 bytes, needs  700 logic elements)
  --    1 (  4 bytes, needs  130 logic elements)
  constant  WR_REC_DWORD_SIZE:    integer range 1 to WR_REC_DWORD_MAX_SIZE := 1;

  -- Size of user read record from TM FAST to CPU, in dwords
  -- allowed values:
  --   32 (128 bytes, needs 1200 logic elements)
  --   16 ( 64 bytes, needs  600 logic elements)
  --    8 ( 32 bytes, needs  300 logic elements)
  --    1 (  4 bytes, needs   70 logic elements)
  constant  RD_REC_DWORD_SIZE:    integer range 1 to RD_REC_DWORD_MAX_SIZE := 1;

  -- user clock frequency
  -- allowed values:
  --    5_000_000 ( 5 MHz, 200.0 ns userlogic cycle periode duration)
  --   15_000_000 (15 MHz,  66.7 ns userlogic cycle periode duration)
  --   25_000_000 (25 MHz,  40.0 ns userlogic cycle periode duration)
  --   50_000_000 (50 MHz,  20.0 ns userlogic cycle periode duration)
  --   75_000_000 (75 MHz,  13.3 ns userlogic cycle periode duration)
  constant  F_CLK_USER:           integer :=  50_000_000;

  -- quantity of user clock phases, used by boolean library components
  -- only necessary for migration library from FM352-5
  -- Example: if the user logic is running with 15 MHz and
  --          the resulting process cycle should be 1 us, then USER_PHASES need to be set to 14
  --          to get in total 15 phases (14 user phases plus one for latch of process I/Os)
  -- Set to '0' if FM 352-5 migration library is not used.
  constant  PHASE_QUANTITY:       integer range 0 to PHASE_MAX_QUANTITY :=  0;

  -- Set interface type and direction of RS485/RS422/TTL channels
  -- RS485 / RS422 / TTL interfaces are organized in groups:
  -- CH0:  RS485 / RS422 / TTL-group0,
  -- CH1:  RS485 / RS422 / TTL-group0,
  -- CH2:  RS485 / RS422 / TTL-group1,
  -- CH3:  RS485 / RS422 / TTL-group1,
  -- CH4:  RS485 / RS422 / TTL-group2,
  -- CH5:  RS485 / RS422 / TTL-group2,
  -- CH6:  RS485 / RS422 / TTL-group3,
  -- CH7:  RS485 / RS422 / TTL-group3,
  -- !!! If TTL is selected: both channels of one group have to be set as TTL interface !!!
  --
  -- possible values:
  --    RS485_bidir  ( RS485 interface, direction changeable in userlogic )
  --    RS422_input  ( RS422 input only )
  --    RS422_output ( RS422 output only )
  --    TTL_input    ( TTL single ended input only )
  --    TTL_output   ( TTL single ended output only )
  --    unused       ( channel not used, RS485 transceiver set as input)
  constant  RS485_OR_TTL_DIRECTION:  RS485_OR_TTL_DIRECTION_TYPE :=
                                  ( 0 => RS422_output,   -- ch0
                                    1 => RS422_output,   -- ch1
                                    2 => RS422_output,   -- ch2
                                    3 => RS422_output,   -- ch3
                                    4 => RS422_output,   -- ch4
                                    5 => RS422_output,   -- ch5
                                    6 => RS422_output,   -- ch6
                                    7 => RS422_output ); -- ch7

  -- enable internal termination for RS485/RS422 channels
  -- only possible for ch0, ch1, ch4 in modes RS485_bidir or RS422_input
  -- all other RS485/RS422 channels: no internal termination available
  -- possible values:
  --     enabled       ( internal termination is enabled, available only for channels: 0, 1 and 4 in modes RS485_bidir or RS422_input )
  --     disabled      ( internal termination is disabled, available only for channels: 0, 1 and 4 )
  --     parameterized ( internal termination is parameterized in TIA Portal, available only for channels: 0, 1 and 4)
  --     unused        ( internal termination is not available, all other channels: 2, 3, 5, 6 and 7, don't change!)
  constant  RS485_TERMINATION:  RS485_TERMINATION_TYPE :=
                                  ( 0      => disabled,  -- ch0 internal termination
                                    1      => disabled,  -- ch1 internal termination
                                    4      => disabled,  -- ch4 internal termination
                                    others => unused ); -- other RS485 channels: no internal termination available, don't change

  -- User defined digital input (DI) filter times in milliseconds (min.: 0, max.: 27.96ms, resolution: 13.33ns)
  -- To use this user defined filter times for the digital inputs: parametrize customer constant filter time in TIA Portal.
  constant DI_FILTER_USER_VAL_MS: DI_FILT_TYPE_REAL :=
                                  ( 0 => 0.000000,   -- User defined filter value for DI0
                                    1 => 0.000000,   -- User defined filter value for DI1
                                    2 => 0.000000,   -- User defined filter value for DI2
                                    3 => 0.000000,   -- User defined filter value for DI3
                                    4 => 0.000000,   -- User defined filter value for DI4
                                    5 => 0.000000,   -- User defined filter value for DI5
                                    6 => 0.000000,   -- User defined filter value for DI6
                                    7 => 0.000000,   -- User defined filter value for DI7
                                    8 => 0.000000,   -- User defined filter value for DI8
                                    9 => 0.000000,   -- User defined filter value for DI9
                                   10 => 0.000000,   -- User defined filter value for DI10
                                   11 => 0.000000 ); -- User defined filter value for DI11

  -- User defined RS485/RS422/TTL input filter values in milliseconds (min.: 0, max.: 27.96ms, resolution: 13.33ns)
  -- To use this user defined filter times for the RS485/RS422/TTL inputs: parametrize customer constant filter time in TIA Portal.
  constant RS485_TTL_FILTER_USER_VAL_MS: RS485_TTL_FILT_TYPE_REAL :=
                                  ( 0 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch0
                                    1 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch1
                                    2 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch2
                                    3 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch3
                                    4 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch4
                                    5 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch5
                                    6 => 0.000000,   -- User defined filter value for RS485/RS422/TTL input ch6
                                    7 => 0.000000 ); -- User defined filter value for RS485/RS422/TTL input ch7


end package TFL_FAST_USER_IP_CONF_PUBLIC_p;