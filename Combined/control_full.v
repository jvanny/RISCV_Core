`timescale 1ns / 1ps

module tb_control();

    // Inputs
    reg [6:0] opcode;
    reg [2:0] funct3;

    // Outputs
    wire [1:0] ALUo;
    wire ALUs, br, mr, mw, rw, j;
    wire [1:0] mtr;
    wire [2:0] BranchType, MemType;

    // Instantiate the Unit Under Test (UUT)
    control uut (
        .opcode(opcode), .funct3(funct3),
        .ALUo(ALUo), .ALUs(ALUs), .br(br),
        .mr(mr), .mw(mw), .rw(rw),
        .mtr(mtr), .j(j),
        .BranchType(BranchType), .MemType(MemType)
    );

    // Task for verification to keep code clean
    task check_outputs(input [31:0] instr_name, input expected_rw, input [1:0] expected_mtr, input expected_j);
        begin
            #10; // Wait for logic to settle
            if (rw !== expected_rw || mtr !== expected_mtr || j !== expected_j) begin
                $display("FAIL: %s | rw=%b (exp %b), mtr=%b (exp %b), j=%b (exp %b)", 
                          instr_name, rw, expected_rw, mtr, expected_mtr, j, expected_j);
            end else begin
                $display("PASS: %s", instr_name);
            end
        end
    endtask

    initial begin
        $display("Starting Control Unit Test for DOOM-compatible core...");
        $display("-----------------------------------------------------");

        // TEST 1: R-Type (e.g., ADD)
        opcode = 7'b0110011; funct3 = 3'b000;
        check_outputs("R-TYPE ", 1, 2'b00, 0);

        // TEST 2: I-Load (e.g., LW)
        opcode = 7'b0000011; funct3 = 3'b010;
        check_outputs("I-LOAD ", 1, 2'b01, 0);

        // TEST 3: I-Math (e.g., ADDI)
        opcode = 7'b0010011; funct3 = 3'b000;
        check_outputs("I-MATH ", 1, 2'b00, 0);

        // TEST 4: S-Type (e.g., SW)
        opcode = 7'b0100011; funct3 = 3'b010;
        check_outputs("S-TYPE ", 0, 2'bxx, 0);

        // TEST 5: B-Type (e.g., BNE)
        opcode = 7'b1100011; funct3 = 3'b001;
        check_outputs("B-TYPE ", 0, 2'bxx, 0);

        // TEST 6: JAL (Function Call)
        opcode = 7'b1101111; 
        check_outputs("JAL    ", 1, 2'b10, 1);

        // TEST 7: JALR (Function Return)
        opcode = 7'b1100111; funct3 = 3'b000;
        check_outputs("JALR   ", 1, 2'b10, 1);

        // TEST 8: LUI (Loading texture addresses)
        opcode = 7'b0110111;
        check_outputs("LUI    ", 1, 2'b00, 0);

        // TEST 9: AUIPC (PC-relative pointers)
        opcode = 7'b0010111;
        check_outputs("AUIPC  ", 1, 2'b00, 0);

        $display("-----------------------------------------------------");
        $display("Testing Complete.");
        $finish;
    end
endmodule