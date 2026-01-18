module forward(rs1, rs2, rd_mem, rd_wb, rw_mem, rw_wb, fwdA, fwdB);

input [4:0] rs1;
input [4:0] rs2;
input [4:0] rd_mem;
input [4:0] rd_wb;
input rw_mem;
input rw_wb;

output reg [1:0] fwdA;
output reg [1:0] fwdB;

always @(*) begin
    fwdA = 2'b00;
    fwdB = 2'b00;


if(rw_mem && (rd_mem != 5'b0) && (rs1==rd_mem)) begin
        fwdA = 2'b01;
end else if(rw_wb && (rd_wb != 5'b0) && (rs1==rd_wb)) begin
        fwdA = 2'b10;
    end

if(rw_mem && (rd_mem != 5'b0) && (rs2==rd_mem)) begin
        fwdB = 2'b01;
end else if(rw_wb && (rd_wb != 5'b0) && (rs2==rd_wb)) begin
        fwdB = 2'b10;
    end

end
endmodule