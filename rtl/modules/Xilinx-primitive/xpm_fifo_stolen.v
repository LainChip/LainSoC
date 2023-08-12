module stolen_fifo_base # (

  // Common module parameters
  parameter integer                 COMMON_CLOCK         = 1,
  parameter integer                 RELATED_CLOCKS       = 0,
  parameter integer                 FIFO_MEMORY_TYPE     = 0,
  parameter integer                 SIM_ASSERT_CHK       = 0,
  parameter integer                 CASCADE_HEIGHT       = 0,

  parameter integer                 FIFO_WRITE_DEPTH     = 2048,
  parameter integer                 WRITE_DATA_WIDTH     = 32,
  parameter integer                 WR_DATA_COUNT_WIDTH  = 12,
  parameter [15:0]                  USE_ADV_FEATURES     = 16'h0707,

  parameter                         READ_MODE            = 0,
  parameter                         FIFO_READ_LATENCY    = 1,
  parameter integer                 READ_DATA_WIDTH      = WRITE_DATA_WIDTH,
  parameter integer                 RD_DATA_COUNT_WIDTH  = 12,
  parameter integer                 CDC_DEST_SYNC_FF     = 2,
  parameter integer                 FULL_RESET_VALUE     = 0,
  parameter integer                 REMOVE_WR_RD_PROT_LOGIC = 0,

  parameter integer                 VERSION              = 1,
  parameter integer                 C_SELECT_XPM         = 1

) (

  // Common module ports
  input  wire                                rst,

  // Write Domain ports
  input  wire                                wr_clk,
  input  wire                                wr_en,
  input  wire [WRITE_DATA_WIDTH-1:0]         din,
  output wire                                full,
  output wire                                full_n,
  output wire [WR_DATA_COUNT_WIDTH-1:0]      wr_data_count,
  output wire                                overflow,
  output wire                                wr_rst_busy,
  output wire                                almost_full,
  output wire                                wr_ack,

  // Read Domain ports
  input  wire                                rd_clk,
  input  wire                                rd_en,
  output wire [READ_DATA_WIDTH-1:0]          dout,
  output wire                                empty,
  output wire [RD_DATA_COUNT_WIDTH-1:0]      rd_data_count,
  output wire                                underflow,
  output wire                                rd_rst_busy,
  output wire                                almost_empty,
  output wire                                data_valid

);

  localparam invalid             = 0;
  localparam stage1_valid        = 2;
  localparam stage2_valid        = 1;
  localparam both_stages_valid   = 3;

  reg  [1:0] curr_fwft_state;
  reg  [1:0] next_fwft_state;// = invalid;



  localparam FIFO_MEM_TYPE   = FIFO_MEMORY_TYPE;
  localparam RD_MODE         = READ_MODE;
  localparam FIFO_READ_DEPTH = FIFO_WRITE_DEPTH*WRITE_DATA_WIDTH/READ_DATA_WIDTH;
  localparam FIFO_SIZE       = FIFO_WRITE_DEPTH*WRITE_DATA_WIDTH;
  localparam WR_PNTR_WIDTH   = $clog2(FIFO_WRITE_DEPTH);
  localparam RD_PNTR_WIDTH   = $clog2(FIFO_READ_DEPTH);
  localparam FULL_RST_VAL    = FULL_RESET_VALUE == 0 ? 1'b0 : 1'b1;
  localparam WR_RD_RATIO     = (WR_PNTR_WIDTH > RD_PNTR_WIDTH) ? (WR_PNTR_WIDTH-RD_PNTR_WIDTH) : 0;
  localparam READ_MODE_LL    = (READ_MODE == 0) ? 0 : 1;

  localparam RD_LATENCY      = (READ_MODE == 2) ? 1 : (READ_MODE == 1) ? 2 : FIFO_READ_LATENCY;
  localparam WIDTH_RATIO     = (READ_DATA_WIDTH > WRITE_DATA_WIDTH) ? (READ_DATA_WIDTH/WRITE_DATA_WIDTH) : (WRITE_DATA_WIDTH/READ_DATA_WIDTH);

  localparam [15:0] EN_ADV_FEATURE = USE_ADV_FEATURES;

  localparam EN_OF           = EN_ADV_FEATURE[0];  //EN_ADV_FLAGS_WR[0] ? 1 : 0;
  localparam EN_WDC          = EN_ADV_FEATURE[2];  //EN_ADV_FLAGS_WR[2] ? 1 : 0;
  localparam EN_AF           = EN_ADV_FEATURE[3];  //EN_ADV_FLAGS_WR[3] ? 1 : 0;
  localparam EN_WACK         = EN_ADV_FEATURE[4];  //EN_ADV_FLAGS_WR[4] ? 1 : 0;
  localparam FG_EQ_ASYM_DOUT = EN_ADV_FEATURE[5];  //EN_ADV_FLAGS_WR[5] ? 1 : 0;
  localparam EN_UF           = EN_ADV_FEATURE[8];  //EN_ADV_FLAGS_RD[0] ? 1 : 0;
  localparam EN_RDC          = EN_ADV_FEATURE[10]; //EN_ADV_FLAGS_RD[2] ? 1 : 0;
  localparam EN_AE           = EN_ADV_FEATURE[11]; //EN_ADV_FLAGS_RD[3] ? 1 : 0;
  localparam EN_DVLD         = EN_ADV_FEATURE[12]; //EN_ADV_FLAGS_RD[4] ? 1 : 0;

  wire                       wrst_busy;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_ext;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_rd_cdc;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_rd_cdc_dc;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_rd;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_rd_dc;
  wire [WR_PNTR_WIDTH-1:0]   rd_pntr_wr_adj;
  wire [WR_PNTR_WIDTH:0]     rd_pntr_wr_adj_dc;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus1;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus2;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus3;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_plus1_pf;
  wire [WR_PNTR_WIDTH:0]     rd_pntr_wr_adj_inv_pf;
  reg  [WR_PNTR_WIDTH:0]     diff_pntr_pf_q;
  wire [WR_PNTR_WIDTH-1:0]   diff_pntr_pf;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_ext;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_wr_cdc;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_wr;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_wr_cdc_dc;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_wr_dc;
  wire [RD_PNTR_WIDTH-1:0]   wr_pntr_rd_adj;
  wire [RD_PNTR_WIDTH:0]     wr_pntr_rd_adj_dc;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_plus1;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_plus2;
  wire                       invalid_state;
  wire                       valid_fwft;
  wire                       ram_valid_fwft;
  wire                       going_empty;
  wire                       leaving_empty;
  wire                       going_aempty;
  wire                       leaving_aempty;
  reg                        ram_empty_i;
  reg                        ram_aempty_i;
  wire                       empty_i;
  wire                       going_full;
  wire                       leaving_full;
  wire                       going_afull;
  wire                       leaving_afull;
  reg                        prog_full_i;
  reg                        ram_full_i;
  reg                        ram_afull_i;
  reg                        ram_full_n;
  wire                       ram_wr_en_i;
  wire                       ram_rd_en_i;
  reg                        wr_ack_i;
  wire                       rd_en_i;
  reg                        rd_en_fwft;
  wire                       ram_regce;
  wire                       ram_regce_pipe;
  wire [READ_DATA_WIDTH-1:0] dout_i;
  reg                        empty_fwft_i;
  reg                        aempty_fwft_i;
  reg                        empty_fwft_fb;
  reg                        overflow_i;
  reg                        underflow_i;
  reg                        data_valid_fwft;
  reg                        data_valid_std;
  wire                       data_vld_std;
  wire                       wrp_gt_rdp_and_red;
  wire                       wrp_lt_rdp_and_red;
  reg                        ram_wr_en_pf_q;
  reg                        ram_rd_en_pf_q;
  wire                       ram_wr_en_pf;
  wire                       ram_rd_en_pf;
  wire                       wr_pntr_plus1_pf_carry;
  wire                       rd_pntr_wr_adj_pf_carry;
  wire                       write_allow;
  wire                       read_allow;
  wire                       read_only;
  wire                       write_only;
  reg                        write_only_q;
  reg                        read_only_q;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe_reg1;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe_reg2;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe;
  reg                        ram_empty_i_d1;
  wire                       fe_of_empty;

  wire wr_en_i;
  wire wr_rst_i;
  wire rd_rst_i;
  reg  rd_rst_d2;
  wire rst_d1;
  wire rst_d2;
  wire clr_full;
  wire empty_fwft_d1;
  wire leaving_empty_fwft_fe;
  wire leaving_empty_fwft_re;
  wire le_fwft_re;
  wire le_fwft_fe;
  wire [1:0] extra_words_fwft;
  wire le_fwft_re_wr;
  wire le_fwft_fe_wr;

  generate

  stolen_fifo_rst # (COMMON_CLOCK, CDC_DEST_SYNC_FF, SIM_ASSERT_CHK)
    stolen_fifo_rst_inst (rst, wr_clk, rd_clk, wr_rst_i, rd_rst_i, wrst_busy, rd_rst_busy);
  assign wr_rst_busy = wrst_busy | rst_d1;

  stolen_fifo_reg_bit #(0)
    rst_d1_inst (1'b0, wr_clk, wrst_busy, rst_d1);
  stolen_fifo_reg_bit #(0)
    rst_d2_inst (1'b0, wr_clk, rst_d1, rst_d2);

  assign clr_full = ~wrst_busy & rst_d1 & ~rst;
  assign rd_en_i = (RD_MODE == 0) ? rd_en : rd_en_fwft;

  if (REMOVE_WR_RD_PROT_LOGIC == 1) begin
    assign ram_wr_en_i = wr_en;
    assign ram_rd_en_i = rd_en_i;
  end
  else begin
    assign ram_wr_en_i = wr_en & ~ram_full_i & ~(wrst_busy|rst_d1);
    assign ram_rd_en_i = rd_en_i & ~ram_empty_i;
  end

  // Write pointer generation
  stolen_counter_updn # (WR_PNTR_WIDTH+1, 0)
    wrp_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_ext);
  assign wr_pntr = wr_pntr_ext[WR_PNTR_WIDTH-1:0];

  stolen_counter_updn # (WR_PNTR_WIDTH, 1)
    wrpp1_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus1);

  stolen_counter_updn # (WR_PNTR_WIDTH, 2)
    wrpp2_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus2);

  if (EN_AF == 1) begin
    stolen_counter_updn # (WR_PNTR_WIDTH, 3)
      wrpp3_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus3);
  end

  // Read pointer generation
  stolen_counter_updn # (RD_PNTR_WIDTH+1, 0)
    rdp_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_ext);
  assign rd_pntr = rd_pntr_ext[RD_PNTR_WIDTH-1:0];

  stolen_counter_updn # (RD_PNTR_WIDTH, 1)
    rdpp1_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_plus1);

  if (EN_AE == 1) begin
    stolen_counter_updn # (RD_PNTR_WIDTH, 2)
      rdpp2_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_plus2);
  end

  assign full        = ram_full_i;
  assign full_n      = ram_full_n;
  assign almost_full = EN_AF == 1 ? ram_afull_i : 1'b0;
  assign wr_ack      = EN_WACK == 1 ? wr_ack_i : 1'b0;
  if (EN_WACK == 1) begin
    always @ (posedge wr_clk) begin
      if (rst | wr_rst_i | wrst_busy)
        wr_ack_i  <= 1'b0;
      else
        wr_ack_i  <= ram_wr_en_i;
    end
  end
  
  assign empty_i = (RD_MODE == 0)? ram_empty_i : empty_fwft_i;
  assign empty   = empty_i;
  assign almost_empty = EN_AE == 1 ? (RD_MODE == 0) ? ram_aempty_i : aempty_fwft_i : 1'b0;
  
  assign data_valid   = EN_DVLD == 1 ? (RD_MODE == 0) ? data_valid_std : data_valid_fwft : 1'b0;
  if (EN_DVLD == 1) begin
    assign data_vld_std = (RD_MODE == 0) ? (FIFO_READ_LATENCY == 1) ? ram_rd_en_i: ram_regce_pipe : ram_regce;
    always @ (posedge rd_clk) begin
      if (rd_rst_i)
        data_valid_std  <= 1'b0;
      else
        data_valid_std  <= data_vld_std;
    end
  end

  // Simple dual port RAM instantiation for non-Built-in FIFO
  if (FIFO_MEMORY_TYPE < 4) begin

  // Reset is not supported when ECC is enabled by the BRAM/URAM primitives
    wire rst_int;
    assign rst_int = rd_rst_i;
  // ----------------------------------------------------------------------
  // Base module instantiation with simple dual port RAM configuration
  // ----------------------------------------------------------------------
  localparam USE_DRAM_CONSTRAINT = (COMMON_CLOCK == 0 && FIFO_MEMORY_TYPE == 1) ? 1 : 0;
  localparam WR_MODE_B           = (FIFO_MEMORY_TYPE == 1 || FIFO_MEMORY_TYPE == 3) ? 1 : 2;
  
      reg [READ_DATA_WIDTH-1:0] stolen_fifo_mem [0:FIFO_WRITE_DEPTH-1];
      
      always @(posedge wr_clk) begin
          if (ram_wr_en_i)
            stolen_fifo_mem[wr_pntr] <= din;
      end

      reg [READ_DATA_WIDTH-1:0] rd_tmp_reg;
      always @(posedge rd_clk) begin
          if (rd_rst_i)
            rd_tmp_reg <= {READ_DATA_WIDTH{1'b0}};
          else if (ram_rd_en_i)
            rd_tmp_reg <= stolen_fifo_mem[rd_pntr];
      end

      assign dout_i = rd_tmp_reg;
  end

  if (WR_PNTR_WIDTH == RD_PNTR_WIDTH) begin
    assign wr_pntr_rd_adj    = wr_pntr_rd[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign wr_pntr_rd_adj_dc = wr_pntr_rd_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign rd_pntr_wr_adj    = rd_pntr_wr[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
    assign rd_pntr_wr_adj_dc = rd_pntr_wr_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
  end

  if (WR_PNTR_WIDTH > RD_PNTR_WIDTH) begin
    assign wr_pntr_rd_adj = wr_pntr_rd[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign wr_pntr_rd_adj_dc = wr_pntr_rd_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign rd_pntr_wr_adj[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH] = rd_pntr_wr;
    assign rd_pntr_wr_adj[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0] = {(WR_PNTR_WIDTH-RD_PNTR_WIDTH){1'b0}};
    assign rd_pntr_wr_adj_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH] = rd_pntr_wr_dc;
    assign rd_pntr_wr_adj_dc[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0] = {(WR_PNTR_WIDTH-RD_PNTR_WIDTH){1'b0}};
  end

  if (WR_PNTR_WIDTH < RD_PNTR_WIDTH) begin
    assign wr_pntr_rd_adj[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH] = wr_pntr_rd;
    assign wr_pntr_rd_adj[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0] = {(RD_PNTR_WIDTH-WR_PNTR_WIDTH){1'b0}};
    assign wr_pntr_rd_adj_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH] = wr_pntr_rd_dc;
    assign wr_pntr_rd_adj_dc[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0] = {(RD_PNTR_WIDTH-WR_PNTR_WIDTH){1'b0}};
    assign rd_pntr_wr_adj = rd_pntr_wr[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
    assign rd_pntr_wr_adj_dc = rd_pntr_wr_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
  end

  if (COMMON_CLOCK == 0 && RELATED_CLOCKS == 0) begin
    // Synchronize the write pointer in rd_clk domain
    stolen_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (WR_PNTR_WIDTH))
      
      wr_pntr_cdc_inst (
        .src_clk             (wr_clk),
        .src_in_bin          (wr_pntr),
        .dest_clk            (rd_clk),
        .dest_out_bin        (wr_pntr_rd_cdc));

    // Register the output of XPM_CDC_GRAY on read side
    stolen_fifo_reg_vec #(WR_PNTR_WIDTH)
      wpr_gray_reg (rd_rst_i, rd_clk, wr_pntr_rd_cdc, wr_pntr_rd);

    // Synchronize the extended write pointer in rd_clk domain
    stolen_cdc_gray #(
      .DEST_SYNC_FF          (READ_MODE == 0 ? CDC_DEST_SYNC_FF : CDC_DEST_SYNC_FF+2),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (WR_PNTR_WIDTH+1))
      wr_pntr_cdc_dc_inst (
        .src_clk             (wr_clk),
        .src_in_bin          (wr_pntr_ext),
        .dest_clk            (rd_clk),
        .dest_out_bin        (wr_pntr_rd_cdc_dc));

    // Register the output of XPM_CDC_GRAY on read side
    stolen_fifo_reg_vec #(WR_PNTR_WIDTH+1)
      wpr_gray_reg_dc (rd_rst_i, rd_clk, wr_pntr_rd_cdc_dc, wr_pntr_rd_dc);

    // Synchronize the read pointer in wr_clk domain
    stolen_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (RD_PNTR_WIDTH))
      rd_pntr_cdc_inst (
        .src_clk             (rd_clk),
        .src_in_bin          (rd_pntr),
        .dest_clk            (wr_clk),
        .dest_out_bin        (rd_pntr_wr_cdc));

    // Register the output of XPM_CDC_GRAY on write side
    stolen_fifo_reg_vec #(RD_PNTR_WIDTH)
      rpw_gray_reg (wrst_busy, wr_clk, rd_pntr_wr_cdc, rd_pntr_wr);

    // Synchronize the read pointer, subtracted by the extra word read for FWFT, in wr_clk domain
    stolen_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (RD_PNTR_WIDTH+1))
      rd_pntr_cdc_dc_inst (
        .src_clk             (rd_clk),
        .src_in_bin          (rd_pntr_ext-extra_words_fwft),
        .dest_clk            (wr_clk),
        .dest_out_bin        (rd_pntr_wr_cdc_dc));

    // Register the output of XPM_CDC_GRAY on write side
    stolen_fifo_reg_vec #(RD_PNTR_WIDTH+1)
      rpw_gray_reg_dc (wrst_busy, wr_clk, rd_pntr_wr_cdc_dc, rd_pntr_wr_dc);

  end

  if (RELATED_CLOCKS == 1) begin
    stolen_fifo_reg_vec #(RD_PNTR_WIDTH)
      rpw_rc_reg (wrst_busy, wr_clk, rd_pntr, rd_pntr_wr);

    stolen_fifo_reg_vec #(WR_PNTR_WIDTH)
      wpr_rc_reg (rd_rst_i, rd_clk, wr_pntr, wr_pntr_rd);

    stolen_fifo_reg_vec #(WR_PNTR_WIDTH+1)
      wpr_rc_reg_dc (rd_rst_i, rd_clk, wr_pntr_ext, wr_pntr_rd_dc);

    stolen_fifo_reg_vec #(RD_PNTR_WIDTH+1)
      rpw_rc_reg_dc (wrst_busy, wr_clk, (rd_pntr_ext-extra_words_fwft), rd_pntr_wr_dc);
  end

  if (COMMON_CLOCK == 0 || RELATED_CLOCKS == 1) begin
  
    assign going_empty     = ((wr_pntr_rd_adj == rd_pntr_plus1) & ram_rd_en_i);
    assign leaving_empty   = ((wr_pntr_rd_adj == rd_pntr));
    assign going_aempty    = ((wr_pntr_rd_adj == rd_pntr_plus2) & ram_rd_en_i);
    assign leaving_aempty  = ((wr_pntr_rd_adj == rd_pntr_plus1));
  
    assign going_full      = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i);
    assign leaving_full    = ((rd_pntr_wr_adj == wr_pntr_plus1));
    assign going_afull     = ((rd_pntr_wr_adj == wr_pntr_plus3) & ram_wr_en_i);
    assign leaving_afull   = ((rd_pntr_wr_adj == wr_pntr_plus2));
  
    // Empty flag generation
    always @ (posedge rd_clk) begin
      if (rd_rst_i) begin
         ram_empty_i  <= 1'b1;
      end else begin
         ram_empty_i  <= going_empty | leaving_empty;
      end
    end

    if (EN_AE == 1) begin
      always @ (posedge rd_clk) begin
        if (rd_rst_i) begin
          ram_aempty_i <= 1'b1;
        end else if (~ram_empty_i) begin
          ram_aempty_i <= going_aempty | leaving_aempty;
        end
      end
    end
  
    // Full flag generation
    if (FULL_RST_VAL == 1) begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i      <= FULL_RST_VAL;
          ram_full_n      <= ~FULL_RST_VAL;
        end else begin
	  if (clr_full) begin
            ram_full_i    <= 1'b0;
            ram_full_n    <= 1'b1;
	  end else begin
            ram_full_i    <= going_full | leaving_full;
            ram_full_n    <= ~(going_full | leaving_full);
          end
        end
      end
    end
    else begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= 1'b0;
          ram_full_n   <= 1'b1;
	end else begin
          ram_full_i   <= going_full | leaving_full;
          ram_full_n   <= ~(going_full | leaving_full);
	end
      end
    end

    if (EN_AF == 1) begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_afull_i  <= FULL_RST_VAL;
        end else if (~rst) begin
	  if (clr_full) begin
            ram_afull_i  <= 1'b0;
	  end else if (~ram_full_i) begin
            ram_afull_i  <= going_afull | leaving_afull;
          end
        end
      end
    end

  end

  if (COMMON_CLOCK == 1 && RELATED_CLOCKS == 0) begin
    assign wr_pntr_rd = wr_pntr;
    assign rd_pntr_wr = rd_pntr;
    assign wr_pntr_rd_dc = wr_pntr_ext;
    assign rd_pntr_wr_dc = rd_pntr_ext-extra_words_fwft;
    assign write_allow  = ram_wr_en_i & ~ram_full_i;
    assign read_allow   = ram_rd_en_i & ~empty_i;

    if (WR_PNTR_WIDTH == RD_PNTR_WIDTH) begin
      assign ram_wr_en_pf  = ram_wr_en_i;
      assign ram_rd_en_pf  = ram_rd_en_i;
  
      assign going_empty    = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_empty  = ((wr_pntr_rd_adj == rd_pntr) & ram_wr_en_i);
      assign going_aempty   = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_aempty = ((wr_pntr_rd_adj == rd_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
  
      assign going_full     = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_full   = ((rd_pntr_wr_adj == wr_pntr) & ram_rd_en_i);
      assign going_afull    = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_afull  = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_rd_en_i & ~ram_wr_en_i);

      assign write_only    = write_allow & ~read_allow;
      assign read_only     = read_allow & ~write_allow;

    end
  
    if (WR_PNTR_WIDTH > RD_PNTR_WIDTH) begin
      assign wrp_gt_rdp_and_red = &wr_pntr_rd[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0];
  
      assign going_empty    = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~(ram_wr_en_i & wrp_gt_rdp_and_red) & ram_rd_en_i);
      assign leaving_empty  = ((wr_pntr_rd_adj == rd_pntr) & (ram_wr_en_i & wrp_gt_rdp_and_red));
      assign going_aempty   = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~(ram_wr_en_i & wrp_gt_rdp_and_red) & ram_rd_en_i);
      assign leaving_aempty = ((wr_pntr_rd_adj == rd_pntr_plus1) & (ram_wr_en_i & wrp_gt_rdp_and_red) & ~ram_rd_en_i);
  
      assign going_full     = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_full   = ((rd_pntr_wr_adj == wr_pntr) & ram_rd_en_i);
      assign going_afull    = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_afull  = (((rd_pntr_wr_adj == wr_pntr) | (rd_pntr_wr_adj == wr_pntr_plus1) | (rd_pntr_wr_adj == wr_pntr_plus2)) & ram_rd_en_i);
  
      assign ram_wr_en_pf  = ram_wr_en_i & wrp_gt_rdp_and_red;
      assign ram_rd_en_pf  = ram_rd_en_i;

      assign read_only     = read_allow & (~(write_allow  & (&wr_pntr[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1 : 0])));
      assign write_only    = write_allow & (&wr_pntr[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1 : 0]) & ~read_allow;


    end
  
    if (WR_PNTR_WIDTH < RD_PNTR_WIDTH) begin
      assign wrp_lt_rdp_and_red = &rd_pntr_wr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0];
  
      assign going_empty     = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_empty   = ((wr_pntr_rd_adj == rd_pntr) & ram_wr_en_i);
      assign going_aempty    = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_aempty  = (((wr_pntr_rd_adj == rd_pntr) | (wr_pntr_rd_adj == rd_pntr_plus1) | (wr_pntr_rd_adj == rd_pntr_plus2)) & ram_wr_en_i);
  
      assign going_full      = ((rd_pntr_wr_adj == wr_pntr_plus1) & ~(ram_rd_en_i & wrp_lt_rdp_and_red) & ram_wr_en_i);
      assign leaving_full    = ((rd_pntr_wr_adj == wr_pntr) & (ram_rd_en_i & wrp_lt_rdp_and_red));
      assign going_afull     = ((rd_pntr_wr_adj == wr_pntr_plus2) & ~(ram_rd_en_i & wrp_lt_rdp_and_red) & ram_wr_en_i);
      assign leaving_afull   = ((rd_pntr_wr_adj == wr_pntr_plus1) & ~ram_wr_en_i & (ram_rd_en_i & wrp_lt_rdp_and_red));
  
      assign ram_wr_en_pf = ram_wr_en_i;
      assign ram_rd_en_pf = ram_rd_en_i & wrp_lt_rdp_and_red;

      assign read_only   = read_allow & (&rd_pntr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1 : 0]) & ~write_allow;
      assign write_only    = write_allow    & (~(read_allow & (&rd_pntr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1 : 0])));
    end
  
    // Empty flag generation
    always @ (posedge rd_clk) begin
      if (rd_rst_i) begin
         ram_empty_i  <= 1'b1;
      end else begin
         ram_empty_i  <= going_empty | (~leaving_empty & ram_empty_i);
      end
    end

    if (EN_AE == 1) begin
      always @ (posedge rd_clk) begin
        if (rd_rst_i) begin
          ram_aempty_i <= 1'b1;
        end else begin
          ram_aempty_i <= going_aempty | (~leaving_aempty & ram_aempty_i);
        end
      end
    end

    // Full flag generation
    if (FULL_RST_VAL == 1) begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= FULL_RST_VAL;
          ram_full_n   <= ~FULL_RST_VAL;
        end else begin
	  if (clr_full) begin
            ram_full_i   <= 1'b0;
            ram_full_n   <= 1'b1;
	  end else begin
            ram_full_i   <= going_full | (~leaving_full & ram_full_i);
            ram_full_n   <= ~(going_full | (~leaving_full & ram_full_i));
          end
        end
      end
    end
    else begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= 1'b0;
          ram_full_n   <= 1'b1;
	end else begin
          ram_full_i   <= going_full | (~leaving_full & ram_full_i);
          ram_full_n   <= ~(going_full | (~leaving_full & ram_full_i));
	end
      end
    end

    if (EN_AF == 1) begin
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_afull_i  <= FULL_RST_VAL;
        end else if (~rst) begin
	  if (clr_full) begin
            ram_afull_i  <= 1'b0;
	  end else begin
            ram_afull_i  <= going_afull | (~leaving_afull & ram_afull_i);
          end
        end
      end
    end
  end

  if (READ_MODE == 0 && FIFO_READ_LATENCY > 1) begin
    stolen_reg_pipe_bit #(FIFO_READ_LATENCY-1, 0)
      regce_pipe_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_regce_pipe);
  end
  if (!(READ_MODE == 0 && FIFO_READ_LATENCY > 1)) begin
    assign ram_regce_pipe = 1'b0;
  end

  if (!((READ_MODE == 1 || READ_MODE == 2)&& FIFO_MEMORY_TYPE != 4)) begin
   assign invalid_state = 1'b0;
  end
  //if (READ_MODE == 1 && FIFO_MEMORY_TYPE != 4) begin
  if (READ_MODE != 0 && FIFO_MEMORY_TYPE != 4) begin
  // First word fall through logic

   //localparam invalid             = 0;
   //localparam stage1_valid        = 2;
   //localparam stage2_valid        = 1;
   //localparam both_stages_valid   = 3;

   //reg  [1:0] curr_fwft_state = invalid;
   //reg  [1:0] next_fwft_state;// = invalid;
   wire next_fwft_state_d1;
   assign invalid_state = ~|curr_fwft_state;
   assign valid_fwft = next_fwft_state_d1;
   assign ram_valid_fwft = curr_fwft_state[1];

    stolen_fifo_reg_bit #(0)
      next_state_d1_inst (1'b0, rd_clk, next_fwft_state[0], next_fwft_state_d1);
   //FSM : To generate the enable, clock enable for stolen_memory and to generate
   //empty signal
   //FSM : Next state Assignment
     if (READ_MODE == 1) begin
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid: begin
           if (~ram_empty_i)
              next_fwft_state     = stage1_valid;
           else
              next_fwft_state     = invalid;
           end
         stage1_valid: begin
           if (ram_empty_i)
              next_fwft_state     = stage2_valid;
           else
              next_fwft_state     = both_stages_valid;
           end
         stage2_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = invalid;
           else if (~ram_empty_i && rd_en)
              next_fwft_state     = stage1_valid;
           else if (~ram_empty_i && ~rd_en)
              next_fwft_state     = both_stages_valid;
           else
              next_fwft_state     = stage2_valid;
           end
         both_stages_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = stage2_valid;
           else if (~ram_empty_i && rd_en)
              next_fwft_state     = both_stages_valid;
           else
              next_fwft_state     = both_stages_valid;
           end
         default: next_fwft_state    = invalid;
       endcase
     end
     end
     if (READ_MODE == 2) begin
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid: begin
           if (~ram_empty_i)
              next_fwft_state     = stage1_valid;
           else
              next_fwft_state     = invalid;
           end
         stage1_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = invalid;
           else
              next_fwft_state     = stage1_valid;
           end
         default: next_fwft_state    = invalid;
       endcase
     end
     end
     // FSM : current state assignment
     always @ (posedge rd_clk) begin
       if (rd_rst_i)
          curr_fwft_state  <= invalid;
       else
          curr_fwft_state  <= next_fwft_state;
     end
 
     reg ram_regout_en;

     // FSM(output assignments) : clock enable generation for stolen_memory
     if (READ_MODE == 1) begin
     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         invalid:           ram_regout_en = 1'b0;
         stage1_valid:      ram_regout_en = 1'b1;
         stage2_valid:      ram_regout_en = 1'b0;
         both_stages_valid: ram_regout_en = rd_en;
         default:           ram_regout_en = 1'b0;
       endcase
     end
     end
     if (READ_MODE == 2) begin
     always @(curr_fwft_state or rd_en or ram_empty_i or fe_of_empty) begin
       case (curr_fwft_state)
         invalid:           ram_regout_en = fe_of_empty;
         stage1_valid:      ram_regout_en = rd_en & !ram_empty_i;
         default:           ram_regout_en = 1'b0;
       endcase
     end
     end

     // FSM(output assignments) : rd_en (enable) signal generation for stolen_memory
     if (READ_MODE == 1) begin
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage1_valid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage2_valid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         both_stages_valid :
           if (~ram_empty_i && rd_en)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         default :
           rd_en_fwft = 1'b0;
       endcase
     end
     end
     if (READ_MODE == 2) begin
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage1_valid :
           if (~ram_empty_i && rd_en)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         default :
           rd_en_fwft = 1'b0;
       endcase
     end
     end
     // assingment to control regce stolen_memory
     assign ram_regce = ram_regout_en;

     reg going_empty_fwft;
     reg leaving_empty_fwft;

     if (READ_MODE == 1) begin
     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         stage2_valid : going_empty_fwft = rd_en;
         default      : going_empty_fwft = 1'b0;
       endcase
     end

     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         stage1_valid : leaving_empty_fwft = 1'b1;
         default      : leaving_empty_fwft = 1'b0;
       endcase
     end
     end
     if (READ_MODE == 2) begin
     always @(curr_fwft_state or rd_en or ram_empty_i) begin
       case (curr_fwft_state)
         stage1_valid : going_empty_fwft = rd_en & ram_empty_i;
         default      : going_empty_fwft = 1'b0;
       endcase
     end

     always @ (posedge rd_clk) begin
       if (rd_rst_i) begin
          ram_empty_i_d1  <= 1'b1;
       end else begin
          ram_empty_i_d1  <= ram_empty_i;
       end
     end
     assign fe_of_empty = ram_empty_i_d1 & !ram_empty_i;

     always @(curr_fwft_state or fe_of_empty) begin
       case (curr_fwft_state)
         invalid      : leaving_empty_fwft = fe_of_empty;
         stage1_valid : leaving_empty_fwft = 1'b1;
         default      : leaving_empty_fwft = 1'b0;
       endcase
     end
     end

     // fwft empty signal generation 
     always @ (posedge rd_clk) begin
       if (rd_rst_i) begin
         empty_fwft_i     <= 1'b1;
         empty_fwft_fb    <= 1'b1;
       end else begin
         empty_fwft_i     <= going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb);
         empty_fwft_fb    <= going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb);
       end
     end

     if (EN_AE == 1) begin
       reg going_aempty_fwft;
       reg leaving_aempty_fwft;

       if (READ_MODE == 1) begin
         always @(curr_fwft_state or rd_en or ram_empty_i) begin
           case (curr_fwft_state)
             both_stages_valid : going_aempty_fwft = rd_en & ram_empty_i;
             default      : going_aempty_fwft = 1'b0;
           endcase
         end
       end
       if (READ_MODE == 2) begin
         always @(curr_fwft_state or rd_en or ram_empty_i) begin
           case (curr_fwft_state)
             stage1_valid : going_aempty_fwft = !rd_en & ram_empty_i;
             default      : going_aempty_fwft = 1'b0;
           endcase
         end
       end

       always @(curr_fwft_state or rd_en or ram_empty_i) begin
         case (curr_fwft_state)
           stage1_valid : leaving_aempty_fwft = ~ram_empty_i;
           stage2_valid : leaving_aempty_fwft = ~(rd_en | ram_empty_i);
           default      : leaving_aempty_fwft = 1'b0;
         endcase
       end

       always @ (posedge rd_clk) begin
         if (rd_rst_i) begin
           aempty_fwft_i    <= 1'b1;
         end else begin
           aempty_fwft_i    <= going_aempty_fwft | (~ leaving_aempty_fwft & aempty_fwft_i);
         end
       end
     end

     if (EN_DVLD == 1) begin
       always @ (posedge rd_clk) begin
         if (rd_rst_i) begin
           data_valid_fwft  <= 1'b0;
         end else begin
           data_valid_fwft  <= ~(going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb));
         end
       end
     end

    stolen_fifo_reg_bit #(0)
      empty_fwft_d1_inst (1'b0, rd_clk, leaving_empty_fwft, empty_fwft_d1);

    wire ge_fwft_d1;
    stolen_fifo_reg_bit #(0)
      ge_fwft_d1_inst (1'b0, rd_clk, going_empty_fwft, ge_fwft_d1);

    wire count_up  ;
    wire count_down;
    wire count_en  ;
    wire count_rst ;
    assign count_up   = (next_fwft_state == 2'b10 && ~|curr_fwft_state) | (curr_fwft_state == 2'b10 && &next_fwft_state) | (curr_fwft_state == 2'b01 && &next_fwft_state);
    assign count_down = (next_fwft_state == 2'b01 && &curr_fwft_state) | (curr_fwft_state == 2'b01 && ~|next_fwft_state);
    assign count_en   = count_up | count_down;
    assign count_rst  = (rd_rst_i | (~|curr_fwft_state & ~|next_fwft_state));

    stolen_counter_updn # (2, 0)
      rdpp1_inst (count_rst, rd_clk, count_en, count_up, count_down, extra_words_fwft);

 
  end

  if (READ_MODE == 0) begin
    assign le_fwft_re       = 1'b0;
    assign le_fwft_fe       = 1'b0;
    assign extra_words_fwft = 2'h0;
  end

  // output data bus assignment
  if (FG_EQ_ASYM_DOUT == 0) begin
    assign dout  = dout_i;
  end

  // Overflow and Underflow flag generation
  if (EN_UF == 1) begin
    always @ (posedge rd_clk) begin
      underflow_i <=  (rd_rst_i | empty_i) & rd_en;
    end
    assign underflow   = underflow_i;
  end
  if (EN_UF == 0) begin
    assign underflow   = 1'b0;
  end

  if (EN_OF == 1) begin
    always @ (posedge wr_clk) begin
     overflow_i  <=  (wrst_busy | rst_d1 | ram_full_i) & wr_en;
    end
    assign overflow    = overflow_i;
  end
  if (EN_OF == 0) begin
    assign overflow    = 1'b0;
  end

  endgenerate
endmodule

module stolen_counter_updn # (
  parameter integer               COUNTER_WIDTH        = 4,
  parameter integer               RESET_VALUE          = 0

) (
  input  wire                     rst,
  input  wire                     clk,
  input  wire                     cnt_en,
  input  wire                     cnt_up,
  input  wire                     cnt_down,
  output wire [COUNTER_WIDTH-1:0] count_value
);
  reg [COUNTER_WIDTH-1:0]          count_value_i;
  assign count_value = count_value_i;
  always @ (posedge clk) begin
    if (rst) begin
      count_value_i  <= RESET_VALUE;
    end else if (cnt_en) begin
      count_value_i  <= count_value_i + cnt_up - cnt_down;
    end
  end
endmodule


module stolen_fifo_rst # (
  parameter integer   COMMON_CLOCK     = 1,
  parameter integer   CDC_DEST_SYNC_FF = 2,
  parameter integer   SIM_ASSERT_CHK = 0

) (
  input  wire         rst,
  input  wire         wr_clk,
  input  wire         rd_clk,
  output wire         wr_rst,
  output wire         rd_rst,
  output wire         wr_rst_busy,
  output wire         rd_rst_busy
);
  reg  [1:0] power_on_rst;
  wire rst_i;

  // -------------------------------------------------------------------------------------------------------------------
  // Reset Logic
  // -------------------------------------------------------------------------------------------------------------------
  //Keeping the power on reset to work even when the input reset(to xpm_fifo) is not applied or not using
   always @ (posedge wr_clk) begin
     power_on_rst <= {power_on_rst[0], 1'b0};
   end
   assign rst_i = power_on_rst[1] | rst;

  // Write and read reset generation for common clock FIFO
   if (COMMON_CLOCK == 1) begin
    reg [2:0] fifo_wr_rst_cc;
    assign wr_rst        = fifo_wr_rst_cc[2];
    assign rd_rst        = fifo_wr_rst_cc[2];
    assign rd_rst_busy   = fifo_wr_rst_cc[2];
    assign wr_rst_busy   = fifo_wr_rst_cc[2];

    always @ (posedge wr_clk) begin
      if (rst_i) begin
        fifo_wr_rst_cc    <= 3'h7;
      end else begin
  	fifo_wr_rst_cc   <= {fifo_wr_rst_cc[1:0],1'b0};
      end
    end
  end

  // Write and read reset generation for independent clock FIFO
  if (COMMON_CLOCK == 0) begin
    wire fifo_wr_rst_rd;
    wire fifo_rd_rst_wr_i;
    reg  fifo_wr_rst_i;
    reg  wr_rst_busy_i;
    reg  fifo_rd_rst_i;
    reg  fifo_rd_rst_ic;
    reg  fifo_wr_rst_ic;
    reg  wr_rst_busy_ic;
    reg  rst_seq_reentered;

    assign wr_rst          = fifo_wr_rst_ic | wr_rst_busy_ic;
    assign rd_rst          = fifo_rd_rst_ic;
    assign rd_rst_busy     = fifo_rd_rst_ic;
    assign wr_rst_busy     = wr_rst_busy_ic;

    localparam WRST_IDLE    = 3'b000;
    localparam WRST_IN      = 3'b010;
    localparam WRST_OUT     = 3'b111;
    localparam WRST_EXIT    = 3'b110;
    localparam WRST_GO2IDLE = 3'b100;
    reg [2:0] curr_wrst_state;
    reg [2:0] next_wrst_state;

    localparam RRST_IDLE = 2'b00;
    localparam RRST_IN   = 2'b10;
    localparam RRST_OUT  = 2'b11;
    localparam RRST_EXIT = 2'b01;
    reg [1:0] curr_rrst_state;
    reg [1:0] next_rrst_state;

   always @ (posedge wr_clk) begin
     if (rst_i) begin
       rst_seq_reentered  <= 1'b0;
     end else begin
       if (curr_wrst_state == WRST_GO2IDLE) begin
	 rst_seq_reentered  <= 1'b1;
       end
     end
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else
               next_wrst_state     <= WRST_IDLE;
            end
         WRST_IN: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (fifo_rd_rst_wr_i)
               next_wrst_state     <= WRST_OUT;
            else
               next_wrst_state     <= WRST_IN;
            end
         WRST_OUT: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (~fifo_rd_rst_wr_i)
               next_wrst_state     <= WRST_EXIT;
            else
               next_wrst_state     <= WRST_OUT;
            end
         WRST_EXIT: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (~rst & ~rst_seq_reentered)
               next_wrst_state     <= WRST_GO2IDLE;
            else if (rst_seq_reentered)
               next_wrst_state     <= WRST_IDLE;
            else
               next_wrst_state     <= WRST_EXIT;
            end
         WRST_GO2IDLE: begin
	      next_wrst_state     <= WRST_IN;
            end
         default: next_wrst_state  <= WRST_IDLE;
      endcase
   end

   always @ (posedge wr_clk) begin
     curr_wrst_state     <= next_wrst_state;
     fifo_wr_rst_ic      <= fifo_wr_rst_i;
     wr_rst_busy_ic      <= wr_rst_busy_i;
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE     : fifo_wr_rst_i = rst_i;
         WRST_IN       : fifo_wr_rst_i = 1'b1;
         WRST_OUT      : fifo_wr_rst_i = 1'b0;
         WRST_EXIT     : fifo_wr_rst_i = 1'b0;
         WRST_GO2IDLE  : fifo_wr_rst_i = 1'b1;
         default:   fifo_wr_rst_i = fifo_wr_rst_ic;
      endcase
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE: wr_rst_busy_i = rst_i;
         WRST_IN  : wr_rst_busy_i = 1'b1;
         WRST_OUT : wr_rst_busy_i = 1'b1;
         WRST_EXIT: wr_rst_busy_i = 1'b1;
         default:   wr_rst_busy_i = wr_rst_busy_ic;
      endcase
   end

    always @* begin
      case (curr_rrst_state)
         RRST_IDLE: begin
            if (fifo_wr_rst_rd)
               next_rrst_state      <= RRST_IN;
            else
               next_rrst_state      <= RRST_IDLE;
            end
         RRST_IN  : next_rrst_state <= RRST_OUT;
         RRST_OUT : begin
            if (~fifo_wr_rst_rd)
               next_rrst_state      <= RRST_EXIT;
            else
               next_rrst_state      <= RRST_OUT;
            end
         RRST_EXIT: next_rrst_state <= RRST_IDLE;
         default: next_rrst_state   <= RRST_IDLE;
      endcase
   end

   always @ (posedge rd_clk) begin
     curr_rrst_state  <= next_rrst_state;
     fifo_rd_rst_ic   <= fifo_rd_rst_i;
   end

   always @* begin
      case (curr_rrst_state)
         RRST_IDLE: fifo_rd_rst_i <= fifo_wr_rst_rd;
         RRST_IN  : fifo_rd_rst_i <= 1'b1;
         RRST_OUT : fifo_rd_rst_i <= 1'b1;
         RRST_EXIT: fifo_rd_rst_i <= 1'b0;
         default:   fifo_rd_rst_i <= 1'b0;
      endcase
   end

    // Synchronize the wr_rst (fifo_wr_rst_ic) in read clock domain
    stolen_cdc_sync_rst #(
      .DEST_SYNC_FF      (CDC_DEST_SYNC_FF)
      ) wrst_rd_inst (
        .src_rst         (fifo_wr_rst_ic),
        .dest_clk        (rd_clk),
        .dest_rst        (fifo_wr_rst_rd));

    // Synchronize the rd_rst (fifo_rd_rst_ic) in write clock domain
    stolen_cdc_sync_rst #(
      .DEST_SYNC_FF      (CDC_DEST_SYNC_FF)
    ) rrst_wr_inst (
        .src_rst         (fifo_rd_rst_ic),
        .dest_clk        (wr_clk),
        .dest_rst        (fifo_rd_rst_wr_i));
  end
endmodule

module stolen_fifo_reg_bit # (
  parameter integer           RST_VALUE        = 0

) (
  input  wire  rst,
  input  wire  clk,
  input  wire  d_in,
  output reg   d_out = RST_VALUE
);
  always @ (posedge clk) begin
    if (rst)
      d_out  <= RST_VALUE;
    else
      d_out  <= d_in;
  end
