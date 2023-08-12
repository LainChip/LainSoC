`include "typedef.svh"
`include "assign.svh"

module cpu_wrapper #(
    parameter C_ASIC_SRAM = 0
) (
    input cpu_clk,    
    input m0_clk,
    input m0_aresetn,
    
    input [7:0] interrupt,
    AXI_BUS.Master m0,

    input [1:0]  debug_output_mode,
    output [3:0] debug_output_data,
    output cpu_aresetn,
    output cpu_global_reset
);

wire [7:0] int_cpu;
stolen_cdc_sync_rst cpu_rstgen(
    .src_rst(m0_aresetn),
    .dest_clk(cpu_clk),
    // output
    .dest_rst(cpu_aresetn)
);

stolen_cdc_array_single #(2, 0, 8) int_cdc(
   .src_clk(1'b1),
   .src_in(interrupt),
   .dest_clk(cpu_clk),
   .dest_out(int_cpu)
);

wire [1:0] debug_output_mode_synced;
stolen_cdc_array_single #(2, 0, 2) dbg_cdc(
   .src_clk(1'b1),
   .src_in(debug_output_mode),
   .dest_clk(cpu_clk),
   .dest_out(debug_output_mode_synced)
);

AXI_BUS #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(32), .AXI_ID_WIDTH(4)) cpu();

`define Lawcmd 4
`define Lawdirqid 4
`define Lawstate 2
`define Lawscseti 2
`define Lawid 4
`define Lawaddr 32 
`define Lawlen 4
`define Lawsize 3
`define Lawburst 2
`define Lawlock 2
`define Lawcache 4
`define Lawprot 3
`define Lawvalid 1
`define Lawready 1
`define Lwid 4
`define Lwdata 32 
`define Lwstrb 4
`define Lwlast 1
`define Lwvalid 1
`define Lwready 1
`define Lbid 4
`define Lbresp 2
`define Lbvalid 1
`define Lbready 1
`define Larcmd 4
`define Larcpuno 10
`define Larid 4
`define Laraddr 32
`define Larlen 4
`define Larsize 3
`define Larburst 2
`define Larlock 2
`define Larcache 4
`define Larprot 3
`define Larvalid 1
`define Larready 1
`define Lrstate 2
`define Lrscseti 2
`define Lrid 4
`define Lrdata 32
`define Lrresp 2
`define Lrlast 1
`define Lrvalid 1
`define Lrready 1
`define Lrrequest 1
`define LID 4
`define LADDR 32
`define LLEN 4
`define LSIZE 3
`define LDATA 32
`define LSTRB 4
`define LBURST 2
`define LLOCK 2
`define LCACHE 4
`define LPROT 3
`define LRESP 2

