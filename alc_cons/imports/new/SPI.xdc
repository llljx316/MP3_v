## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]


##Switches

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports rst]


## LEDs

set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports LED_INT1]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports LED_INT2]


##Accelerometer

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports MISO]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports MOSI]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports SCLK]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports CSN]
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports INT1]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports INT2]

set_property IOSTANDARD LVCMOS33 [get_ports {z_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {z_data[0]}]
set_property PACKAGE_PIN V11 [get_ports {z_data[7]}]
set_property PACKAGE_PIN V12 [get_ports {z_data[6]}]
set_property PACKAGE_PIN V14 [get_ports {z_data[5]}]
set_property PACKAGE_PIN V15 [get_ports {z_data[4]}]
set_property PACKAGE_PIN T16 [get_ports {z_data[3]}]
set_property PACKAGE_PIN U14 [get_ports {z_data[2]}]
set_property PACKAGE_PIN T15 [get_ports {z_data[1]}]
set_property PACKAGE_PIN V16 [get_ports {z_data[0]}]

set_property MARK_DEBUG true [get_nets {z_data_OBUF[0]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[1]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[2]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[3]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[4]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[5]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[6]}]
set_property MARK_DEBUG true [get_nets {z_data_OBUF[7]}]
set_property MARK_DEBUG true [get_nets CSN_OBUF]
set_property MARK_DEBUG true [get_nets {din[0]}]
set_property MARK_DEBUG true [get_nets {din[1]}]
set_property MARK_DEBUG true [get_nets {din[2]}]
set_property MARK_DEBUG true [get_nets {din[3]}]
set_property MARK_DEBUG true [get_nets {din[4]}]
set_property MARK_DEBUG true [get_nets {din[5]}]
set_property MARK_DEBUG true [get_nets {din[6]}]
set_property MARK_DEBUG true [get_nets {din[7]}]
set_property MARK_DEBUG true [get_nets MISO_IBUF]
set_property MARK_DEBUG true [get_nets MOSI_OBUF]
set_property MARK_DEBUG true [get_nets {config_cnt_reg[4]_i_2_n_0}]
set_property MARK_DEBUG true [get_nets {config_cnt_reg[4]_i_2_n_3}]
set_property MARK_DEBUG true [get_nets {config_cnt_reg[4]_i_2_n_1}]
set_property MARK_DEBUG true [get_nets {config_cnt_reg[4]_i_2_n_2}]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {z_data_OBUF[0]} {z_data_OBUF[1]} {z_data_OBUF[2]} {z_data_OBUF[3]} {z_data_OBUF[4]} {z_data_OBUF[5]} {z_data_OBUF[6]} {z_data_OBUF[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {din[0]} {din[1]} {din[2]} {din[3]} {din[4]} {din[5]} {din[6]} {din[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {config_cnt_reg[4]_i_2_n_0}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {config_cnt_reg[4]_i_2_n_1}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {config_cnt_reg[4]_i_2_n_2}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {config_cnt_reg[4]_i_2_n_3}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list CSN_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list MISO_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list MOSI_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
