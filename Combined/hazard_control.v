module hazard_control(rs1_id, rs2_id, rd_ex, mr_ex, PCsrc, pc_stall, if_id_stall, if_id_flush, id_ex_flush, ex_mem_flush);

input [4:0] rs1_id;
input [4:0] rs2_id;
input [4:0] rd_ex;
input mr_ex;
input PCsrc;

output reg pc_stall, if_id_stall;

output reg if_id_flush, id_ex_flush, ex_mem_flush;


always @ (*) begin
if_id_flush = 0;
id_ex_flush = 0; 
ex_mem_flush = 0;
pc_stall = 0;
if_id_stall = 0;

if(PCsrc) begin
    if_id_flush = 1;
    id_ex_flush = 1;
    ex_mem_flush = 1;
    end

else if(mr_ex && (rd_ex == rs1_id || rd_ex == rs2_id) && (rd_ex != 5'b0)) begin

    pc_stall = 1;
    if_id_stall = 1;
    id_ex_flush = 1;

end

end

endmodule