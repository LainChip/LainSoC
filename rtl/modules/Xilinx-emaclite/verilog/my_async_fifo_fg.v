module my_async_fifo_fg #(
    parameter C_DATA_WIDTH = 6,
    parameter C_FIFO_DEPTH = 16,
    parameter C_SELECT_XPM = 1
) (
    input Wr_clk,
    input Ainit,  // sync to wr_clk
    input [C_DATA_WIDTH-1:0] Din,
    input Wr_en,
    output Full,
    output Wr_ack,
    
    input Rd_clk,
    input Rd_en,
    output Rd_ack,
    output [C_DATA_WIDTH-1:0] Dout,
    output Empty
);

wire [C_DATA_WIDTH-1:0] Dout2, Dout1;
wire Full2, Empty2, Full1, Empty1, Rd_ack1, Rd_ack2;
assign Rd_ack = Rd_ack2;
wire Full_int, wr_rst_busy;

assign Dout = Dout2;
assign Full = Full2 || wr_rst_busy;
assign Empty = Empty2;

stolen_fifo_base # (
          .COMMON_CLOCK               (0      ),
          .RELATED_CLOCKS             (0      ),
          .FIFO_MEMORY_TYPE           (2),
          .SIM_ASSERT_CHK             (1      ),
          .CASCADE_HEIGHT             (0      ),
          .FIFO_WRITE_DEPTH           (C_FIFO_DEPTH    ),
          .WRITE_DATA_WIDTH           (C_DATA_WIDTH    ),
          .WR_DATA_COUNT_WIDTH        (0),
          .FULL_RESET_VALUE           (0),
          .USE_ADV_FEATURES           (16'h1717    ),
          .READ_MODE                  (0         ),
          .FIFO_READ_LATENCY          (1   ),
          .READ_DATA_WIDTH            (C_DATA_WIDTH     ),
          .RD_DATA_COUNT_WIDTH        (0 ),
          .CDC_DEST_SYNC_FF           (2     ),
          .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
          .VERSION                    (0                   ),
          .C_SELECT_XPM               (C_SELECT_XPM)
     
        ) xpm_fifo_base_inst (
          .rst              (Ainit),
          .wr_clk           (Wr_clk),
          .wr_en            (Wr_en),
          .din              (Din),
          .full             (Full2),
          .wr_rst_busy      (wr_rst_busy),
          .wr_ack           (Wr_ack),
          .rd_clk           (Rd_clk),
          .rd_en            (Rd_en),
          .dout             (Dout2),
          .empty            (Empty2),
          .data_valid       (Rd_ack2)
        );
/*
wire Full_int, wr_rst_busy;
assign Full1 = Full_int || wr_rst_busy;

   xpm_fifo_async #(
      .CDC_SYNC_STAGES(2),       // DECIMAL
      .DOUT_RESET_VALUE("0"),    // String
      .ECC_MODE("no_ecc"),       // String
      .FIFO_MEMORY_TYPE("auto"), // String
      .FIFO_READ_LATENCY(1),     // DECIMAL
      .FIFO_WRITE_DEPTH(C_FIFO_DEPTH),   // DECIMAL
      .FULL_RESET_VALUE(0),      // DECIMAL
      .PROG_EMPTY_THRESH(10),    // DECIMAL
      .PROG_FULL_THRESH(10),     // DECIMAL
      .RD_DATA_COUNT_WIDTH(1),   // DECIMAL
      .READ_DATA_WIDTH(C_DATA_WIDTH),      // DECIMAL
      .READ_MODE("std"),         // String
      .RELATED_CLOCKS(0),        // DECIMAL
      .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_ADV_FEATURES("1717"), // String
      .WAKEUP_TIME(0),           // DECIMAL
      .WRITE_DATA_WIDTH(C_DATA_WIDTH),     // DECIMAL
      .WR_DATA_COUNT_WIDTH(1)    // DECIMAL
   )
   xpm_fifo_async_inst (

      .data_valid(Rd_ack1),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                     // that valid data is available on the output bus (dout).

      .dout(Dout1),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                     // when reading the FIFO.

      .empty(Empty1),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                     // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                     // initiating a read while empty is not destructive to the FIFO.

      .full(Full_int),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                     // FIFO is full. Write requests are ignored when the FIFO is full,
                                     // initiating a write when the FIFO is full is not destructive to the
                                     // contents of the FIFO.

      .wr_ack(Wr_ack),               // 1-bit output: Write Acknowledge: This signal indicates that a write
                                     // request (wr_en) during the prior clock cycle is succeeded.
      .wr_rst_busy(wr_rst_busy),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                     // write domain is currently in a reset state.

      .din(Din),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                     // writing the FIFO.

      .injectdbiterr(0), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.

      .injectsbiterr(0), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.
    
      .rd_clk(Rd_clk),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                     // running clock.

      .rd_en(Rd_en),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                     // signal causes data (on dout) to be read from the FIFO. Must be held
                                     // active-low when rd_rst_busy is active high.

      .rst(Ainit),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                     // unstable at the time of applying reset, but reset must be released only
                                     // after the clock(s) is/are stable.

      .sleep(0),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                     // block is in power saving mode.

      .wr_clk(Wr_clk),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                     // free running clock.

      .wr_en(Wr_en)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                     // signal causes data (on din) to be written to the FIFO. Must be held
                                     // active-low when rst or wr_rst_busy is active high.

   );
*/

endmodule
