module vga_wrapper (
    input aclk,
    input aresetn,

    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire vga_hsync,
    output wire vga_vsync,
    input  wire vga_clk,

    AXI_BUS.Slave   slv,
    AXI_BUS.Master  dma_mst
);

    logic [5:0] vga_red, vga_green, vga_blue;

    (*mark_debug = "true"*) wire [31:0] slave_ar_addr  = slv.ar_addr  ;
    (*mark_debug = "true"*) wire        slave_ar_valid = slv.ar_valid ;
    (*mark_debug = "true"*) wire        slave_ar_ready = slv.ar_ready ;

    (*mark_debug = "true"*) wire [31:0] slave_r_data   = slv.r_data   ;
    (*mark_debug = "true"*) wire [1 :0] slave_r_resp   = slv.r_resp   ;
    (*mark_debug = "true"*) wire        slave_r_valid  = slv.r_valid ;
    (*mark_debug = "true"*) wire        slave_r_last  = slv.r_last;
    (*mark_debug = "true"*) wire        slave_r_ready  = slv.r_ready  ;
    
    (*mark_debug = "true"*) wire [31:0] slave_aw_addr  = slv.aw_addr  ;
    (*mark_debug = "true"*) wire        slave_aw_valid = slv.aw_valid ;
    (*mark_debug = "true"*) wire        slave_aw_ready = slv.aw_ready ;
    
    (*mark_debug = "true"*) wire [31:0] slave_w_data   = slv.w_data   ;
    (*mark_debug = "true"*) wire [3 :0] slave_w_strb   = slv.w_strb   ;
    (*mark_debug = "true"*) wire        slave_w_valid  = slv.w_valid  ;
    (*mark_debug = "true"*) wire        slave_w_ready  = slv.w_ready  ;
    
    (*mark_debug = "true"*) wire [1 :0] slave_b_resp   = slv.b_resp   ;
    (*mark_debug = "true"*) wire        slave_b_valid  = slv.b_valid  ;
    (*mark_debug = "true"*) wire        slave_b_ready  = slv.b_ready  ;

    (*mark_debug = "true"*) wire [3 :0] slave_ar_id = slv.ar_id ;
    (*mark_debug = "true"*) wire [3 :0] slave_r_id  = slv.r_id  ;
    (*mark_debug = "true"*) wire [3 :0] slave_aw_id = slv.aw_id ;
    (*mark_debug = "true"*) wire [3 :0] slave_b_id  = slv.b_id  ;

    assign slv.r_id = slv.ar_id;
    assign slv.r_last = slv.r_valid;
    assign slv.b_id = slv.aw_id;
    assign dma_mst.ar_id = '0;
    assign dma_mst.aw_id = '0;

    vga_controller instance_vga (
        .s_axi_aclk         (aclk),
        .s_axi_aresetn      (aresetn),
        .m_axi_aclk         (aclk),
        .m_axi_aresetn      (aresetn),
        .sys_tft_clk        (vga_clk),

        .s_axi_araddr       (slv.ar_addr ),
        .s_axi_arvalid      (slv.ar_valid),
        .s_axi_arready      (slv.ar_ready),
        .s_axi_rdata        (slv.r_data  ),
        .s_axi_rresp        (slv.r_resp  ),
        .s_axi_rvalid       (slv.r_valid ),
        .s_axi_rready       (slv.r_ready ),
        .s_axi_awaddr       (slv.aw_addr ),
        .s_axi_awvalid      (slv.aw_valid),
        .s_axi_awready      (slv.aw_ready),
        .s_axi_wdata        (slv.w_data  ),
        .s_axi_wstrb        (slv.w_strb  ),
        .s_axi_wvalid       (slv.w_valid ),
        .s_axi_wready       (slv.w_ready ),
        .s_axi_bresp        (slv.b_resp  ),
        .s_axi_bvalid       (slv.b_valid ),
        .s_axi_bready       (slv.b_ready ),

        .m_axi_araddr       (dma_mst.ar_addr ),
        .m_axi_arlen        (dma_mst.ar_len  ),
        .m_axi_arsize       (dma_mst.ar_size ),
        .m_axi_arburst      (dma_mst.ar_burst),
        .m_axi_arcache      (dma_mst.ar_cache),
        .m_axi_arprot       (dma_mst.ar_prot ),
        .m_axi_arvalid      (dma_mst.ar_valid),
        .m_axi_arready      (dma_mst.ar_ready),
        .m_axi_rdata        (dma_mst.r_data  ),
        .m_axi_rresp        (dma_mst.r_resp  ),
        .m_axi_rlast        (dma_mst.r_last  ),
        .m_axi_rvalid       (dma_mst.r_valid ),
        .m_axi_rready       (dma_mst.r_ready ),
        .m_axi_awaddr       (dma_mst.aw_addr ),
        .m_axi_awlen        (dma_mst.aw_len  ),
        .m_axi_awsize       (dma_mst.aw_size ),
        .m_axi_awburst      (dma_mst.aw_burst),
        .m_axi_awcache      (dma_mst.aw_cache),
        .m_axi_awprot       (dma_mst.aw_prot ),
        .m_axi_awvalid      (dma_mst.aw_valid),
        .m_axi_awready      (dma_mst.aw_ready),
        .m_axi_wdata        (dma_mst.w_data  ),
        .m_axi_wstrb        (dma_mst.w_strb  ),
        .m_axi_wlast        (dma_mst.w_last  ),
        .m_axi_wvalid       (dma_mst.w_valid ),
        .m_axi_wready       (dma_mst.w_ready ),
        .m_axi_bresp        (dma_mst.b_resp  ),
        .m_axi_bvalid       (dma_mst.b_valid ),
        .m_axi_bready       (dma_mst.b_ready ),

        .tft_hsync          (vga_hsync),        // output wire tft_hsync
        .tft_vsync          (vga_vsync),        // output wire tft_vsync
        .tft_de             (),                 // output wire tft_de
        .tft_dps            (),                 // output wire tft_dps
        .tft_vga_clk        (),                 // output wire tft_vga_clk
        .tft_vga_r          (vga_red),          // output wire [5 : 0] tft_vga_r
        .tft_vga_g          (vga_green),        // output wire [5 : 0] tft_vga_g
        .tft_vga_b          (vga_blue)          // output wire [5 : 0] tft_vga_b
    );

    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : vga_gen
            //match on-board DAC built by resistor
            assign vga_r[i] = vga_red[i + 2]   ? 1'b1 : 1'bZ;
            assign vga_g[i] = vga_green[i + 2] ? 1'b1 : 1'bZ;
            assign vga_b[i] = vga_blue[i + 2]  ? 1'b1 : 1'bZ;
        end
    endgenerate

endmodule