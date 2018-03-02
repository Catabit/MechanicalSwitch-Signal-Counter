# MechanicalSwitch-Signal-Counter

This project intended to capture the nature of mechanical switches in electronic circuits: imperfect. When the (usually) two metal plates in the switch make contact it is not guaranteed that they will not actually conduct and/or stop conducting multiple times before settling to a stable signal of 1 (Closed) or 0 (Open).

Read: https://en.wikipedia.org/wiki/Switch#Contact_bounce

Software tehniques exist to bypass this by using two timed measurements on the switch to make sure of a stable signal.

The code (vga_driver.vhd - name stayed this way from a previous project on VGA output) was uploaded on a Basys 3, Artix-7 FPGA and a on-board two position switch was used in testing.

Video:

https://youtu.be/b2KWymsdrEA

https://youtu.be/2LrTjuaM_Jo

https://youtu.be/EnODc7bOqkk
