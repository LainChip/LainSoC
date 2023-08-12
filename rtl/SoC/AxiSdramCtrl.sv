// Generator : SpinalHDL v1.4.3    git head : adf552d8f500e7419fff395b7049228e4bc5de26
// Component : AxiSdramCtrl
// Git hash  : e03a66e8f94607b5b85df824187b35e3c8c2028f


`define SdramCtrlBackendTask_binary_sequential_type [2:0]
`define SdramCtrlBackendTask_binary_sequential_MODE 3'b000
`define SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL 3'b001
`define SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE 3'b010
`define SdramCtrlBackendTask_binary_sequential_REFRESH 3'b011
`define SdramCtrlBackendTask_binary_sequential_ACTIVE 3'b100
`define SdramCtrlBackendTask_binary_sequential_READ 3'b101
`define SdramCtrlBackendTask_binary_sequential_WRITE 3'b110

`define SdramCtrlFrontendState_binary_sequential_type [1:0]
`define SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE 2'b00
`define SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH 2'b01
`define SdramCtrlFrontendState_binary_sequential_BOOT_MODE 2'b10
`define SdramCtrlFrontendState_binary_sequential_RUN 2'b11


module AxiSdramCtrl (
  input               io_bus_aw_valid,
  output              io_bus_aw_ready,
  input      [31:0]   io_bus_aw_payload_addr,
  input      [5:0]    io_bus_aw_payload_id,
  input      [7:0]    io_bus_aw_payload_len,
  input      [2:0]    io_bus_aw_payload_size,
  input      [1:0]    io_bus_aw_payload_burst,
  input               io_bus_w_valid,
  output              io_bus_w_ready,
  input      [31:0]   io_bus_w_payload_data,
  input      [3:0]    io_bus_w_payload_strb,
  input               io_bus_w_payload_last,
  output              io_bus_b_valid,
  input               io_bus_b_ready,
  output     [5:0]    io_bus_b_payload_id,
  output     [1:0]    io_bus_b_payload_resp,
  input               io_bus_ar_valid,
  output              io_bus_ar_ready,
  input      [31:0]   io_bus_ar_payload_addr,
  input      [5:0]    io_bus_ar_payload_id,
  input      [7:0]    io_bus_ar_payload_len,
  input      [2:0]    io_bus_ar_payload_size,
  input      [1:0]    io_bus_ar_payload_burst,
  output              io_bus_r_valid,
  input               io_bus_r_ready,
  output     [31:0]   io_bus_r_payload_data,
  output     [5:0]    io_bus_r_payload_id,
  output     [1:0]    io_bus_r_payload_resp,
  output              io_bus_r_payload_last,
  output     [12:0]   io_sdram_ADDR,
  output     [1:0]    io_sdram_BA,
  input      [31:0]   io_sdram_DQ_read,
  output     [31:0]   io_sdram_DQ_write,
  output     [31:0]   io_sdram_DQ_writeEnable,
  output     [3:0]    io_sdram_DQM,
  output              io_sdram_CASn,
  output              io_sdram_CKE,
  output              io_sdram_CSn,
  output              io_sdram_RASn,
  output              io_sdram_WEn,
  input               clk,
  input               reset
);
  wire       [26:0]   _zz_1;
  wire                _zz_2;
  wire                sdramCtrl_1_io_axi_arw_ready;
  wire                sdramCtrl_1_io_axi_w_ready;
  wire                sdramCtrl_1_io_axi_b_valid;
  wire       [5:0]    sdramCtrl_1_io_axi_b_payload_id;
  wire       [1:0]    sdramCtrl_1_io_axi_b_payload_resp;
  wire                sdramCtrl_1_io_axi_r_valid;
  wire       [31:0]   sdramCtrl_1_io_axi_r_payload_data;
  wire       [5:0]    sdramCtrl_1_io_axi_r_payload_id;
  wire       [1:0]    sdramCtrl_1_io_axi_r_payload_resp;
  wire                sdramCtrl_1_io_axi_r_payload_last;
  wire       [12:0]   sdramCtrl_1_io_sdram_ADDR;
  wire       [1:0]    sdramCtrl_1_io_sdram_BA;
  wire                sdramCtrl_1_io_sdram_CASn;
  wire                sdramCtrl_1_io_sdram_CKE;
  wire                sdramCtrl_1_io_sdram_CSn;
  wire       [3:0]    sdramCtrl_1_io_sdram_DQM;
  wire                sdramCtrl_1_io_sdram_RASn;
  wire                sdramCtrl_1_io_sdram_WEn;
  wire       [31:0]   sdramCtrl_1_io_sdram_DQ_write;
  wire       [31:0]   sdramCtrl_1_io_sdram_DQ_writeEnable;
  wire                streamArbiter_1_io_inputs_0_ready;
  wire                streamArbiter_1_io_inputs_1_ready;
  wire                streamArbiter_1_io_output_valid;
  wire       [31:0]   streamArbiter_1_io_output_payload_addr;
  wire       [5:0]    streamArbiter_1_io_output_payload_id;
  wire       [7:0]    streamArbiter_1_io_output_payload_len;
  wire       [2:0]    streamArbiter_1_io_output_payload_size;
  wire       [1:0]    streamArbiter_1_io_output_payload_burst;
  wire       [0:0]    streamArbiter_1_io_chosen;
  wire       [1:0]    streamArbiter_1_io_chosenOH;

  Axi4SharedSdramCtrl sdramCtrl_1 (
    .io_axi_arw_valid            (streamArbiter_1_io_output_valid               ), //i
    .io_axi_arw_ready            (sdramCtrl_1_io_axi_arw_ready                  ), //o
    .io_axi_arw_payload_addr     (_zz_1[26:0]                                   ), //i
    .io_axi_arw_payload_id       (streamArbiter_1_io_output_payload_id[5:0]     ), //i
    .io_axi_arw_payload_len      (streamArbiter_1_io_output_payload_len[7:0]    ), //i
    .io_axi_arw_payload_size     (streamArbiter_1_io_output_payload_size[2:0]   ), //i
    .io_axi_arw_payload_burst    (streamArbiter_1_io_output_payload_burst[1:0]  ), //i
    .io_axi_arw_payload_write    (_zz_2                                         ), //i
    .io_axi_w_valid              (io_bus_w_valid                                ), //i
    .io_axi_w_ready              (sdramCtrl_1_io_axi_w_ready                    ), //o
    .io_axi_w_payload_data       (io_bus_w_payload_data[31:0]                   ), //i
    .io_axi_w_payload_strb       (io_bus_w_payload_strb[3:0]                    ), //i
    .io_axi_w_payload_last       (io_bus_w_payload_last                         ), //i
    .io_axi_b_valid              (sdramCtrl_1_io_axi_b_valid                    ), //o
    .io_axi_b_ready              (io_bus_b_ready                                ), //i
    .io_axi_b_payload_id         (sdramCtrl_1_io_axi_b_payload_id[5:0]          ), //o
    .io_axi_b_payload_resp       (sdramCtrl_1_io_axi_b_payload_resp[1:0]        ), //o
    .io_axi_r_valid              (sdramCtrl_1_io_axi_r_valid                    ), //o
    .io_axi_r_ready              (io_bus_r_ready                                ), //i
    .io_axi_r_payload_data       (sdramCtrl_1_io_axi_r_payload_data[31:0]       ), //o
    .io_axi_r_payload_id         (sdramCtrl_1_io_axi_r_payload_id[5:0]          ), //o
    .io_axi_r_payload_resp       (sdramCtrl_1_io_axi_r_payload_resp[1:0]        ), //o
    .io_axi_r_payload_last       (sdramCtrl_1_io_axi_r_payload_last             ), //o
    .io_sdram_ADDR               (sdramCtrl_1_io_sdram_ADDR[12:0]               ), //o
    .io_sdram_BA                 (sdramCtrl_1_io_sdram_BA[1:0]                  ), //o
    .io_sdram_DQ_read            (io_sdram_DQ_read[31:0]                        ), //i
    .io_sdram_DQ_write           (sdramCtrl_1_io_sdram_DQ_write[31:0]           ), //o
    .io_sdram_DQ_writeEnable     (sdramCtrl_1_io_sdram_DQ_writeEnable[31:0]     ), //o
    .io_sdram_DQM                (sdramCtrl_1_io_sdram_DQM[3:0]                 ), //o
    .io_sdram_CASn               (sdramCtrl_1_io_sdram_CASn                     ), //o
    .io_sdram_CKE                (sdramCtrl_1_io_sdram_CKE                      ), //o
    .io_sdram_CSn                (sdramCtrl_1_io_sdram_CSn                      ), //o
    .io_sdram_RASn               (sdramCtrl_1_io_sdram_RASn                     ), //o
    .io_sdram_WEn                (sdramCtrl_1_io_sdram_WEn                      ), //o
    .clk                         (clk                                           ), //i
    .reset                       (reset                                         )  //i
  );
  StreamArbiter streamArbiter_1 (
    .io_inputs_0_valid            (io_bus_ar_valid                               ), //i
    .io_inputs_0_ready            (streamArbiter_1_io_inputs_0_ready             ), //o
    .io_inputs_0_payload_addr     (io_bus_ar_payload_addr[31:0]                  ), //i
    .io_inputs_0_payload_id       (io_bus_ar_payload_id[5:0]                     ), //i
    .io_inputs_0_payload_len      (io_bus_ar_payload_len[7:0]                    ), //i
    .io_inputs_0_payload_size     (io_bus_ar_payload_size[2:0]                   ), //i
    .io_inputs_0_payload_burst    (io_bus_ar_payload_burst[1:0]                  ), //i
    .io_inputs_1_valid            (io_bus_aw_valid                               ), //i
    .io_inputs_1_ready            (streamArbiter_1_io_inputs_1_ready             ), //o
    .io_inputs_1_payload_addr     (io_bus_aw_payload_addr[31:0]                  ), //i
    .io_inputs_1_payload_id       (io_bus_aw_payload_id[5:0]                     ), //i
    .io_inputs_1_payload_len      (io_bus_aw_payload_len[7:0]                    ), //i
    .io_inputs_1_payload_size     (io_bus_aw_payload_size[2:0]                   ), //i
    .io_inputs_1_payload_burst    (io_bus_aw_payload_burst[1:0]                  ), //i
    .io_output_valid              (streamArbiter_1_io_output_valid               ), //o
    .io_output_ready              (sdramCtrl_1_io_axi_arw_ready                  ), //i
    .io_output_payload_addr       (streamArbiter_1_io_output_payload_addr[31:0]  ), //o
    .io_output_payload_id         (streamArbiter_1_io_output_payload_id[5:0]     ), //o
    .io_output_payload_len        (streamArbiter_1_io_output_payload_len[7:0]    ), //o
    .io_output_payload_size       (streamArbiter_1_io_output_payload_size[2:0]   ), //o
    .io_output_payload_burst      (streamArbiter_1_io_output_payload_burst[1:0]  ), //o
    .io_chosen                    (streamArbiter_1_io_chosen                     ), //o
    .io_chosenOH                  (streamArbiter_1_io_chosenOH[1:0]              ), //o
    .clk                          (clk                                           ), //i
    .reset                        (reset                                         )  //i
  );
  assign io_bus_ar_ready = streamArbiter_1_io_inputs_0_ready;
  assign io_bus_aw_ready = streamArbiter_1_io_inputs_1_ready;
  assign io_bus_w_ready = sdramCtrl_1_io_axi_w_ready;
  assign io_bus_b_valid = sdramCtrl_1_io_axi_b_valid;
  assign io_bus_b_payload_id = sdramCtrl_1_io_axi_b_payload_id;
  assign io_bus_b_payload_resp = sdramCtrl_1_io_axi_b_payload_resp;
  assign io_bus_r_valid = sdramCtrl_1_io_axi_r_valid;
  assign io_bus_r_payload_data = sdramCtrl_1_io_axi_r_payload_data;
  assign io_bus_r_payload_id = sdramCtrl_1_io_axi_r_payload_id;
  assign io_bus_r_payload_resp = sdramCtrl_1_io_axi_r_payload_resp;
  assign io_bus_r_payload_last = sdramCtrl_1_io_axi_r_payload_last;
  assign _zz_1 = streamArbiter_1_io_output_payload_addr[26:0];
  assign _zz_2 = streamArbiter_1_io_chosenOH[1];
  assign io_sdram_ADDR = sdramCtrl_1_io_sdram_ADDR;
  assign io_sdram_BA = sdramCtrl_1_io_sdram_BA;
  assign io_sdram_DQ_write = sdramCtrl_1_io_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = sdramCtrl_1_io_sdram_DQ_writeEnable;
  assign io_sdram_DQM = sdramCtrl_1_io_sdram_DQM;
  assign io_sdram_CASn = sdramCtrl_1_io_sdram_CASn;
  assign io_sdram_CKE = sdramCtrl_1_io_sdram_CKE;
  assign io_sdram_CSn = sdramCtrl_1_io_sdram_CSn;
  assign io_sdram_RASn = sdramCtrl_1_io_sdram_RASn;
  assign io_sdram_WEn = sdramCtrl_1_io_sdram_WEn;

endmodule

module StreamArbiter (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input      [31:0]   io_inputs_0_payload_addr,
  input      [5:0]    io_inputs_0_payload_id,
  input      [7:0]    io_inputs_0_payload_len,
  input      [2:0]    io_inputs_0_payload_size,
  input      [1:0]    io_inputs_0_payload_burst,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input      [31:0]   io_inputs_1_payload_addr,
  input      [5:0]    io_inputs_1_payload_id,
  input      [7:0]    io_inputs_1_payload_len,
  input      [2:0]    io_inputs_1_payload_size,
  input      [1:0]    io_inputs_1_payload_burst,
  output              io_output_valid,
  input               io_output_ready,
  output     [31:0]   io_output_payload_addr,
  output     [5:0]    io_output_payload_id,
  output     [7:0]    io_output_payload_len,
  output     [2:0]    io_output_payload_size,
  output     [1:0]    io_output_payload_burst,
  output     [0:0]    io_chosen,
  output     [1:0]    io_chosenOH,
  input               clk,
  input               reset
);
  wire       [3:0]    _zz_6;
  wire       [1:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [0:0]    _zz_10;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_1;
  wire       [3:0]    _zz_2;
  wire       [3:0]    _zz_3;
  wire       [1:0]    _zz_4;
  wire                _zz_5;

  assign _zz_6 = (_zz_2 - _zz_8);
  assign _zz_7 = {maskLocked_0,maskLocked_1};
  assign _zz_8 = {2'd0, _zz_7};
  assign _zz_9 = _zz_4[0 : 0];
  assign _zz_10 = _zz_4[1 : 1];
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2 = {_zz_1,_zz_1};
  assign _zz_3 = (_zz_2 & (~ _zz_6));
  assign _zz_4 = (_zz_3[3 : 2] | _zz_3[1 : 0]);
  assign maskProposal_0 = _zz_9[0];
  assign maskProposal_1 = _zz_10[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5 = io_chosenOH[1];
  assign io_chosen = _zz_5;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module Axi4SharedSdramCtrl (
  input               io_axi_arw_valid,
  output reg          io_axi_arw_ready,
  input      [26:0]   io_axi_arw_payload_addr,
  input      [5:0]    io_axi_arw_payload_id,
  input      [7:0]    io_axi_arw_payload_len,
  input      [2:0]    io_axi_arw_payload_size,
  input      [1:0]    io_axi_arw_payload_burst,
  input               io_axi_arw_payload_write,
  input               io_axi_w_valid,
  output              io_axi_w_ready,
  input      [31:0]   io_axi_w_payload_data,
  input      [3:0]    io_axi_w_payload_strb,
  input               io_axi_w_payload_last,
  output              io_axi_b_valid,
  input               io_axi_b_ready,
  output     [5:0]    io_axi_b_payload_id,
  output     [1:0]    io_axi_b_payload_resp,
  output              io_axi_r_valid,
  input               io_axi_r_ready,
  output     [31:0]   io_axi_r_payload_data,
  output     [5:0]    io_axi_r_payload_id,
  output     [1:0]    io_axi_r_payload_resp,
  output              io_axi_r_payload_last,
  output     [12:0]   io_sdram_ADDR,
  output     [1:0]    io_sdram_BA,
  input      [31:0]   io_sdram_DQ_read,
  output     [31:0]   io_sdram_DQ_write,
  output     [31:0]   io_sdram_DQ_writeEnable,
  output     [3:0]    io_sdram_DQM,
  output              io_sdram_CASn,
  output              io_sdram_CKE,
  output              io_sdram_CSn,
  output              io_sdram_RASn,
  output              io_sdram_WEn,
  input               clk,
  input               reset
);
  wire       [24:0]   _zz_3;
  reg        [11:0]   _zz_4;
  wire                ctrl_io_bus_cmd_ready;
  wire                ctrl_io_bus_rsp_valid;
  wire       [31:0]   ctrl_io_bus_rsp_payload_data;
  wire       [5:0]    ctrl_io_bus_rsp_payload_context_id;
  wire                ctrl_io_bus_rsp_payload_context_last;
  wire       [12:0]   ctrl_io_sdram_ADDR;
  wire       [1:0]    ctrl_io_sdram_BA;
  wire                ctrl_io_sdram_CASn;
  wire                ctrl_io_sdram_CKE;
  wire                ctrl_io_sdram_CSn;
  wire       [3:0]    ctrl_io_sdram_DQM;
  wire                ctrl_io_sdram_RASn;
  wire                ctrl_io_sdram_WEn;
  wire       [31:0]   ctrl_io_sdram_DQ_write;
  wire       [31:0]   ctrl_io_sdram_DQ_writeEnable;
  wire                _zz_5;
  wire       [1:0]    _zz_6;
  wire       [11:0]   _zz_7;
  wire       [11:0]   _zz_8;
  wire       [11:0]   _zz_9;
  wire       [2:0]    _zz_10;
  wire       [2:0]    _zz_11;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [26:0]   unburstify_result_payload_fragment_addr;
  reg        [5:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [26:0]   unburstify_buffer_transaction_addr;
  reg        [5:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [26:0]   Axi4Incr_result;
  wire       [14:0]   Axi4Incr_highCat;
  wire       [2:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_1;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                _zz_2;
  wire                bridge_axiCmd_valid;
  wire                bridge_axiCmd_ready;
  wire                bridge_axiCmd_payload_last;
  wire       [26:0]   bridge_axiCmd_payload_fragment_addr;
  wire       [5:0]    bridge_axiCmd_payload_fragment_id;
  wire       [2:0]    bridge_axiCmd_payload_fragment_size;
  wire       [1:0]    bridge_axiCmd_payload_fragment_burst;
  wire                bridge_axiCmd_payload_fragment_write;
  wire                bridge_writeRsp_valid;
  wire                bridge_writeRsp_ready;
  wire       [5:0]    bridge_writeRsp_payload_id;
  wire       [1:0]    bridge_writeRsp_payload_resp;
  wire                bridge_writeRsp_m2sPipe_valid;
  wire                bridge_writeRsp_m2sPipe_ready;
  wire       [5:0]    bridge_writeRsp_m2sPipe_payload_id;
  wire       [1:0]    bridge_writeRsp_m2sPipe_payload_resp;
  reg                 bridge_writeRsp_m2sPipe_rValid;
  reg        [5:0]    bridge_writeRsp_m2sPipe_rData_id;
  reg        [1:0]    bridge_writeRsp_m2sPipe_rData_resp;

  assign _zz_5 = (io_axi_arw_payload_len == 8'h0);
  assign _zz_6 = {(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)};
  assign _zz_7 = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_8 = _zz_7;
  assign _zz_9 = {9'd0, Axi4Incr_sizeValue};
  assign _zz_10 = {1'd0, Axi4Incr_validSize};
  assign _zz_11 = {1'd0, _zz_1};
  SdramCtrl ctrl (
    .io_bus_cmd_valid                   (bridge_axiCmd_valid                      ), //i
    .io_bus_cmd_ready                   (ctrl_io_bus_cmd_ready                    ), //o
    .io_bus_cmd_payload_address         (_zz_3[24:0]                              ), //i
    .io_bus_cmd_payload_write           (bridge_axiCmd_payload_fragment_write     ), //i
    .io_bus_cmd_payload_data            (io_axi_w_payload_data[31:0]              ), //i
    .io_bus_cmd_payload_mask            (io_axi_w_payload_strb[3:0]               ), //i
    .io_bus_cmd_payload_context_id      (bridge_axiCmd_payload_fragment_id[5:0]   ), //i
    .io_bus_cmd_payload_context_last    (bridge_axiCmd_payload_last               ), //i
    .io_bus_rsp_valid                   (ctrl_io_bus_rsp_valid                    ), //o
    .io_bus_rsp_ready                   (io_axi_r_ready                           ), //i
    .io_bus_rsp_payload_data            (ctrl_io_bus_rsp_payload_data[31:0]       ), //o
    .io_bus_rsp_payload_context_id      (ctrl_io_bus_rsp_payload_context_id[5:0]  ), //o
    .io_bus_rsp_payload_context_last    (ctrl_io_bus_rsp_payload_context_last     ), //o
    .io_sdram_ADDR                      (ctrl_io_sdram_ADDR[12:0]                 ), //o
    .io_sdram_BA                        (ctrl_io_sdram_BA[1:0]                    ), //o
    .io_sdram_DQ_read                   (io_sdram_DQ_read[31:0]                   ), //i
    .io_sdram_DQ_write                  (ctrl_io_sdram_DQ_write[31:0]             ), //o
    .io_sdram_DQ_writeEnable            (ctrl_io_sdram_DQ_writeEnable[31:0]       ), //o
    .io_sdram_DQM                       (ctrl_io_sdram_DQM[3:0]                   ), //o
    .io_sdram_CASn                      (ctrl_io_sdram_CASn                       ), //o
    .io_sdram_CKE                       (ctrl_io_sdram_CKE                        ), //o
    .io_sdram_CSn                       (ctrl_io_sdram_CSn                        ), //o
    .io_sdram_RASn                      (ctrl_io_sdram_RASn                       ), //o
    .io_sdram_WEn                       (ctrl_io_sdram_WEn                        ), //o
    .clk                                (clk                                      ), //i
    .reset                              (reset                                    )  //i
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : begin
        _zz_4 = {Axi4Incr_base[11 : 1],Axi4Incr_baseIncr[0 : 0]};
      end
      3'b001 : begin
        _zz_4 = {Axi4Incr_base[11 : 2],Axi4Incr_baseIncr[1 : 0]};
      end
      3'b010 : begin
        _zz_4 = {Axi4Incr_base[11 : 3],Axi4Incr_baseIncr[2 : 0]};
      end
      3'b011 : begin
        _zz_4 = {Axi4Incr_base[11 : 4],Axi4Incr_baseIncr[3 : 0]};
      end
      3'b100 : begin
        _zz_4 = {Axi4Incr_base[11 : 5],Axi4Incr_baseIncr[4 : 0]};
      end
      default : begin
        _zz_4 = {Axi4Incr_base[11 : 6],Axi4Incr_baseIncr[5 : 0]};
      end
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[26 : 12];
  assign Axi4Incr_sizeValue = {(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_6};
  assign Axi4Incr_base = (_zz_8 & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_9);
  always @ (*) begin
    if((((unburstify_buffer_len & 8'h08) == 8'h08))) begin
        _zz_1 = 2'b11;
    end else if((((unburstify_buffer_len & 8'h04) == 8'h04))) begin
        _zz_1 = 2'b10;
    end else if((((unburstify_buffer_len & 8'h02) == 8'h02))) begin
        _zz_1 = 2'b01;
    end else begin
        _zz_1 = 2'b00;
    end
  end

  assign Axi4Incr_wrapCase = (_zz_10 + _zz_11);
  always @ (*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = {Axi4Incr_highCat,_zz_4};
      end
      default : begin
        Axi4Incr_result = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @ (*) begin
    io_axi_arw_ready = 1'b0;
    if(! unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      if(_zz_5)begin
        unburstify_result_payload_last = 1'b1;
      end else begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign _zz_2 = (! (unburstify_result_payload_fragment_write && (! io_axi_w_valid)));
  assign bridge_axiCmd_valid = (unburstify_result_valid && _zz_2);
  assign unburstify_result_ready = (bridge_axiCmd_ready && _zz_2);
  assign bridge_axiCmd_payload_last = unburstify_result_payload_last;
  assign bridge_axiCmd_payload_fragment_addr = unburstify_result_payload_fragment_addr;
  assign bridge_axiCmd_payload_fragment_id = unburstify_result_payload_fragment_id;
  assign bridge_axiCmd_payload_fragment_size = unburstify_result_payload_fragment_size;
  assign bridge_axiCmd_payload_fragment_burst = unburstify_result_payload_fragment_burst;
  assign bridge_axiCmd_payload_fragment_write = unburstify_result_payload_fragment_write;
  assign _zz_3 = bridge_axiCmd_payload_fragment_addr[26 : 2];
  assign bridge_writeRsp_valid = (((bridge_axiCmd_valid && bridge_axiCmd_ready) && bridge_axiCmd_payload_fragment_write) && bridge_axiCmd_payload_last);
  assign bridge_writeRsp_payload_resp = 2'b00;
  assign bridge_writeRsp_payload_id = bridge_axiCmd_payload_fragment_id;
  assign bridge_writeRsp_ready = ((1'b1 && (! bridge_writeRsp_m2sPipe_valid)) || bridge_writeRsp_m2sPipe_ready);
  assign bridge_writeRsp_m2sPipe_valid = bridge_writeRsp_m2sPipe_rValid;
  assign bridge_writeRsp_m2sPipe_payload_id = bridge_writeRsp_m2sPipe_rData_id;
  assign bridge_writeRsp_m2sPipe_payload_resp = bridge_writeRsp_m2sPipe_rData_resp;
  assign io_axi_b_valid = bridge_writeRsp_m2sPipe_valid;
  assign bridge_writeRsp_m2sPipe_ready = io_axi_b_ready;
  assign io_axi_b_payload_id = bridge_writeRsp_m2sPipe_payload_id;
  assign io_axi_b_payload_resp = bridge_writeRsp_m2sPipe_payload_resp;
  assign io_axi_r_valid = ctrl_io_bus_rsp_valid;
  assign io_axi_r_payload_id = ctrl_io_bus_rsp_payload_context_id;
  assign io_axi_r_payload_data = ctrl_io_bus_rsp_payload_data;
  assign io_axi_r_payload_last = ctrl_io_bus_rsp_payload_context_last;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_w_ready = ((unburstify_result_valid && unburstify_result_payload_fragment_write) && bridge_axiCmd_ready);
  assign bridge_axiCmd_ready = (ctrl_io_bus_cmd_ready && (! (bridge_axiCmd_payload_fragment_write && (! bridge_writeRsp_ready))));
  assign io_sdram_ADDR = ctrl_io_sdram_ADDR;
  assign io_sdram_BA = ctrl_io_sdram_BA;
  assign io_sdram_DQ_write = ctrl_io_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = ctrl_io_sdram_DQ_writeEnable;
  assign io_sdram_DQM = ctrl_io_sdram_DQM;
  assign io_sdram_CASn = ctrl_io_sdram_CASn;
  assign io_sdram_CKE = ctrl_io_sdram_CKE;
  assign io_sdram_CSn = ctrl_io_sdram_CSn;
  assign io_sdram_RASn = ctrl_io_sdram_RASn;
  assign io_sdram_WEn = ctrl_io_sdram_WEn;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      unburstify_buffer_valid <= 1'b0;
      bridge_writeRsp_m2sPipe_rValid <= 1'b0;
    end else begin
      if(unburstify_result_ready)begin
        if(unburstify_buffer_last)begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(! unburstify_buffer_valid) begin
        if(! _zz_5) begin
          if(unburstify_result_ready)begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(bridge_writeRsp_ready)begin
        bridge_writeRsp_m2sPipe_rValid <= bridge_writeRsp_valid;
      end
    end
  end

  always @ (posedge clk) begin
    if(unburstify_result_ready)begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(! unburstify_buffer_valid) begin
      if(! _zz_5) begin
        if(unburstify_result_ready)begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(bridge_writeRsp_ready)begin
      bridge_writeRsp_m2sPipe_rData_id <= bridge_writeRsp_payload_id;
      bridge_writeRsp_m2sPipe_rData_resp <= bridge_writeRsp_payload_resp;
    end
  end


endmodule

module SdramCtrl (
  input               io_bus_cmd_valid,
  output reg          io_bus_cmd_ready,
  input      [24:0]   io_bus_cmd_payload_address,
  input               io_bus_cmd_payload_write,
  input      [31:0]   io_bus_cmd_payload_data,
  input      [3:0]    io_bus_cmd_payload_mask,
  input      [5:0]    io_bus_cmd_payload_context_id,
  input               io_bus_cmd_payload_context_last,
  output              io_bus_rsp_valid,
  input               io_bus_rsp_ready,
  output     [31:0]   io_bus_rsp_payload_data,
  output     [5:0]    io_bus_rsp_payload_context_id,
  output              io_bus_rsp_payload_context_last,
  output     [12:0]   io_sdram_ADDR,
  output     [1:0]    io_sdram_BA,
  input      [31:0]   io_sdram_DQ_read,
  output     [31:0]   io_sdram_DQ_write,
  output     [31:0]   io_sdram_DQ_writeEnable,
  output     [3:0]    io_sdram_DQM,
  output              io_sdram_CASn,
  output              io_sdram_CKE,
  output              io_sdram_CSn,
  output              io_sdram_RASn,
  output              io_sdram_WEn,
  input               clk,
  input               reset
);
  wire                _zz_17;
  reg                 _zz_18;
  reg        [12:0]   _zz_19;
  reg                 _zz_20;
  reg                 _zz_21;
  wire                chip_backupIn_fifo_io_push_ready;
  wire                chip_backupIn_fifo_io_pop_valid;
  wire       [31:0]   chip_backupIn_fifo_io_pop_payload_data;
  wire       [5:0]    chip_backupIn_fifo_io_pop_payload_context_id;
  wire                chip_backupIn_fifo_io_pop_payload_context_last;
  wire       [1:0]    chip_backupIn_fifo_io_occupancy;
  wire                _zz_22;
  wire                _zz_23;
  wire                _zz_24;
  wire       [0:0]    _zz_25;
  wire       [8:0]    _zz_26;
  wire       [0:0]    _zz_27;
  wire       [2:0]    _zz_28;
  wire                refresh_counter_willIncrement;
  wire                refresh_counter_willClear;
  reg        [8:0]    refresh_counter_valueNext;
  reg        [8:0]    refresh_counter_value;
  wire                refresh_counter_willOverflowIfInc;
  wire                refresh_counter_willOverflow;
  reg                 refresh_pending;
  reg        [12:0]   powerup_counter;
  reg                 powerup_done;
  wire       [12:0]   _zz_1;
  reg                 frontend_banks_0_active;
  reg        [12:0]   frontend_banks_0_row;
  reg                 frontend_banks_1_active;
  reg        [12:0]   frontend_banks_1_row;
  reg                 frontend_banks_2_active;
  reg        [12:0]   frontend_banks_2_row;
  reg                 frontend_banks_3_active;
  reg        [12:0]   frontend_banks_3_row;
  wire       [9:0]    frontend_address_column;
  wire       [1:0]    frontend_address_bank;
  wire       [12:0]   frontend_address_row;
  wire       [24:0]   _zz_2;
  reg                 frontend_rsp_valid;
  wire                frontend_rsp_ready;
  reg        `SdramCtrlBackendTask_binary_sequential_type frontend_rsp_payload_task;
  wire       [1:0]    frontend_rsp_payload_bank;
  reg        [12:0]   frontend_rsp_payload_rowColumn;
  wire       [31:0]   frontend_rsp_payload_data;
  wire       [3:0]    frontend_rsp_payload_mask;
  wire       [5:0]    frontend_rsp_payload_context_id;
  wire                frontend_rsp_payload_context_last;
  reg        `SdramCtrlFrontendState_binary_sequential_type frontend_state;
  reg                 frontend_bootRefreshCounter_willIncrement;
  wire                frontend_bootRefreshCounter_willClear;
  reg        [2:0]    frontend_bootRefreshCounter_valueNext;
  reg        [2:0]    frontend_bootRefreshCounter_value;
  wire                frontend_bootRefreshCounter_willOverflowIfInc;
  wire                frontend_bootRefreshCounter_willOverflow;
  wire                _zz_3;
  wire       [3:0]    _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire                _zz_8;
  wire                bubbleInserter_cmd_valid;
  wire                bubbleInserter_cmd_ready;
  wire       `SdramCtrlBackendTask_binary_sequential_type bubbleInserter_cmd_payload_task;
  wire       [1:0]    bubbleInserter_cmd_payload_bank;
  wire       [12:0]   bubbleInserter_cmd_payload_rowColumn;
  wire       [31:0]   bubbleInserter_cmd_payload_data;
  wire       [3:0]    bubbleInserter_cmd_payload_mask;
  wire       [5:0]    bubbleInserter_cmd_payload_context_id;
  wire                bubbleInserter_cmd_payload_context_last;
  reg                 frontend_rsp_m2sPipe_rValid;
  reg        `SdramCtrlBackendTask_binary_sequential_type frontend_rsp_m2sPipe_rData_task;
  reg        [1:0]    frontend_rsp_m2sPipe_rData_bank;
  reg        [12:0]   frontend_rsp_m2sPipe_rData_rowColumn;
  reg        [31:0]   frontend_rsp_m2sPipe_rData_data;
  reg        [3:0]    frontend_rsp_m2sPipe_rData_mask;
  reg        [5:0]    frontend_rsp_m2sPipe_rData_context_id;
  reg                 frontend_rsp_m2sPipe_rData_context_last;
  wire                bubbleInserter_rsp_valid;
  wire                bubbleInserter_rsp_ready;
  wire       `SdramCtrlBackendTask_binary_sequential_type bubbleInserter_rsp_payload_task;
  wire       [1:0]    bubbleInserter_rsp_payload_bank;
  wire       [12:0]   bubbleInserter_rsp_payload_rowColumn;
  wire       [31:0]   bubbleInserter_rsp_payload_data;
  wire       [3:0]    bubbleInserter_rsp_payload_mask;
  wire       [5:0]    bubbleInserter_rsp_payload_context_id;
  wire                bubbleInserter_rsp_payload_context_last;
  reg                 bubbleInserter_insertBubble;
  wire                _zz_9;
  wire       `SdramCtrlBackendTask_binary_sequential_type _zz_10;
  wire                bubbleInserter_timings_read_busy;
  reg        [1:0]    bubbleInserter_timings_write_counter;
  wire                bubbleInserter_timings_write_busy;
  reg        [1:0]    bubbleInserter_timings_banks_0_precharge_counter;
  wire                bubbleInserter_timings_banks_0_precharge_busy;
  reg        [1:0]    bubbleInserter_timings_banks_0_active_counter;
  wire                bubbleInserter_timings_banks_0_active_busy;
  reg        [1:0]    bubbleInserter_timings_banks_1_precharge_counter;
  wire                bubbleInserter_timings_banks_1_precharge_busy;
  reg        [1:0]    bubbleInserter_timings_banks_1_active_counter;
  wire                bubbleInserter_timings_banks_1_active_busy;
  reg        [1:0]    bubbleInserter_timings_banks_2_precharge_counter;
  wire                bubbleInserter_timings_banks_2_precharge_busy;
  reg        [1:0]    bubbleInserter_timings_banks_2_active_counter;
  wire                bubbleInserter_timings_banks_2_active_busy;
  reg        [1:0]    bubbleInserter_timings_banks_3_precharge_counter;
  wire                bubbleInserter_timings_banks_3_precharge_busy;
  reg        [1:0]    bubbleInserter_timings_banks_3_active_counter;
  wire                bubbleInserter_timings_banks_3_active_busy;
  wire                chip_cmd_valid;
  wire                chip_cmd_ready;
  wire       `SdramCtrlBackendTask_binary_sequential_type chip_cmd_payload_task;
  wire       [1:0]    chip_cmd_payload_bank;
  wire       [12:0]   chip_cmd_payload_rowColumn;
  wire       [31:0]   chip_cmd_payload_data;
  wire       [3:0]    chip_cmd_payload_mask;
  wire       [5:0]    chip_cmd_payload_context_id;
  wire                chip_cmd_payload_context_last;
  reg        [12:0]   chip_sdram_ADDR;
  reg        [1:0]    chip_sdram_BA;
  reg        [31:0]   chip_sdram_DQ_read;
  reg        [31:0]   chip_sdram_DQ_write;
  reg        [31:0]   chip_sdram_DQ_writeEnable;
  reg        [3:0]    chip_sdram_DQM;
  reg                 chip_sdram_CASn;
  reg                 chip_sdram_CKE;
  reg                 chip_sdram_CSn;
  reg                 chip_sdram_RASn;
  reg                 chip_sdram_WEn;
  wire                chip_remoteCke;
  wire                chip_readHistory_0;
  wire                chip_readHistory_1;
  wire                chip_readHistory_2;
  wire                chip_readHistory_3;
  wire                chip_readHistory_4;
  wire                _zz_11;
  reg                 _zz_12;
  reg                 _zz_13;
  reg                 _zz_14;
  reg                 _zz_15;
  reg        [5:0]    chip_cmd_payload_context_delay_1_id;
  reg                 chip_cmd_payload_context_delay_1_last;
  reg        [5:0]    chip_cmd_payload_context_delay_2_id;
  reg                 chip_cmd_payload_context_delay_2_last;
  reg        [5:0]    chip_cmd_payload_context_delay_3_id;
  reg                 chip_cmd_payload_context_delay_3_last;
  reg        [5:0]    chip_contextDelayed_id;
  reg                 chip_contextDelayed_last;
  wire                chip_sdramCkeNext;
  reg                 chip_sdramCkeInternal;
  reg                 chip_sdramCkeInternal_regNext;
  wire                _zz_16;
  wire                chip_backupIn_valid;
  wire                chip_backupIn_ready;
  wire       [31:0]   chip_backupIn_payload_data;
  wire       [5:0]    chip_backupIn_payload_context_id;
  wire                chip_backupIn_payload_context_last;
  `ifndef SYNTHESIS
  reg [127:0] frontend_rsp_payload_task_string;
  reg [111:0] frontend_state_string;
  reg [127:0] bubbleInserter_cmd_payload_task_string;
  reg [127:0] frontend_rsp_m2sPipe_rData_task_string;
  reg [127:0] bubbleInserter_rsp_payload_task_string;
  reg [127:0] _zz_10_string;
  reg [127:0] chip_cmd_payload_task_string;
  `endif


  assign _zz_22 = (((frontend_banks_0_active || frontend_banks_1_active) || frontend_banks_2_active) || frontend_banks_3_active);
  assign _zz_23 = (_zz_3 && (_zz_19 != frontend_address_row));
  assign _zz_24 = (! _zz_3);
  assign _zz_25 = refresh_counter_willIncrement;
  assign _zz_26 = {8'd0, _zz_25};
  assign _zz_27 = frontend_bootRefreshCounter_willIncrement;
  assign _zz_28 = {2'd0, _zz_27};
  StreamFifoLowLatency chip_backupIn_fifo (
    .io_push_valid                   (chip_backupIn_valid                                ), //i
    .io_push_ready                   (chip_backupIn_fifo_io_push_ready                   ), //o
    .io_push_payload_data            (chip_backupIn_payload_data[31:0]                   ), //i
    .io_push_payload_context_id      (chip_backupIn_payload_context_id[5:0]              ), //i
    .io_push_payload_context_last    (chip_backupIn_payload_context_last                 ), //i
    .io_pop_valid                    (chip_backupIn_fifo_io_pop_valid                    ), //o
    .io_pop_ready                    (io_bus_rsp_ready                                   ), //i
    .io_pop_payload_data             (chip_backupIn_fifo_io_pop_payload_data[31:0]       ), //o
    .io_pop_payload_context_id       (chip_backupIn_fifo_io_pop_payload_context_id[5:0]  ), //o
    .io_pop_payload_context_last     (chip_backupIn_fifo_io_pop_payload_context_last     ), //o
    .io_flush                        (_zz_17                                             ), //i
    .io_occupancy                    (chip_backupIn_fifo_io_occupancy[1:0]               ), //o
    .clk                             (clk                                                ), //i
    .reset                           (reset                                              )  //i
  );
  always @(*) begin
    case(frontend_address_bank)
      2'b00 : begin
        _zz_18 = frontend_banks_0_active;
        _zz_19 = frontend_banks_0_row;
      end
      2'b01 : begin
        _zz_18 = frontend_banks_1_active;
        _zz_19 = frontend_banks_1_row;
      end
      2'b10 : begin
        _zz_18 = frontend_banks_2_active;
        _zz_19 = frontend_banks_2_row;
      end
      default : begin
        _zz_18 = frontend_banks_3_active;
        _zz_19 = frontend_banks_3_row;
      end
    endcase
  end

  always @(*) begin
    case(bubbleInserter_cmd_payload_bank)
      2'b00 : begin
        _zz_20 = bubbleInserter_timings_banks_0_precharge_busy;
        _zz_21 = bubbleInserter_timings_banks_0_active_busy;
      end
      2'b01 : begin
        _zz_20 = bubbleInserter_timings_banks_1_precharge_busy;
        _zz_21 = bubbleInserter_timings_banks_1_active_busy;
      end
      2'b10 : begin
        _zz_20 = bubbleInserter_timings_banks_2_precharge_busy;
        _zz_21 = bubbleInserter_timings_banks_2_active_busy;
      end
      default : begin
        _zz_20 = bubbleInserter_timings_banks_3_precharge_busy;
        _zz_21 = bubbleInserter_timings_banks_3_active_busy;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(frontend_rsp_payload_task)
      `SdramCtrlBackendTask_binary_sequential_MODE : frontend_rsp_payload_task_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : frontend_rsp_payload_task_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : frontend_rsp_payload_task_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : frontend_rsp_payload_task_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : frontend_rsp_payload_task_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : frontend_rsp_payload_task_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : frontend_rsp_payload_task_string = "WRITE           ";
      default : frontend_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : frontend_state_string = "BOOT_PRECHARGE";
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : frontend_state_string = "BOOT_REFRESH  ";
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : frontend_state_string = "BOOT_MODE     ";
      `SdramCtrlFrontendState_binary_sequential_RUN : frontend_state_string = "RUN           ";
      default : frontend_state_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(bubbleInserter_cmd_payload_task)
      `SdramCtrlBackendTask_binary_sequential_MODE : bubbleInserter_cmd_payload_task_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : bubbleInserter_cmd_payload_task_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : bubbleInserter_cmd_payload_task_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : bubbleInserter_cmd_payload_task_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : bubbleInserter_cmd_payload_task_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : bubbleInserter_cmd_payload_task_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : bubbleInserter_cmd_payload_task_string = "WRITE           ";
      default : bubbleInserter_cmd_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(frontend_rsp_m2sPipe_rData_task)
      `SdramCtrlBackendTask_binary_sequential_MODE : frontend_rsp_m2sPipe_rData_task_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : frontend_rsp_m2sPipe_rData_task_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : frontend_rsp_m2sPipe_rData_task_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : frontend_rsp_m2sPipe_rData_task_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : frontend_rsp_m2sPipe_rData_task_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : frontend_rsp_m2sPipe_rData_task_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : frontend_rsp_m2sPipe_rData_task_string = "WRITE           ";
      default : frontend_rsp_m2sPipe_rData_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(bubbleInserter_rsp_payload_task)
      `SdramCtrlBackendTask_binary_sequential_MODE : bubbleInserter_rsp_payload_task_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : bubbleInserter_rsp_payload_task_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : bubbleInserter_rsp_payload_task_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : bubbleInserter_rsp_payload_task_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : bubbleInserter_rsp_payload_task_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : bubbleInserter_rsp_payload_task_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : bubbleInserter_rsp_payload_task_string = "WRITE           ";
      default : bubbleInserter_rsp_payload_task_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_10)
      `SdramCtrlBackendTask_binary_sequential_MODE : _zz_10_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : _zz_10_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : _zz_10_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : _zz_10_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : _zz_10_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : _zz_10_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : _zz_10_string = "WRITE           ";
      default : _zz_10_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(chip_cmd_payload_task)
      `SdramCtrlBackendTask_binary_sequential_MODE : chip_cmd_payload_task_string = "MODE            ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : chip_cmd_payload_task_string = "PRECHARGE_ALL   ";
      `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : chip_cmd_payload_task_string = "PRECHARGE_SINGLE";
      `SdramCtrlBackendTask_binary_sequential_REFRESH : chip_cmd_payload_task_string = "REFRESH         ";
      `SdramCtrlBackendTask_binary_sequential_ACTIVE : chip_cmd_payload_task_string = "ACTIVE          ";
      `SdramCtrlBackendTask_binary_sequential_READ : chip_cmd_payload_task_string = "READ            ";
      `SdramCtrlBackendTask_binary_sequential_WRITE : chip_cmd_payload_task_string = "WRITE           ";
      default : chip_cmd_payload_task_string = "????????????????";
    endcase
  end
  `endif

  assign refresh_counter_willClear = 1'b0;
  assign refresh_counter_willOverflowIfInc = (refresh_counter_value == 9'h186);
  assign refresh_counter_willOverflow = (refresh_counter_willOverflowIfInc && refresh_counter_willIncrement);
  always @ (*) begin
    if(refresh_counter_willOverflow)begin
      refresh_counter_valueNext = 9'h0;
    end else begin
      refresh_counter_valueNext = (refresh_counter_value + _zz_26);
    end
    if(refresh_counter_willClear)begin
      refresh_counter_valueNext = 9'h0;
    end
  end

  assign refresh_counter_willIncrement = 1'b1;
  assign _zz_1[12 : 0] = 13'h1fff;
  assign _zz_2 = io_bus_cmd_payload_address;
  assign frontend_address_column = _zz_2[9 : 0];
  assign frontend_address_bank = _zz_2[11 : 10];
  assign frontend_address_row = _zz_2[24 : 12];
  always @ (*) begin
    frontend_rsp_valid = 1'b0;
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
        if(powerup_done)begin
          frontend_rsp_valid = 1'b1;
        end
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
        frontend_rsp_valid = 1'b1;
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
        frontend_rsp_valid = 1'b1;
      end
      default : begin
        if(refresh_pending)begin
          frontend_rsp_valid = 1'b1;
        end else begin
          if(io_bus_cmd_valid)begin
            frontend_rsp_valid = 1'b1;
          end
        end
      end
    endcase
  end

  always @ (*) begin
    frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_REFRESH;
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
        frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL;
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
        frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_REFRESH;
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
        frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_MODE;
      end
      default : begin
        if(refresh_pending)begin
          if(_zz_22)begin
            frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL;
          end else begin
            frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_REFRESH;
          end
        end else begin
          if(io_bus_cmd_valid)begin
            if(_zz_23)begin
              frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE;
            end else begin
              if(_zz_24)begin
                frontend_rsp_payload_task = `SdramCtrlBackendTask_binary_sequential_ACTIVE;
              end else begin
                frontend_rsp_payload_task = (io_bus_cmd_payload_write ? `SdramCtrlBackendTask_binary_sequential_WRITE : `SdramCtrlBackendTask_binary_sequential_READ);
              end
            end
          end
        end
      end
    endcase
  end

  assign frontend_rsp_payload_bank = frontend_address_bank;
  always @ (*) begin
    frontend_rsp_payload_rowColumn = frontend_address_row;
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
      end
      default : begin
        if(! refresh_pending) begin
          if(io_bus_cmd_valid)begin
            if(! _zz_23) begin
              if(! _zz_24) begin
                frontend_rsp_payload_rowColumn = {3'd0, frontend_address_column};
              end
            end
          end
        end
      end
    endcase
  end

  assign frontend_rsp_payload_data = io_bus_cmd_payload_data;
  assign frontend_rsp_payload_mask = io_bus_cmd_payload_mask;
  assign frontend_rsp_payload_context_id = io_bus_cmd_payload_context_id;
  assign frontend_rsp_payload_context_last = io_bus_cmd_payload_context_last;
  always @ (*) begin
    io_bus_cmd_ready = 1'b0;
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
      end
      default : begin
        if(! refresh_pending) begin
          if(io_bus_cmd_valid)begin
            if(! _zz_23) begin
              if(! _zz_24) begin
                io_bus_cmd_ready = frontend_rsp_ready;
              end
            end
          end
        end
      end
    endcase
  end

  always @ (*) begin
    frontend_bootRefreshCounter_willIncrement = 1'b0;
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
        if(frontend_rsp_ready)begin
          frontend_bootRefreshCounter_willIncrement = 1'b1;
        end
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
      end
      default : begin
      end
    endcase
  end

  assign frontend_bootRefreshCounter_willClear = 1'b0;
  assign frontend_bootRefreshCounter_willOverflowIfInc = (frontend_bootRefreshCounter_value == 3'b111);
  assign frontend_bootRefreshCounter_willOverflow = (frontend_bootRefreshCounter_willOverflowIfInc && frontend_bootRefreshCounter_willIncrement);
  always @ (*) begin
    frontend_bootRefreshCounter_valueNext = (frontend_bootRefreshCounter_value + _zz_28);
    if(frontend_bootRefreshCounter_willClear)begin
      frontend_bootRefreshCounter_valueNext = 3'b000;
    end
  end

  assign _zz_3 = _zz_18;
  assign _zz_4 = ({3'd0,1'b1} <<< frontend_address_bank);
  assign _zz_5 = _zz_4[0];
  assign _zz_6 = _zz_4[1];
  assign _zz_7 = _zz_4[2];
  assign _zz_8 = _zz_4[3];
  assign frontend_rsp_ready = ((1'b1 && (! bubbleInserter_cmd_valid)) || bubbleInserter_cmd_ready);
  assign bubbleInserter_cmd_valid = frontend_rsp_m2sPipe_rValid;
  assign bubbleInserter_cmd_payload_task = frontend_rsp_m2sPipe_rData_task;
  assign bubbleInserter_cmd_payload_bank = frontend_rsp_m2sPipe_rData_bank;
  assign bubbleInserter_cmd_payload_rowColumn = frontend_rsp_m2sPipe_rData_rowColumn;
  assign bubbleInserter_cmd_payload_data = frontend_rsp_m2sPipe_rData_data;
  assign bubbleInserter_cmd_payload_mask = frontend_rsp_m2sPipe_rData_mask;
  assign bubbleInserter_cmd_payload_context_id = frontend_rsp_m2sPipe_rData_context_id;
  assign bubbleInserter_cmd_payload_context_last = frontend_rsp_m2sPipe_rData_context_last;
  always @ (*) begin
    bubbleInserter_insertBubble = 1'b0;
    if(bubbleInserter_cmd_valid)begin
      case(bubbleInserter_cmd_payload_task)
        `SdramCtrlBackendTask_binary_sequential_MODE : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_banks_0_active_busy;
        end
        `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : begin
          bubbleInserter_insertBubble = ({bubbleInserter_timings_banks_3_precharge_busy,{bubbleInserter_timings_banks_2_precharge_busy,{bubbleInserter_timings_banks_1_precharge_busy,bubbleInserter_timings_banks_0_precharge_busy}}} != 4'b0000);
        end
        `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : begin
          bubbleInserter_insertBubble = _zz_20;
        end
        `SdramCtrlBackendTask_binary_sequential_REFRESH : begin
          bubbleInserter_insertBubble = ({bubbleInserter_timings_banks_3_active_busy,{bubbleInserter_timings_banks_2_active_busy,{bubbleInserter_timings_banks_1_active_busy,bubbleInserter_timings_banks_0_active_busy}}} != 4'b0000);
        end
        `SdramCtrlBackendTask_binary_sequential_ACTIVE : begin
          bubbleInserter_insertBubble = _zz_21;
        end
        `SdramCtrlBackendTask_binary_sequential_READ : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_read_busy;
        end
        default : begin
          bubbleInserter_insertBubble = bubbleInserter_timings_write_busy;
        end
      endcase
    end
  end

  assign _zz_9 = (! bubbleInserter_insertBubble);
  assign bubbleInserter_cmd_ready = (bubbleInserter_rsp_ready && _zz_9);
  assign _zz_10 = bubbleInserter_cmd_payload_task;
  assign bubbleInserter_rsp_valid = (bubbleInserter_cmd_valid && _zz_9);
  assign bubbleInserter_rsp_payload_task = _zz_10;
  assign bubbleInserter_rsp_payload_bank = bubbleInserter_cmd_payload_bank;
  assign bubbleInserter_rsp_payload_rowColumn = bubbleInserter_cmd_payload_rowColumn;
  assign bubbleInserter_rsp_payload_data = bubbleInserter_cmd_payload_data;
  assign bubbleInserter_rsp_payload_mask = bubbleInserter_cmd_payload_mask;
  assign bubbleInserter_rsp_payload_context_id = bubbleInserter_cmd_payload_context_id;
  assign bubbleInserter_rsp_payload_context_last = bubbleInserter_cmd_payload_context_last;
  assign bubbleInserter_timings_read_busy = 1'b0;
  assign bubbleInserter_timings_write_busy = (bubbleInserter_timings_write_counter != 2'b00);
  assign bubbleInserter_timings_banks_0_precharge_busy = (bubbleInserter_timings_banks_0_precharge_counter != 2'b00);
  assign bubbleInserter_timings_banks_0_active_busy = (bubbleInserter_timings_banks_0_active_counter != 2'b00);
  assign bubbleInserter_timings_banks_1_precharge_busy = (bubbleInserter_timings_banks_1_precharge_counter != 2'b00);
  assign bubbleInserter_timings_banks_1_active_busy = (bubbleInserter_timings_banks_1_active_counter != 2'b00);
  assign bubbleInserter_timings_banks_2_precharge_busy = (bubbleInserter_timings_banks_2_precharge_counter != 2'b00);
  assign bubbleInserter_timings_banks_2_active_busy = (bubbleInserter_timings_banks_2_active_counter != 2'b00);
  assign bubbleInserter_timings_banks_3_precharge_busy = (bubbleInserter_timings_banks_3_precharge_counter != 2'b00);
  assign bubbleInserter_timings_banks_3_active_busy = (bubbleInserter_timings_banks_3_active_counter != 2'b00);
  assign chip_cmd_valid = bubbleInserter_rsp_valid;
  assign bubbleInserter_rsp_ready = chip_cmd_ready;
  assign chip_cmd_payload_task = bubbleInserter_rsp_payload_task;
  assign chip_cmd_payload_bank = bubbleInserter_rsp_payload_bank;
  assign chip_cmd_payload_rowColumn = bubbleInserter_rsp_payload_rowColumn;
  assign chip_cmd_payload_data = bubbleInserter_rsp_payload_data;
  assign chip_cmd_payload_mask = bubbleInserter_rsp_payload_mask;
  assign chip_cmd_payload_context_id = bubbleInserter_rsp_payload_context_id;
  assign chip_cmd_payload_context_last = bubbleInserter_rsp_payload_context_last;
  assign io_sdram_ADDR = chip_sdram_ADDR;
  assign io_sdram_BA = chip_sdram_BA;
  assign io_sdram_DQ_write = chip_sdram_DQ_write;
  assign io_sdram_DQ_writeEnable = chip_sdram_DQ_writeEnable;
  assign io_sdram_DQM = chip_sdram_DQM;
  assign io_sdram_CASn = chip_sdram_CASn;
  assign io_sdram_CKE = chip_sdram_CKE;
  assign io_sdram_CSn = chip_sdram_CSn;
  assign io_sdram_RASn = chip_sdram_RASn;
  assign io_sdram_WEn = chip_sdram_WEn;
  assign _zz_11 = (chip_cmd_valid && ((chip_cmd_payload_task == `SdramCtrlBackendTask_binary_sequential_READ) || 1'b0));
  assign chip_readHistory_0 = _zz_11;
  assign chip_readHistory_1 = _zz_12;
  assign chip_readHistory_2 = _zz_13;
  assign chip_readHistory_3 = _zz_14;
  assign chip_readHistory_4 = _zz_15;
  assign chip_sdramCkeNext = (! (({chip_readHistory_4,{chip_readHistory_3,{chip_readHistory_2,{chip_readHistory_1,chip_readHistory_0}}}} != 5'h0) && (! io_bus_rsp_ready)));
  assign chip_remoteCke = chip_sdramCkeInternal_regNext;
  assign _zz_16 = (! chip_readHistory_0);
  assign chip_backupIn_valid = (chip_readHistory_4 && chip_remoteCke);
  assign chip_backupIn_payload_data = chip_sdram_DQ_read;
  assign chip_backupIn_payload_context_id = chip_contextDelayed_id;
  assign chip_backupIn_payload_context_last = chip_contextDelayed_last;
  assign chip_backupIn_ready = chip_backupIn_fifo_io_push_ready;
  assign io_bus_rsp_valid = chip_backupIn_fifo_io_pop_valid;
  assign io_bus_rsp_payload_data = chip_backupIn_fifo_io_pop_payload_data;
  assign io_bus_rsp_payload_context_id = chip_backupIn_fifo_io_pop_payload_context_id;
  assign io_bus_rsp_payload_context_last = chip_backupIn_fifo_io_pop_payload_context_last;
  assign chip_cmd_ready = chip_remoteCke;
  assign _zz_17 = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      refresh_counter_value <= 9'h0;
      refresh_pending <= 1'b0;
      powerup_counter <= 13'h0;
      powerup_done <= 1'b0;
      frontend_banks_0_active <= 1'b0;
      frontend_banks_1_active <= 1'b0;
      frontend_banks_2_active <= 1'b0;
      frontend_banks_3_active <= 1'b0;
      frontend_state <= `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE;
      frontend_bootRefreshCounter_value <= 3'b000;
      frontend_rsp_m2sPipe_rValid <= 1'b0;
      bubbleInserter_timings_write_counter <= 2'b00;
      bubbleInserter_timings_banks_0_precharge_counter <= 2'b00;
      bubbleInserter_timings_banks_0_active_counter <= 2'b00;
      bubbleInserter_timings_banks_1_precharge_counter <= 2'b00;
      bubbleInserter_timings_banks_1_active_counter <= 2'b00;
      bubbleInserter_timings_banks_2_precharge_counter <= 2'b00;
      bubbleInserter_timings_banks_2_active_counter <= 2'b00;
      bubbleInserter_timings_banks_3_precharge_counter <= 2'b00;
      bubbleInserter_timings_banks_3_active_counter <= 2'b00;
      _zz_12 <= 1'b0;
      _zz_13 <= 1'b0;
      _zz_14 <= 1'b0;
      _zz_15 <= 1'b0;
      chip_sdramCkeInternal <= 1'b1;
      chip_sdramCkeInternal_regNext <= 1'b1;
    end else begin
      refresh_counter_value <= refresh_counter_valueNext;
      if(refresh_counter_willOverflow)begin
        refresh_pending <= 1'b1;
      end
      if((! powerup_done))begin
        powerup_counter <= (powerup_counter + 13'h0001);
        if((powerup_counter == _zz_1))begin
          powerup_done <= 1'b1;
        end
      end
      frontend_bootRefreshCounter_value <= frontend_bootRefreshCounter_valueNext;
      case(frontend_state)
        `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
          if(powerup_done)begin
            if(frontend_rsp_ready)begin
              frontend_state <= `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH;
            end
          end
        end
        `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
          if(frontend_rsp_ready)begin
            if(frontend_bootRefreshCounter_willOverflowIfInc)begin
              frontend_state <= `SdramCtrlFrontendState_binary_sequential_BOOT_MODE;
            end
          end
        end
        `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
          if(frontend_rsp_ready)begin
            frontend_state <= `SdramCtrlFrontendState_binary_sequential_RUN;
          end
        end
        default : begin
          if(refresh_pending)begin
            if(_zz_22)begin
              if(frontend_rsp_ready)begin
                frontend_banks_0_active <= 1'b0;
                frontend_banks_1_active <= 1'b0;
                frontend_banks_2_active <= 1'b0;
                frontend_banks_3_active <= 1'b0;
              end
            end else begin
              if(frontend_rsp_ready)begin
                refresh_pending <= 1'b0;
              end
            end
          end else begin
            if(io_bus_cmd_valid)begin
              if(_zz_23)begin
                if(frontend_rsp_ready)begin
                  if(_zz_5)begin
                    frontend_banks_0_active <= 1'b0;
                  end
                  if(_zz_6)begin
                    frontend_banks_1_active <= 1'b0;
                  end
                  if(_zz_7)begin
                    frontend_banks_2_active <= 1'b0;
                  end
                  if(_zz_8)begin
                    frontend_banks_3_active <= 1'b0;
                  end
                end
              end else begin
                if(_zz_24)begin
                  if(frontend_rsp_ready)begin
                    if(_zz_5)begin
                      frontend_banks_0_active <= 1'b1;
                    end
                    if(_zz_6)begin
                      frontend_banks_1_active <= 1'b1;
                    end
                    if(_zz_7)begin
                      frontend_banks_2_active <= 1'b1;
                    end
                    if(_zz_8)begin
                      frontend_banks_3_active <= 1'b1;
                    end
                  end
                end
              end
            end
          end
        end
      endcase
      if(frontend_rsp_ready)begin
        frontend_rsp_m2sPipe_rValid <= frontend_rsp_valid;
      end
      if((bubbleInserter_timings_write_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_write_counter <= (bubbleInserter_timings_write_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_0_precharge_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_0_precharge_counter <= (bubbleInserter_timings_banks_0_precharge_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_0_active_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_0_active_counter <= (bubbleInserter_timings_banks_0_active_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_1_precharge_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_1_precharge_counter <= (bubbleInserter_timings_banks_1_precharge_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_1_active_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_1_active_counter <= (bubbleInserter_timings_banks_1_active_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_2_precharge_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_2_precharge_counter <= (bubbleInserter_timings_banks_2_precharge_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_2_active_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_2_active_counter <= (bubbleInserter_timings_banks_2_active_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_3_precharge_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_3_precharge_counter <= (bubbleInserter_timings_banks_3_precharge_counter - 2'b01);
      end
      if((bubbleInserter_timings_banks_3_active_busy && bubbleInserter_rsp_ready))begin
        bubbleInserter_timings_banks_3_active_counter <= (bubbleInserter_timings_banks_3_active_counter - 2'b01);
      end
      if(bubbleInserter_cmd_valid)begin
        case(bubbleInserter_cmd_payload_task)
          `SdramCtrlBackendTask_binary_sequential_MODE : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_timings_banks_0_active_counter <= 2'b01))begin
                bubbleInserter_timings_banks_0_active_counter <= 2'b01;
              end
              if((bubbleInserter_timings_banks_1_active_counter <= 2'b01))begin
                bubbleInserter_timings_banks_1_active_counter <= 2'b01;
              end
              if((bubbleInserter_timings_banks_2_active_counter <= 2'b01))begin
                bubbleInserter_timings_banks_2_active_counter <= 2'b01;
              end
              if((bubbleInserter_timings_banks_3_active_counter <= 2'b01))begin
                bubbleInserter_timings_banks_3_active_counter <= 2'b01;
              end
            end
          end
          `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_timings_banks_0_active_counter <= 2'b00))begin
                bubbleInserter_timings_banks_0_active_counter <= 2'b00;
              end
            end
          end
          `SdramCtrlBackendTask_binary_sequential_PRECHARGE_SINGLE : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_cmd_payload_bank == 2'b00))begin
                if((bubbleInserter_timings_banks_0_active_counter <= 2'b00))begin
                  bubbleInserter_timings_banks_0_active_counter <= 2'b00;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b01))begin
                if((bubbleInserter_timings_banks_1_active_counter <= 2'b00))begin
                  bubbleInserter_timings_banks_1_active_counter <= 2'b00;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b10))begin
                if((bubbleInserter_timings_banks_2_active_counter <= 2'b00))begin
                  bubbleInserter_timings_banks_2_active_counter <= 2'b00;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b11))begin
                if((bubbleInserter_timings_banks_3_active_counter <= 2'b00))begin
                  bubbleInserter_timings_banks_3_active_counter <= 2'b00;
                end
              end
            end
          end
          `SdramCtrlBackendTask_binary_sequential_REFRESH : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_timings_banks_0_active_counter <= 2'b11))begin
                bubbleInserter_timings_banks_0_active_counter <= 2'b11;
              end
              if((bubbleInserter_timings_banks_1_active_counter <= 2'b11))begin
                bubbleInserter_timings_banks_1_active_counter <= 2'b11;
              end
              if((bubbleInserter_timings_banks_2_active_counter <= 2'b11))begin
                bubbleInserter_timings_banks_2_active_counter <= 2'b11;
              end
              if((bubbleInserter_timings_banks_3_active_counter <= 2'b11))begin
                bubbleInserter_timings_banks_3_active_counter <= 2'b11;
              end
            end
          end
          `SdramCtrlBackendTask_binary_sequential_ACTIVE : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_timings_write_counter <= 2'b00))begin
                bubbleInserter_timings_write_counter <= 2'b00;
              end
              if((bubbleInserter_cmd_payload_bank == 2'b00))begin
                if((bubbleInserter_timings_banks_0_precharge_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_0_precharge_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b01))begin
                if((bubbleInserter_timings_banks_1_precharge_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_1_precharge_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b10))begin
                if((bubbleInserter_timings_banks_2_precharge_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_2_precharge_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b11))begin
                if((bubbleInserter_timings_banks_3_precharge_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_3_precharge_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b00))begin
                if((bubbleInserter_timings_banks_0_active_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_0_active_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b01))begin
                if((bubbleInserter_timings_banks_1_active_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_1_active_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b10))begin
                if((bubbleInserter_timings_banks_2_active_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_2_active_counter <= 2'b10;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b11))begin
                if((bubbleInserter_timings_banks_3_active_counter <= 2'b10))begin
                  bubbleInserter_timings_banks_3_active_counter <= 2'b10;
                end
              end
            end
          end
          `SdramCtrlBackendTask_binary_sequential_READ : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_timings_write_counter <= 2'b11))begin
                bubbleInserter_timings_write_counter <= 2'b11;
              end
            end
          end
          default : begin
            if(bubbleInserter_cmd_ready)begin
              if((bubbleInserter_cmd_payload_bank == 2'b00))begin
                if((bubbleInserter_timings_banks_0_precharge_counter <= 2'b01))begin
                  bubbleInserter_timings_banks_0_precharge_counter <= 2'b01;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b01))begin
                if((bubbleInserter_timings_banks_1_precharge_counter <= 2'b01))begin
                  bubbleInserter_timings_banks_1_precharge_counter <= 2'b01;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b10))begin
                if((bubbleInserter_timings_banks_2_precharge_counter <= 2'b01))begin
                  bubbleInserter_timings_banks_2_precharge_counter <= 2'b01;
                end
              end
              if((bubbleInserter_cmd_payload_bank == 2'b11))begin
                if((bubbleInserter_timings_banks_3_precharge_counter <= 2'b01))begin
                  bubbleInserter_timings_banks_3_precharge_counter <= 2'b01;
                end
              end
            end
          end
        endcase
      end
      if(chip_remoteCke)begin
        _zz_12 <= _zz_11;
      end
      if(chip_remoteCke)begin
        _zz_13 <= _zz_12;
      end
      if(chip_remoteCke)begin
        _zz_14 <= _zz_13;
      end
      if(chip_remoteCke)begin
        _zz_15 <= _zz_14;
      end
      chip_sdramCkeInternal <= chip_sdramCkeNext;
      chip_sdramCkeInternal_regNext <= chip_sdramCkeInternal;
    end
  end

  always @ (posedge clk) begin
    case(frontend_state)
      `SdramCtrlFrontendState_binary_sequential_BOOT_PRECHARGE : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_REFRESH : begin
      end
      `SdramCtrlFrontendState_binary_sequential_BOOT_MODE : begin
      end
      default : begin
        if(! refresh_pending) begin
          if(io_bus_cmd_valid)begin
            if(! _zz_23) begin
              if(_zz_24)begin
                if(_zz_5)begin
                  frontend_banks_0_row <= frontend_address_row;
                end
                if(_zz_6)begin
                  frontend_banks_1_row <= frontend_address_row;
                end
                if(_zz_7)begin
                  frontend_banks_2_row <= frontend_address_row;
                end
                if(_zz_8)begin
                  frontend_banks_3_row <= frontend_address_row;
                end
              end
            end
          end
        end
      end
    endcase
    if(frontend_rsp_ready)begin
      frontend_rsp_m2sPipe_rData_task <= frontend_rsp_payload_task;
      frontend_rsp_m2sPipe_rData_bank <= frontend_rsp_payload_bank;
      frontend_rsp_m2sPipe_rData_rowColumn <= frontend_rsp_payload_rowColumn;
      frontend_rsp_m2sPipe_rData_data <= frontend_rsp_payload_data;
      frontend_rsp_m2sPipe_rData_mask <= frontend_rsp_payload_mask;
      frontend_rsp_m2sPipe_rData_context_id <= frontend_rsp_payload_context_id;
      frontend_rsp_m2sPipe_rData_context_last <= frontend_rsp_payload_context_last;
    end
    if(chip_remoteCke)begin
      chip_cmd_payload_context_delay_1_id <= chip_cmd_payload_context_id;
      chip_cmd_payload_context_delay_1_last <= chip_cmd_payload_context_last;
    end
    if(chip_remoteCke)begin
      chip_cmd_payload_context_delay_2_id <= chip_cmd_payload_context_delay_1_id;
      chip_cmd_payload_context_delay_2_last <= chip_cmd_payload_context_delay_1_last;
    end
    if(chip_remoteCke)begin
      chip_cmd_payload_context_delay_3_id <= chip_cmd_payload_context_delay_2_id;
      chip_cmd_payload_context_delay_3_last <= chip_cmd_payload_context_delay_2_last;
    end
    if(chip_remoteCke)begin
      chip_contextDelayed_id <= chip_cmd_payload_context_delay_3_id;
      chip_contextDelayed_last <= chip_cmd_payload_context_delay_3_last;
    end
    chip_sdram_CKE <= chip_sdramCkeNext;
    if(chip_remoteCke)begin
      chip_sdram_DQ_read <= io_sdram_DQ_read;
      chip_sdram_CSn <= 1'b0;
      chip_sdram_RASn <= 1'b1;
      chip_sdram_CASn <= 1'b1;
      chip_sdram_WEn <= 1'b1;
      chip_sdram_DQ_write <= chip_cmd_payload_data;
      chip_sdram_DQ_writeEnable <= 32'h0;
      chip_sdram_DQM[0] <= _zz_16;
      chip_sdram_DQM[1] <= _zz_16;
      chip_sdram_DQM[2] <= _zz_16;
      chip_sdram_DQM[3] <= _zz_16;
      if(chip_cmd_valid)begin
        case(chip_cmd_payload_task)
          `SdramCtrlBackendTask_binary_sequential_PRECHARGE_ALL : begin
            chip_sdram_ADDR[10] <= 1'b1;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b0;
          end
          `SdramCtrlBackendTask_binary_sequential_REFRESH : begin
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b1;
          end
          `SdramCtrlBackendTask_binary_sequential_MODE : begin
            chip_sdram_ADDR <= 13'h0;
            chip_sdram_ADDR[2 : 0] <= 3'b000;
            chip_sdram_ADDR[3] <= 1'b0;
            chip_sdram_ADDR[6 : 4] <= 3'b010;
            chip_sdram_ADDR[8 : 7] <= 2'b00;
            chip_sdram_ADDR[9] <= 1'b0;
            chip_sdram_BA <= 2'b00;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b0;
          end
          `SdramCtrlBackendTask_binary_sequential_ACTIVE : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b1;
          end
          `SdramCtrlBackendTask_binary_sequential_WRITE : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_DQ_writeEnable <= 32'hffffffff;
            chip_sdram_DQ_write <= chip_cmd_payload_data;
            chip_sdram_DQM <= (~ chip_cmd_payload_mask);
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b1;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b0;
          end
          `SdramCtrlBackendTask_binary_sequential_READ : begin
            chip_sdram_ADDR <= chip_cmd_payload_rowColumn;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b1;
            chip_sdram_CASn <= 1'b0;
            chip_sdram_WEn <= 1'b1;
          end
          default : begin
            chip_sdram_BA <= chip_cmd_payload_bank;
            chip_sdram_ADDR[10] <= 1'b0;
            chip_sdram_CSn <= 1'b0;
            chip_sdram_RASn <= 1'b0;
            chip_sdram_CASn <= 1'b1;
            chip_sdram_WEn <= 1'b0;
          end
        endcase
      end
    end
  end


endmodule

module StreamFifoLowLatency (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_data,
  input      [5:0]    io_push_payload_context_id,
  input               io_push_payload_context_last,
  output reg          io_pop_valid,
  input               io_pop_ready,
  output reg [31:0]   io_pop_payload_data,
  output reg [5:0]    io_pop_payload_context_id,
  output reg          io_pop_payload_context_last,
  input               io_flush,
  output     [1:0]    io_occupancy,
  input               clk,
  input               reset
);
  wire       [38:0]   _zz_4;
  wire                _zz_5;
  wire       [0:0]    _zz_6;
  wire       [38:0]   _zz_7;
  reg                 _zz_1;
  reg                 pushPtr_willIncrement;
  reg                 pushPtr_willClear;
  reg        [0:0]    pushPtr_valueNext;
  reg        [0:0]    pushPtr_value;
  wire                pushPtr_willOverflowIfInc;
  wire                pushPtr_willOverflow;
  reg                 popPtr_willIncrement;
  reg                 popPtr_willClear;
  reg        [0:0]    popPtr_valueNext;
  reg        [0:0]    popPtr_value;
  wire                popPtr_willOverflowIfInc;
  wire                popPtr_willOverflow;
  wire                ptrMatch;
  reg                 risingOccupancy;
  wire                empty;
  wire                full;
  wire                pushing;
  wire                popping;
  wire       [38:0]   _zz_2;
  wire       [6:0]    _zz_3;
  wire       [0:0]    ptrDif;
  (* ram_style = "distributed" *) reg [38:0] ram [0:1];

  assign _zz_5 = (! empty);
  assign _zz_6 = _zz_3[6 : 6];
  assign _zz_7 = {{io_push_payload_context_last,io_push_payload_context_id},io_push_payload_data};
  assign _zz_4 = ram[popPtr_value];
  always @ (posedge clk) begin
    if(_zz_1) begin
      ram[pushPtr_value] <= _zz_7;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = (pushPtr_value == 1'b1);
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @ (*) begin
    pushPtr_valueNext = (pushPtr_value + pushPtr_willIncrement);
    if(pushPtr_willClear)begin
      pushPtr_valueNext = 1'b0;
    end
  end

  always @ (*) begin
    popPtr_willIncrement = 1'b0;
    if(popping)begin
      popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      popPtr_willClear = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = (popPtr_value == 1'b1);
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  always @ (*) begin
    popPtr_valueNext = (popPtr_value + popPtr_willIncrement);
    if(popPtr_willClear)begin
      popPtr_valueNext = 1'b0;
    end
  end

  assign ptrMatch = (pushPtr_value == popPtr_value);
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  always @ (*) begin
    if(_zz_5)begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  assign _zz_2 = _zz_4;
  assign _zz_3 = _zz_2[38 : 32];
  always @ (*) begin
    if(_zz_5)begin
      io_pop_payload_data = _zz_2[31 : 0];
    end else begin
      io_pop_payload_data = io_push_payload_data;
    end
  end

  always @ (*) begin
    if(_zz_5)begin
      io_pop_payload_context_id = _zz_3[5 : 0];
    end else begin
      io_pop_payload_context_id = io_push_payload_context_id;
    end
  end

  always @ (*) begin
    if(_zz_5)begin
      io_pop_payload_context_last = _zz_6[0];
    end else begin
      io_pop_payload_context_last = io_push_payload_context_last;
    end
  end

  assign ptrDif = (pushPtr_value - popPtr_value);
  assign io_occupancy = {(risingOccupancy && ptrMatch),ptrDif};
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      pushPtr_value <= 1'b0;
      popPtr_value <= 1'b0;
      risingOccupancy <= 1'b0;
    end else begin
      pushPtr_value <= pushPtr_valueNext;
      popPtr_value <= popPtr_valueNext;
      if((pushing != popping))begin
        risingOccupancy <= pushing;
      end
      if(io_flush)begin
        risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
