module ALU(A, B, ALUctrl, result, zero, neg, carry, overflow);

//A = rd1, B=muxout
input [31:0] A;
input [31:0] B;
input [3:0] ALUctrl;
    
output reg [31:0] result;
output zero;
output neg;
output carry;
output overflow;

wire [32:0] sub_result;
wire [32:0] add_result; 
assign sub_result = {1'b1, A} - {1'b0, B};
assign add_result = {1'b0, A} + {1'b0, B};

assign zero = (result == 0);
assign neg = result[31];
assign carry = (sub_result[32] || add_result[32]);
assign overflow = (A[31] != B[31]) && (result[31] != A[31]);

always @ (*) begin

case (ALUctrl)

//AND
4'b0000:begin

    result = A & B;

end
//OR
4'b0001:begin

    result = A | B;

end
//add
4'b0010: begin

    result = A + B;

end
//SLL
4'b0100: begin
//hardware only uses last 5 bits for shifts
    result = A << B[4:0];

end

//SLTU
4'b1000: begin

    result = (A < B) ? 1 : 0;

end

//NOR
4'b1100: begin

    result = ~(A | B);

end

//SLT
4'b0111: begin

    result = ($signed(A) < $signed(B)) ? 1 : 0;

end

//SRL
4'b1010: begin

    result = A >> B[4:0];

end

//XOR
4'b0011: begin

    result = A ^ B;

end

//sub
4'b0110: begin

    result = A - B;
    

end

//SRA
4'b1101: begin

    result = $signed(A) >>> B[4:0];

end

default: begin

result = 32'b0;

end

endcase

end

endmodule