endmodule

module stolen_reg_pipe_bit # (
  parameter integer           PIPE_STAGES      = 1,
  parameter integer           RST_VALUE        = 0

) (
  input  wire  rst,
  input  wire  clk,
  input  wire  pipe_in,
  output wire  pipe_out
);
  wire pipe_stage_ff [PIPE_STAGES:0];

  genvar pipestage;
  assign pipe_stage_ff[0] = pipe_in;

    for (pipestage = 0; pipestage < PIPE_STAGES ;pipestage = pipestage + 1) begin
      stolen_fifo_reg_bit #(RST_VALUE)
        pipe_bit_inst (rst, clk, pipe_stage_ff[pipestage], pipe_stage_ff[pipestage+1]);
    end

  assign pipe_out = pipe_stage_ff[PIPE_STAGES];
endmodule

module stolen_fifo_reg_vec # (
  parameter integer           REG_WIDTH        = 4

) (
  input  wire                 rst,
  input  wire                 clk,
  input  wire [REG_WIDTH-1:0] reg_in,
  output wire  [REG_WIDTH-1:0] reg_out
);
  reg [REG_WIDTH-1:0] reg_out_i;
  always @ (posedge clk) begin
    if (rst)
      reg_out_i  <= {REG_WIDTH{1'b0}};
    else
      reg_out_i  <= reg_in;
  end
  assign reg_out = reg_out_i;
endmodule

