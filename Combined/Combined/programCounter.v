//program counter for getting the next address

module programCounter (clk, reset, pc_stall, PC_OUT, PC_IN);


input clk, reset, pc_stall;
input [31:0] PC_IN;

output reg [31:0] PC_OUT;

always@(posedge clk)
begin

    if(reset) begin
        PC_OUT <= 32'h00000000;
    end else if (!pc_stall) begin
        PC_OUT <= PC_IN;
    end

end

endmodule
