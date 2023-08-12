module framebuffer_wrapper (
    input wire aclk,
    input wire aresetn,
    input wire [31:0] ctl_reg1,

    AXI_BUS.Slave   slv_read,
    AXI_BUS.Slave   slv_write,
    AXI_BUS.Master  dma_mst_read,
    AXI_BUS.Master  dma_mst_write
);

    logic        m_axis_video_TREADY;
    logic        m_axis_video_TVALID;
    logic [23:0] m_axis_video_TDATA;
    logic [ 2:0] m_axis_video_TKEEP;
    logic [ 2:0] m_axis_video_TSTRB;
    logic        m_axis_video_TUSER;
    logic        m_axis_video_TLAST;
    logic        m_axis_video_TID;
    logic        m_axis_video_TDEST;

    logic        s_axis_video_TREADY;
    logic        s_axis_video_TVALID;
    logic [23:0] s_axis_video_TDATA;
    logic [ 2:0] s_axis_video_TKEEP;
    logic [ 2:0] s_axis_video_TSTRB;
    logic        s_axis_video_TUSER;
    logic        s_axis_video_TLAST;
    logic        s_axis_video_TID;
    logic        s_axis_video_TDEST;

    video_frame_buffer_reader inst_fb_reader (
        .ap_clk(aclk),                                    // input wire ap_clk
        .ap_rst_n(aresetn),                                // input wire ap_rst_n
        .interrupt(),                                       // output wire interrupt

        .s_axi_CTRL_AWADDR      (slv_read.aw_addr),              // input wire [6 : 0] s_axi_CTRL_AWADDR
        .s_axi_CTRL_AWVALID     (slv_read.aw_valid),            // input wire s_axi_CTRL_AWVALID
        .s_axi_CTRL_AWREADY     (slv_read.aw_ready),            // output wire s_axi_CTRL_AWREADY
        .s_axi_CTRL_WDATA       (slv_read.w_data),                // input wire [31 : 0] s_axi_CTRL_WDATA
        .s_axi_CTRL_WSTRB       (slv_read.w_strb),                // input wire [3 : 0] s_axi_CTRL_WSTRB
        .s_axi_CTRL_WVALID      (slv_read.w_valid),              // input wire s_axi_CTRL_WVALID
        .s_axi_CTRL_WREADY      (slv_read.w_ready),              // output wire s_axi_CTRL_WREADY
        .s_axi_CTRL_BRESP       (slv_read.b_resp),                // output wire [1 : 0] s_axi_CTRL_BRESP
        .s_axi_CTRL_BVALID      (slv_read.b_valid),              // output wire s_axi_CTRL_BVALID
        .s_axi_CTRL_BREADY      (slv_read.b_ready),              // input wire s_axi_CTRL_BREADY
        .s_axi_CTRL_ARADDR      (slv_read.ar_addr),              // input wire [6 : 0] s_axi_CTRL_ARADDR
        .s_axi_CTRL_ARVALID     (slv_read.ar_valid),            // input wire s_axi_CTRL_ARVALID
        .s_axi_CTRL_ARREADY     (slv_read.ar_ready),            // output wire s_axi_CTRL_ARREADY
        .s_axi_CTRL_RDATA       (slv_read.r_data),                // output wire [31 : 0] s_axi_CTRL_RDATA
        .s_axi_CTRL_RRESP       (slv_read.r_resp),                // output wire [1 : 0] s_axi_CTRL_RRESP
        .s_axi_CTRL_RVALID      (slv_read.r_valid),              // output wire s_axi_CTRL_RVALID
        .s_axi_CTRL_RREADY      (slv_read.r_ready),              // input wire s_axi_CTRL_RREADY

        .m_axi_mm_video_AWADDR  (dma_mst_read.aw_addr),      // output wire [31 : 0] m_axi_mm_video_AWADDR
        .m_axi_mm_video_AWLEN   (dma_mst_read.aw_len),        // output wire [7 : 0] m_axi_mm_video_AWLEN
        .m_axi_mm_video_AWSIZE  (dma_mst_read.aw_size),      // output wire [2 : 0] m_axi_mm_video_AWSIZE
        .m_axi_mm_video_AWBURST (dma_mst_read.aw_burst),    // output wire [1 : 0] m_axi_mm_video_AWBURST
        .m_axi_mm_video_AWLOCK  (dma_mst_read.aw_lock),      // output wire [1 : 0] m_axi_mm_video_AWLOCK
        .m_axi_mm_video_AWREGION(dma_mst_read.aw_region),  // output wire [3 : 0] m_axi_mm_video_AWREGION
        .m_axi_mm_video_AWCACHE (dma_mst_read.aw_cache),    // output wire [3 : 0] m_axi_mm_video_AWCACHE
        .m_axi_mm_video_AWPROT  (dma_mst_read.aw_prot),      // output wire [2 : 0] m_axi_mm_video_AWPROT
        .m_axi_mm_video_AWQOS   (dma_mst_read.aw_qos),        // output wire [3 : 0] m_axi_mm_video_AWQOS
        .m_axi_mm_video_AWVALID (dma_mst_read.aw_valid),    // output wire m_axi_mm_video_AWVALID
        .m_axi_mm_video_AWREADY (dma_mst_read.aw_ready),    // input wire m_axi_mm_video_AWREADY
        .m_axi_mm_video_WDATA   (dma_mst_read.w_data),        // output wire [63 : 0] m_axi_mm_video_WDATA
        .m_axi_mm_video_WSTRB   (dma_mst_read.w_strb),        // output wire [7 : 0] m_axi_mm_video_WSTRB
        .m_axi_mm_video_WLAST   (dma_mst_read.w_last),        // output wire m_axi_mm_video_WLAST
        .m_axi_mm_video_WVALID  (dma_mst_read.w_valid),      // output wire m_axi_mm_video_WVALID
        .m_axi_mm_video_WREADY  (dma_mst_read.w_ready),      // input wire m_axi_mm_video_WREADY
        .m_axi_mm_video_BRESP   (dma_mst_read.b_resp),        // input wire [1 : 0] m_axi_mm_video_BRESP
        .m_axi_mm_video_BVALID  (dma_mst_read.b_valid),      // input wire m_axi_mm_video_BVALID
        .m_axi_mm_video_BREADY  (dma_mst_read.b_ready),      // output wire m_axi_mm_video_BREADY
        .m_axi_mm_video_ARADDR  (dma_mst_read.ar_addr),      // output wire [31 : 0] m_axi_mm_video_ARADDR
        .m_axi_mm_video_ARLEN   (dma_mst_read.ar_len),        // output wire [7 : 0] m_axi_mm_video_ARLEN
        .m_axi_mm_video_ARSIZE  (dma_mst_read.ar_size),      // output wire [2 : 0] m_axi_mm_video_ARSIZE
        .m_axi_mm_video_ARBURST (dma_mst_read.ar_burst),    // output wire [1 : 0] m_axi_mm_video_ARBURST
        .m_axi_mm_video_ARLOCK  (dma_mst_read.ar_lock),      // output wire [1 : 0] m_axi_mm_video_ARLOCK
        .m_axi_mm_video_ARREGION(dma_mst_read.ar_region),  // output wire [3 : 0] m_axi_mm_video_ARREGION
        .m_axi_mm_video_ARCACHE (dma_mst_read.ar_cache),    // output wire [3 : 0] m_axi_mm_video_ARCACHE
        .m_axi_mm_video_ARPROT  (dma_mst_read.ar_prot),      // output wire [2 : 0] m_axi_mm_video_ARPROT
        .m_axi_mm_video_ARQOS   (dma_mst_read.ar_qos),        // output wire [3 : 0] m_axi_mm_video_ARQOS
        .m_axi_mm_video_ARVALID (dma_mst_read.ar_valid),    // output wire m_axi_mm_video_ARVALID
        .m_axi_mm_video_ARREADY (dma_mst_read.ar_ready),    // input wire m_axi_mm_video_ARREADY
        .m_axi_mm_video_RDATA   (dma_mst_read.r_data),        // input wire [63 : 0] m_axi_mm_video_RDATA
        .m_axi_mm_video_RRESP   (dma_mst_read.r_resp),        // input wire [1 : 0] m_axi_mm_video_RRESP
        .m_axi_mm_video_RLAST   (dma_mst_read.r_last),        // input wire m_axi_mm_video_RLAST
        .m_axi_mm_video_RVALID  (dma_mst_read.r_valid),      // input wire m_axi_mm_video_RVALID
        .m_axi_mm_video_RREADY  (dma_mst_read.r_ready),      // output wire m_axi_mm_video_RREADY

        .m_axis_video_TVALID    (m_axis_video_TVALID),          // output wire m_axis_video_TVALID
        .m_axis_video_TREADY    (m_axis_video_TREADY),          // input wire m_axis_video_TREADY
        .m_axis_video_TDATA     (m_axis_video_TDATA),            // output wire [23 : 0] m_axis_video_TDATA
        .m_axis_video_TKEEP     (m_axis_video_TKEEP),            // output wire [2 : 0] m_axis_video_TKEEP
        .m_axis_video_TSTRB     (m_axis_video_TSTRB),            // output wire [2 : 0] m_axis_video_TSTRB
        .m_axis_video_TUSER     (m_axis_video_TUSER),            // output wire [0 : 0] m_axis_video_TUSER
        .m_axis_video_TLAST     (m_axis_video_TLAST),            // output wire [0 : 0] m_axis_video_TLAST
        .m_axis_video_TID       (m_axis_video_TID),                // output wire [0 : 0] m_axis_video_TID
        .m_axis_video_TDEST     (m_axis_video_TDEST)            // output wire [0 : 0] m_axis_video_TDEST
    );

    
    video_stream_modifier inst_fb_modifier (
        .aclk(aclk),                                    // input wire ap_clk
        .aresetn(aresetn),                                // input wire ap_rst_n
        .ctl_reg1(ctl_reg1),

        .s_axis_video_TVALID    (m_axis_video_TVALID),          // input wire s_axis_video_TVALID
        .s_axis_video_TREADY    (m_axis_video_TREADY),          // output wire s_axis_video_TREADY
        .s_axis_video_TDATA     (m_axis_video_TDATA ),            // input wire [23 : 0] s_axis_video_TDATA
        .s_axis_video_TKEEP     (m_axis_video_TKEEP ),            // input wire [2 : 0] s_axis_video_TKEEP
        .s_axis_video_TSTRB     (m_axis_video_TSTRB ),            // input wire [2 : 0] s_axis_video_TSTRB
        .s_axis_video_TUSER     (m_axis_video_TUSER ),            // input wire s_axis_video_TUSER
        .s_axis_video_TLAST     (m_axis_video_TLAST ),            // input wire s_axis_video_TLAST
        .s_axis_video_TID       (m_axis_video_TID   ),                // input wire s_axis_video_TID
        .s_axis_video_TDEST     (m_axis_video_TDEST ),           // input wire s_axis_video_TDEST

        .m_axis_video_TVALID    (s_axis_video_TVALID),          // output wire m_axis_video_TVALID
        .m_axis_video_TREADY    (s_axis_video_TREADY),          // input wire m_axis_video_TREADY
        .m_axis_video_TDATA     (s_axis_video_TDATA ),            // output wire [23 : 0] m_axis_video_TDATA
        .m_axis_video_TKEEP     (s_axis_video_TKEEP ),            // output wire [2 : 0] m_axis_video_TKEEP
        .m_axis_video_TSTRB     (s_axis_video_TSTRB ),            // output wire [2 : 0] m_axis_video_TSTRB
        .m_axis_video_TUSER     (s_axis_video_TUSER ),            // output wire [0 : 0] m_axis_video_TUSER
        .m_axis_video_TLAST     (s_axis_video_TLAST ),            // output wire [0 : 0] m_axis_video_TLAST
        .m_axis_video_TID       (s_axis_video_TID   ),                // output wire [0 : 0] m_axis_video_TID
        .m_axis_video_TDEST     (s_axis_video_TDEST )            // output wire [0 : 0] m_axis_video_TDEST
    );


    video_frame_buffer_writer inst_fb_writer (
        .ap_clk(aclk),                                    // input wire ap_clk
        .ap_rst_n(aresetn),                                // input wire ap_rst_n
        .interrupt(),                                       // output wire interrupt

        .s_axi_CTRL_AWADDR      (slv_write.aw_addr),              // input wire [6 : 0] s_axi_CTRL_AWADDR
        .s_axi_CTRL_AWVALID     (slv_write.aw_valid),            // input wire s_axi_CTRL_AWVALID
        .s_axi_CTRL_AWREADY     (slv_write.aw_ready),            // output wire s_axi_CTRL_AWREADY
        .s_axi_CTRL_WDATA       (slv_write.w_data),                // input wire [31 : 0] s_axi_CTRL_WDATA
        .s_axi_CTRL_WSTRB       (slv_write.w_strb),                // input wire [3 : 0] s_axi_CTRL_WSTRB
        .s_axi_CTRL_WVALID      (slv_write.w_valid),              // input wire s_axi_CTRL_WVALID
        .s_axi_CTRL_WREADY      (slv_write.w_ready),              // output wire s_axi_CTRL_WREADY
        .s_axi_CTRL_BRESP       (slv_write.b_resp),                // output wire [1 : 0] s_axi_CTRL_BRESP
        .s_axi_CTRL_BVALID      (slv_write.b_valid),              // output wire s_axi_CTRL_BVALID
        .s_axi_CTRL_BREADY      (slv_write.b_ready),              // input wire s_axi_CTRL_BREADY
        .s_axi_CTRL_ARADDR      (slv_write.ar_addr),              // input wire [6 : 0] s_axi_CTRL_ARADDR
        .s_axi_CTRL_ARVALID     (slv_write.ar_valid),            // input wire s_axi_CTRL_ARVALID
        .s_axi_CTRL_ARREADY     (slv_write.ar_ready),            // output wire s_axi_CTRL_ARREADY
        .s_axi_CTRL_RDATA       (slv_write.r_data),                // output wire [31 : 0] s_axi_CTRL_RDATA
        .s_axi_CTRL_RRESP       (slv_write.r_resp),                // output wire [1 : 0] s_axi_CTRL_RRESP
        .s_axi_CTRL_RVALID      (slv_write.r_valid),              // output wire s_axi_CTRL_RVALID
        .s_axi_CTRL_RREADY      (slv_write.r_ready),              // input wire s_axi_CTRL_RREADY

        .m_axi_mm_video_AWADDR  (dma_mst_write.aw_addr),      // output wire [31 : 0] m_axi_mm_video_AWADDR
        .m_axi_mm_video_AWLEN   (dma_mst_write.aw_len),        // output wire [7 : 0] m_axi_mm_video_AWLEN
        .m_axi_mm_video_AWSIZE  (dma_mst_write.aw_size),      // output wire [2 : 0] m_axi_mm_video_AWSIZE
        .m_axi_mm_video_AWBURST (dma_mst_write.aw_burst),    // output wire [1 : 0] m_axi_mm_video_AWBURST
        .m_axi_mm_video_AWLOCK  (dma_mst_write.aw_lock),      // output wire [1 : 0] m_axi_mm_video_AWLOCK
        .m_axi_mm_video_AWREGION(dma_mst_write.aw_region),  // output wire [3 : 0] m_axi_mm_video_AWREGION
        .m_axi_mm_video_AWCACHE (dma_mst_write.aw_cache),    // output wire [3 : 0] m_axi_mm_video_AWCACHE
        .m_axi_mm_video_AWPROT  (dma_mst_write.aw_prot),      // output wire [2 : 0] m_axi_mm_video_AWPROT
        .m_axi_mm_video_AWQOS   (dma_mst_write.aw_qos),        // output wire [3 : 0] m_axi_mm_video_AWQOS
        .m_axi_mm_video_AWVALID (dma_mst_write.aw_valid),    // output wire m_axi_mm_video_AWVALID
        .m_axi_mm_video_AWREADY (dma_mst_write.aw_ready),    // input wire m_axi_mm_video_AWREADY
        .m_axi_mm_video_WDATA   (dma_mst_write.w_data),        // output wire [63 : 0] m_axi_mm_video_WDATA
        .m_axi_mm_video_WSTRB   (dma_mst_write.w_strb),        // output wire [7 : 0] m_axi_mm_video_WSTRB
        .m_axi_mm_video_WLAST   (dma_mst_write.w_last),        // output wire m_axi_mm_video_WLAST
        .m_axi_mm_video_WVALID  (dma_mst_write.w_valid),      // output wire m_axi_mm_video_WVALID
        .m_axi_mm_video_WREADY  (dma_mst_write.w_ready),      // input wire m_axi_mm_video_WREADY
        .m_axi_mm_video_BRESP   (dma_mst_write.b_resp),        // input wire [1 : 0] m_axi_mm_video_BRESP
        .m_axi_mm_video_BVALID  (dma_mst_write.b_valid),      // input wire m_axi_mm_video_BVALID
        .m_axi_mm_video_BREADY  (dma_mst_write.b_ready),      // output wire m_axi_mm_video_BREADY
        .m_axi_mm_video_ARADDR  (dma_mst_write.ar_addr),      // output wire [31 : 0] m_axi_mm_video_ARADDR
        .m_axi_mm_video_ARLEN   (dma_mst_write.ar_len),        // output wire [7 : 0] m_axi_mm_video_ARLEN
        .m_axi_mm_video_ARSIZE  (dma_mst_write.ar_size),      // output wire [2 : 0] m_axi_mm_video_ARSIZE
        .m_axi_mm_video_ARBURST (dma_mst_write.ar_burst),    // output wire [1 : 0] m_axi_mm_video_ARBURST
        .m_axi_mm_video_ARLOCK  (dma_mst_write.ar_lock),      // output wire [1 : 0] m_axi_mm_video_ARLOCK
        .m_axi_mm_video_ARREGION(dma_mst_write.ar_region),  // output wire [3 : 0] m_axi_mm_video_ARREGION
        .m_axi_mm_video_ARCACHE (dma_mst_write.ar_cache),    // output wire [3 : 0] m_axi_mm_video_ARCACHE
        .m_axi_mm_video_ARPROT  (dma_mst_write.ar_prot),      // output wire [2 : 0] m_axi_mm_video_ARPROT
        .m_axi_mm_video_ARQOS   (dma_mst_write.ar_qos),        // output wire [3 : 0] m_axi_mm_video_ARQOS
        .m_axi_mm_video_ARVALID (dma_mst_write.ar_valid),    // output wire m_axi_mm_video_ARVALID
        .m_axi_mm_video_ARREADY (dma_mst_write.ar_ready),    // input wire m_axi_mm_video_ARREADY
        .m_axi_mm_video_RDATA   (dma_mst_write.r_data),        // input wire [63 : 0] m_axi_mm_video_RDATA
        .m_axi_mm_video_RRESP   (dma_mst_write.r_resp),        // input wire [1 : 0] m_axi_mm_video_RRESP
        .m_axi_mm_video_RLAST   (dma_mst_write.r_last),        // input wire m_axi_mm_video_RLAST
        .m_axi_mm_video_RVALID  (dma_mst_write.r_valid),      // input wire m_axi_mm_video_RVALID
        .m_axi_mm_video_RREADY  (dma_mst_write.r_ready),      // output wire m_axi_mm_video_RREADY

        .s_axis_video_TVALID    (s_axis_video_TVALID),          // input wire s_axis_video_TVALID
        .s_axis_video_TREADY    (s_axis_video_TREADY),          // output wire s_axis_video_TREADY
        .s_axis_video_TDATA     (s_axis_video_TDATA),            // input wire [23 : 0] s_axis_video_TDATA
        .s_axis_video_TKEEP     (s_axis_video_TKEEP),            // input wire [2 : 0] s_axis_video_TKEEP
        .s_axis_video_TSTRB     (s_axis_video_TSTRB),            // input wire [2 : 0] s_axis_video_TSTRB
        .s_axis_video_TUSER     (s_axis_video_TUSER),            // input wire s_axis_video_TUSER
        .s_axis_video_TLAST     (s_axis_video_TLAST),            // input wire s_axis_video_TLAST
        .s_axis_video_TID       (s_axis_video_TID),                // input wire s_axis_video_TID
        .s_axis_video_TDEST     (s_axis_video_TDEST)            // input wire s_axis_video_TDEST
    );

endmodule