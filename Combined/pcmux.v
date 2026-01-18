module pcmux(PCsrc, br_addr, pc4, pcmux_out);

input PCsrc;
input [31:0] br_addr;
input [31:0] pc4;

output reg [31:0] pcmux_out;

always @(*) begin
    
    case(PCsrc)

    1'b0: pcmux_out = pc4;
    1'b1: pcmux_out = br_addr;

    endcase
    
end


endmodule
