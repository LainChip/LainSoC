(* keep_hierarchy = "yes" *)
module soc_top #(
    parameter C_ASIC_SRAM = 1
) (
    input soc_clk,
    input mig_clk,
    input cpu_clk,
    input mig_aresetn,
    
    output [6:0]  mem_axi_awid,
    output [31:0] mem_axi_awaddr,
    output [7:0]  mem_axi_awlen,
    output [2:0]  mem_axi_awsize,
    output [1:0]  mem_axi_awburst,
    output        mem_axi_awvalid,
    input         mem_axi_awready,
    output [31:0] mem_axi_wdata,
    output [3:0]  mem_axi_wstrb,
    output        mem_axi_wlast,
    output        mem_axi_wvalid,
    input         mem_axi_wready,
    output        mem_axi_bready,
    input  [6:0]  mem_axi_bid,
    input  [1:0]  mem_axi_bresp,
    input         mem_axi_bvalid,
    output [6:0]  mem_axi_arid,
    output [31:0] mem_axi_araddr,
    output [7:0]  mem_axi_arlen,
    output [2:0]  mem_axi_arsize,
    output [1:0]  mem_axi_arburst,
    output        mem_axi_arvalid,
    input         mem_axi_arready,
    output        mem_axi_rready,
    input [6:0]   mem_axi_rid,
    input [31:0]  mem_axi_rdata,
    input [1:0]   mem_axi_rresp,
    input         mem_axi_rlast,
    input         mem_axi_rvalid,
    
    output [3:0]  csn_o,
    output        sck_o,
    input         sdo_i,
    output        sdo_o,
    output        sdo_en, 
    input         sdi_i,
    output        sdi_o,
    output        sdi_en,
    
    input         uart_txd_i,
    output        uart_txd_o,
    output        uart_txd_en,
    input         uart_rxd_i,
    output        uart_rxd_o,
    output        uart_rxd_en,
    
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
    
    output [15:0]   led,

    output  [3:0]   vga_r,
    output  [3:0]   vga_g,
    output  [3:0]   vga_b,
    output          vga_hsync,
    output          vga_vsync,
    input           vga_clk,
    
    input  [3:0]    sd_dat_i,
    output [3:0]    sd_dat_o,
    output          sd_dat_t,
    input           sd_cmd_i,
    output          sd_cmd_o,
    output          sd_cmd_t,
    output          sd_clk,

    input           utmi_clk,
    input  [7:0]    utmi_data_i,
    input           utmi_txready_i,
    input           utmi_rxvalid_i,
    input           utmi_rxactive_i,
    input           utmi_rxerror_i,
    input  [1:0]    utmi_linestate_i,
    output [7:0]    utmi_data_o,
    output          utmi_data_t,
    output          utmi_txvalid_o,
    output [1:0]    utmi_op_mode_o,
    output [1:0]    utmi_xcvrselect_o,
    output          utmi_termselect_o,
    output          utmi_dppulldown_o,
    output          utmi_dmpulldown_o,
    output          utmi_reset_o,
    // do not use: set 0
    output          utmi_idpullup_o,
    output          utmi_chrgvbus_o,
    output          utmi_dischrgvbus_o,
    output          utmi_suspend_n_o,
    
    output          i2s_lrclk_o,
    output          i2s_sclk_o,
    output          i2s_sdata_o,
    input           i2s_clk,

    output          CDBUS_tx,
    output          CDBUS_tx_t,
    output          CDBUS_tx_en,
    output          CDBUS_tx_en_t,
    input           CDBUS_rx,

    output   [31:0] dat_cfg_to_ctrl,
    input    [31:0] dat_ctrl_to_cfg,

    output   [7:0] gpio_o,
    input    [7:0] gpio_i,
    output   [7:0] gpio_t,
    
    input    [3:0]  spi_div_ctrl,
    input           intr_ctrl,

    input    [1:0]  debug_output_mode,
    output   [3:0]  debug_output_data,

    input  i2cm_scl_i,
    output i2cm_scl_o,
    output i2cm_scl_t,

    input  i2cm_sda_i,
    output i2cm_sda_o,
    output i2cm_sda_t
);

