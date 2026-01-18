module muxA(rd1, ALU_result_mem, result_wb, fwdA, output_A);

input [31:0] rd1;
input [31:0] ALU_result_mem;
input [31:0] result_wb;
input [1:0] fwdA;

output reg [31:0] output_A;


always @(*) begin

    case (fwdA)

    2'b00: output_A = rd1;
    2'b01: output_A = ALU_result_mem;
    2'b10: output_A = result_wb;
    default: output_A = rd1;

    endcase

end

endmodule