module control(

input [6:0] opcode,
//input [2:0] funct3,

output reg [1:0] ALUo, //00 for mem/jumps, 01 for Branches, 10 for R type math, 11 for Immediate math
output reg ALUs, //0 rd2, 1 ImmGen
output reg br, //0 ALU result, 1 branch
output reg mr, //0 do nothing, 1 read from memory
output reg mw, //0 do nothing, 1 write to mem
output reg rw, //0 do nothing, 1 enabvle register write
output reg [1:0] mtr, //determines what to write to rd 00 for ALU, 01 for load data memory access, 10 for jumps (save pc+4), 11 immediate
output reg j, //0 do nothing, 1 jump instruction
output reg jr
//output reg [2:0] funct3_out, //funct3 bits
//output reg [2:0] BranchType, // Tells Branch Logic: 000 BEQ, 001 BNE, 100 BLT, 101 BGE, 110 BLTU, 111 BGEU
//output reg [2:0] MemType     // Tells Memory: 000 LB, 001 LH, 010 LW, 100 LBU, 101 LHU
);

always @(*) begin
//base/default assignments
        ALUo = 2'b00;
        ALUs = 1'b0;
        br = 1'b0;
        mr = 1'b0;
        mw = 1'b0;
        rw = 1'b0;
        mtr = 2'b00;
        j = 1'b0;
        jr = 1'b0;
        //BranchType = funct3;
        //MemType = funct3;

case(opcode)


//R-type
    7'b0110011: begin
            ALUo = 2'b10;
            //ALUs = 1'b0;
            //br = 1'b0;
            //mr = 1'b0;
            //mw = 1'b0;
            rw = 1'b1;
            //mtr = 1'b0;
    end
//I-Load
    7'b0000011: begin
            //ALUo = 2'b00;
            ALUs = 1'b1;
            //br = 1'b0;
            mr = 1'b1;
            //mw = 1'b0;
            rw = 1'b1;
            mtr = 2'b01;         
    end

//I-Math
    7'b0010011: begin
            ALUo = 2'b11;
            ALUs = 1'b1;
            //br = 1'b0;
            //mr = 1'b1;
            //mw = 1'b0;
            rw = 1'b1;
            //mtr = 1'b1;         
    end
//S-Type
    7'b0100011: begin
            //ALUo = 2'b00;
            ALUs = 1'b1;
            //br = 1'b0;
            //mr = 1'b0;
            mw = 1'b1;
            //rw = 1'b0;
            mtr = 2'b00;
            //MemType = funct3;
    end
//B-Type
    7'b1100011: begin
            ALUo = 2'b01;
            //ALUs = 1'b0;
            br = 1'b1;
            //mr = 1'b0;
            //mw = 1'b0;
            //rw = 1'b0;
            mtr = 2'b00;
            //BranchType = funct3;
    end
//JAL
    7'b1101111: begin
            rw = 1;
            j = 1;
            mtr = 2'b10; // Select PC+4 to write to RD
        end
//JALR
        7'b1100111: begin
            rw = 1;
            jr = 1;
            ALUs = 1;     // Use immediate for the offset
            mtr = 2'b10; // Select PC+4 to write to RD
            ALUo = 2'b00; // Force ADD to calculate the target address
        end

//LUI
    7'b0110111: begin
            ALUo = 2'b11;
            ALUs = 1'b1;
            //br = 1'b0;
            //mr = 1'b0;
            //mw = 1'b0;
            rw = 1'b1;
            mtr = 2'b00;
    end

//AUIPC
    7'b0010111: begin
            ALUo = 2'b11;
            ALUs = 1'b1;
            //br = 1'b0;
            //mr = 1'b0;
            //mw = 1'b0;
            rw = 1'b1;
            mtr = 2'b00;
    end

default: ;

endcase


end
endmodule