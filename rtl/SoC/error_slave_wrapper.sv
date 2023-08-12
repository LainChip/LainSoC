`include "assign.svh"
`include "typedef.svh"

module error_slave_wrapper (
  input  logic    aclk,                 // Clock
  input  logic    aresetn,                // Asynchronous reset active low
  AXI_BUS.Slave slv
);

  typedef logic [3:0]       id_t;
  typedef logic [31:0]   addr_t;
  typedef logic [31:0]   data_t;
  typedef logic [3:0] strb_t;
  typedef logic [0:0]   user_t;
  `AXI_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(b_chan_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(r_chan_t, data_t, id_t, user_t)
  `AXI_TYPEDEF_REQ_T(req_t, aw_chan_t, w_chan_t, ar_chan_t)
  `AXI_TYPEDEF_RESP_T(resp_t, b_chan_t, r_chan_t)
  
  req_t                     slv_req;
  resp_t                    slv_resp;
  
  
  `AXI_ASSIGN_TO_REQ(slv_req, slv)
  `AXI_ASSIGN_FROM_RESP(slv, slv_resp)
  
  axi_err_slv #(
      .AxiIdWidth(4),
      .req_t(req_t),
      .resp_t(resp_t),
      .ATOPs(0)
  ) err_slv (
      .clk_i(aclk),
      .rst_ni(aresetn),
      .test_i(1'b0),
      .slv_req_i(slv_req),
      .slv_resp_o(slv_resp)
  );

endmodule

