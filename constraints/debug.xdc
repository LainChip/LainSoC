




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_gen_1/inst/slow_sys_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[0]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[1]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[2]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[3]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[4]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[5]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[6]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[7]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[8]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[9]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[10]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[11]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[12]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[13]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[14]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[15]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[16]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[17]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[18]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[19]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[20]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[21]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[22]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[23]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[24]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[25]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[26]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[27]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[28]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[29]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[30]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_data_q[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[0]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[1]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[2]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[3]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[4]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[5]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[6]} {soc/jpeg_decoder/jpeg_decoder_inst/wr_addr_w[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/state_q[0]} {soc/jpeg_decoder/jpeg_decoder_inst/state_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[0]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[1]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[2]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[3]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[4]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[5]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[6]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[7]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[8]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[9]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[10]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[11]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[12]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[13]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[14]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[15]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[16]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[17]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[18]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[19]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[20]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[21]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[22]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[23]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[24]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[25]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[26]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[27]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[28]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[29]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[30]} {soc/jpeg_decoder/jpeg_decoder_inst/outport_rdata_i[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[0]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[1]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[2]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[3]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[4]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[5]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[6]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[7]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[8]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[9]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[10]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[11]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[12]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[13]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[14]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[15]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[16]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[17]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[18]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[19]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[20]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[21]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[22]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[23]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[24]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[25]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[26]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[27]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[28]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[29]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[30]} {soc/jpeg_decoder/jpeg_decoder_inst/jpeg_data_w[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[0]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[1]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[2]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[3]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[4]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[5]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[6]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[7]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[8]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[9]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[10]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[11]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[12]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[13]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[14]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[15]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[16]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[17]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[18]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[19]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[20]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[21]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[22]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[23]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[24]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[25]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[26]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[27]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[28]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[29]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[30]} {soc/jpeg_decoder/jpeg_decoder_inst/araddr_q[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 5 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {soc/jpeg_decoder/jpeg_decoder_inst/u_core/u_jpeg_input/state_q[0]} {soc/jpeg_decoder/jpeg_decoder_inst/u_core/u_jpeg_input/state_q[1]} {soc/jpeg_decoder/jpeg_decoder_inst/u_core/u_jpeg_input/state_q[2]} {soc/jpeg_decoder/jpeg_decoder_inst/u_core/u_jpeg_input/state_q[3]} {soc/jpeg_decoder/jpeg_decoder_inst/u_core/u_jpeg_input/state_q[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/cfg_awvalid_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/jpeg_accept_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/jpeg_valid_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_arready_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_arvalid_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_awvalid_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_rlast_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_rready_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_rvalid_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_wready_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/outport_wvalid_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list soc/jpeg_decoder/jpeg_decoder_inst/write_en_w]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets slow_sys_clk]
