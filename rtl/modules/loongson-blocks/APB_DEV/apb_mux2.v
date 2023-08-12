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

`define APB_DEV0  6'h10
`define APB_DEV2  6'h14
`define APB_DEV1  6'h1c
module apb_mux2 (
    apb_ack_cpu,
    apb_rw_cpu,
    apb_psel_cpu,
    apb_enab_cpu,
    apb_addr_cpu,
    apb_datai_cpu,
    apb_datao_cpu,

    apb0_ack,
    apb0_rw,
    apb0_psel,
    apb0_enab,
    apb0_addr,
    apb0_datai,
    apb0_datao,

    apb1_ack,
    apb1_rw,
    apb1_psel,
    apb1_enab,
    apb1_addr,
    apb1_datai,
    apb1_datao,

    apb2_ack,
    apb2_rw,
    apb2_psel,
    apb2_enab,
    apb2_addr,
    apb2_datai,
    apb2_datao
);

parameter ADDR_APB = 20,
          DATA_APB = 8;

output                  apb_ack_cpu;
input                   apb_rw_cpu;
input                   apb_psel_cpu;
input                   apb_enab_cpu;
input [ADDR_APB-1:0]    apb_addr_cpu;
input [DATA_APB-1:0]    apb_datai_cpu;
output[DATA_APB-1:0]    apb_datao_cpu;

wire                  apb0_req;
input                   apb0_ack;
output                  apb0_rw;
output                  apb0_psel;
output                  apb0_enab;
output[ADDR_APB-1:0]    apb0_addr;
output[DATA_APB-1:0]    apb0_datai;
input [DATA_APB-1:0]    apb0_datao;

wire                  apb1_req;
input                   apb1_ack;
output                  apb1_rw;
output                  apb1_psel;
output                  apb1_enab;
output[ADDR_APB-1:0]    apb1_addr;
output[DATA_APB-1:0]    apb1_datai;
input [DATA_APB-1:0]    apb1_datao;

wire                  apb2_req;
input                   apb2_ack;
output                  apb2_rw;
output                  apb2_psel;
output                  apb2_enab;
output[ADDR_APB-1:0]    apb2_addr;
output[DATA_APB-1:0]    apb2_datai;
input [DATA_APB-1:0]    apb2_datao;

wire                    apb_ack; 
wire                    apb_rw;
wire                    apb_psel;
wire                    apb_enab;
wire [ADDR_APB-1:0]     apb_addr;
wire [DATA_APB-1:0]     apb_datai;
wire [DATA_APB-1:0]     apb_datao;

assign apb_addr         = apb_addr_cpu; 
assign apb_rw           = apb_rw_cpu; 
assign apb_psel         = apb_psel_cpu; 
assign apb_enab         = apb_enab_cpu; 
assign apb_datai        = apb_datai_cpu; 

assign apb_datao_cpu      = apb_datao;
assign apb_ack_cpu        = apb_ack;

wire [5:0] chk_addr = apb_addr[ADDR_APB-1:14];

assign apb0_req = (chk_addr ==`APB_DEV0) || 1'b1;
assign apb1_req = (chk_addr ==`APB_DEV1) && 1'b0;
assign apb2_req = (chk_addr ==`APB_DEV2) && 1'b0;

assign apb0_psel = apb_psel && apb0_req;
assign apb1_psel = apb_psel && apb1_req;
assign apb2_psel = apb_psel && apb2_req;

assign apb0_enab = apb_enab && apb0_req;
assign apb1_enab = apb_enab && apb1_req;
assign apb2_enab = apb_enab && apb2_req;

assign apb_ack = apb0_req ? apb0_ack : 
                 apb1_req ? apb1_ack : 
                 apb2_req ? apb2_ack : 
                 1'b0;

assign apb_datao = apb0_req ? apb0_datao : 
                   apb1_req ? apb1_datao[7:0] : 
                   apb2_req ? apb2_datao[7:0] : 
                   8'b0;


assign apb0_addr  = apb_addr;
assign apb0_datai = apb_datai;
assign apb0_rw    = apb_rw;

assign apb1_addr  = apb_addr;
assign apb1_datai = apb_datai;
assign apb1_rw    = apb_rw;

assign apb2_addr  = apb_addr;
assign apb2_datai = apb_datai;
assign apb2_rw    = apb_rw;

endmodule
