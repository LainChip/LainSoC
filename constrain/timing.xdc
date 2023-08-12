set _xlnx_shared_i0 [get_nets -hierarchical -filter CDC_ASYNC==1]
set_max_delay -through $_xlnx_shared_i0 10.000
set_false_path -hold -through $_xlnx_shared_i0

set_false_path -to [get_cells -hier -regexp {.*/syncstages_ff_reg\[0\]} -filter {STOLEN_CDC == "SINGLE" || STOLEN_CDC == "SYNC_RST"}]
set_false_path -to [get_cells -hier -regexp {.*/syncstages_ff_reg\[0\]\[\d+\]} -filter {STOLEN_CDC == "ARRAY_SINGLE"}]

set_max_delay -datapath_only -from [get_cells -hier -regexp .*/src_gray_ff_reg.* -filter {STOLEN_CDC == "GRAY"}] -to [get_cells -hier -regexp {.*/dest_graysync_ff_reg\[0\].*} -filter {STOLEN_CDC == "GRAY"}] 10.000
set_bus_skew -from [get_cells -hier -regexp .*/src_gray_ff_reg.* -filter {STOLEN_CDC == "GRAY"}] -to [get_cells -hier -regexp {.*/dest_graysync_ff_reg\[0\].*} -filter {STOLEN_CDC == "GRAY"}] 10.000


current_instance soc/ethernet/eth/XEMAC_I/EMAC_I/RX/INST_RX_INTRFCE/I_RX_FIFO/xpm_fifo_base_inst
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -through [get_pins -of_objects [get_cells -hier stolen_fifo_mem_reg*] -filter {DIRECTION==OUT}]
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -to [get_cells -hier *rd_tmp_reg_reg*]

current_instance -quiet
current_instance soc/ethernet/eth/XEMAC_I/EMAC_I/TX/INST_TX_INTRFCE/I_TX_FIFO/xpm_fifo_base_inst
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -through [get_pins -of_objects [get_cells -hier stolen_fifo_mem_reg*] -filter {DIRECTION==OUT}]
set_false_path -from [all_fanout -from [get_ports -scoped_to_current_instance wr_clk] -flat -endpoints_only] -to [get_cells -hier *rd_tmp_reg_reg*]


