module ALU_Control(ALUop, funct3, funct7_30, ALUctrl);

input [1:0] ALUop;
input [2:0] funct3;
input funct7_30;

output reg [3:0] ALUctrl;

localparam AND = 4'b0000;
localparam OR = 4'b0001;
localparam ADD = 4'b0010;
localparam SLL = 4'b0100;
localparam SLTU = 4'b1000;
localparam NOR = 4'b1100;
localparam SLT = 4'b0111;
localparam SRL = 4'b1010;
localparam XOR = 4'b0011;
localparam SUB = 4'b0110;
localparam SRA = 4'b1101;


always @(*) begin

case (ALUop)

    //load/store/jump
    2'b00: ALUctrl = ADD;

    //branch
    2'b01: begin
        case(funct3)
        3'b000: ALUctrl = SUB;
        3'b001: ALUctrl = SUB;
        3'b100: ALUctrl = SLT;
        3'b101: ALUctrl = SLT;
        3'b110: ALUctrl = SLTU;
        3'b111: ALUctrl = SLTU;
        default: ALUctrl = SUB;
        endcase
    end
    //R-type math
    2'b10: begin
        case(funct3)

            3'b000: begin
                case(funct7_30)
                    1'b0: ALUctrl = ADD;
                    1'b1: ALUctrl = SUB;
                endcase
                end

            3'b001: begin

                ALUctrl = SLL;
            
                end

            3'b010: begin

                ALUctrl = SLT;
            
                end
            
            3'b011: begin
            
                ALUctrl = SLTU;

                end

            3'b100: begin
            
                ALUctrl = XOR;

                end

            3'b101: begin
                case(funct7_30)
                1'b0: ALUctrl = SRL;
                1'b1: ALUctrl = SRA;
                endcase

                end

            3'b110: begin

                ALUctrl = OR;
            
                end

            3'b111: begin

                ALUctrl = AND;
            
                end
            default: ALUctrl = ADD;
        endcase


    end
    //I-type math
    2'b11: begin
        case(funct3)

            3'b000: begin

                ALUctrl = ADD;
            
                end

            3'b001: begin

                ALUctrl = SLL;
            
                end

            3'b010: begin

                ALUctrl = SLT;
            
                end
            
            3'b011: begin
            
                ALUctrl = SLTU;

                end

            3'b100: begin
            
                ALUctrl = XOR;

                end

            3'b101: begin
                case(funct7_30)
                1'b0: ALUctrl = SRL;
                1'b1: ALUctrl = SRA;
                endcase

                end

            3'b110: begin

                ALUctrl = OR;
            
                end

            3'b111: begin

                ALUctrl = AND;
            
                end
            default: ALUctrl = ADD;
        endcase

    end
    

endcase
end


endmodule