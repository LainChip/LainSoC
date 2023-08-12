// -------------------------------------------------------------------------------------------------------------------
// Macro definitions.  Only to be used by xpm_cdc_* modules.
// -------------------------------------------------------------------------------------------------------------------

// Define Xilinx Synchronous Register.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREG(clk, reset_p, q, d, rstval)   \
  always @(posedge clk) begin                    \
    if (reset_p == 1'b1)                         \
      q <= rstval;                               \
    else                                         \
      q <= d;                                    \
  end

// Define Xilinx Synchronous Register with Enable.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREGEN(clk, reset_p, q, d, en, rstval)   \
  always @(posedge clk) begin                          \
    if (reset_p == 1'b1)                               \
      q <= rstval;                                     \
    else                                               \
      if (en == 1'b1)                                  \
        q <= d;                                        \
  end

// Define Xilinx Asynchronous Register. Only to be used by xpm_cdc_* modules.
`define XPM_XARREG(clk, reset_p, q, d, rstval)   \
  always @(posedge clk or posedge reset_p)       \
  begin                                          \
    if (reset_p == 1'b1)                         \
      q <= rstval;                               \
    else                                         \
      q <= d;                                    \
  end

//==================================================================================================================

  // Define Xilinx Synchronous Register.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREG_INIT(clk, reset_p, q, d, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted) begin                                                  \
    if (gsr_asserted)                                                           \
      force q = gsr_init_val;                                                   \
    else                                                                        \
      release q;                                                                \
  end                                                                           \
                                                                                \
  always @(posedge clk) begin                                                   \
    if (reset_p == 1'b1)                                                        \
      q <= rstval;                                                              \
    else                                                                        \
      q <= d;                                                                   \
  end

// Define Xilinx Synchronous Register with Enable.  Only to be used by xpm_cdc_* modules.
`define XPM_XSRREGEN_INIT(clk, reset_p, q, d, en, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted) begin                                                        \
    if (gsr_asserted)                                                                 \
      force q = gsr_init_val;                                                         \
    else                                                                              \
      release q;                                                                      \
  end                                                                                 \
                                                                                      \
  always @(posedge clk) begin                                                         \
    if (reset_p == 1'b1)                                                              \
      q <= rstval;                                                                    \
    else                                                                              \
      if (en == 1'b1)                                                                 \
        q <= d;                                                                       \
  end

// Define Xilinx Asynchronous Register. Only to be used by xpm_cdc_* modules.
`define XPM_XARREG_INIT(clk, reset_p, q, d, rstval, gsr_asserted, gsr_init_val) \
  always @(gsr_asserted or reset_p)                                             \
    if (gsr_asserted)                                                           \
      force q = gsr_init_val;                                                   \
    else if (reset_p === 1'b1)                                                  \
      force q = ~gsr_init_val;                                                  \
    else if (reset_p === 1'bx)                                                  \
      force q = 1'bx;                                                           \
    else                                                                        \
      release q;                                                                \
                                                                                \
  always @(posedge clk or posedge reset_p)                                      \
  begin                                                                         \
    if (reset_p == 1'b1)                                                        \
      q <= rstval;                                                              \
    else                                                                        \
      q <= d;                                                                   \
  end

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_single #(
  // Module parameters
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer SRC_INPUT_REG   = 1
) (
  // Module ports
  input  wire         src_clk,
  input  wire         src_in,
  input  wire         dest_clk,
  output wire         dest_out
);

  // Set Asynchronous Register property on synchronizers
  (* DONT_TOUCH, STOLEN_CDC = "SINGLE", ASYNC_REG = "TRUE" *) reg [DEST_SYNC_FF-1:0] syncstages_ff;

  reg  src_ff;
  wire src_inqual;
  wire async_path_bit;

  assign dest_out       = syncstages_ff[DEST_SYNC_FF-1];
  assign async_path_bit = src_inqual;

  // Virtual mux:  Register at input optional.
  generate
  if (SRC_INPUT_REG) begin
    assign src_inqual = src_ff;
  end
  else begin
    assign src_inqual = src_in;
  end 
  endgenerate

  `XPM_XSRREG(src_clk , 1'b0,  src_ff,        src_in,         1'b0)
  `XPM_XSRREG(dest_clk, 1'b0,  syncstages_ff, { syncstages_ff[DEST_SYNC_FF-2:0], async_path_bit} , {DEST_SYNC_FF{1'b0}})

endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_sync_rst # (
  parameter integer DEST_SYNC_FF    = 4
  ) (
  input  wire       src_rst,
  input  wire       dest_clk,
  output wire       dest_rst
);

  (* DONT_TOUCH, STOLEN_CDC = "SYNC_RST", ASYNC_REG = "TRUE" *) reg [DEST_SYNC_FF-1:0] syncstages_ff;

  wire async_path_bit;

  assign dest_rst = syncstages_ff[DEST_SYNC_FF-1];
  assign async_path_bit = src_rst;
  
  `XPM_XSRREG(dest_clk, 1'b0,  syncstages_ff, { syncstages_ff[DEST_SYNC_FF-2:0], async_path_bit}, {DEST_SYNC_FF{1'b0}})

endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_array_single # (
  parameter integer DEST_SYNC_FF    = 4,
  parameter integer SRC_INPUT_REG   = 1,
  parameter integer WIDTH           = 2
) (
  input  wire             src_clk,
  input  wire [WIDTH-1:0] src_in,
  input  wire             dest_clk,
  output wire [WIDTH-1:0] dest_out
);

  (* DONT_TOUCH, STOLEN_CDC = "ARRAY_SINGLE", ASYNC_REG = "TRUE" *) reg  [WIDTH-1:0] syncstages_ff [DEST_SYNC_FF-1:0];

  reg  [WIDTH-1:0] src_ff;
  wire [WIDTH-1:0] src_inqual;
  wire [WIDTH-1:0] async_path_bit;

  assign dest_out = syncstages_ff[DEST_SYNC_FF-1];

  integer syncstage;
  always @(posedge dest_clk) begin
    syncstages_ff[0] <= async_path_bit;

    for ( syncstage = 1; syncstage < DEST_SYNC_FF ;syncstage = syncstage + 1)
      syncstages_ff[syncstage] <= syncstages_ff [syncstage-1];
  end

  assign async_path_bit = src_inqual;

  // Virtual mux:  Register at input optional.
  generate
  if (SRC_INPUT_REG) begin 
    assign src_inqual = src_ff;
  end 
  else begin 
    assign src_inqual = src_in;
  end 
  endgenerate

  genvar vara_i;
  generate
      `XPM_XSRREG(src_clk, 1'b0, src_ff, src_in, {WIDTH{1'b0}})
  endgenerate
endmodule

(* KEEP_HIERARCHY = "TRUE" *)
module stolen_cdc_gray #(
  // Module parameters
  parameter integer DEST_SYNC_FF          = 4,
  parameter integer INIT_SYNC_FF          = 0,
  parameter integer REG_OUTPUT            = 0,
  parameter integer SIM_ASSERT_CHK        = 0,
  parameter integer SIM_LOSSLESS_GRAY_CHK = 0,
  parameter integer VERSION               = 0,
  parameter integer WIDTH                 = 2
) (
  // Module ports
  input  wire             src_clk,
  input  wire [WIDTH-1:0] src_in_bin,
  input  wire             dest_clk,
  output wire [WIDTH-1:0] dest_out_bin
);

  // Set Asynchronous Register property on synchronizers
  (* DONT_TOUCH, STOLEN_CDC = "GRAY", ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] dest_graysync_ff [DEST_SYNC_FF-1:0];


  wire [WIDTH-1:0] gray_enc;
  reg  [WIDTH-1:0] binval;

  (* DONT_TOUCH, STOLEN_CDC = "GRAY" *) reg  [WIDTH-1:0] src_gray_ff;
  wire [WIDTH-1:0] synco_gray;
  wire [WIDTH-1:0] async_path;
  reg  [WIDTH-1:0] dest_out_bin_ff;

  integer syncstage;
  always @(posedge dest_clk) begin
    dest_graysync_ff[0] <= async_path;

    for (syncstage = 1; syncstage < DEST_SYNC_FF ;syncstage = syncstage + 1)
      dest_graysync_ff[syncstage] <= dest_graysync_ff [syncstage-1];
  end

  assign async_path = src_gray_ff;

  assign synco_gray = dest_graysync_ff[DEST_SYNC_FF-1];
  assign gray_enc = src_in_bin ^ {1'b0, src_in_bin[WIDTH-1:1]};

  // Convert gray code back to binary
  integer j;
  always @(*) begin
    binval[WIDTH-1] = synco_gray[WIDTH-1];
    for (j = WIDTH - 2; j >= 0; j = j - 1)
        binval[j] = binval[j+1] ^ synco_gray[j];
  end

  generate
  if(REG_OUTPUT) begin
    assign dest_out_bin     = dest_out_bin_ff;
  end
  else begin
    assign dest_out_bin     = binval;
  end
  endgenerate


  `XPM_XSRREG(src_clk, 1'b0,  src_gray_ff, gray_enc, {WIDTH{1'b0}})
  `XPM_XSRREG(dest_clk, 1'b0,  dest_out_bin_ff, binval, {WIDTH{1'b0}})


endmodule
