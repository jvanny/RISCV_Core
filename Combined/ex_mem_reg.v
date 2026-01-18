module ex_mem_reg(clk, reset, flush, 
                pc4_in ,br_in, mr_in, mw_in, rw_in, mtr_in, j_in, jr_in, rd2_in, imm_in, funct3_in, regdest_in, adder_result_in, ALU_result_in, overflow_in, carry_in, zero_in, neg_in,
                pc4_out, br_out, mr_out, mw_out, rw_out, mtr_out, j_out, jr_out, rd2_out, imm_out, funct3_out, regdest_out, adder_result_out, ALU_result_out, overflow_out, carry_out, zero_out, neg_out);

input clk;
//input stall;
input flush;
input reset;

input [31:0] pc4_in;
input br_in;
input mr_in;
input mw_in;
input rw_in;
input [1:0] mtr_in;
input j_in;
input jr_in;
input [31:0] rd2_in;
input [31:0] imm_in;
input [2:0] funct3_in;
input [4:0] regdest_in;
input [31:0] adder_result_in;
input [31:0] ALU_result_in;
input overflow_in;
input carry_in;
input zero_in;
input neg_in;

output reg [31:0] pc4_out;
output reg br_out;
output reg mr_out;
output reg mw_out;
output reg rw_out;
output reg [1:0] mtr_out;
output reg j_out;
output reg jr_out;
output reg [31:0] rd2_out;
output reg [31:0] imm_out;
output reg [2:0] funct3_out;
output reg [4:0] regdest_out;
output reg [31:0] adder_result_out;
output reg [31:0] ALU_result_out;
output reg overflow_out;
output reg carry_out;
output reg zero_out;
output reg neg_out;

always @(posedge clk) begin
    if(flush || reset) begin
        
        pc4_out <= 32'b0;
        br_out <= 0;
        mr_out <= 0;
        mw_out <= 0;
        rw_out <= 0;
        mtr_out <= 2'b0;
        j_out <= 1'b0;
        jr_out <= 1'b0;
        rd2_out <= 32'b0;
        imm_out <= 32'b0;
        funct3_out <= 3'b0;
        regdest_out <= 5'b0;
        adder_result_out <= 32'b0;
        ALU_result_out <= 32'b0;
        overflow_out <= 0;
        carry_out <= 0;
        zero_out <= 0;
        neg_out <= 0;
        


    end else begin
        
        pc4_out <= pc4_in;
        br_out <= br_in;
        mr_out <= mr_in;
        mw_out <= mw_in;
        rw_out <= rw_in;
        mtr_out <= mtr_in;
        j_out <= j_in;
        jr_out <= jr_in;
        rd2_out <= rd2_in;
        imm_out <= imm_in;
        funct3_out <= funct3_in;
        regdest_out <= regdest_in;
        adder_result_out <= adder_result_in;
        ALU_result_out <= ALU_result_in;
        overflow_out <= overflow_in;
        carry_out <= carry_in;
        zero_out <= zero_in;
        neg_out <= neg_in;
        
    end

end


endmodule