# Incremental Encoder Example Logic for S7-1500 TM FAST Module

The Incremental Encoder Logic example designed in VHDL shows how to use the TM FAST module to read and use the value delivered by an Incremental Encoder. <br>
The incremental encoder logic is based on the FM352-5 module (see chapter 7 in the manual [here](https://support.industry.siemens.com/cs/ww/en/view/9240171). <br>
For basic information on the TM FAST Module see: [here](https://support.industry.siemens.com/cs/ww/en/view/109817062).

## Description

This example shows the use of an incremental encoder in conjunction with the TM FAST module.<br>
The user can connect an incremental Encoder to the module at DI0/1/2 (A/B/N) and read the values returned by the encoder in the feedback interface or control outputs depending on these values. <br>
### Control Interface
Can be parametrized in the Control Interface:

<table>
  <tr>
    <th>CTRL_IF</th>
    <th colspan="8" style="text-align: right">Byte3</th>
    <th colspan="8" style="text-align: right">Byte2</th>
    <th colspan="8" style="text-align: right">Byte1</th>
    <th colspan="8" style="text-align: right">Byte0</th>
  </tr>
  <tr>
    <td>*DWord0</td>
    <td colspan="27" style="text-align: center">-</td>
    <td colspan="5"  style="text-align: center">INC_CTRL</td>
  </tr>
  <tr>
</table>
INC_CTRL(4 downto 0) is structured as follow:
<table>
  <tr>
    <th>Bit4</th>
    <th>Bit3</th>
    <th>Bit2</th>
    <th>Bit1</th>
    <th>Bit0</th>
  </tr>
  <tr>
    <td>RESETSW</td>
    <td>HOLDSW</td>
    <td>EDGE</td>
    <td>LOAD</td>
    <td>PULSECLEAR</td>
  </tr>
  <tr>
</table>

### Feedback Interface
Can be read back in the feedback interface:

<table>
  <tr>
    <th>FB_IF</th>
    <th colspan="8" style="text-align: right">Byte3</th>
    <th colspan="8" style="text-align: right">Byte2</th>
    <th colspan="8" style="text-align: right">Byte1</th>
    <th colspan="8" style="text-align: right">Byte0</th>
  </tr>
  <tr>
    <td>*DWord0</td>
    <td colspan="1" style="text-align: center">-</td>
    <td colspan="5" style="text-align: center">INC_ENC_STATUS</td>
    <td colspan="2" style="text-align: center">DIAG_STATUS</td>
    <td colspan="12"  style="text-align: center">SET_DQ</td>
    <td colspan="12"  style="text-align: center">DI_STAT</td>
  </tr>
  <tr>
  <tr>
    <td>*DWord1</td>
    <td colspan="32" style="text-align: center">INC_ENC_COUNT_VALUE</td>
  </tr>
</table>

INC_ENC_STATUS is tructured as follow:

|bit  |30      |29       |28   |27  |26          |
|---  |---     |---      |---  |--- |---         |
|value|OVERFLOW|UNDERFLOW|HOMED|HOME|LASTCOUNTDIR|

DIAG_STATUS is structured as follow:

|bit|25|24|
|---|---|---|
|value|DIAG_STAT_LP_QI|DIAG_STAT_CPU_STOP|

### Incremental Encoder Module Ports Description:

|Parameter|Data type|Address|Description|
|   ---   |   ---   |   --- |       --- |
| A       |  BOOL   | Input |Encoder A /Pulse Input: **DI(0)**|
| B       |  BOOL   | Input |Encoder B /Pulse Input: **DI(1)**|
| B       |  BOOL   | Input |Encoder N /Null or Zero pulse: **DI(2)**|
|A_PULS_POL| BOOL   | Input |Invert A inpulse **FALSE** |
|B_DIR_POL| BOOL    | Input |Invert B inpulse **FALSE** |
|N_ZERO_POL| BOOL   | Input |Invert N inpulse **FALSE** |
|PULSECLEAR| BOOL   | Input |Reset Counter Value to 0 **CTRL_IF(0)(0)** |
|LOAD     | BOOL    | Input |Load input using **CTRL_IF(0)(1)**|
|EDGE     | BOOL    |Input  |Edge Input - Latch hold/reset signals : **CTRL_IF(0)(2)**|
|MISSINGSUPPLY| BOOL|Input  |if active, resets HOME/HOMED outputs|
|COUNT_MODE| BOOL   |Input  |Counting mode: <br> **0** ->  Single count <br> 1 -> double count <br> 2 -> quad count <br> 3 -> pulse/dir|
|COUNT_TYPE| BOOL   |Input  |Counting type: <br> **0** ->  Continous count <br> 1 -> periodic count <br> 2 -> single count| 
|COUNT_DIR| BOOL    |Input  |Main counting direction inverted **FALSE**|
|HOLDSW| BOOL       |Input  |SW-Hold input using **CTRL_IF(0)(3)**|
|HOLDHW| BOOL       |Input  |HW-Hold input **DI(3)**|
|HOLDSOURCE| BOOL   |Input  |Hold source: <br> 0 -> HW <br> 1 -> SW <br> 2 -> HW and SW <br> 3 -> HW or SW <br> **4** -> none| 
|RESETSW| BOOL      |Input  |SW-Reset input using **CTRL_IF(0)(4)**|
|RESETSOURCE| BOOL  |Input  |Reset source:<br> 0 -> none <br> **1** ->  HW-Reset <br> 2 -> SW-Reset <br> 3 -> HW and SW Reset <br> 4 -> HW or SW Reset|
|MAX_VALUE | WORD | Input | Count range max value **0000FFFF**|
|MIN_VALUE | WORD | Input | Count range min value **00000000**|
|RESET_VALUE | WORD | Input | reset value **000000FF**|
|LOAD_VALUE | WORD | Input | load value **00000000**|
|ENCODERCOUNT | WORD | Output | Encoder counter value|
|HOME |BOOL|Output|Home Signal|
|HOMED |BOOL|Output|Homed Signal|
|UNDERFLOW |BOOL|Output|Underflow occured|
|OVERFLOW  |BOOL|Output|Overflow occured|
|LASTCOUNTDIR|BOOL|Output|Direction of the last count pulse|
*Default values are marked in bold.

  ## Requirements
To use the logic example, you need to download the architecture and the package associated as well as the Quartus Project.
-	TFL_MP_FAST_1.qpf (provided with the system logic)
-	TFL_FAST_USER_INC_ENC_a.vhd
-	TFL_FAST_USER_INC_ENC_p.vhd
-   Inc_Enc_ea.vhd
-   Encoder_ea.vhd
-   QuadDec_ea.vhd

  ## Installation
1.	Download the example logic files INC_Encoder
2.	Open the Quartus project: TFL_MP_FAST_1.qpf. and replace TFL_FAST_USER_EXAMPLE_HELLO_WORLD_a.vhd with the TFL_FAST_USER_INC_ENC_a.vhd
3.	Add TFL_FAST_USER_INC_ENC_p.vhd.
4.	Run Compilation Process.


  ## History
  INC_ENC Example V1.0: First released Version