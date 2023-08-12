module xil_axi_to_axi_lite_wrapper(
    input logic     aclk,
    input logic     aresetn,
    AXI_BUS.Slave   slv,
    AXI_LITE.Master mst
);
    xil_axi_to_axi_lite xil_axi_to_axi_lite_i (
    .aclk(aclk),                     // input wire aclk
    .aresetn(aresetn),               // input wire aresetn
    .s_axi_awid(slv.aw_id),          // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr(slv.aw_addr),      // input wire [31 : 0] s_axi_awaddr
    .s_axi_awlen(slv.aw_len),        // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize(slv.aw_size),      // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst(slv.aw_burst),    // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock(slv.aw_lock),      // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache(slv.aw_cache),    // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot(slv.aw_prot),      // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion(slv.aw_region),  // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos(slv.aw_qos),        // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid(slv.aw_valid),    // input wire s_axi_awvalid
    .s_axi_awready(slv.aw_ready),    // output wire s_axi_awready
    .s_axi_arid(slv.ar_id),          // input wire [3 : 0] s_axi_arid
    .s_axi_araddr(slv.ar_addr),      // input wire [31 : 0] s_axi_araddr
    .s_axi_arlen(slv.ar_len),        // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize(slv.ar_size),      // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst(slv.ar_burst),    // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock(slv.ar_lock),      // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache(slv.ar_cache),    // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot(slv.ar_prot),      // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion(slv.ar_region),  // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos(slv.ar_qos),        // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid(slv.ar_valid),    // input wire s_axi_arvalid
    .s_axi_arready(slv.ar_ready),    // output wire s_axi_arready
    .s_axi_wdata(slv.w_data),        // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb(slv.w_strb),        // input wire [3 : 0] s_axi_wstrb
    .s_axi_wlast(slv.w_last),        // input wire s_axi_wlast
    .s_axi_wvalid(slv.w_valid),      // input wire s_axi_wvalid
    .s_axi_wready(slv.w_ready),      // output wire s_axi_wready
    .s_axi_bid(slv.b_id),            // output wire [3 : 0] s_axi_bid
    .s_axi_bresp(slv.b_resp),        // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid(slv.b_valid),      // output wire s_axi_bvalid
    .s_axi_bready(slv.b_ready),      // input wire s_axi_bready
    .s_axi_rid(slv.r_id),            // output wire [3 : 0] s_axi_rid
    .s_axi_rdata(slv.r_data),        // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp(slv.r_resp),        // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast(slv.r_last),        // output wire s_axi_rlast
    .s_axi_rvalid(slv.r_valid),      // output wire s_axi_rvalid
    .s_axi_rready(slv.r_ready),      // input wire s_axi_rready

    .m_axi_awaddr(mst.aw_addr),      // output wire [31 : 0] m_axi_awaddr
    .m_axi_awprot(mst.aw_prot),      // output wire [2 : 0] m_axi_awprot
    .m_axi_awvalid(mst.aw_valid),    // output wire m_axi_awvalid
    .m_axi_awready(mst.aw_ready),    // input wire m_axi_awready
    .m_axi_araddr(mst.ar_addr),      // output wire [31 : 0] m_axi_araddr
    .m_axi_arprot(mst.ar_prot),      // output wire [2 : 0] m_axi_arprot
    .m_axi_arvalid(mst.ar_valid),    // output wire m_axi_arvalid
    .m_axi_arready(mst.ar_ready),    // input wire m_axi_arready
    .m_axi_wdata(mst.w_data),        // output wire [31 : 0] m_axi_wdata
    .m_axi_wstrb(mst.w_strb),        // output wire [3 : 0] m_axi_wstrb
    .m_axi_wvalid(mst.w_valid),      // output wire m_axi_wvalid
    .m_axi_wready(mst.w_ready),      // input wire m_axi_wready
    .m_axi_bresp(mst.b_resp),        // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid(mst.b_valid),      // input wire m_axi_bvalid
    .m_axi_bready(mst.b_ready),      // output wire m_axi_bready
    .m_axi_rdata(mst.r_data),        // input wire [31 : 0] m_axi_rdata
    .m_axi_rresp(mst.r_resp),        // input wire [1 : 0] m_axi_rresp
    .m_axi_rvalid(mst.r_valid),      // input wire m_axi_rvalid
    .m_axi_rready(mst.r_ready)       // output wire m_axi_rready
    );
endmodule