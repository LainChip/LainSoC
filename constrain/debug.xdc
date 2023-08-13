
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
connect_debug_port u_ila_0/clk [get_nets [list clk_gen_1/inst/cpu_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {soc/cpu/cpu_mid/debug_wb_pc[0]} {soc/cpu/cpu_mid/debug_wb_pc[1]} {soc/cpu/cpu_mid/debug_wb_pc[2]} {soc/cpu/cpu_mid/debug_wb_pc[3]} {soc/cpu/cpu_mid/debug_wb_pc[4]} {soc/cpu/cpu_mid/debug_wb_pc[5]} {soc/cpu/cpu_mid/debug_wb_pc[6]} {soc/cpu/cpu_mid/debug_wb_pc[7]} {soc/cpu/cpu_mid/debug_wb_pc[8]} {soc/cpu/cpu_mid/debug_wb_pc[9]} {soc/cpu/cpu_mid/debug_wb_pc[10]} {soc/cpu/cpu_mid/debug_wb_pc[11]} {soc/cpu/cpu_mid/debug_wb_pc[12]} {soc/cpu/cpu_mid/debug_wb_pc[13]} {soc/cpu/cpu_mid/debug_wb_pc[14]} {soc/cpu/cpu_mid/debug_wb_pc[15]} {soc/cpu/cpu_mid/debug_wb_pc[16]} {soc/cpu/cpu_mid/debug_wb_pc[17]} {soc/cpu/cpu_mid/debug_wb_pc[18]} {soc/cpu/cpu_mid/debug_wb_pc[19]} {soc/cpu/cpu_mid/debug_wb_pc[20]} {soc/cpu/cpu_mid/debug_wb_pc[21]} {soc/cpu/cpu_mid/debug_wb_pc[22]} {soc/cpu/cpu_mid/debug_wb_pc[23]} {soc/cpu/cpu_mid/debug_wb_pc[24]} {soc/cpu/cpu_mid/debug_wb_pc[25]} {soc/cpu/cpu_mid/debug_wb_pc[26]} {soc/cpu/cpu_mid/debug_wb_pc[27]} {soc/cpu/cpu_mid/debug_wb_pc[28]} {soc/cpu/cpu_mid/debug_wb_pc[29]} {soc/cpu/cpu_mid/debug_wb_pc[30]} {soc/cpu/cpu_mid/debug_wb_pc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {soc/cpu/cpu_mid/debug_wb_instr[0]} {soc/cpu/cpu_mid/debug_wb_instr[1]} {soc/cpu/cpu_mid/debug_wb_instr[2]} {soc/cpu/cpu_mid/debug_wb_instr[3]} {soc/cpu/cpu_mid/debug_wb_instr[4]} {soc/cpu/cpu_mid/debug_wb_instr[5]} {soc/cpu/cpu_mid/debug_wb_instr[6]} {soc/cpu/cpu_mid/debug_wb_instr[7]} {soc/cpu/cpu_mid/debug_wb_instr[8]} {soc/cpu/cpu_mid/debug_wb_instr[9]} {soc/cpu/cpu_mid/debug_wb_instr[10]} {soc/cpu/cpu_mid/debug_wb_instr[11]} {soc/cpu/cpu_mid/debug_wb_instr[12]} {soc/cpu/cpu_mid/debug_wb_instr[13]} {soc/cpu/cpu_mid/debug_wb_instr[14]} {soc/cpu/cpu_mid/debug_wb_instr[15]} {soc/cpu/cpu_mid/debug_wb_instr[16]} {soc/cpu/cpu_mid/debug_wb_instr[17]} {soc/cpu/cpu_mid/debug_wb_instr[18]} {soc/cpu/cpu_mid/debug_wb_instr[19]} {soc/cpu/cpu_mid/debug_wb_instr[20]} {soc/cpu/cpu_mid/debug_wb_instr[21]} {soc/cpu/cpu_mid/debug_wb_instr[22]} {soc/cpu/cpu_mid/debug_wb_instr[23]} {soc/cpu/cpu_mid/debug_wb_instr[24]} {soc/cpu/cpu_mid/debug_wb_instr[25]} {soc/cpu/cpu_mid/debug_wb_instr[26]} {soc/cpu/cpu_mid/debug_wb_instr[27]} {soc/cpu/cpu_mid/debug_wb_instr[28]} {soc/cpu/cpu_mid/debug_wb_instr[29]} {soc/cpu/cpu_mid/debug_wb_instr[30]} {soc/cpu/cpu_mid/debug_wb_instr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {soc/cpu/cpu_mid/core_wrap/intrpt[0]} {soc/cpu/cpu_mid/core_wrap/intrpt[1]} {soc/cpu/cpu_mid/core_wrap/intrpt[2]} {soc/cpu/cpu_mid/core_wrap/intrpt[3]} {soc/cpu/cpu_mid/core_wrap/intrpt[4]} {soc/cpu/cpu_mid/core_wrap/intrpt[5]} {soc/cpu/cpu_mid/core_wrap/intrpt[6]} {soc/cpu/cpu_mid/core_wrap/intrpt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {soc/cpu/cpu_mid/debug_wb_rf_wdata[0]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[1]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[2]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[3]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[4]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[5]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[6]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[7]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[8]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[9]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[10]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[11]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[12]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[13]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[14]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[15]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[16]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[17]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[18]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[19]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[20]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[21]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[22]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[23]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[24]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[25]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[26]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[27]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[28]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[29]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[30]} {soc/cpu/cpu_mid/debug_wb_rf_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {soc/cpu/cpu_mid/debug0_wb_rf_wnum_nc[0]} {soc/cpu/cpu_mid/debug0_wb_rf_wnum_nc[1]} {soc/cpu/cpu_mid/debug0_wb_rf_wnum_nc[2]} {soc/cpu/cpu_mid/debug0_wb_rf_wnum_nc[3]} {soc/cpu/cpu_mid/debug0_wb_rf_wnum_nc[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list soc/cpu/cpu_mid/debug0_wb_rf_we_nc]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets cpu_clk]
