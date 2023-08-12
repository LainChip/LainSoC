/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Copyright (c) 2016, Loongson Technology Corporation Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of Loongson Technology Corporation Limited nor the names of 
its contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL LOONGSON TECHNOLOGY CORPORATION LIMITED BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

`include "config.vh"

module axi2apb_misc #(
           parameter C_ASIC_SRAM = 0
)  (
clk,
rst_n,

axi_s_awid,
axi_s_awaddr,
axi_s_awlen,
axi_s_awsize,
axi_s_awburst,
axi_s_awlock,
axi_s_awcache,
axi_s_awprot,
axi_s_awvalid,
axi_s_awready,
axi_s_wdata,
axi_s_wstrb,
axi_s_wlast,
axi_s_wvalid,
axi_s_wready,
axi_s_bid,
axi_s_bresp,
axi_s_bvalid,
axi_s_bready,
axi_s_arid,
axi_s_araddr,
axi_s_arlen,
axi_s_arsize,
axi_s_arburst,
axi_s_arlock,
axi_s_arcache,
axi_s_arprot,
axi_s_arvalid,
axi_s_arready,
axi_s_rid,
axi_s_rdata,
axi_s_rresp,
axi_s_rlast,
axi_s_rvalid,
axi_s_rready,

uart0_txd_i,
uart0_txd_o,
uart0_txd_oe,
uart0_rxd_i,
uart0_rxd_o,
uart0_rxd_oe,
uart0_rts_o,
uart0_dtr_o,
uart0_cts_i,
uart0_dsr_i,
uart0_dcd_i,
uart0_ri_i,

uart0_int,
cdbus_int,
i2c_int,

cdbus_tx,
cdbus_tx_t,
cdbus_rx,
cdbus_tx_en,
cdbus_tx_en_t,

i2cm_scl_i,
i2cm_scl_o,
i2cm_scl_t, 
i2cm_sda_i, 
i2cm_sda_o, 
i2cm_sda_t
);

parameter ADDR_APB = 20,
          DATA_APB = 8,
          L_ADDR = 64,
          L_ID   = 8,
          L_DATA = 128,
          L_MASK = 16;

input          clk;
input          rst_n;

input  [`LID         -1 :0] axi_s_awid;
input  [`Lawaddr     -1 :0] axi_s_awaddr;
input  [`Lawlen      -1 :0] axi_s_awlen;
input  [`Lawsize     -1 :0] axi_s_awsize;
input  [`Lawburst    -1 :0] axi_s_awburst;
input  [`Lawlock     -1 :0] axi_s_awlock;
input  [`Lawcache    -1 :0] axi_s_awcache;
input  [`Lawprot     -1 :0] axi_s_awprot;
input                       axi_s_awvalid;
output                      axi_s_awready;
input  [`Lwdata      -1 :0] axi_s_wdata;
input  [`Lwstrb      -1 :0] axi_s_wstrb;
input                       axi_s_wlast;
input                       axi_s_wvalid;
output                      axi_s_wready;
output [`LID         -1 :0] axi_s_bid;
output [`Lbresp      -1 :0] axi_s_bresp;
output                      axi_s_bvalid;
input                       axi_s_bready;
input  [`LID         -1 :0] axi_s_arid;
input  [`Laraddr     -1 :0] axi_s_araddr;
input  [`Larlen      -1 :0] axi_s_arlen;
input  [`Larsize     -1 :0] axi_s_arsize;
input  [`Larburst    -1 :0] axi_s_arburst;
input  [`Larlock     -1 :0] axi_s_arlock;
input  [`Larcache    -1 :0] axi_s_arcache;
input  [`Larprot     -1 :0] axi_s_arprot;
input                       axi_s_arvalid;
output                      axi_s_arready;
output [`LID         -1 :0] axi_s_rid;
output [`Lrdata      -1 :0] axi_s_rdata;
output [`Lrresp      -1 :0] axi_s_rresp;
output                      axi_s_rlast;
output                      axi_s_rvalid;
input                       axi_s_rready;
input               uart0_txd_i;
output              uart0_txd_o;
output              uart0_txd_oe;
input               uart0_rxd_i;
output              uart0_rxd_o;
output              uart0_rxd_oe;
output              uart0_rts_o;
output              uart0_dtr_o;
input               uart0_cts_i;
input               uart0_dsr_i;
input               uart0_dcd_i;
input               uart0_ri_i;

output uart0_int;
output cdbus_int;
output i2c_int;

output cdbus_tx;
output cdbus_tx_t;
input  cdbus_rx;
output cdbus_tx_en;
output cdbus_tx_en_t;

