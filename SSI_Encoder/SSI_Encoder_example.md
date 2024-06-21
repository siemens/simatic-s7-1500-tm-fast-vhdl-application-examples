# Synchronous Serial Interface (SSI) Example Logic for S7-1500 TM FAST Module

The SSI Logic example designed in VHDL shows how to use the **TM FAST** module to read and use the value delivered by an SSI Encoder.
For basic information on the TM FAST Module see [here](https://support.industry.siemens.com/cs/ww/en/view/109817062)

## Description

This example shows the use of an SSI encoder in conjunction with the TM FAST module.
The user can connect an SSI Encoder to the module at CH0 (CLK OUT) and CH4 (DATA IN) and read the values returned by the encoder in the feedback interface.

|  FB_IF  |   |   |   |Byte3|   |   |   |   |   |   |   |Byte2|   |   |   |   |   |   |   |Byte1|   |   |   |   |   |   | |Byte0|   |   |   |   |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|0||||||||||||||||ENCODERCOUNT ||||||||||
|1||||||||||||||||||||||||||||||DATAAVAILABLE|FRAME_OVERRUN|


| Parameter             |Data type| Description                         |
|   ---                 |  ---    |     ---                             |
| SSI_CLOCK_TX          |  BOOL   | SSI clock output is **CH0**         |
| SSI_DATA_IN_RX        |  BOOL   | SSI data input is **CH4**           |
| COUNT_BIT_WIDTH       |  Int    | SSI whole frame length **16bits**   |
| FRAME_BIT_WIDTH       |  Int    | SSI position value length **13bits**|
| CLOCKSEL              |  Int    | SSI Baudrate Selection: <br> **0** ->  125KHz <br> 1 -> 250KHz <br> 2 -> 500KHz <br> 3 -> 1MHz|
| MONOFLOPSEL           |  Int    | SSI Monoflop Selection:<br> **0** ->  16us <br> 1 -> 32us <br> 2 -> 48us <br> 3 -> 64us|
| GREY_BIN_N_CTRL       |  BOOL   | Signal Encoding  : <br> **0** -> Gray Code to Absolute Binary <br>  1 -> no conversion|
| FB_IF_SSI_VAL         |  Int    | FB_IF address selection for the Position Value (DW0 to 7)  |
| FB_IF_DATAAVAILABLE_W |  Int    | FB_IF Word address selection for DATAAVAILABLE (DW0 to 7)  |
| FB_IF_DATAAVAILABLE_B |  Int    | FB_IF address bit selection for DATAAVAILABLE (bit 0 to 31)|
| FB_IF_FRAME_OVERRUN_W |  Int    | FB_IF Word address selection for FRAME_OVERRUN (DW0 to 7)  |
| FB_IF_FRAME_OVERRUN_B |  Int    | FB_IF address bit selection for FRAME_OVERRUN (bit 0 to 31)|
| SHIFT_DIR             |  string | Justification : <br> - **"right"** <br> - "left"               |
| SHIFT_COUNT           |  Int    | Number of bits to shift (0 to FRAME_BIT_WIDTH - 1) :  **0**|



## Requirement

To use the logic example, you need to download the architecture and the package associated as well as the Quartus Project.
 
 -	TFL_MP_FAST_1.qpf (provided with the system logic)
 -	SSI_ea.vhd
 -	SSI_Input_ea.vhd
 -	SSI_ClockOut_ea.vhd
 -	TFL_FAST_USER_EXAMPLE_SSI_a.vhd
 -   TFL_FAST_USER_EXAMPLE_SSI_p.vhd

## Installation

1.	Download the example logic files.
2.	Open the Quartus project: TFL_MP_FAST_1.qpf. and replace the necessary files.
3.	Rename the Application and Logic version in TFL_FAST_USER_IP_CONF_PUBLIC_MP_FAST_1_p.vhd
4.	Run Compilation Process.

## History

SSI Example V0.1: First released Version.\
SSI Example V1.0.1: Release for the System logic 1.0.1

