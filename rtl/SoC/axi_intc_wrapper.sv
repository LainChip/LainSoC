module axi_intc_wrapper #(
    parameter C_NUM_INTR_INPUTS = 8
) (
    AXI_BUS.Slave aslv,
    
    input aclk,
    input aresetn,
    output irq_o,
    input [C_NUM_INTR_INPUTS-1:0] irq_i
);
AXI_LITE #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
) slv();
axi_to_axi_lite_intf #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .AXI_ID_WIDTH(4),
    .FALL_THROUGH(0)
) slv_conv(
    .clk_i(aclk),
    .rst_ni(aresetn),
    .testmode_i(1'b0),
    .slv(aslv),
    .mst(slv)
);

axi_intc #(
    .C_NUM_INTR_INPUTS(C_NUM_INTR_INPUTS),
    .C_KIND_OF_INTR(32'h1),
    .C_ASYNC_INTR(32'h0),
    .C_DISABLE_SYNCHRONIZERS(1) // all interrupts are from same clock domain
) intc (
    .s_axi_aclk(aclk),
    .s_axi_aresetn(aresetn),
    
    .s_axi_awaddr          (slv.aw_addr[8:0] ),
    .s_axi_awvalid         (slv.aw_valid     ),
    .s_axi_awready         (slv.aw_ready     ),
    .s_axi_wready          (slv.w_ready      ),
    .s_axi_wdata           (slv.w_data       ),
    .s_axi_wstrb           (slv.w_strb       ),
    .s_axi_wvalid          (slv.w_valid      ),
    .s_axi_bresp           (slv.b_resp       ),
    .s_axi_bvalid          (slv.b_valid      ),
    .s_axi_bready          (slv.b_ready      ),
    .s_axi_araddr          (slv.ar_addr[8:0] ),
    .s_axi_arvalid         (slv.ar_valid     ),
    .s_axi_arready         (slv.ar_ready     ),
    .s_axi_rready          (slv.r_ready      ),
    .s_axi_rdata           (slv.r_data       ),
    .s_axi_rresp           (slv.r_resp       ),
    .s_axi_rvalid          (slv.r_valid      ),
    
    .intr(irq_i),
    .irq(irq_o)
);
    
endmodule
