module debug_output(
    input clk,
    input rst,
    
    input [1:0] mode,//（0：输出 PC，1：输出 PC 及指令，2：输出所有信息。上电默认值：2'd1
    
    input [31:0] debug_wb_pc,
    input [31:0] debug_wb_instr,
    input [31:0] debug_wb_rf_wdata,

    output [3:0] data
);
function logic [3:0] se96(input logic [95:0] in, input logic[4:0] se);
	case(se)
        5'd0:return in[3:0];
        5'd1:return in[7:4];
        5'd2:return in[11:8];
        5'd3:return in[15:12];
        5'd4:return in[19:16];
        5'd5:return in[23:20];
        5'd6:return in[27:24];
        5'd7:return in[31:28];
        5'd8:return in[35:32];
        5'd9:return in[39:36];
        5'd10:return in[43:40];
        5'd11:return in[47:44];
        5'd12:return in[51:48];
        5'd13:return in[55:52];
        5'd14:return in[59:56];
        5'd15:return in[63:60];
        5'd16:return in[67:64];
        5'd17:return in[71:68];
        5'd18:return in[75:72];
        5'd19:return in[79:76];
        5'd20:return in[83:80];
        5'd21:return in[87:84];
        5'd22:return in[91:88];
        5'd23:return in[95:92];
	endcase
endfunction

function logic [3:0] se64(input logic [63:0] in, input logic[4:0] se);
	case(se)
        5'd0:return in[3:0];
        5'd1:return in[7:4];
        5'd2:return in[11:8];
        5'd3:return in[15:12];
        5'd4:return in[19:16];
        5'd5:return in[23:20];
        5'd6:return in[27:24];
        5'd7:return in[31:28];
        5'd8:return in[35:32];
        5'd9:return in[39:36];
        5'd10:return in[43:40];
        5'd11:return in[47:44];
        5'd12:return in[51:48];
        5'd13:return in[55:52];
        5'd14:return in[59:56];
        5'd15:return in[63:60];
	endcase
endfunction

function logic [3:0] se32(input logic [31:0] in, input logic[4:0] se);
	case(se)
        5'd0:return in[3:0];
        5'd1:return in[7:4];
        5'd2:return in[11:8];
        5'd3:return in[15:12];
        5'd4:return in[19:16];
        5'd5:return in[23:20];
        5'd6:return in[27:24];
        5'd7:return in[31:28];
	endcase
endfunction

logic [31:0] r_now_pc, r_now_instr, r_now_wdata;
logic [1:0] r_now_mode;
logic r_changed_flag, w_changed_flag, w_finish, r_finish;
logic r_is_work, w_is_work;//1:work 0:touch fish
logic [63:0] w_pc_instr;
logic [95:0] w_pc_instr_wdata;
logic [4:0] r_cnt;
logic [3:0] w_data;
logic [6:0] w_temp, w_temp_3;
assign w_temp = r_cnt << 2;
assign w_temp_3 = r_cnt + 3;
const logic [4:0] mode_1_cnt = 7;
const logic [4:0] mode_2_cnt = 15;
const logic [4:0] mode_3_cnt = 23;
assign w_pc_instr = {r_now_instr, r_now_pc};
assign w_pc_instr_wdata = {r_now_wdata, r_now_instr, r_now_pc};
assign w_finish = ((r_now_mode == 2'd0 && r_cnt == mode_1_cnt) 
                || (r_now_mode == 2'd1 && r_cnt == mode_2_cnt) 
                || (r_now_mode == 2'd2 && r_cnt == mode_3_cnt)) && r_is_work;

assign data = r_is_work ? w_data : '0;
always_comb begin
    if(r_now_mode == 2'b0) begin
        w_data = se32(r_now_pc,r_cnt);
    end
    else if(r_now_mode == 2'd1) begin
        w_data = se64(w_pc_instr,r_cnt);
    end
    else if(r_now_mode == 2'd2) begin

        w_data = se96(w_pc_instr_wdata,r_cnt);
    end
end

always_comb begin 
    w_changed_flag = r_changed_flag;
    if(w_changed_flag == 1'b1) begin
        if(w_finish) begin
            w_changed_flag = '0;
        end
    end
    else begin
        if(debug_wb_pc != r_now_pc) begin
            w_changed_flag = 1'b1;
        end
    end
end

always_comb begin
    w_is_work = r_is_work;
    if(w_is_work == 1'b1) begin
        if(w_finish) begin
            w_is_work = 0;
        end
    end
    else begin
        if(w_changed_flag && debug_wb_pc != '0) begin
            w_is_work = 1'b1;
        end
    end
end

always_ff @(posedge clk) begin
    if(rst) begin
        r_now_pc <= '0;
        r_now_instr <= '0;
        r_now_mode <= 2'd1;
        r_now_wdata <= '0;
        r_changed_flag <= '0;
        r_is_work <= '0;
        r_cnt <= '0;
    end
    else begin
        r_changed_flag <= w_changed_flag;
        r_finish <= w_finish;
        r_is_work <= w_is_work;
        if(!r_is_work && w_changed_flag) begin
            r_now_pc <= debug_wb_pc;
            r_now_instr <= debug_wb_instr;
            r_now_wdata <= debug_wb_rf_wdata;
            r_now_mode <= mode;
            r_cnt <= '0;
        end
        else if(r_is_work) begin
            r_cnt <= r_cnt + 1;
        end
    end
end

endmodule
