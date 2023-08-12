module usb_wrapper (
    input wire aclk,
    input wire aresetn,
    input wire utmi_clk,

    output wire interrupt_o,

    input  wire [7:0] utmi_data_i,
    input  wire       utmi_txready_i,
    input  wire       utmi_rxvalid_i,
    input  wire       utmi_rxactive_i,
    input  wire       utmi_rxerror_i,
    input  wire [1:0] utmi_linestate_i,

    output wire [7:0] utmi_data_o,
    output wire       utmi_data_t,
    output wire       utmi_txvalid_o,
    output wire [1:0] utmi_op_mode_o,
    output wire [1:0] utmi_xcvrselect_o,
    output wire       utmi_termselect_o,
    output wire       utmi_dppulldown_o,
    output wire       utmi_dmpulldown_o,
    output wire       utmi_reset_o,
    // do not use: set 0
    output wire       utmi_idpullup_o,
    output wire       utmi_chrgvbus_o,
    output wire       utmi_dischrgvbus_o,
    output wire       utmi_suspend_n_o,

    AXI_BUS.Slave     usb_ctl_slv
);
    /* Clock Domain Crossing - IN */
    // reset cdc
    wire utmi_rstn;
    stolen_cdc_sync_rst usb_rst_cdc (
        .src_rst(aresetn),
        .dest_clk(utmi_clk),
        // output
        .dest_rst(utmi_rstn)
    );

    // axi bus cdc
    AXI_BUS #(
        .AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)
    ) ctl_slv();
    axi_cdc_intf #(
        .AXI_ID_WIDTH(4),
        .AXI_ADDR_WIDTH(32),
        .AXI_DATA_WIDTH(32),
        .LOG_DEPTH(2)
    ) usb_axi_cdc (
        // slave in
        .src_clk_i(aclk),      // input
        .src_rst_ni(aresetn),  // input
        .src(usb_ctl_slv),     // AXI_BUS.Slave
        // master out
        .dst_clk_i(utmi_clk),  // input
        .dst_rst_ni(utmi_rstn),// input
        .dst(ctl_slv)          // AXI_BUS.Master
    );

    /* AXI and UTMI connecting */
    assign ctl_slv.b_id = ctl_slv.aw_id;
    assign ctl_slv.r_id = ctl_slv.ar_id;
    assign ctl_slv.r_last = ctl_slv.r_valid;

    assign utmi_data_t = ~utmi_txvalid_o;
    // utmi: unused singal
    assign utmi_idpullup_o = 0;
    assign utmi_chrgvbus_o = 0;
    assign utmi_dischrgvbus_o = 0;
    assign utmi_suspend_n_o = 1;

    wire usb_interrupt;

    usbh_host usbh_host_inst (
        .clk_i(utmi_clk),
        .rst_i(~utmi_rstn),

        .cfg_awvalid_i(ctl_slv.aw_valid),
        .cfg_awaddr_i (ctl_slv.aw_addr ),
        .cfg_wvalid_i (ctl_slv.w_valid ),
        .cfg_wdata_i  (ctl_slv.w_data  ),
        .cfg_wstrb_i  (ctl_slv.w_strb  ),
        .cfg_bready_i (ctl_slv.b_ready ),
        .cfg_arvalid_i(ctl_slv.ar_valid),
        .cfg_araddr_i (ctl_slv.ar_addr ),
        .cfg_rready_i (ctl_slv.r_ready ),
        .cfg_awready_o(ctl_slv.aw_ready),
        .cfg_wready_o (ctl_slv.w_ready ),
        .cfg_bvalid_o (ctl_slv.b_valid ),
        .cfg_bresp_o  (ctl_slv.b_resp  ),
        .cfg_arready_o(ctl_slv.ar_ready),
        .cfg_rvalid_o (ctl_slv.r_valid ),
        .cfg_rdata_o  (ctl_slv.r_data  ),
        .cfg_rresp_o  (ctl_slv.r_resp  ),

        .utmi_data_in_i   (utmi_data_i),
        .utmi_txready_i   (utmi_txready_i),
        .utmi_rxvalid_i   (utmi_rxvalid_i),
        .utmi_rxactive_i  (utmi_rxactive_i),
        .utmi_rxerror_i   (utmi_rxerror_i),
        .utmi_linestate_i (utmi_linestate_i),
        .utmi_data_out_o  (utmi_data_o),
        .utmi_txvalid_o   (utmi_txvalid_o),
        .utmi_op_mode_o   (utmi_op_mode_o),
        .utmi_xcvrselect_o(utmi_xcvrselect_o),
        .utmi_termselect_o(utmi_termselect_o),
        .utmi_dppulldown_o(utmi_dppulldown_o),
        .utmi_dmpulldown_o(utmi_dmpulldown_o),
        .utmi_reset_o     (utmi_reset_o),

        .intr_o(usb_interrupt)
    );

    /* Clock Domain Crossing - OUT */
    // intr cdc
    stolen_cdc_single #(2,0) usb_intr_cdc (
        .src_clk(utmi_clk),
        .src_in(usb_interrupt),
        .dest_clk(aclk),
        .dest_out(interrupt_o)  // output
    );

endmodule
