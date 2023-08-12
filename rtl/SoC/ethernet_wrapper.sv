module ethernet_wrapper #(
    parameter C_ASIC_SRAM = 1'b0
) (
    input aclk,
    input aresetn,                     

    output interrupt_0,
 
    input           mii_tx_clk,
    output  [3:0]   mii_txd,    
    output          mii_tx_en,
    output          mii_tx_er,

    input           mii_rx_clk,
    input   [3:0]   mii_rxd, 
    input           mii_rxdv,
    input           mii_rx_err,
    input           mii_crs,
    input           mii_col,

    input           md_i_0,      
    output          mdc_0,
    output          md_o_0,
    output          md_t_0,
    output          phy_rstn,
    
    AXI_BUS.Slave   slv
);

`include "debug.vh"

`DEBUG_W(mii_txd)
`DEBUG_W(mii_tx_en)
`DEBUG_W(mii_tx_er)

`DEBUG_W(mii_rxd)
`DEBUG_W(mii_rxdv)
`DEBUG_W(mii_rx_err)
`DEBUG_W(md_i_0)
`DEBUG_W(mdc_0)
`DEBUG_W(md_o_0)
`DEBUG_W(md_t_0)
`DEBUG_W(phy_rstn)


wire           mcoll_soc;
wire           mcrs_soc;

stolen_cdc_array_single #(2, 0, 2) crs_cdc(
   .src_in({mii_col, mii_crs}),
   .dest_clk(aclk),
   .dest_out({mcoll_soc, mcrs_soc})
);

axi_ethernetlite #(
  .C_S_AXI_ACLK_PERIOD_PS(20000),
  .C_TX_PING_PONG(1),
  .C_RX_PING_PONG(1),
  .C_SELECT_XPM(!C_ASIC_SRAM)
) eth (
  .s_axi_aclk(aclk),
  .s_axi_aresetn(aresetn),
  .ip2intc_irpt(interrupt_0),
  
  .s_axi_awid(slv.aw_id),
  .s_axi_awaddr(slv.aw_addr[12:0]),
  .s_axi_awlen(slv.aw_len),
  .s_axi_awsize(slv.aw_size),
  .s_axi_awburst(slv.aw_burst),
  .s_axi_awcache(slv.aw_cache),
  .s_axi_awvalid(slv.aw_valid),
  .s_axi_awready(slv.aw_ready),
  .s_axi_wdata(slv.w_data),
  .s_axi_wstrb(slv.w_strb),
  .s_axi_wlast(slv.w_last),
  .s_axi_wvalid(slv.w_valid),
  .s_axi_wready(slv.w_ready),
  .s_axi_bid(slv.b_id),
  .s_axi_bresp(slv.b_resp),
  .s_axi_bvalid(slv.b_valid),
  .s_axi_bready(slv.b_ready),
  .s_axi_arid(slv.ar_id),
  .s_axi_araddr(slv.ar_addr[12:0]),
  .s_axi_arlen(slv.ar_len),
  .s_axi_arsize(slv.ar_size),
  .s_axi_arburst(slv.ar_burst),
  .s_axi_arcache(slv.ar_cache),
  .s_axi_arvalid(slv.ar_valid),
  .s_axi_arready(slv.ar_ready),
  .s_axi_rid(slv.r_id),
  .s_axi_rdata(slv.r_data),
  .s_axi_rresp(slv.r_resp),
  .s_axi_rlast(slv.r_last),
  .s_axi_rvalid(slv.r_valid),
  .s_axi_rready(slv.r_ready),
    
  .phy_tx_clk(mii_tx_clk),
  .phy_rx_clk(mii_rx_clk),
  .phy_crs(mcrs_soc),
  .phy_dv(mii_rxdv),
  .phy_rx_data(mii_rxd),
  .phy_col(mcoll_soc),
  .phy_rx_er(mii_rx_err),
  .phy_tx_en(mii_tx_en),
  .phy_tx_data(mii_txd),
  .phy_mdio_i(md_i_0),
  .phy_mdio_o(md_o_0),
  .phy_mdio_t(md_t_0),
  .phy_mdc(mdc_0),
  .phy_rst_n(phy_rstn)
);

endmodule
