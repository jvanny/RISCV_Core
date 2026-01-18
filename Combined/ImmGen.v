//Take in an instruciton, determine the instruction type, and output the immediate value which is sign extended

module ImmGen (instr, immout);

input [31:0] instr;

output reg [31:0] immout;

reg [6:0] opcode;
//Define instruction types
//Rtype has no immediate
//arithmetic immediate instructions
localparam IRTYPE = 7'b0010011;
//LOAD instructions
localparam ILTYPE = 7'b0000011;
//STORES
localparam STYPE = 7'b0100011;
//LUI
localparam UPPERUTYPE = 7'b0110111;
//AUIPC
localparam ALUUTYPE = 7'b0010111;
//JUMP
localparam JTYPE = 7'b1101111;
//JUMP AND LINK REGISTER
localparam JRTYPE = 7'b1100111;
//BRANCH
localparam BTYPE = 7'b1100011;
//SYSTEM - no immediate values

//Check input instruction to determine what type of instruction it is

always @ (*) begin
    opcode = instr[6:0];

    case (opcode)

        IRTYPE, ILTYPE, JRTYPE: begin

            immout = { {21{instr[31]}}, instr[30:20] };
        end 
   
        STYPE: begin

            immout = { {21{instr[31]}}, instr[30:25], instr[11:7] };
        end

        BTYPE: begin

            //immout = { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 };
            immout = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };

        end

        UPPERUTYPE, ALUUTYPE: begin


            immout = { instr[31:12], 12'b0 };

        end

        JTYPE: begin

            immout = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 };

        end

        default: begin
            immout[31:0] = 32'b0;
        end

    endcase

end

endmodule