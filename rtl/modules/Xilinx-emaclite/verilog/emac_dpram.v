module emac_dpram #(
    parameter C_SELECT_XPM = 1
)(
    input Clk,
    input Rst,
    
    input Ce_a,
    input Wr_rd_n_a,
    input [11:0] Adr_a,
    input [3:0]  Data_in_a,
    output [3:0] Data_out_a,
    
    input Ce_b,
    input Wr_rd_n_b,
    input [8:0] Adr_b,
    input [31:0] Data_in_b,
    output [31:0] Data_out_b
    );
  
generate if (!C_SELECT_XPM) begin
reg [2:0] OffsetAQ;
wire [2:0] OffsetA = Adr_a[2:0];
wire [31:0] QA;
assign Data_out_a = (QA >> {OffsetAQ, 2'b0}); 

always @(posedge Clk) begin
    OffsetAQ <= OffsetA;
end

wire [31:0] DA = Data_in_a << {OffsetA, 2'b0};
wire [31:0] BWENA =4'hF << {OffsetA, 2'b0};

S018DP_RAM_DP_W512_B32_M4_BW t(
        .QA(QA),
        .QB(Data_out_b),
	    .CLKA(Clk),
	    .CLKB(Clk),
	    .CENA(~Ce_a),
		.CENB(~Ce_b),
		.WENA(~Wr_rd_n_a),
		.WENB(~Wr_rd_n_b),
        .BWENA(~BWENA),
        .BWENB(~(32'hFFFFFFFF)),
		.AA(Adr_a[11:3]),
	    .AB(Adr_b),
		.DA(DA),
		.DB(Data_in_b));
end else begin

 xpm_memory_tdpram #(
		// Common module parameters
		.MEMORY_SIZE(512*32),
		.MEMORY_PRIMITIVE("auto"),
		.CLOCKING_MODE("independent_clock"),
		.USE_MEM_INIT(0),
		.WAKEUP_TIME("disable_sleep"),
		.MESSAGE_CONTROL(0),

		// Port A module parameters
        .WRITE_DATA_WIDTH_A(4),
        .BYTE_WRITE_WIDTH_A(4),
		.READ_DATA_WIDTH_A(4),
		.READ_RESET_VALUE_A("0"),
		.READ_LATENCY_A(1),
		.WRITE_MODE_A("write_first"),

		// Port B module parameters
        .WRITE_DATA_WIDTH_B(32),
        .BYTE_WRITE_WIDTH_B(32),
		.READ_DATA_WIDTH_B(32),
		.READ_RESET_VALUE_B("0"),
		.READ_LATENCY_B(1),
		.WRITE_MODE_B("write_first")
		) xpm_mem (
		// Common module ports
		.sleep          ( 1'b0  ),

		// Port A module ports
		.clka           ( Clk   ),
		.rsta           ( 1'b0   ),
		.ena            ( Ce_a   ),
		.regcea         ( 1'b0  ),
		.wea            ( Wr_rd_n_a ), 
		.addra          ( Adr_a ), 
		.dina           ( Data_in_a ),
		.injectsbiterra ( 1'b0  ), // do not change
		.injectdbiterra ( 1'b0  ), // do not change
		.douta          ( Data_out_a ),
		.sbiterra       (       ), // do not change
		.dbiterra       (       ), // do not change
 
		// Port B module ports
		.clkb           ( Clk   ),
		.rstb           ( 1'b0   ),
		.enb            ( Ce_b   ),
		.regceb         ( 1'b0  ),
		.web            (Wr_rd_n_b), 
		.addrb          ( Adr_b ),
		.dinb           ( Data_in_b ), 
		.injectsbiterrb ( 1'b0  ), // do not change
		.injectdbiterrb ( 1'b0  ), // do not change
		.doutb          ( Data_out_b ),
		.sbiterrb       (       ), // do not change
		.dbiterrb       (       )  // do not change
		);



end
endgenerate
endmodule
