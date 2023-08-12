module jpeg_decoder_wrapper (
    input aclk,
    input aresetn,

    AXI_BUS.Slave  ctl_slv,
    AXI_BUS.Master dma_mst
  );

  assign ctl_slv.r_id   = ctl_slv.ar_id;
  assign ctl_slv.r_last = ctl_slv.r_valid;
  assign ctl_slv.b_id   = ctl_slv.aw_id;

  jpeg_decoder # (
                 .AXI_ID(4)
               )
               jpeg_decoder_inst (
                 .clk_i(aclk),
                 .rst_i(~aresetn),

                 .cfg_awvalid_i (ctl_slv.aw_valid),
                 .cfg_awaddr_i  (ctl_slv.aw_addr ),
                 .cfg_wvalid_i  (ctl_slv.w_valid ),
                 .cfg_wdata_i   (ctl_slv.w_data  ),
                 .cfg_wstrb_i   (ctl_slv.w_strb  ),
                 .cfg_bready_i  (ctl_slv.b_ready ),
                 .cfg_arvalid_i (ctl_slv.ar_valid),
                 .cfg_araddr_i  (ctl_slv.ar_addr ),
                 .cfg_rready_i  (ctl_slv.r_ready ),
                 .cfg_awready_o (ctl_slv.aw_ready),
                 .cfg_wready_o  (ctl_slv.w_ready ),
                 .cfg_bvalid_o  (ctl_slv.b_valid ),
                 .cfg_bresp_o   (ctl_slv.b_resp  ),
                 .cfg_arready_o (ctl_slv.ar_ready),
                 .cfg_rvalid_o  (ctl_slv.r_valid ),
                 .cfg_rdata_o   (ctl_slv.r_data  ),
                 .cfg_rresp_o   (ctl_slv.r_resp  ),

                 .outport_arvalid_o(dma_mst.ar_valid),
                 .outport_araddr_o (dma_mst.ar_addr ),
                 .outport_arid_o   (dma_mst.ar_id   ),
                 .outport_arlen_o  (dma_mst.ar_len  ),
                 .outport_arburst_o(dma_mst.ar_burst),
                 .outport_arready_i(dma_mst.ar_ready),
                 .outport_awready_i(dma_mst.aw_ready),
                 .outport_awvalid_o(dma_mst.aw_valid),
                 .outport_awaddr_o (dma_mst.aw_addr ),
                 .outport_awid_o   (dma_mst.aw_id   ),
                 .outport_awlen_o  (dma_mst.aw_len  ),
                 .outport_awburst_o(dma_mst.aw_burst),
                 .outport_wvalid_o (dma_mst.w_valid ),
                 .outport_wdata_o  (dma_mst.w_data  ),
                 .outport_wstrb_o  (dma_mst.w_strb  ),
                 .outport_wlast_o  (dma_mst.w_last  ),
                 .outport_wready_i (dma_mst.w_ready ),
                 .outport_bvalid_i (dma_mst.b_valid ),
                 .outport_bresp_i  (dma_mst.b_resp  ),
                 .outport_bid_i    (dma_mst.b_id    ),
                 .outport_bready_o (dma_mst.b_ready ),
                 .outport_rvalid_i (dma_mst.r_valid ),
                 .outport_rdata_i  (dma_mst.r_data  ),
                 .outport_rresp_i  (dma_mst.r_resp  ),
                 .outport_rid_i    (dma_mst.r_id    ),
                 .outport_rlast_i  (dma_mst.r_last  ),
                 .outport_rready_o (dma_mst.r_ready )
               );

endmodule