wire soc_aresetn;

`define AXI_LINE(name) AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)) name()
`define AXI_LITE_LINE(name) AXI_LITE #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32)) name()
`define AXI_LINE_W(name, idw) AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(idw)) name()

`define CLK_BOOST(name, soc_field, mig_field) axi_cdc_intf #(.AXI_ID_WIDTH(4),.AXI_ADDR_WIDTH(32),.AXI_DATA_WIDTH(32),.LOG_DEPTH(2)) name(.src_clk_i(soc_clk),.src_rst_ni(soc_aresetn),.src(soc_field),.dst_clk_i(mig_clk),.dst_rst_ni(mig_aresetn),.dst(mig_field))

`AXI_LINE(cpu_m);

`AXI_LINE(spi_s);
`AXI_LINE(eth_s);
`AXI_LINE(intc_s);
`AXI_LINE(sdc_s);
`AXI_LINE(vga_s);
`AXI_LINE(jpeg_s);
`AXI_LINE(usb_s);
`AXI_LINE(i2s_mod_s);
`AXI_LINE(i2s_tx_s);

`AXI_LINE_W(mig_s, 7);
// `AXI_LINE_W(migsoc_s, 7);

`AXI_LINE(sdc_dma_m);
`AXI_LINE(vga_dma_m);
`AXI_LINE(jpeg_dma_m);
`AXI_LINE(i2s_dma_m);
`AXI_LINE(mem_m);
// BOOST CLOCK
`AXI_LINE(sdc_dma_mig_m);
`CLK_BOOST(sdc_boost, sdc_dma_m, sdc_dma_mig_m);
`AXI_LINE(vga_dma_mig_m);
`CLK_BOOST(vga_boost, vga_dma_m, vga_dma_mig_m);
`AXI_LINE(jpeg_dma_mig_m);
`CLK_BOOST(jpeg_boost, jpeg_dma_m, jpeg_dma_mig_m);
`AXI_LINE(i2s_dma_mig_m);
`CLK_BOOST(i2s_boost, i2s_dma_m, i2s_dma_mig_m);
`AXI_LINE(mem_mig_m);
`CLK_BOOST(mem_boost, mem_m, mem_mig_m);


`AXI_LINE(apb_s);
`AXI_LINE(cfg_s);
`AXI_LINE(err_s);

// 这里进行一个时钟域转换，从mig uiclk -> SoC clk
wire i2s_resetn, i2s_rst;
stolen_cdc_sync_rst soc_rstgen(
    .src_rst(mig_aresetn),
    .dest_clk(soc_clk),
    // output
    .dest_rst(soc_aresetn)
);
stolen_cdc_sync_rst i2s_rstgen(
    .src_rst(mig_aresetn),
    .dest_clk(i2s_clk),
    // output
    .dest_rst(i2s_resetn)
);
assign i2s_rst = !i2s_resetn;

// axi_cdc_intf #(
//     .AXI_ID_WIDTH(7),
//     .AXI_ADDR_WIDTH(32),
//     .AXI_DATA_WIDTH(32),
//     .LOG_DEPTH(2)
// ) cpu_cdc (
//     // slave in
//     .src_clk_i(soc_clk),
//     .src_rst_ni(soc_aresetn),
//     .src(migsoc_s),
//     // master out
//     .dst_clk_i(mig_clk),
//     .dst_rst_ni(mig_aresetn),
//     .dst(mig_s)
// ); 


error_slave_wrapper err_slave_err(soc_clk, soc_aresetn, err_s);

