module branch_unit(br, j, jr, zero, funct3, neg, overflow, carry, PCsrc);

//TODO
//Need to beef up branch unit to handle all B-type instructions using the br control signal to verify the instr is a branch and then determining what the output should be.
//This requires ALU modification to output negatives and overflow indicators
//

input br;
input j;
input jr;
input zero;
input [2:0] funct3;
input neg;

input overflow;
input carry;

output reg PCsrc;

//this is used for signed less than comparisons to determine the true sign bit in case of overflow
wire slt = neg ^ overflow;

//this is used for unsigned less than comparisons to determine whether the sign bit (31) flipped due to carry over
wire ult = !carry;

always @(*) begin
    PCsrc = 1'b0;

    if (j || jr) begin
        PCsrc = 1'b1;
        
    end else if(br) begin 
        
        case (funct3)
        3'b000: PCsrc = br & zero; //BEQ
        3'b001: PCsrc = br & !zero; //BNE
        3'b100: PCsrc = br & slt; //BLT
        3'b101: PCsrc = br & !slt; //BGE
        3'b110: PCsrc = br & ult; //BLTU
        3'b111: PCsrc = br & !ult; //BGEU
        default: PCsrc = 1'b0;

endcase

    end else begin
        PCsrc = 1'b0;
    end
    
end

endmodule