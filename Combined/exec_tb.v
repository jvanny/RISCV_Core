`timescale 1ns / 1ps
module exec_tb();

//inputs into EX stage
reg [1:0] ALUop;
reg alusrc;

reg [31:0] pc;
reg [31:0] imm;

reg [31:0] rd1;
reg [31:0] rd2;

reg [2:0] funct3;
reg funct7_30;

//module outputs
wire [31:0] result_adder;

wire [3:0] ALUctrl;

wire [31:0] result_alu;
wire zero; 

wire [31:0] muxout;


//Inst ADDER
ADDER adder_inst(
    .pc(pc),
    .imm(imm),
    .result(result_adder)
);
//Inst ALU_Control
ALU_Control aluctrl_inst(
    .ALUop(ALUop),
    .funct3(funct3),
    .funct7_30(funct7_30),
    .ALUctrl(ALUctrl)
);
//Inst ALU
ALU alu_inst(
    .A(rd1),
    .B(muxout),
    .ALUctrl(ALUctrl),
    .result(result_alu),
    .zero(zero)
);
//Inst ALUsrc mux
ALUsrc alusrc_inst(
    .imm(imm),
    .rd2(rd2),
    .alusrc(alusrc),
    .muxout(muxout)
);

    initial begin
        
        // Initialize
        ALUop = 2'b00;
        alusrc = 0;
        funct7_30 = 0;
        pc = 32'b0; 
        imm = 32'b0;
        rd1 = 32'b0;
        rd2 = 32'b0;
        funct3 = 3'b0;
        $display("--- Starting Execution Stage Test ---");
        #5
        $display("Time:%0t | result_adder:%b | ALUctrl:%b | result_alu:%b | zero:%b | muxout:%b", 
          $time, result_adder, ALUctrl, result_alu, zero, muxout);

        //begin test
        //ADD rd1 and rd2
        ALUop = 2'b10;
        alusrc = 0;

        funct3 = 3'b0;
        funct7_30 = 0;

        rd1 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;

        //pc = 32'b0; 

        //imm = 32'b0;
        rd2 = 32'b0000_0000_0000_0000_0000_0000_1000_0000;
        #5
        $display("Time:%0t | result_adder:%b | ALUctrl:%b | result_alu:%b | zero:%b | muxout:%b", 
          $time, result_adder, ALUctrl, result_alu, zero, muxout);

        #5
        //AND rd1 and rd2
        ALUop = 2'b10;
        alusrc = 0;

        funct3 = 3'b111;
        funct7_30 = 0;

        rd1 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;

        //pc = 32'b0; 

        //imm = 32'b0;
        rd2 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
        #5
        $display("Time:%0t | result_adder:%b | ALUctrl:%b | result_alu:%b | zero:%b | muxout:%b", 
          $time, result_adder, ALUctrl, result_alu, zero, muxout);

        #5
        //Add rd1 and imm
        ALUop = 2'b11;
        alusrc = 1;

        funct3 = 3'b0;
        funct7_30 = 0;

        rd1 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;

        //pc = 32'b0; 

        //imm = 32'b0;
        imm = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
        #5
        $display("Time:%0t | result_adder:%b | ALUctrl:%b | result_alu:%b | zero:%b | muxout:%b", 
          $time, result_adder, ALUctrl, result_alu, zero, muxout);

        #5
        //SUB rd1 and rd2
        ALUop = 2'b10;
        alusrc = 0;

        funct3 = 3'b000;
        funct7_30 = 1;

        rd1 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;

        //pc = 32'b0; 

        //imm = 32'b0;
        rd2 = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
        #5
        $display("Time:%0t | result_adder:%b | ALUctrl:%b | result_alu:%b | zero:%b | muxout:%b", 
          $time, result_adder, ALUctrl, result_alu, zero, muxout);
        $display("Integration Test Complete.");
        $finish;

    end
    
endmodule