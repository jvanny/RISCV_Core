module id_ex_reg(clk, reset, flush, 
                pc_in ,pc4_in ,ALU_Op_in, ALUSrc_in, br_in, mr_in, mw_in, rw_in, mtr_in, j_in, jr_in, rd1_in, rd2_in, imm_in, funct3_in, instr30_in, regdest_in, rs1_in, rs2_in,
                pc_out ,pc4_out ,ALU_Op_out, ALUSrc_out, br_out, mr_out, mw_out, rw_out, mtr_out, j_out, jr_out, rd1_out, rd2_out, imm_out, funct3_out, instr30_out, regdest_out, rs1_out, rs2_out);

input clk;
input flush;
input reset;

input [31:0] pc_in;
input [31:0] pc4_in;
input [1:0] ALU_Op_in;
input ALUSrc_in;
input br_in;
input mr_in;
input mw_in;
input rw_in;
input [1:0] mtr_in;
input j_in;
input jr_in;
input [31:0] rd1_in;
input [31:0] rd2_in;
input [31:0] imm_in;
input [2:0] funct3_in;
input instr30_in;
input [4:0] regdest_in;
input [4:0] rs1_in;
input [4:0] rs2_in;

output reg [31:0] pc_out;
output reg [31:0] pc4_out;
output reg [1:0] ALU_Op_out;
output reg ALUSrc_out;
output reg br_out;
output reg mr_out;
output reg mw_out;
output reg rw_out;
output reg [1:0] mtr_out;
output reg  j_out;
output reg  jr_out;
output reg [31:0] rd1_out;
output reg [31:0] rd2_out;
output reg [31:0] imm_out;
output reg [2:0] funct3_out;
output reg instr30_out;
output reg [4:0] regdest_out;
output reg [4:0] rs1_out;
output reg [4:0] rs2_out;

always @(posedge clk) begin
    if(flush || reset) begin
        pc_out <= 32'b0;
        pc4_out <= 32'b0;
        ALU_Op_out <= 2'b0;
        ALUSrc_out <= 0;
        br_out <= 0;
        mr_out <= 0;
        mw_out <= 0;
        rw_out <= 0;
        mtr_out <= 2'b0;
        j_out <= 0;
        jr_out <= 0;
        rd1_out <= 32'b0;
        rd2_out <= 32'b0;
        imm_out <= 32'b0;
        funct3_out <= 3'b0;
        instr30_out <= 0;
        regdest_out <= 5'b0;
        rs1_out <= 5'b0;
        rs2_out <= 5'b0;

    end else begin
        pc_out <= pc_in;
        pc4_out <= pc4_in;
        ALU_Op_out <= ALU_Op_in;
        ALUSrc_out <= ALUSrc_in;
        br_out <= br_in;
        mr_out <= mr_in;
        mw_out <= mw_in;
        rw_out <= rw_in;
        mtr_out <= mtr_in;
        j_out <= j_in;
        jr_out <= jr_in;
        rd1_out <= rd1_in;
        rd2_out <= rd2_in;
        imm_out <= imm_in;
        funct3_out <= funct3_in;
        instr30_out <= instr30_in;
        regdest_out <= regdest_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
    end

end
endmodule