wire spi_interrupt;
wire eth_interrupt;
wire uart_interrupt;
wire cpu_interrupt;
wire sd_dat_interrupt, sd_cmd_interrupt;
wire usb_interrupt;
wire cdbus_interrupt; // unused
wire i2c_interrupt;   // unused
wire mod_irq;
wire tx_irq;
// Ethernet should be at lowest bit because the configuration in intc
// (interrupt of emaclite is a pulse interrupt, not level) 
// wire [7:0] interrupts = {i2c_interrupt, cdbus_interrupt, usb_interrupt, sd_dat_interrupt, sd_cmd_interrupt, uart_interrupt, spi_interrupt, eth_interrupt};

wire [7:0] interrupts = {'0, tx_irq, mod_irq, usb_interrupt, sd_dat_interrupt, sd_cmd_interrupt, uart_interrupt, spi_interrupt};

cpu_wrapper #(
    .C_ASIC_SRAM(C_ASIC_SRAM)
) cpu (
    .cpu_clk(cpu_clk),
    .m0_clk(soc_clk),
    .m0_aresetn(soc_aresetn),
    .interrupt(interrupts),
    .m0(cpu_m),

    .debug_output_mode(debug_output_mode),
    .debug_output_data(debug_output_data)
);

function automatic logic [3:0] periph_addr_sel(input logic [ 31 : 0 ] addr);
    automatic logic [3:0] select;
    if (addr[31:27] == 5'b0) // MIG
        select = 1;
    else if (addr[31:20]==12'h1c0 || addr[31:16]==16'h1fe8) // SPI
        select = 5;
    else if (addr[31:16]==16'h1fe4 /* || addr[31:16]==16'h1fe7 || addr[31:16] == 16'h1fe5 */) // APB
        select = 3; 
    else if (addr[31:16]==16'h1fd0) // conf
        select = 2;
    // else if (addr[31:16]==16'h1ff0) // Ethernet
    //     select = 4;
    // else if (addr[31:16]==16'h1fb0) // Interrupt Controller
    //     select = 6;
    else if (addr[31:16]==16'h1c12) // i2s mod
        select = 4;
    else if (addr[31:16]==16'h1c14 || addr[31:16]==16'h1c15) // i2s tx 
        select = 6;
    else if (addr[31:16]==16'h1fe1) // SD Controller
        select = 7;
    else if (addr[31:16]==16'h1c11) // VGA Controller
        select = 8;
    else if (addr[31:16]==16'h1d10) // JPEG Decoder
        select = 9;
    else if (addr[31:16]==16'h1c17) // USB Host Controller
        select = 10;
    else // ERROR
        select = 0;
    return select;
endfunction

my_axi_demux_intf #(
    .AXI_ID_WIDTH(4),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .NO_MST_PORTS(11),
    .MAX_TRANS(2),
    .AXI_LOOK_BITS(2),
    .FALL_THROUGH(1)
) cpu_demux (
    .clk_i(soc_clk),
    .rst_ni(soc_aresetn),
    .test_i(1'b0),
    .slv_aw_select_i(periph_addr_sel(cpu_m.aw_addr)),
    .slv_ar_select_i(periph_addr_sel(cpu_m.ar_addr)),
    .slv(cpu_m),
    .mst0(err_s),
    .mst1(mem_m),
    .mst2(cfg_s),
    .mst3(apb_s),
    .mst4(i2s_mod_s),
    .mst5(spi_s),
    .mst6(i2s_tx_s),  // unused
    .mst7(sdc_s),
    .mst8(vga_s),
    .mst9(jpeg_s), 
    .mst10(usb_s)
);

my_axi_mux_intf #(
    .SLV_AXI_ID_WIDTH(4),
    .MST_AXI_ID_WIDTH(7),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .NO_SLV_PORTS(5),
    .MAX_W_TRANS(4),
    .FALL_THROUGH(1)
) mem_mux (
    // .clk_i(soc_clk),
    .clk_i(mig_clk),
    // .rst_ni(soc_aresetn),
    .rst_ni(mig_aresetn),
    .test_i(1'b0),
    .slv0(sdc_dma_mig_m),
    .slv1(mem_mig_m),
    .slv2(i2s_dma_mig_m),
    .slv3(jpeg_dma_mig_m),
    .slv4(vga_dma_mig_m),
    .mst(mig_s)
);

// axi_intc_wrapper #(
//     .C_NUM_INTR_INPUTS($bits(interrupts))
// ) intc (
//     .aslv(intc_s),
//     .aclk(soc_clk),
//     .aresetn(soc_aresetn),
//     .irq_i(interrupts),
//     .irq_o(cpu_interrupt)
// );

//eth top
//ethernet_wrapper #(
//    .C_ASIC_SRAM(C_ASIC_SRAM)
//) ethernet (
//    .aclk        (soc_clk  ),
//    .aresetn     (soc_aresetn  ),      
//    .slv         (eth_s    ),

//    .interrupt_0 (eth_interrupt),
 
//    .mii_tx_clk,
//    .mii_txd,    
//    .mii_tx_en,
//    .mii_tx_er,

//    .mii_rx_clk,
//    .mii_rxd, 
//    .mii_rxdv,
//    .mii_rx_err,
//    .mii_crs,
//    .mii_col,

//    .md_i_0,      
//    .mdc_0,
//    .md_o_0,
//    .md_t_0,
//    .phy_rstn
//);

sdc_wrapper sdc(
    .aclk(soc_clk),
    .aresetn(soc_aresetn),
    
    .slv(sdc_s),
    .dma_mst(sdc_dma_m),
    .int_cmd(sd_cmd_interrupt),
    .int_data(sd_dat_interrupt),
    
    .sd_dat_i(sd_dat_i),
    .sd_dat_o(sd_dat_o),
    .sd_dat_t(sd_dat_t),
    .sd_cmd_i(sd_cmd_i),
    .sd_cmd_o(sd_cmd_o),
    .sd_cmd_t(sd_cmd_t),
    .sd_clk(sd_clk)
);

vga_wrapper vga(
    .aclk(soc_clk),
    .aresetn(soc_aresetn),

    .slv(vga_s),
    .dma_mst(vga_dma_m),

    .vga_r(vga_r),  // output wire [3 : 0] vga_r
    .vga_g(vga_g),  // output wire [3 : 0] vga_g
    .vga_b(vga_b),  // output wire [3 : 0] vga_b
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync),
    .vga_clk(vga_clk)
);

// jpeg
jpeg_decoder_wrapper  jpeg_decoder (
    .aclk(soc_clk),
    .aresetn(soc_aresetn),

    .ctl_slv(jpeg_s),
    .dma_mst(jpeg_dma_m)
);

// i2s
i2s_wrapper  i2s_wrapper_inst (
    .aclk(soc_clk),
    .aresetn(soc_aresetn),
    .i2s_clk(i2s_clk),
    .i2s_rst(i2s_rst),

    .lrclk_o(i2s_lrclk_o),
    .sclk_o(i2s_sclk_o),
    .sdata_o(i2s_sdata_o),
    .i2s_mod_slv(i2s_mod_s),
    .i2s_tx_slv(i2s_tx_s),
    .dma_mst(i2s_dma_m),
    .mod_irq(mod_irq),
    .tx_irq(tx_irq)
  );

usb_wrapper  usb_host (
    .aclk(soc_clk),
    .aresetn(soc_aresetn),
    .utmi_clk(utmi_clk), // 60MHz

    .interrupt_o(usb_interrupt),

    .utmi_data_i(utmi_data_i),
    .utmi_txready_i(utmi_txready_i),
    .utmi_rxvalid_i(utmi_rxvalid_i),
    .utmi_rxactive_i(utmi_rxactive_i),
    .utmi_rxerror_i(utmi_rxerror_i),
    .utmi_linestate_i(utmi_linestate_i),
    .utmi_data_o(utmi_data_o),
    .utmi_data_t(utmi_data_t),
    .utmi_txvalid_o(utmi_txvalid_o),
    .utmi_op_mode_o(utmi_op_mode_o),
    .utmi_xcvrselect_o(utmi_xcvrselect_o),
    .utmi_termselect_o(utmi_termselect_o),
    .utmi_dppulldown_o(utmi_dppulldown_o),
    .utmi_dmpulldown_o(utmi_dmpulldown_o),
    .utmi_reset_o(utmi_reset_o),
    // do not use: set 0
    .utmi_idpullup_o(utmi_idpullup_o),
    .utmi_chrgvbus_o(utmi_chrgvbus_o),
    .utmi_dischrgvbus_o(utmi_dischrgvbus_o),
    .utmi_suspend_n_o(utmi_suspend_n_o),    

    .usb_ctl_slv(usb_s)
);

//confreg
la_confreg_syn  confreg_inst (
    .aclk(soc_clk),
    .aresetn(soc_aresetn),

    .s_awid(cfg_s.aw_id),
    .s_awaddr(cfg_s.aw_addr),
    .s_awlen(cfg_s.aw_len),
    .s_awsize(cfg_s.aw_size),
    .s_awburst(cfg_s.aw_burst),
    .s_awlock('0),
    .s_awcache('0),
    .s_awprot('0),
    .s_awvalid(cfg_s.aw_valid),
    .s_awready(cfg_s.aw_ready),

    .s_wid('0),
    .s_wdata(cfg_s.w_data),
    .s_wstrb(cfg_s.w_strb),
    .s_wlast(cfg_s.w_last),
    .s_wvalid(cfg_s.w_valid),
    .s_wready(cfg_s.w_ready),

    .s_bid(cfg_s.b_id),
    .s_bresp(cfg_s.b_resp),
    .s_bvalid(cfg_s.b_valid),
    .s_bready(cfg_s.b_ready),

    .s_arid(cfg_s.ar_id),
    .s_araddr(cfg_s.ar_addr),
    .s_arlen(cfg_s.ar_len),
    .s_arsize(cfg_s.ar_size),
    .s_arburst(cfg_s.ar_burst),
    .s_arlock('0),
    .s_arcache('0),
    .s_arprot('0),
    .s_arvalid(cfg_s.ar_valid),
    .s_arready(cfg_s.ar_ready),

    .s_rid(cfg_s.r_id),
    .s_rdata(cfg_s.r_data),
    .s_rresp(cfg_s.r_resp),
    .s_rlast(cfg_s.r_last),
    .s_rvalid(cfg_s.r_valid),
    .s_rready(cfg_s.r_ready)

    // .order_addr_reg(order_addr_reg),
    // .finish_read_order(finish_read_order),
    // .write_dma_end(write_dma_end),
    // .cr00(cr00),
    // .cr01(cr01),
    // .cr02(cr02),
    // .cr03(cr03),
    // .cr04(cr04),
    // .cr05(cr05),
    // .cr06(cr06),
    // .cr07(cr07),
    // .led(led),
    // .led_rg0(led_rg0),
    // .led_rg1(led_rg1),
    // .num_csn(num_csn),
    // .num_a_g(num_a_g),
    // .switch(switch),
    // .btn_key_col(btn_key_col),
    // .btn_key_row(btn_key_row),
    // .btn_step(btn_step)
  );

  assign dat_cfg_to_ctrl = '0;
  assign gpio_o = '0;
  assign gpio_t = '0;


spi_flash_ctrl SPI (                                         
    .aclk           (soc_clk            ),       
    .aresetn        (soc_aresetn            ),       
    .spi_addr       (16'h1fe8           ),
    .fast_startup   (1'b0               ),
    .s_awid         (spi_s.aw_id        ),
    .s_awaddr       (spi_s.aw_addr      ),
    .s_awlen        (spi_s.aw_len[3:0]       ),
    .s_awsize       (spi_s.aw_size      ),
    .s_awburst      (spi_s.aw_burst     ),
    .s_awlock       ('0                 ),
    .s_awcache      ('0                 ),
    .s_awprot       ('0                 ),
    .s_awvalid      (spi_s.aw_valid     ),
    .s_awready      (spi_s.aw_ready     ),
    .s_wready       (spi_s.w_ready      ),
    .s_wdata        (spi_s.w_data       ),
    .s_wstrb        (spi_s.w_strb       ),
    .s_wlast        (spi_s.w_last       ),
    .s_wvalid       (spi_s.w_valid      ),
    .s_bid          (spi_s.b_id         ),
    .s_bresp        (spi_s.b_resp       ),
    .s_bvalid       (spi_s.b_valid      ),
    .s_bready       (spi_s.b_ready      ),
    .s_arid         (spi_s.ar_id        ),
    .s_araddr       (spi_s.ar_addr      ),
    .s_arlen        (spi_s.ar_len[3:0]       ),
    .s_arsize       (spi_s.ar_size      ),
    .s_arburst      (spi_s.ar_burst     ),
    .s_arlock       ('0                 ),
    .s_arcache      ('0                 ),
    .s_arprot       ('0                 ),
    .s_arvalid      (spi_s.ar_valid     ),
    .s_arready      (spi_s.ar_ready     ),
    .s_rready       (spi_s.r_ready      ),
    .s_rid          (spi_s.r_id         ),
    .s_rdata        (spi_s.r_data       ),
    .s_rresp        (spi_s.r_resp       ),
    .s_rlast        (spi_s.r_last       ),
    .s_rvalid       (spi_s.r_valid      ),
    
    .power_down_req (1'b0              ),
    .power_down_ack (                  ),
    .csn_o          (csn_o         ),
    .sck_o          (sck_o         ),
    .sdo_i          (sdo_i         ),
    .sdo_o          (sdo_o         ),
    .sdo_en         (sdo_en        ), // active low
    .sdi_i          (sdi_i         ),
    .sdi_o          (sdi_o         ),
    .sdi_en         (sdi_en        ),
    .inta_o         (spi_interrupt ),
    
    .default_div    (spi_div_ctrl  )
);

axi2apb_misc #(.C_ASIC_SRAM(C_ASIC_SRAM)) APB_DEV 
(
    .clk                (soc_clk               ),
    .rst_n              (soc_aresetn            ),

    .axi_s_awid         (apb_s.aw_id        ),
    .axi_s_awaddr       (apb_s.aw_addr      ),
    .axi_s_awlen        (apb_s.aw_len[3:0]  ),
    .axi_s_awsize       (apb_s.aw_size      ),
    .axi_s_awburst      (apb_s.aw_burst     ),
    .axi_s_awlock       ('0                 ),
    .axi_s_awcache      ('0                 ),
    .axi_s_awprot       ('0                 ),
    .axi_s_awvalid      (apb_s.aw_valid     ),
    .axi_s_awready      (apb_s.aw_ready     ),
    .axi_s_wready       (apb_s.w_ready      ),
    .axi_s_wdata        (apb_s.w_data       ),
    .axi_s_wstrb        (apb_s.w_strb       ),
    .axi_s_wlast        (apb_s.w_last       ),
    .axi_s_wvalid       (apb_s.w_valid      ),
    .axi_s_bid          (apb_s.b_id         ),
    .axi_s_bresp        (apb_s.b_resp       ),
    .axi_s_bvalid       (apb_s.b_valid      ),
    .axi_s_bready       (apb_s.b_ready      ),
    .axi_s_arid         (apb_s.ar_id        ),
    .axi_s_araddr       (apb_s.ar_addr      ),
    .axi_s_arlen        (apb_s.ar_len[3:0]  ),
    .axi_s_arsize       (apb_s.ar_size      ),
    .axi_s_arburst      (apb_s.ar_burst     ),
    .axi_s_arlock       ('0                 ),
    .axi_s_arcache      ('0                 ),
    .axi_s_arprot       ('0                 ),
    .axi_s_arvalid      (apb_s.ar_valid     ),
    .axi_s_arready      (apb_s.ar_ready     ),
    .axi_s_rready       (apb_s.r_ready      ),
    .axi_s_rid          (apb_s.r_id         ),
    .axi_s_rdata        (apb_s.r_data       ),
    .axi_s_rresp        (apb_s.r_resp       ),
    .axi_s_rlast        (apb_s.r_last       ),
    .axi_s_rvalid       (apb_s.r_valid      ),

    .uart0_txd_i        (uart_txd_i      ),
    .uart0_txd_o        (uart_txd_o      ),
    .uart0_txd_oe       (uart_txd_en     ),
    .uart0_rxd_i        (uart_rxd_i      ),
    .uart0_rxd_o        (uart_rxd_o      ),
    .uart0_rxd_oe       (uart_rxd_en     ),
    .uart0_rts_o        (       ),
    .uart0_dtr_o        (       ),
    .uart0_cts_i        (1'b0   ),
    .uart0_dsr_i        (1'b0   ),
    .uart0_dcd_i        (1'b0   ),
    .uart0_ri_i         (1'b0   ),
    .uart0_int          (uart_interrupt),

    .cdbus_int          (cdbus_interrupt),
    .cdbus_tx           (CDBUS_tx),
    .cdbus_tx_t         (CDBUS_tx_t),
    .cdbus_rx           (CDBUS_rx),
    .cdbus_tx_en        (CDBUS_tx_en),
    .cdbus_tx_en_t      (CDBUS_tx_en_t),

    .i2cm_scl_i,
    .i2cm_scl_o,
    .i2cm_scl_t, 

    .i2cm_sda_i,
    .i2cm_sda_o,
    .i2cm_sda_t,

    .i2c_int(i2c_interrupt)
);

    assign mem_axi_awid = mig_s.aw_id;
    assign mem_axi_awaddr = mig_s.aw_addr;
    assign mem_axi_awlen = mig_s.aw_len;
    assign mem_axi_awsize = mig_s.aw_size;
    assign mem_axi_awburst = mig_s.aw_burst;
    assign mem_axi_awvalid = mig_s.aw_valid;
    assign mig_s.aw_ready = mem_axi_awready;
    assign mem_axi_wdata = mig_s.w_data;
    assign mem_axi_wstrb = mig_s.w_strb;
    assign mem_axi_wlast = mig_s.w_last;
    assign mem_axi_wvalid = mig_s.w_valid;
    assign mig_s.w_ready = mem_axi_wready;
    assign mem_axi_bready = mig_s.b_ready;
    assign mig_s.b_id = mem_axi_bid;
    assign mig_s.b_resp = mem_axi_bresp;
    assign mig_s.b_valid = mem_axi_bvalid;
    assign mem_axi_arid = mig_s.ar_id;
    assign mem_axi_araddr = mig_s.ar_addr;
    assign mem_axi_arlen = mig_s.ar_len;
    assign mem_axi_arsize = mig_s.ar_size;
    assign mem_axi_arburst = mig_s.ar_burst;
    assign mem_axi_arvalid = mig_s.ar_valid;
    assign mig_s.ar_ready = mem_axi_arready;
    assign mem_axi_rready = mig_s.r_ready;
    assign mig_s.r_id = mem_axi_rid;
    assign mig_s.r_data = mem_axi_rdata;
    assign mig_s.r_resp = mem_axi_rresp;
    assign mig_s.r_last = mem_axi_rlast;
    assign mig_s.r_valid = mem_axi_rvalid;

endmodule
