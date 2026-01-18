module muxB(rd2, ALU_result_mem, result_wb, fwdB, output_B);

input [31:0] rd2;
input [31:0] ALU_result_mem;
input [31:0] result_wb;
input [1:0] fwdB;

output reg [31:0] output_B;


always @(*) begin

    case (fwdB)

    2'b00: output_B = rd2;
    2'b01: output_B = ALU_result_mem;
    2'b10: output_B = result_wb;
    default: output_B = rd2;

    endcase

end

endmodule