wire [`LID         -1 :0] cpu_awid;
wire [`Lawaddr     -1 :0] cpu_awaddr;
wire [`Lawlen      -1 :0] cpu_awlen;
wire [`Lawsize     -1 :0] cpu_awsize;
wire [`Lawburst    -1 :0] cpu_awburst;
wire [`Lawlock     -1 :0] cpu_awlock;
wire [`Lawcache    -1 :0] cpu_awcache;
wire [`Lawprot     -1 :0] cpu_awprot;
wire                      cpu_awvalid;
wire                      cpu_awready;
wire [`Lwdata      -1 :0] cpu_wdata;
wire [`Lwstrb      -1 :0] cpu_wstrb;
wire                      cpu_wlast;
wire                      cpu_wvalid;
wire                      cpu_wready;
wire [`LID         -1 :0] cpu_bid;
wire [`Lbresp      -1 :0] cpu_bresp;
wire                      cpu_bvalid;
wire                      cpu_bready;
wire [`LID         -1 :0] cpu_arid;
wire [`Laraddr     -1 :0] cpu_araddr;
wire [`Larlen      -1 :0] cpu_arlen;
wire [`Larsize     -1 :0] cpu_arsize;
wire [`Larburst    -1 :0] cpu_arburst;
wire [`Larlock     -1 :0] cpu_arlock;
wire [`Larcache    -1 :0] cpu_arcache;
wire [`Larprot     -1 :0] cpu_arprot;
wire                      cpu_arvalid;
wire                      cpu_arready;
wire [`LID         -1 :0] cpu_rid;
wire [`Lrdata      -1 :0] cpu_rdata;
wire [`Lrresp      -1 :0] cpu_rresp;
wire                      cpu_rlast;
wire                      cpu_rvalid;
wire                      cpu_rready;

assign cpu.ar_id = cpu_arid;
assign cpu.ar_addr = cpu_araddr;
assign cpu.ar_len = {4'b0, cpu_arlen};
assign cpu.ar_size = cpu_arsize;
assign cpu.ar_burst = cpu_arburst;
assign cpu.ar_lock = cpu_arlock;
assign cpu.ar_cache = cpu_arcache;
assign cpu.ar_prot = cpu_arprot;
assign cpu.ar_valid = cpu_arvalid;
assign cpu_arready = cpu.ar_ready;

assign cpu_rid = cpu.r_id;
assign cpu_rdata = cpu.r_data;
assign cpu_rresp = cpu.r_resp;
assign cpu_rlast = cpu.r_last;
assign cpu_rvalid = cpu.r_valid;
assign cpu.r_ready = cpu_rready;

assign cpu.aw_id = cpu_awid;
assign cpu.aw_addr = cpu_awaddr;
assign cpu.aw_len = {4'b0, cpu_awlen};
assign cpu.aw_size = cpu_awsize;
assign cpu.aw_burst = cpu_awburst;
assign cpu.aw_lock = cpu_awlock;
assign cpu.aw_cache = cpu_awcache;
assign cpu.aw_prot = cpu_awprot;
assign cpu.aw_valid = cpu_awvalid;
assign cpu_awready = cpu.aw_ready;

assign cpu.w_data = cpu_wdata;
assign cpu.w_strb = cpu_wstrb;
assign cpu.w_last = cpu_wlast;
assign cpu.w_valid = cpu_wvalid;
assign cpu_wready = cpu.w_ready;

assign cpu_bid = cpu.b_id;
assign cpu_bresp = cpu.b_resp;
assign cpu_bvalid = cpu.b_valid;
assign cpu.b_ready = cpu_bready;

axi_cdc_intf #(
    .AXI_ID_WIDTH(4),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .LOG_DEPTH(2)
) cpu_cdc (
    .src_clk_i(cpu_clk),
    .src_rst_ni(cpu_aresetn),
    .src(cpu),
    
    .dst_clk_i(m0_clk),
    .dst_rst_ni(m0_aresetn),
    .dst(m0)
); 

wire [31:0] debug_wb_pc;
wire [31:0] debug_wb_instr;
wire [31:0] debug_wb_rf_wdata;

// cpu
// ref core
//rcpu_top  cpu_mid (
//  .aclk         (cpu_clk),
//  .intrpt       (int_cpu),  //232 only 5bit
//  .aresetn      (cpu_aresetn ),
 
//  .arid         (cpu_arid[3:0] ),
//  .araddr       (cpu_araddr    ),
//  .arlen        (cpu_arlen     ),
//  .arsize       (cpu_arsize    ),
//  .arburst      (cpu_arburst   ),
//  .arlock       (cpu_arlock    ),
//  .arcache      (cpu_arcache   ),
//  .arprot       (cpu_arprot    ),
//  .arvalid      (cpu_arvalid   ),
//  .arready      (cpu_arready   ),

//  .rid          (cpu_rid[3:0]  ),
//  .rdata        (cpu_rdata     ),
//  .rresp        (cpu_rresp     ),
//  .rlast        (cpu_rlast     ),
//  .rvalid       (cpu_rvalid    ),
//  .rready       (cpu_rready    ),

//  .awid         (cpu_awid[3:0] ),
//  .awaddr       (cpu_awaddr    ),
//  .awlen        (cpu_awlen     ),
//  .awsize       (cpu_awsize    ),
//  .awburst      (cpu_awburst   ),
//  .awlock       (cpu_awlock    ),
//  .awcache      (cpu_awcache   ),
//  .awprot       (cpu_awprot    ),
//  .awvalid      (cpu_awvalid   ),
//  .awready      (cpu_awready   ),

//  .wid          (    4'b0      ),
//  .wdata        (cpu_wdata     ),
//  .wstrb        (cpu_wstrb     ),
//  .wlast        (cpu_wlast     ),
//  .wvalid       (cpu_wvalid    ),
//  .wready       (cpu_wready    ),

//  .bid          (cpu_bid[3:0]  ),
//  .bresp        (cpu_bresp     ),
//  .bvalid       (cpu_bvalid    ),
//  .bready       (cpu_bready    ),

//  .debug0_wb_pc  (debug_wb_pc   ),
//  .debug0_wb_rf_wen('0),
//  .debug0_wb_rf_wnum('0),
//  .debug0_wb_rf_wdata(debug_wb_rf_wdata),
//  .debug0_wb_inst(debug_wb_instr)
//);
assign cpu_global_reset = ~cpu_aresetn; // useless

// simple_loong_cpu
 mycpu_mega_top  cpu_mid (
  .aclk         (cpu_clk),
  .ext_int      (int_cpu),  // [7:0] hardware interrupt
  .aresetn      (cpu_aresetn    ),
  .global_reset (cpu_global_reset),
 
  .arid         (cpu_arid[3:0] ),
  .araddr       (cpu_araddr    ),
  .arlen        (cpu_arlen     ),
  .arsize       (cpu_arsize    ),
  .arburst      (cpu_arburst   ),
  .arlock       (cpu_arlock    ),
  .arcache      (cpu_arcache   ),
  .arprot       (cpu_arprot    ),
  .arvalid      (cpu_arvalid   ),
  .arready      (cpu_arready   ),
  .rid          (cpu_rid[3:0]  ),
  .rdata        (cpu_rdata     ),
  .rresp        (cpu_rresp     ),
  .rlast        (cpu_rlast     ),
  .rvalid       (cpu_rvalid    ),
  .rready       (cpu_rready    ),
  .awid         (cpu_awid[3:0] ),
  .awaddr       (cpu_awaddr    ),
  .awlen        (cpu_awlen     ),
  .awsize       (cpu_awsize    ),
  .awburst      (cpu_awburst   ),
  .awlock       (cpu_awlock    ),
  .awcache      (cpu_awcache   ),
  .awprot       (cpu_awprot    ),
  .awvalid      (cpu_awvalid   ),
  .awready      (cpu_awready   ),
  .wdata        (cpu_wdata     ),
  .wstrb        (cpu_wstrb     ),
  .wlast        (cpu_wlast     ),
  .wvalid       (cpu_wvalid    ),
  .wready       (cpu_wready    ),
  .bid          (cpu_bid[3:0]  ),
  .bresp        (cpu_bresp     ),
  .bvalid       (cpu_bvalid    ),
  .bready       (cpu_bready    ),

  .debug_wb_pc  (debug_wb_pc   ),
  .debug_wb_instr(debug_wb_instr),
  .debug_wb_rf_wdata(debug_wb_rf_wdata)
 );

debug_output debugger (
  .clk(cpu_clk),
  .rst(~cpu_aresetn),

  .debug_wb_pc  (debug_wb_pc   ),
  .debug_wb_instr(debug_wb_instr),
  .debug_wb_rf_wdata(debug_wb_rf_wdata),

  .mode(debug_output_mode_synced),
  .data(debug_output_data)
);

endmodule

