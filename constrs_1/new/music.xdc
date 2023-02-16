#mp3_board
set_property IOSTANDARD LVCMOS33 [get_ports o_XRST]
set_property IOSTANDARD LVCMOS33 [get_ports i_DREQ]
#set_property IOSTANDARD LVCMOS33 [get_ports i_SO]
set_property IOSTANDARD LVCMOS33 [get_ports o_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports o_SI]
set_property IOSTANDARD LVCMOS33 [get_ports o_XCS]
set_property IOSTANDARD LVCMOS33 [get_ports o_XDCS]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN G1 [get_ports i_DREQ]
#set_property PACKAGE_PIN F3 [get_ports i_SO]
set_property PACKAGE_PIN G4 [get_ports o_SCK]
set_property PACKAGE_PIN G2 [get_ports o_SI]
set_property PACKAGE_PIN H2 [get_ports o_XCS]
set_property PACKAGE_PIN H4 [get_ports o_XDCS]
set_property PACKAGE_PIN J15 [get_ports rst_n]
set_property PACKAGE_PIN H1 [get_ports o_XRST]


set_property IOSTANDARD LVCMOS33 [get_ports o_LED]
set_property PACKAGE_PIN H17 [get_ports o_LED]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN E3 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN J3 [get_ports rx]


#display 7
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {onum[0]}]

set_property PACKAGE_PIN T10 [get_ports {onum[0]}]
set_property PACKAGE_PIN R10 [get_ports {onum[1]}]
set_property PACKAGE_PIN K16 [get_ports {onum[2]}]
set_property PACKAGE_PIN K13 [get_ports {onum[3]}]
set_property PACKAGE_PIN P15 [get_ports {onum[4]}]
set_property PACKAGE_PIN T11 [get_ports {onum[5]}]
set_property PACKAGE_PIN L18 [get_ports {onum[6]}]

set_property PACKAGE_PIN J17 [get_ports {odigit[0]}]
set_property PACKAGE_PIN J18 [get_ports {odigit[1]}]
set_property PACKAGE_PIN T9 [get_ports {odigit[2]}]
set_property PACKAGE_PIN J14 [get_ports {odigit[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {odigit[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {odigit[4]}]
set_property PACKAGE_PIN P14 [get_ports {odigit[4]}]
set_property PACKAGE_PIN T14 [get_ports {odigit[5]}]
set_property PACKAGE_PIN K2 [get_ports {odigit[6]}]
set_property PACKAGE_PIN U13 [get_ports {odigit[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_led_song_select[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_led_song_select[0]}]
set_property PACKAGE_PIN V11 [get_ports o_led_song_select]

#vga
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]
set_property PACKAGE_PIN D8 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN D7 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN C7 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN B7 [get_ports {VGA_B[3]}]
set_property PACKAGE_PIN A4 [get_ports {VGA_R[0]}]
set_property PACKAGE_PIN C5 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN B4 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN A3 [get_ports {VGA_R[3]}]
set_property PACKAGE_PIN A6 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN B6 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN A5 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN C6 [get_ports {VGA_G[3]}]
set_property PACKAGE_PIN B11 [get_ports VGA_HS]
set_property PACKAGE_PIN B12 [get_ports VGA_VS]

#others
set_property IOSTANDARD LVCMOS33 [get_ports o_next]
set_property PACKAGE_PIN K15 [get_ports o_next]

set_property PACKAGE_PIN V11 [get_ports {o_led_song_select[1]}]
set_property PACKAGE_PIN V12 [get_ports {o_led_song_select[0]}]

