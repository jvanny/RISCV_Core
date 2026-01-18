module pcadder(pc, pc4_out);

input [31:0] pc;

output reg [31:0] pc4_out;

always @(*) begin
    pc4_out = pc + + 32'd4;
    
end

endmodule
