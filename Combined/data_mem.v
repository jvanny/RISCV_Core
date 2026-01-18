module data_mem(clk, rd2, address, mw, mr, funct3, clk, rs2_out);

input clk;
input [31:0] rd2;
input [31:0] address;
input mw;
input mr;
input [2:0] funct3;

output reg [31:0] rs2_out;

reg [31:0] mem [0:8191];

always @(*) begin

if (mr) begin
    case (funct3) 

        3'b000: rs2_out = {{24{mem[address[14:2]][7]}}, mem[address[14:2]][7:0]};
        3'b001: rs2_out = {{16{mem[address[14:2]][15]}}, mem[address[14:2]][15:0]};
        3'b010: rs2_out = mem[address[14:2]];
        3'b100: rs2_out = {24'b0,mem[address[14:2]][7:0]};
        3'b101: rs2_out = {16'b0,mem[address[14:2]][15:0]};
        default: rs2_out = 32'b0;
    endcase

    end else begin
        rs2_out = 32'b0;
        
    end
end

always @(posedge clk) begin

    if (mw) begin
        case (funct3)
        
        3'b000: case(address[1:0])
            2'b00: mem[address[14:2]][7:0] <= rd2[7:0];
            2'b01: mem[address[14:2]][15:8] <= rd2[7:0];
            2'b10: mem[address[14:2]][23:16] <= rd2[7:0];
            2'b11: mem[address[14:2]][31:24] <= rd2[7:0];
        endcase

        3'b001: case(address[1])
            1'b0: mem[address[14:2]][15:0] <= rd2[15:0];
            1'b1: mem[address[14:2]][31:16] <= rd2[15:0];
        endcase
        
        3'b010: mem[address[14:2]] <= rd2;
        
        endcase
        
    end

end

endmodule