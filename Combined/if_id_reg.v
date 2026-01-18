module if_id_reg(clk, reset, stall, flush, pc_in ,pc4_in ,instr_in, pc_out ,pc4_out ,instr_out);

input [31:0] pc_in;
input [31:0] pc4_in;
input [31:0] instr_in;
input clk;
input stall;
input flush;
input reset;

output reg [31:0] pc_out;
output reg [31:0] pc4_out;
output reg [31:0] instr_out;

always @(posedge clk) begin
    if(flush || reset) begin
        pc_out <= 32'b0;
        pc4_out <= 32'b0;
        instr_out <= 32'h00000013;

    end else if(!stall) begin
        pc_out <= pc_in;
        pc4_out <= pc4_in;
        instr_out <= instr_in;
    end

end
endmodule