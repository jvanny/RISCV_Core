module ALUsrc(imm, rd2, muxout, alusrc);

input [31:0] imm;
input [31:0] rd2;
input alusrc;

output reg [31:0] muxout;
always @(*) begin
case(alusrc)

    1'b0: muxout = rd2;
    1'b1: muxout = imm;
    default: muxout = 32'b0;
endcase
end
endmodule