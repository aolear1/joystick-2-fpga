# Joystick2Fpga

**Joystick2Fpga** is a real-time interface project that connects an STM32 Blue Pill microcontroller to an Intel FPGA (DE1-SoC) using a wireless UART link. The system reads joystick and button inputs on the Blue Pill and displays the processed data on the FPGA using hex displays and LEDs.
The project uses STM32 HAL as well as [Intel's University Program UART IP](https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/18.1/University_Program_IP_Cores/Communication/RS232.pdf).

---

## Project Components

- STM32 Blue Pill
- Random Arduino Joystick
- Pushbutton
- De1Soc
- 2 APC220 Wireless Uart Tranceivers
- Some resistors and capacitors and stuff
---

## Demo

[Here](https://youtu.be/DvpHV2o8FcU) is a video of a little demo. I hope to get this up and running with my space invaders game soon! Latency issues were improved by doubling baud rate and swithing to non-blocking uart transmits. Adding an RC filter on the button also removed most of the missed clicks. 

---
## Little Facts

- In `fpga` there is a .tcl script to import an avalon MM wrapper to read/process data from the UART fifo, and display it so any avalon MM master can access it. 
- APC220 Tranceiver parameters can be edited using [RF Magic Software](https://wiki.dfrobot.com/apc220_radio_data_module_sku_tel0005_), be sure to connect GND, TX, and RX *before* VCC for it to connect
- The UART IP's read interrupt is generated when there are >96 bytes in the FIFO, it also takes 3 cycles to clear. Best to base successive reads off polling the `RVALID` bit, but after you sucessfully read, it takes *an extra cycle* to go low after reading, so be sure to account for that otherwise the double read could overwrite your data with a 0.




