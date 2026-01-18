`timescale 1ns / 1ps

module tb_id_stage();

    // Inputs
    reg [31:0] instruction;
    reg [31:0] write_data_wb; 
    reg clk, manual_we;       

    // Wires for Interconnect
    wire [6:0] opcode   = instruction[6:0];
    wire [2:0] funct3   = instruction[14:12];
    wire [4:0] rs1_addr = instruction[19:15];
    wire [4:0] rs2_addr = instruction[24:20];
    wire [4:0] rd_addr  = instruction[11:7];

    // Module Outputs
    wire [31:0] rd1_val, rd2_val; 
    wire [31:0] imm_ext;          
    wire [1:0]  alu_op; 
    wire [1:0]  mem_to_reg;       
    wire alu_src, reg_write_ctrl;

    // ---------------------------------------------------------
    // 1. Instantiate YOUR registerFile
    // ---------------------------------------------------------
    registerFile rf_inst (
        .clk(clk),
        .we(manual_we | reg_write_ctrl), 
        .rr1(rs1_addr),
        .rr2(rs2_addr),
        .wr(rd_addr),
        .wd(write_data_wb),
        .rd1(rd1_val),
        .rd2(rd2_val)
    );

    // ---------------------------------------------------------
    // 2. Instantiate YOUR ImmGen
    // ---------------------------------------------------------
    ImmGen imm_inst (
        .instr(instruction),
        .immout(imm_ext)
    );

    // ---------------------------------------------------------
    // 3. Instantiate YOUR control
    // ---------------------------------------------------------
    control ctrl_inst (
        .opcode(opcode),
        .funct3(funct3),
        .ALUo(alu_op),
        .ALUs(alu_src),
        .rw(reg_write_ctrl),
        .mtr(mem_to_reg)
    );

    // Clock Generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz)
    end

    initial begin
        $monitor("Time:%0t | Instr:%h | Opcode:%b | ImmOut:%h | RS1:%d | RS2:%d", 
          $time, instruction, instruction[6:0], imm_ext, rd1_val, rd2_val);
        // Initialize
        clk = 0;
        manual_we = 0;
        instruction = 32'b0;
        write_data_wb = 32'b0;

        $display("Starting Full ID Stage Integration Test...");
        $display("-------------------------------------------");

        // --- STEP 1: PRE-LOAD REGISTERS ---
        @(negedge clk);
        manual_we = 1; 
        write_data_wb = 32'd15;      // Data
        instruction = (1 << 7);      // This sets rd = 1 (bits 11:7)
        @(posedge clk);              // Capture x1 = 15

        @(negedge clk);
        write_data_wb = 32'd3;       // Data
        instruction = (2 << 7);      // This sets rd = 2 (bits 11:7)
        @(posedge clk);              // Capture x2 = 3

        @(negedge clk);
        manual_we = 0;
        //instruction = 32'h0;         // Reset instruction to clear addresses
        //#20;                         // Settle time

        // --- STEP 2: TEST BNE (Branch if x1 != x2) ---
        // Machine code for: bne x1, x2, -4
        // imm[12]=1, imm[10:5]=111111, rs2=2, rs1=1, f3=001, imm[4:1]=1110, imm[11]=1, op=1100011
        instruction = 32'hfe209ee3; 
        #1;
        // --- STEP 2: TEST B-TYPE (BNE x1, x2, offset -4) ---
        // B-Type is the ultimate test for ImmGen bit-mapping
        // Target offset -4 (dec). In RISC-V B-type: 
        // imm[12|10:5] [rs2] [rs1] [f3] [imm 4:1|11] [op]
        // For -4 (binary 1111111111100), we expect imm_ext = 32'hFFFFFFFC
        
        $display("[BNE]  rs1:%0d, rs2:%0d | Imm (Exp -4): %d", rd1_val, rd2_val, $signed(imm_ext));
        if (imm_ext[0] == 1'b0 && $signed(imm_ext) == -4)
            $display("PASS: B-Type ImmGen Correct");
        else
            $display("FAIL: B-Type ImmGen Mismatch: %h", imm_ext);

        // --- STEP 3: TEST U-TYPE (LUI x3, 0x12345) ---
        // Machine Code for LUI: [imm 31:12][rd][0110111]
        instruction = {20'h12345, 5'd3, 7'b0110111};
        #1;
        $display("[LUI]  Imm (Exp 0x12345000): %h", imm_ext);
        if (imm_ext == 32'h12345000)
            $display("PASS: U-Type LUI Correct");
        else
            $display("FAIL: U-Type LUI Mismatch");

        // --- STEP 4: TEST J-TYPE (JAL x1, offset 20) ---
        // Instruction: [imm bits scrambled] [rd] [1101111]
        instruction = 32'b0_0000000000_1_00000101_00001_1101111; // Simplified offset 20
        #1;
        $display("[JAL]  J-Signal: %b | mtr (Exp 10): %b", ctrl_inst.j, mem_to_reg);
        if (ctrl_inst.j == 1'b1 && mem_to_reg == 2'b10)
            $display("PASS: Jump Control Correct");
        else
            $display("FAIL: Jump Control Mismatch");

        $display("-------------------------------------------");
        $display("Integration Test Complete.");
        $finish;
    end

endmodule