input  i2cm_scl_i;       // SCL-line input
output i2cm_scl_o;       // SCL-line output (always 1'b0)
output i2cm_scl_t;       // SCL-line output enable (active low)

input  i2cm_sda_i;       // SDA-line input
output i2cm_sda_o;       // SDA-line output (always 1'b0)
output i2cm_sda_t;       // SDA-line output enable (active low)

wire                    apb_rw_cpu;
wire                    apb_psel_cpu;
wire                    apb_enab_cpu;
wire [ADDR_APB-1 :0]    apb_addr_cpu;
wire [DATA_APB-1:0]     apb_datai_cpu;
wire [DATA_APB-1:0]     apb_datao_cpu;

wire                    apb_rw_uart;
wire                    apb_psel_uart;
wire                    apb_enab_uart;
wire [ADDR_APB-1 :0]    apb_addr_uart;
wire [DATA_APB-1:0]     apb_datai_uart;
wire [DATA_APB-1:0]     apb_datao_uart;

wire                    apb_rw_cdbus;
wire                    apb_psel_cdbus;
wire                    apb_enab_cdbus;
wire [ADDR_APB-1 :0]    apb_addr_cdbus;
wire [DATA_APB-1:0]     apb_datai_cdbus;
wire [DATA_APB-1:0]     apb_datao_cdbus;

wire                    apb_rw_i2c;
wire                    apb_psel_i2c;
wire                    apb_enab_i2c;
wire [ADDR_APB-1 :0]    apb_addr_i2c;
wire [DATA_APB-1:0]     apb_datai_i2c;
wire [DATA_APB-1:0]     apb_datao_i2c;

