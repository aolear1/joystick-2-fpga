# Joystick2Fpga

**Joystick2Fpga** is a real-time interface project that connects an STM32 Blue Pill microcontroller to an Intel FPGA (DE1-SoC) using a wireless UART link. The system reads joystick and button inputs on the Blue Pill and displays the processed data on the FPGA using hex displays and LEDs.
The project uses STM32 HAL as well as Intel's University Program UART IP.

---

## Project Components

- STM32 Blue Pill
- Random Arduino Joystick
- Pushbutton
- De1Soc
- 2 APC220 Wireless Uart Tranceivers
- Some resistors and capacitors and stuff
---

## Little Facts

In `fpga` there is a .tcl script to import an avalon MM wrapper to read/process data from the UART fifo, and display it so any avalon MM master can access it. 
[Here](https://youtu.be/DvpHV2o8FcU) is a video of a little demo. I hope to get this up and running with my space invaders game soon!



