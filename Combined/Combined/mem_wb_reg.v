module mem_wb_reg(clk, reset, 
                    pc4_in, rw_in, mtr_in, read_data_in, ALU_result_in, imm_in, regdest_in,
                    pc4_out, rw_out, mtr_out, read_data_out, ALU_result_out, imm_out, regdest_out);

input clk;
input reset;

input [31:0] pc4_in;
input rw_in;
input [1:0] mtr_in;
input [31:0] read_data_in;
input [31:0] ALU_result_in;
input [31:0] imm_in;
input [4:0] regdest_in;

output reg [31:0] pc4_out;
output reg rw_out;
output reg [1:0] mtr_out;
output reg [31:0] read_data_out;
output reg [31:0] ALU_result_out;
output reg [31:0] imm_out;
output reg [4:0] regdest_out;



always @(posedge clk) begin
    if(reset) begin
        pc4_out <= 32'b0;
        rw_out <= 1'b0;
        mtr_out <= 2'b0;
        read_data_out <= 32'b0;
        ALU_result_out <= 32'b0;
        imm_out <= 32'b0;
        regdest_out <= 5'b0;


    end else begin
        pc4_out <= pc4_in;
        rw_out <= rw_in;
        mtr_out <= mtr_in;
        read_data_out <= read_data_in;
        ALU_result_out <= ALU_result_in;
        imm_out <= imm_in;
        regdest_out <= regdest_in;

    end

end

endmodule