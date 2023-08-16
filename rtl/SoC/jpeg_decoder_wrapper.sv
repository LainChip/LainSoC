module jpeg_decoder_wrapper (
    input aclk,
    input decoder_clk,
    input aresetn,

    input dma_clk,
    input dma_resetn,

    AXI_BUS.Slave  ctl_slv,
    AXI_BUS.Master dma_mst
  );

`define AXI_LINE(name) AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)) name()
`define AXI_LITE_LINE(name) AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) name()

  `AXI_LINE(ctl_slv_slow);
  `AXI_LINE(dma_slow);
  `AXI_LITE_LINE(ctl_slv_lite);

`undef AXI_LINE
`undef AXI_LITE_LINE

  axi_cdc_intf #(.AXI_ID_WIDTH(4),.AXI_ADDR_WIDTH(32),.AXI_DATA_WIDTH(32),.LOG_DEPTH(3)) slv_trans(
                 .src_clk_i(aclk),
                 .src_rst_ni(aresetn),
                 .src(ctl_slv),
                 .dst_clk_i(decoder_clk),
                 .dst_rst_ni(aresetn),
                 .dst(ctl_slv_slow)
               );
  // axi_cdc_wrapper  slv_trans (
  //                    .s_aclk(aclk),
  //                    .s_aresetn(aresetn),
  //                    .m_aclk(decoder_clk),
  //                    .m_aresetn(aresetn),
  //                    .slv(ctl_slv),
  //                    .mst(ctl_slv_slow)
  //                  );
  xil_axi_to_axi_lite_wrapper  axi2axil_mod (
                                 .aclk(decoder_clk),
                                 .aresetn(aresetn),
                                 .slv(ctl_slv_slow),
                                 .mst(ctl_slv_lite)
                               );

  // wire[31:0] waddr = ctl_slv_lite.aw_addr;
  // wire[31:0] wdata = ctl_slv_lite.w_data;
  // wire wready = ctl_slv_lite.w_ready;

  axi_cdc_intf #(.AXI_ID_WIDTH(4),.AXI_ADDR_WIDTH(32),.AXI_DATA_WIDTH(32),.LOG_DEPTH(3)) mst_trans(
                 .src_clk_i(decoder_clk),
                 .src_rst_ni(aresetn),
                 .src(dma_slow),
                 .dst_clk_i(dma_clk),
                 .dst_rst_ni(dma_resetn),
                 .dst(dma_mst)
               );
  // axi_cdc_wrapper  mst_trans (
  //                    .s_aclk(decoder_clk),
  //                    .s_aresetn(aresetn),
  //                    .m_aclk(dma_clk),
  //                    .m_aresetn(dma_resetn),
  //                    .slv(dma_slow),
  //                    .mst(dma_mst)
  //                  );
  jpeg_decoder # (
                 .AXI_ID(0)
               )
               jpeg_decoder_inst (
                 .clk_i(decoder_clk),
                 .rst_i(!aresetn),
                 .cfg_awvalid_i (ctl_slv_lite.aw_valid),
                 .cfg_awaddr_i  (ctl_slv_lite.aw_addr),
                 .cfg_arvalid_i (ctl_slv_lite.ar_valid),
                 .cfg_araddr_i  (ctl_slv_lite.ar_addr),
                 .cfg_wvalid_i  (ctl_slv_lite.w_valid),
                 .cfg_wdata_i   (ctl_slv_lite.w_data),
                 .cfg_wstrb_i   (ctl_slv_lite.w_strb),
                 .cfg_bready_i  (ctl_slv_lite.b_ready),
                 .cfg_rready_i  (ctl_slv_lite.r_ready),
                 .cfg_awready_o (ctl_slv_lite.aw_ready),
                 .cfg_arready_o (ctl_slv_lite.ar_ready),
                 .cfg_wready_o  (ctl_slv_lite.w_ready),
                 .cfg_bvalid_o  (ctl_slv_lite.b_valid),
                 .cfg_bresp_o   (ctl_slv_lite.b_resp),
                 .cfg_rvalid_o  (ctl_slv_lite.r_valid),
                 .cfg_rdata_o   (ctl_slv_lite.r_data),
                 .cfg_rresp_o   (ctl_slv_lite.r_resp),

                 .outport_awvalid_o (dma_slow.aw_valid),
                 .outport_awaddr_o  (dma_slow.aw_addr),
                 .outport_awid_o    (dma_slow.aw_id),
                 .outport_awlen_o   (dma_slow.aw_len),
                 .outport_awburst_o (dma_slow.aw_burst),
                 .outport_arvalid_o (dma_slow.ar_valid),
                 .outport_araddr_o  (dma_slow.ar_addr),
                 .outport_arid_o    (dma_slow.ar_id),
                 .outport_arlen_o   (dma_slow.ar_len),
                 .outport_arburst_o (dma_slow.ar_burst),
                 .outport_wvalid_o  (dma_slow.w_valid),
                 .outport_wdata_o   (dma_slow.w_data),
                 .outport_wstrb_o   (dma_slow.w_strb),
                 .outport_wlast_o   (dma_slow.w_last),
                 .outport_bready_o  (dma_slow.b_ready),
                 .outport_rready_o  (dma_slow.r_ready),
                 .outport_awready_i (dma_slow.aw_ready),
                 .outport_arready_i (dma_slow.ar_ready),
                 .outport_wready_i  (dma_slow.w_ready),
                 .outport_bvalid_i  (dma_slow.b_valid),
                 .outport_bresp_i   (dma_slow.b_resp),
                 .outport_bid_i     (dma_slow.b_id),
                 .outport_rvalid_i  (dma_slow.r_valid),
                 .outport_rdata_i   (dma_slow.r_data),
                 .outport_rresp_i   (dma_slow.r_resp),
                 .outport_rid_i     (dma_slow.r_id),
                 .outport_rlast_i   (dma_slow.r_last)
               );

  assign dma_slow.ar_size = 3'b010;
  assign dma_slow.aw_size = 3'b010;

endmodule
