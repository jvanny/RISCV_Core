module wb_mux(ALU_result, data_mem, pc4, imm_in, mtr, wb_out);

input [31:0] ALU_result;
input [31:0] data_mem;
input [31:0] pc4;
input [31:0] imm_in;

input [1:0] mtr;

output reg [31:0] wb_out;

always @(*) begin
    case (mtr)

        2'b00: wb_out = ALU_result;
        2'b01: wb_out = data_mem;
        2'b10: wb_out = pc4;
        2'b11: wb_out = imm_in;
        default: wb_out = 32'b0;

    endcase

end


endmodule