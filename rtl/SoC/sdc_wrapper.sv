module sdc_wrapper (
    input aclk,
    input aresetn,
    
    input  wire [3:0] sd_dat_i,
    output wire [3:0] sd_dat_o,
    output wire sd_dat_t,
    input  wire sd_cmd_i,
    output wire sd_cmd_o,
    output wire sd_cmd_t,
    output wire sd_clk,
    
    output wire int_cmd, 
    output wire int_data,
    
    AXI_BUS.Slave   slv,
    AXI_BUS.Master  dma_mst
);

// WISHBONE pipeline slave
wire   [31:0]  sp_wb_dat_i;     // WISHBONE data input
wire   [31:0]  sp_wb_dat_o;     // WISHBONE data output
wire           sp_wb_err;     // WISHBONE error output
wire   [31:2]  sp_wb_adr;     // WISHBONE address input
wire    [3:0]  sp_wb_sel;     // WISHBONE byte select input
wire           sp_wb_we;      // WISHBONE write enable input
wire           sp_wb_cyc;     // WISHBONE cycle input
wire           sp_wb_stb;     // WISHBONE strobe input
wire           sp_wb_ack;     // WISHBONE acknowledge output
wire           sp_wb_stall;     // WISHBONE acknowledge output

// WISHBONE slave
wire   [31:0]  s_wb_dat_i;     // WISHBONE data input
wire   [31:0]  s_wb_dat_o;     // WISHBONE data output
wire   [31:2]  s_wb_adr;     // WISHBONE address input
wire    [3:0]  s_wb_sel;     // WISHBONE byte select input
wire           s_wb_we;      // WISHBONE write enable input
wire           s_wb_cyc;     // WISHBONE cycle input
wire           s_wb_stb;     // WISHBONE strobe input
wire           s_wb_ack;     // WISHBONE acknowledge output

// WISHBONE master
wire  [31:0]  m_wb_adr;
wire   [3:0]  m_wb_sel;
wire          m_wb_we;
wire  [31:0]  m_wb_dat_i;
wire  [31:0]  m_wb_dat_o;
wire          m_wb_cyc;
wire          m_wb_stb;
wire          m_wb_ack;
wire          m_wb_err;

// WISHBONE pipeline master
wire  [31:2]  mp_wb_adr;
wire   [3:0]  mp_wb_sel;
wire          mp_wb_we;
wire  [31:0]  mp_wb_dat_i;
wire  [31:0]  mp_wb_dat_o;
wire          mp_wb_cyc;
wire          mp_wb_stb;
wire          mp_wb_ack;
wire          mp_wb_err;
wire          mp_wb_stall;

wire sd_cmd_oe, sd_dat_oe;
assign sd_cmd_t = ~sd_cmd_oe;
assign sd_dat_t = ~sd_dat_oe;

sdc_controller inst
(
  // WISHBONE common
  .wb_clk_i(aclk), .wb_rst_i(~aresetn), 
  
  // WISHBONE slave
  .wb_dat_i(s_wb_dat_i), .wb_dat_o(s_wb_dat_o), 
  .wb_adr_i({s_wb_adr[7:2], 2'b0}), .wb_sel_i(s_wb_sel), 
  .wb_we_i(s_wb_we), .wb_cyc_i(s_wb_cyc), 
  .wb_stb_i(s_wb_stb), .wb_ack_o(s_wb_ack),

  // WISHBONE master
  .m_wb_adr_o(m_wb_adr), .m_wb_sel_o(m_wb_sel), .m_wb_we_o(m_wb_we),
  .m_wb_dat_o({m_wb_dat_o[7:0], m_wb_dat_o[15:8], m_wb_dat_o[23:16], m_wb_dat_o[31:24]}),
  .m_wb_dat_i({m_wb_dat_i[7:0], m_wb_dat_i[15:8], m_wb_dat_i[23:16], m_wb_dat_i[31:24]}),
  .m_wb_cyc_o(m_wb_cyc), .m_wb_stb_o(m_wb_stb), .m_wb_ack_i(m_wb_ack),
  
  .sd_cmd_dat_i(sd_cmd_i), 
  .sd_cmd_out_o(sd_cmd_o), 
  .sd_cmd_oe_o(sd_cmd_oe),
  .sd_dat_dat_i(sd_dat_i), 
  .sd_dat_out_o(sd_dat_o),
  .sd_dat_oe_o(sd_dat_oe), 
  .sd_clk_o_pad(sd_clk),
  .sd_clk_i_pad(aclk),
  .int_cmd(int_cmd),
  .int_data(int_data)
);

AXI_LITE #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
) slv_lite();

AXI_LITE #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
) mst_lite();

axi_to_axi_lite_intf #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .AXI_ID_WIDTH(4),
    .FALL_THROUGH(1)
) slv_conv (
    .clk_i(aclk),
    .rst_ni(aresetn),
    .testmode_i(1'b0),
    .slv(slv),
    .mst(slv_lite)
);

axlite2wbsp #(.C_AXI_ADDR_WIDTH(32)) ax2wp (
    .i_clk(aclk), .i_axi_reset_n(aresetn),
	//
	.o_axi_awready(slv_lite.aw_ready), .i_axi_awaddr(slv_lite.aw_addr),
	.i_axi_awvalid(slv_lite.aw_valid),
	//
	.o_axi_wready(slv_lite.w_ready), .i_axi_wdata(slv_lite.w_data),
	.i_axi_wstrb(slv_lite.w_strb), .i_axi_wvalid(slv_lite.w_valid),
	//
	.o_axi_bresp(slv_lite.b_resp), .o_axi_bvalid(slv_lite.b_valid), .i_axi_bready(slv_lite.b_ready),
	//
	.o_axi_arready(slv_lite.ar_ready), .i_axi_araddr(slv_lite.ar_addr),
	 .i_axi_arvalid(slv_lite.ar_valid),
	//
	.o_axi_rresp(slv_lite.r_resp), .o_axi_rvalid(slv_lite.r_valid),
	 .o_axi_rdata(slv_lite.r_data), .i_axi_rready(slv_lite.r_ready),
	//
	// Wishbone interface
	.o_wb_cyc(sp_wb_cyc), .o_wb_stb(sp_wb_stb), .o_wb_we(sp_wb_we),
	.o_wb_addr(sp_wb_adr), .o_wb_data(sp_wb_dat_o), .o_wb_sel(sp_wb_sel),
	.i_wb_ack(sp_wb_ack), .i_wb_stall(sp_wb_stall), .i_wb_data(sp_wb_dat_i), 
	.i_wb_err(sp_wb_err)
);


