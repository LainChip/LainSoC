`timescale 1ns / 1ps

module ram16x4 (
    input [3:0] Addr,
    input [3:0] D,
    input We,
    input Clk,
    output [3:0] Q
);

reg [3:0] data [15:0];

assign Q = data[Addr];

always @(posedge Clk) begin
    if (We) begin
        data[Addr] <= D;
    end
end    
    
endmodule
