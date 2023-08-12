module i2s_wrapper(
    input aclk,
    input aresetn,

    input wire i2s_clk,
    input wire i2s_rst,
    output wire lrclk_o,
    output wire sclk_o,
    output wire sdata_o,

    AXI_BUS.Slave   i2s_mod_slv,
    AXI_BUS.Slave   i2s_tx_slv,
    AXI_BUS.Master  dma_mst,

    output mod_irq,
    (*mark_debug = "true"*) output tx_irq
  );

  `define AXI_LITE_LINE(name) AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) name()

  `AXI_LITE_LINE(i2s_mod_slv_l);
  `AXI_LITE_LINE(i2s_tx_slv_l);

  xil_axi_to_axi_lite_wrapper  axi2axil_mod (
                     .aclk(aclk),
                     .aresetn(aresetn),
                     .slv(i2s_mod_slv),
                     .mst(i2s_mod_slv_l)
                   );
  xil_axi_to_axi_lite_wrapper  axi2axil_tx (
                     .aclk(aclk),
                     .aresetn(aresetn),
                     .slv(i2s_tx_slv),
                     .mst(i2s_tx_slv_l)
                   );

  // assign i2s_tx_slv.r_id = i2s_tx_slv.ar_id;
  // assign i2s_tx_slv.r_last = i2s_tx_slv.r_valid;
  // assign i2s_tx_slv.b_id = i2s_tx_slv.aw_id;
  // assign i2s_mod_slv.r_id = i2s_mod_slv.ar_id;
  // assign i2s_mod_slv.r_last = i2s_mod_slv.r_valid;
  // assign i2s_mod_slv.b_id = i2s_mod_slv.aw_id;

  (*mark_debug = "true"*)wire tvalid;
  (*mark_debug = "true"*)wire tready;
  (*mark_debug = "true"*)wire [31 : 0] tdata;
  (*mark_debug = "true"*)wire [7 : 0] tid;

  // 这里进行一个时钟域转换，从 soc clk -> i2s clk
  // logic i2s_resetn;
  // stolen_cdc_sync_rst soc_rstgen(
  //                       .src_rst(aresetn),
  //                       .dest_clk(i2s_clk),
  //                       // output
  //                       .dest_rst(i2s_resetn)
  //                     );
  // assign i2s_resetn = '1;

  xil_audio_formatter xil_audio_formater_i (
                        .s_axi_lite_aclk(aclk),          // input wire s_axi_lite_aclk
                        .s_axi_lite_aresetn(aresetn),    // input wire s_axi_lite_aresetn

                        .s_axi_lite_araddr(i2s_mod_slv_l.ar_addr),      // input wire [11 : 0] s_axi_lite_araddr
                        .s_axi_lite_arvalid(i2s_mod_slv_l.ar_valid),    // input wire s_axi_lite_arvalid
                        .s_axi_lite_arready(i2s_mod_slv_l.ar_ready),    // output wire s_axi_lite_arready
                        .s_axi_lite_rdata(i2s_mod_slv_l.r_data),        // output wire [31 : 0] s_axi_lite_rdata
                        .s_axi_lite_rresp(i2s_mod_slv_l.r_resp),        // output wire [1 : 0] s_axi_lite_rresp
                        .s_axi_lite_rvalid(i2s_mod_slv_l.r_valid),      // output wire s_axi_lite_rvalid
                        .s_axi_lite_rready(i2s_mod_slv_l.r_ready),      // input wire s_axi_lite_rready
                        .s_axi_lite_awaddr(i2s_mod_slv_l.aw_addr),      // input wire [11 : 0] s_axi_lite_awaddr
                        .s_axi_lite_awvalid(i2s_mod_slv_l.aw_valid),    // input wire s_axi_lite_awvalid
                        .s_axi_lite_awready(i2s_mod_slv_l.aw_ready),    // output wire s_axi_lite_awready
                        .s_axi_lite_wdata(i2s_mod_slv_l.w_data),        // input wire [31 : 0] s_axi_lite_wdata
                        .s_axi_lite_wvalid(i2s_mod_slv_l.w_valid),      // input wire s_axi_lite_wvalid
                        .s_axi_lite_wready(i2s_mod_slv_l.w_ready),      // output wire s_axi_lite_wready
                        .s_axi_lite_bresp(i2s_mod_slv_l.b_resp),        // output wire [1 : 0] s_axi_lite_bresp
                        .s_axi_lite_bvalid(i2s_mod_slv_l.b_valid),      // output wire s_axi_lite_bvalid
                        .s_axi_lite_bready(i2s_mod_slv_l.b_ready),      // input wire s_axi_lite_bready
                        // NO WSTOBE ?

                        .aud_mclk(i2s_clk),                        // input wire aud_mclk
                        .aud_mreset(i2s_rst),                      // input wire aud_mreset
                        .irq_mm2s(mod_irq),                        // output wire irq_mm2s

                        .m_axi_mm2s_araddr(dma_mst.ar_addr),      // output wire [31 : 0] m_axi_mm2s_araddr
                        .m_axi_mm2s_arlen(dma_mst.ar_len),        // output wire [7 : 0] m_axi_mm2s_arlen
                        .m_axi_mm2s_arsize(dma_mst.ar_size),      // output wire [2 : 0] m_axi_mm2s_arsize
                        .m_axi_mm2s_arburst(dma_mst.ar_burst),    // output wire [1 : 0] m_axi_mm2s_arburst
                        .m_axi_mm2s_arprot(dma_mst.ar_prot),      // output wire [2 : 0] m_axi_mm2s_arprot
                        .m_axi_mm2s_arcache(dma_mst.ar_cache),    // output wire [3 : 0] m_axi_mm2s_arcache
                        .m_axi_mm2s_aruser(dma_mst.ar_user),      // output wire [3 : 0] m_axi_mm2s_aruser
                        .m_axi_mm2s_arvalid(dma_mst.ar_valid),    // output wire m_axi_mm2s_arvalid
                        .m_axi_mm2s_arready(dma_mst.ar_ready),    // input wire m_axi_mm2s_arready
                        .m_axi_mm2s_rdata(dma_mst.r_data),        // input wire [31 : 0] m_axi_mm2s_rdata
                        .m_axi_mm2s_rresp(dma_mst.r_resp),        // input wire [1 : 0] m_axi_mm2s_rresp
                        .m_axi_mm2s_rlast(dma_mst.r_last),        // input wire m_axi_mm2s_rlast
                        .m_axi_mm2s_rvalid(dma_mst.r_valid),      // input wire m_axi_mm2s_rvalid
                        .m_axi_mm2s_rready(dma_mst.r_ready),     // output wire m_axi_mm2s_rready

                        .m_axis_mm2s_aclk(aclk),        // input wire m_axis_mm2s_aclk
                        .m_axis_mm2s_aresetn(aresetn),  // input wire m_axis_mm2s_aresetn
                        .m_axis_mm2s_tvalid(tvalid),    // output wire m_axis_mm2s_tvalid
                        .m_axis_mm2s_tready(tready),    // input wire m_axis_mm2s_tready
                        .m_axis_mm2s_tdata(tdata),      // output wire [31 : 0] m_axis_mm2s_tdata
                        .m_axis_mm2s_tid(tid)           // output wire [7 : 0] m_axis_mm2s_tid
                      );

  assign dma_mst.ar_id    =  5;
  assign dma_mst.aw_valid = '0;
  assign dma_mst.aw_addr  = '0;
  assign dma_mst.aw_id    = '0;
  assign dma_mst.aw_len   = '0;
  assign dma_mst.aw_burst = '0;
  assign dma_mst.w_valid  = '0;
  assign dma_mst.w_data   = '0;
  assign dma_mst.w_strb   = '0;
  assign dma_mst.w_last   = '0;
  assign dma_mst.b_ready  = '0;

  xil_i2s_transmitter xil_i2s_transmitter_i (
                        .s_axi_ctrl_aclk(aclk),        // input wire s_axi_ctrl_aclk
                        .s_axi_ctrl_aresetn(aresetn),  // input wire s_axi_ctrl_aresetn

                        .s_axi_ctrl_awvalid(i2s_tx_slv_l.aw_valid),  // input wire s_axi_ctrl_awvalid
                        .s_axi_ctrl_awready(i2s_tx_slv_l.aw_ready),  // output wire s_axi_ctrl_awready
                        .s_axi_ctrl_awaddr(i2s_tx_slv_l.aw_addr),    // input wire [7 : 0] s_axi_ctrl_awaddr
                        .s_axi_ctrl_arvalid(i2s_tx_slv_l.ar_valid),  // input wire s_axi_ctrl_arvalid
                        .s_axi_ctrl_arready(i2s_tx_slv_l.ar_ready),  // output wire s_axi_ctrl_arready
                        .s_axi_ctrl_araddr(i2s_tx_slv_l.ar_addr),    // input wire [7 : 0] s_axi_ctrl_araddr
                        .s_axi_ctrl_wvalid(i2s_tx_slv_l.w_valid),    // input wire s_axi_ctrl_wvalid
                        .s_axi_ctrl_wready(i2s_tx_slv_l.w_ready),    // output wire s_axi_ctrl_wready
                        .s_axi_ctrl_wdata(i2s_tx_slv_l.w_data),      // input wire [31 : 0] s_axi_ctrl_wdata
                        .s_axi_ctrl_bvalid(i2s_tx_slv_l.b_valid),    // output wire s_axi_ctrl_bvalid
                        .s_axi_ctrl_bready(i2s_tx_slv_l.b_ready),    // input wire s_axi_ctrl_bready
                        .s_axi_ctrl_bresp(i2s_tx_slv_l.b_resp),      // output wire [1 : 0] s_axi_ctrl_bresp
                        .s_axi_ctrl_rvalid(i2s_tx_slv_l.r_valid),    // output wire s_axi_ctrl_rvalid
                        .s_axi_ctrl_rready(i2s_tx_slv_l.r_ready),    // input wire s_axi_ctrl_rready
                        .s_axi_ctrl_rdata(i2s_tx_slv_l.r_data),      // output wire [31 : 0] s_axi_ctrl_rdata
                        .s_axi_ctrl_rresp(i2s_tx_slv_l.r_resp),      // output wire [1 : 0] s_axi_ctrl_rresp
                        .irq(tx_irq),                              // output wire 

                        .aud_mclk(i2s_clk),                 // input wire aud_mclk
                        .aud_mrst(i2s_rst),                 // input wire aud_mrst

                        .lrclk_out(lrclk_o),                  // output wire lrclk_out
                        .sclk_out(sclk_o),                    // output wire sclk_out
                        .sdata_0_out(sdata_o),                // output wire sdata_0_out

                        .s_axis_aud_aclk(aclk),        // input wire s_axis_aud_aclk
                        .s_axis_aud_aresetn(aresetn),  // input wire s_axis_aud_aresetn
                        .s_axis_aud_tdata(tdata),      // input wire [31:0] s_axis_aud_tdata
                        .s_axis_aud_tid(tid[2:0]),     // input wire [2 :0] s_axis_aud_tid
                        .s_axis_aud_tvalid(tvalid),    // input wire s_axis_aud_tvalid
                        .s_axis_aud_tready(tready)    // output wire s_axis_aud_tready
                      );

endmodule