wbp2classic #(.AW(30)) wp2wc (
    .i_clk(aclk), .i_reset(~aresetn),
    
    .i_scyc(sp_wb_cyc), 
    .i_sstb(sp_wb_stb), 
    .i_swe(sp_wb_we),
	.i_saddr(sp_wb_adr),
	.i_sdata(sp_wb_dat_o),
	.i_ssel(sp_wb_sel),
	.o_sstall(sp_wb_stall), 
	.o_sack(sp_wb_ack),
	.o_sdata(sp_wb_dat_i),
	.o_serr(sp_wb_err),
	
	.o_mcyc(s_wb_cyc),
    .o_mstb(s_wb_stb),
    .o_mwe(s_wb_we),
    .o_maddr(s_wb_adr),
    .o_mdata(s_wb_dat_i),
    .o_msel(s_wb_sel),
    .i_mack(s_wb_ack),
    .i_mdata(s_wb_dat_o),
    .i_merr(1'b0)
);


wbc2pipeline #(.AW(30)) wc2wp(
    .i_clk(aclk), .i_reset(~aresetn),
    
    .i_scyc(m_wb_cyc), 
    .i_sstb(m_wb_stb), 
    .i_swe(m_wb_we),
	.i_saddr(m_wb_adr[31:2]),
	.i_sdata(m_wb_dat_o),
	.i_ssel(m_wb_sel),
	.o_sack(m_wb_ack),
	.o_sdata(m_wb_dat_i),
	.o_serr(m_wb_err),
	
	.o_mcyc(mp_wb_cyc),
    .o_mstb(mp_wb_stb),
    .o_mwe(mp_wb_we),
    .o_maddr(mp_wb_adr),
    .o_mdata(mp_wb_dat_i),
    .o_msel(mp_wb_sel),
    .i_mack(mp_wb_ack),
    .i_mdata(mp_wb_dat_o),
    .i_merr(mp_wb_err),
    .i_mstall(mp_wb_stall)
);

wbm2axisp #(
    .C_AXI_ADDR_WIDTH(32),
    .C_AXI_DATA_WIDTH(32),
    .AW(30),
    .DW(32),
    .C_AXI_ID_WIDTH(4),
    .AXI_WRITE_ID(1'b1),
    .AXI_READ_ID(1'b1)
) wp2ax (
    .i_clk(aclk), .i_reset(~aresetn),
	//
	.i_axi_awready (dma_mst.aw_ready), .o_axi_awaddr (dma_mst.aw_addr),
	.o_axi_awvalid (dma_mst.aw_valid), .o_axi_awid   (dma_mst.aw_id  ),
	.o_axi_awlen   (dma_mst.aw_len  ), .o_axi_awsize (dma_mst.aw_size),
	.o_axi_awburst (dma_mst.aw_burst),
	//
	.i_axi_wready  (dma_mst.w_ready ), .o_axi_wdata  (dma_mst.w_data ),
	.o_axi_wstrb   (dma_mst.w_strb  ), .o_axi_wvalid (dma_mst.w_valid),
	.o_axi_wlast   (dma_mst.w_last  ),
	//
	.i_axi_bresp   (dma_mst.b_resp  ), .i_axi_bid    (dma_mst.b_id   ),
	.i_axi_bvalid  (dma_mst.b_valid ), .o_axi_bready (dma_mst.b_ready),
	//
	.o_axi_arid    (dma_mst.ar_id   ), .o_axi_araddr (dma_mst.ar_addr),
	.o_axi_arlen   (dma_mst.ar_len  ), .o_axi_arsize (dma_mst.ar_size),
	.i_axi_arready (dma_mst.ar_ready), .o_axi_arvalid(dma_mst.ar_valid),
	.o_axi_arburst (dma_mst.ar_burst),
	//
	.i_axi_rresp   (dma_mst.r_resp  ), .i_axi_rvalid(dma_mst.r_valid),
	.i_axi_rdata   (dma_mst.r_data  ), .o_axi_rready(dma_mst.r_ready),
    .i_axi_rlast   (dma_mst.r_last  ), .i_axi_rid   (dma_mst.r_id   ),
	//
	// Wishbone interface
	.i_wb_cyc (mp_wb_cyc), .i_wb_stb  (mp_wb_stb  ), .i_wb_we  (mp_wb_we   ),
	.i_wb_addr(mp_wb_adr), .i_wb_data (mp_wb_dat_i), .i_wb_sel (mp_wb_sel  ),
	.o_wb_ack (mp_wb_ack), .o_wb_stall(mp_wb_stall), .o_wb_data(mp_wb_dat_o), 
	.o_wb_err (mp_wb_err)
);


endmodule

