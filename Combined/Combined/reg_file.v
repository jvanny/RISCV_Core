//create register file

module reg_file (clk, we, rr1, rr2, wr, wd, rd1, rd2);
//clk and write enable
input clk, we;
//read and write register
input [4:0] rr1;
input [4:0] rr2;
input [4:0] wr;
input [31:0] wd;
//read data out
output [31:0] rd1;
output [31:0] rd2;
//create 32 32 bit registers
reg [31:0] reg_mem [0:31];

//if rr1/rr2 is not 0 then  assign it the value of the register, else make it 0
assign rd1 = (rr1 == 5'b0) ? 32'b0 : ((rr1 == wr) && we) ? wd : reg_mem[rr1];
assign rd2 = (rr2 == 5'b0) ? 32'b0 : ((rr2 == wr) && we) ? wd : reg_mem[rr2];

//if we and the write register is not 0, store the write data in the write register
always @(negedge clk) begin
        if (we && (wr != 5'b0)) begin
            reg_mem[wr] <= wd;
        end
    end

endmodule