axi2apb_bridge AA_axi2apb_bridge_cpu (
    .clk                (clk                ),
    .rst_n              (rst_n              ),
    .axi_s_awid         (axi_s_awid         ),
    .axi_s_awaddr       (axi_s_awaddr       ),
    .axi_s_awlen        (axi_s_awlen        ),
    .axi_s_awsize       (axi_s_awsize       ),
    .axi_s_awburst      (axi_s_awburst      ),
    .axi_s_awlock       (axi_s_awlock       ),
    .axi_s_awcache      (axi_s_awcache      ),
    .axi_s_awprot       (axi_s_awprot       ),
    .axi_s_awvalid      (axi_s_awvalid      ),
    .axi_s_awready      (axi_s_awready      ),
    .axi_s_wdata        (axi_s_wdata        ),
    .axi_s_wstrb        (axi_s_wstrb        ),
    .axi_s_wlast        (axi_s_wlast        ),
    .axi_s_wvalid       (axi_s_wvalid       ),
    .axi_s_wready       (axi_s_wready       ),
    .axi_s_bid          (axi_s_bid          ),
    .axi_s_bresp        (axi_s_bresp        ),
    .axi_s_bvalid       (axi_s_bvalid       ),
    .axi_s_bready       (axi_s_bready       ),
    .axi_s_arid         (axi_s_arid         ),
    .axi_s_araddr       (axi_s_araddr       ),
    .axi_s_arlen        (axi_s_arlen        ),
    .axi_s_arsize       (axi_s_arsize       ),
    .axi_s_arburst      (axi_s_arburst      ),
    .axi_s_arlock       (axi_s_arlock       ),
    .axi_s_arcache      (axi_s_arcache      ),
    .axi_s_arprot       (axi_s_arprot       ),
    .axi_s_arvalid      (axi_s_arvalid      ),
    .axi_s_arready      (axi_s_arready      ),
    .axi_s_rid          (axi_s_rid          ),
    .axi_s_rdata        (axi_s_rdata        ),
    .axi_s_rresp        (axi_s_rresp        ),
    .axi_s_rlast        (axi_s_rlast        ),
    .axi_s_rvalid       (axi_s_rvalid       ),
    .axi_s_rready       (axi_s_rready       ),
    
    .apb_word_trans     (1'b0     ),
    .apb_high_24b_rd    (24'b0    ),
    .cpu_grant          (1'b1     ),
    
    .reg_psel           (apb_psel_cpu       ),
    .reg_enable         (apb_enab_cpu       ),
    .reg_rw             (apb_rw_cpu         ),
    .reg_addr           (apb_addr_cpu       ),
    .reg_datai          (apb_datai_cpu      ),
    .reg_datao          (apb_datao_cpu      ),
    .reg_ready_1        (1'b1               )
);

apb_mux2 mux (
    .apb_rw_cpu(apb_rw_cpu),
    .apb_psel_cpu(apb_psel_cpu),
    .apb_enab_cpu(apb_enab_cpu),
    .apb_addr_cpu(apb_addr_cpu),
    .apb_datai_cpu(apb_datai_cpu),
    .apb_datao_cpu(apb_datao_cpu),

    .apb0_rw(apb_rw_uart),
    .apb0_psel(apb_psel_uart),
    .apb0_enab(apb_enab_uart),
    .apb0_addr(apb_addr_uart),
    .apb0_datai(apb_datai_uart),
    .apb0_datao(apb_datao_uart),

    .apb1_rw(apb_rw_cdbus),
    .apb1_psel(apb_psel_cdbus),
    .apb1_enab(apb_enab_cdbus),
    .apb1_addr(apb_addr_cdbus),
    .apb1_datai(apb_datai_cdbus),
    .apb1_datao(apb_datao_cdbus),

    .apb2_rw(apb_rw_i2c),
    .apb2_psel(apb_psel_i2c),
    .apb2_enab(apb_enab_i2c),
    .apb2_addr(apb_addr_i2c),
    .apb2_datai(apb_datai_i2c),
    .apb2_datao(apb_datao_i2c)
);

UART_TOP uart0 (
    .PCLK              (clk               ),
    .clk_carrier       (1'b0              ),
    .PRST_             (rst_n             ),
    .PSEL              (apb_psel_uart     ),
    .PENABLE           (apb_enab_uart     ),
    .PADDR             (apb_addr_uart[7:0]),
    .PWRITE            (apb_rw_uart       ),
    .PWDATA            (apb_datai_uart    ),
    .URT_PRDATA        (apb_datao_uart    ),
    .INT               (uart0_int         ),
    .TXD_o             (uart0_txd_o       ),
    .TXD_i             (uart0_txd_i       ),
    .TXD_oe            (uart0_txd_oe      ),
    .RXD_o             (uart0_rxd_o       ),
    .RXD_i             (uart0_rxd_i       ),
    .RXD_oe            (uart0_rxd_oe      ),
    .RTS               (uart0_rts_o       ),
    .CTS               (uart0_cts_i       ),
    .DSR               (uart0_dsr_i       ),
    .DCD               (uart0_dcd_i       ),
    .DTR               (uart0_dtr_o       ),
    .RI                (uart0_ri_i        )
);
    
//cdbus #(
//    .DIV_LS(868),
//    .DIV_HS(868),
//    .C_ASIC_SRAM(C_ASIC_SRAM)
//) cdbus_ctrl (
//    .clk(clk),
//    .reset_n(rst_n),
//    .chip_select(apb_psel_cdbus),
//    .irq(cdbus_int),
    
//    .csr_address   (apb_addr_cdbus[4:0]                               ),
//    .csr_read      (apb_psel_cdbus && apb_enab_cdbus && !apb_rw_cdbus ),
//    .csr_readdata  (apb_datao_cdbus                                   ),
//    .csr_write     (apb_psel_cdbus && apb_enab_cdbus && apb_rw_cdbus  ),
//    .csr_writedata (apb_datai_cdbus                                   ),
    
//    .tx      (cdbus_tx      ),
//    .tx_t    (cdbus_tx_t    ),
//    .rx      (cdbus_rx      ),
//    .tx_en   (cdbus_tx_en   ),
//    .tx_en_t (cdbus_tx_en_t )
//);
assign cdbus_tx = 1'b0;
assign cdbus_tx_t = 1'b0;
assign cdbus_tx_en = 1'b0;
assign cdbus_tx_en_t = 1'b0;

//i2c_master_top i2c_ctrl(
//    .clk(clk),
//    .rst(~rst_n),
//    .irq(i2c_int),

//    .csr_address   (apb_addr_i2c[2:0]                           ),
//    .csr_read      (apb_psel_i2c && apb_enab_i2c && !apb_rw_i2c ),
//    .csr_readdata  (apb_datao_i2c                               ),
//    .csr_write     (apb_psel_i2c && apb_enab_i2c && apb_rw_i2c  ),
//    .csr_writedata (apb_datai_i2c                               ),

//    .scl_pad_i     (i2cm_scl_i),
//    .scl_pad_o     (i2cm_scl_o),
//    .scl_padoen_o  (i2cm_scl_t),
//    .sda_pad_i     (i2cm_sda_i),
//    .sda_pad_o     (i2cm_sda_o),
//    .sda_padoen_o  (i2cm_sda_t)
//);
assign i2cm_scl_o = 1'b0;
assign i2cm_scl_t = 1'b1;
assign i2cm_sda_o = 1'b0;
assign i2cm_sda_t = 1'b1;

endmodule
