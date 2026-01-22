module ADDER (pc, imm, result);

input [31:0] pc;
input [31:0] imm;

output reg [31:0] result;

always @ (*) begin

result = pc + imm;

end

endmodule