### This file is RPI Logic board .xdc for the PYNQ-Z2 ########################################
### To use it in a project:
### - uncomment the lines corresponding to used pins
### - rename the used ports (in each line, after get_ports)
### - according to the top level signal names in the project
###
############################Raspberry Digital I/O###############################################
### Clock signal 12 MHz  ##
##set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { OSC_12MHz }]; #rpio_21

###Button #Active Low##
##set_property -dict { PACKAGE_PIN V7    IOSTANDARD LVCMOS33 } [get_ports { Button }]; #rpio_27  

### SSD(Seven Segment Display) x 4 ##
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { seg_data[0] }]; #rpio_sd
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { seg_data[1] }]; #rpio_sc
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { seg_data[2] }]; #rpio_02
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { seg_data[3] }]; #rpio_03
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { seg_data[4] }]; #rpio_04
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { seg_data[5] }]; #rpio_05
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { seg_data[6] }]; #rpio_06
#set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { seg_data[] }]; #rpio_07

set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { digit_sel[0] }]; #rpio_08
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { digit_sel[1] }]; #rpio_09
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports { digit_sel[2] }]; #rpio_10
set_property -dict { PACKAGE_PIN W10   IOSTANDARD LVCMOS33 } [get_ports { digit_sel[3] }]; #rpio_11

###LED(GREEN)##
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { blink[0] }]; #rpio_12
set_property -dict { PACKAGE_PIN W8    IOSTANDARD LVCMOS33 } [get_ports { blink[1] }]; #rpio_13
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports { blink[2] }]; #rpio_22
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports { blink[3] }]; #rpio_23
set_property -dict { PACKAGE_PIN Y7    IOSTANDARD LVCMOS33 } [get_ports { blink[4] }]; #rpio_24
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { blink[5] }]; #rpio_25

###Switches##
#set_property -dict { PACKAGE_PIN V6    IOSTANDARD LVCMOS33 } [get_ports { D }]; #rpio_14
#set_property -dict { PACKAGE_PIN Y6    IOSTANDARD LVCMOS33 } [get_ports { C }]; #rpio_15
#set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { B }]; #rpio_16
#set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports { A }]; #rpio_17
##set_property -dict { PACKAGE_PIN C20   IOSTANDARD LVCMOS33 } [get_ports { A[0] }]; #rpio_18
##set_property -dict { PACKAGE_PIN Y8    IOSTANDARD LVCMOS33 } [get_ports { A[1] }]; #rpio_19
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { set }]; #rpio_20
set_property -dict { PACKAGE_PIN W9    IOSTANDARD LVCMOS33 } [get_ports { start_stop }]; #rpio_26