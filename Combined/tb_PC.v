`timescale 1ns / 1ps

module tb_programCounter;

    // Parameters for easy modification
    parameter T = 10; // Clock period

    // Testbench signals
    reg clk;
    reg reset;
    reg branch_instr;
    reg [31:0] Branch_Addr;
    wire [31:0] PC_OUT;

    // Instantiate the Device Under Test (DUT)
    programCounter dut (
        .clk(clk),
        .reset(reset),
        .branch_instr(branch_instr),
        .Branch_Addr(Branch_Addr),
        .PC_OUT(PC_OUT)
    );

    // Clock generation invert clk value every T/2
    initial begin
        clk = 0;
        forever #(T/2) clk = ~clk;
    end

    // Main test sequence
    initial begin

        $dumpfile("program_counter.vcd");
        $dumpvars(0, tb_programCounter);

        // 1. Initial State: Reset the PC
        $display("--- Test 1: Reset Condition ---");
        reset = 1;
        branch_instr = 0;
        Branch_Addr = 32'h0;
        #T;
        if (PC_OUT === 32'h00000000) begin
            $display("Reset successful. PC_OUT = 0x%h", PC_OUT);
        end else begin
            $display("Reset failed. Expected 0x00000000, Got 0x%h", PC_OUT);
        end

        // 2. Normal Operation: Sequential Increment
        $display("\n--- Test 2: Sequential Increment ---");
        reset = 0;
        #T; // PC should increment to 0x00000004
        if (PC_OUT === 32'h00000004) begin
            $display("Increment 1 successful. PC_OUT = 0x%h", PC_OUT);
        end else begin
            $display("Increment 1 failed. Expected 0x00000004, Got 0x%h", PC_OUT);
        end
        
        #T; // PC should increment to 0x00000008
        if (PC_OUT === 32'h00000008) begin
            $display("Increment 2 successful. PC_OUT = 0x%h", PC_OUT);
        end else begin
            $display("Increment 2 failed. Expected 0x00000008, Got 0x%h", PC_OUT);
        end

        // 3. Branch Condition
        $display("\n--- Test 3: Branch Instruction ---");
        branch_instr = 1;
        Branch_Addr = 32'hAABBCCDD;
        #T; // PC should load the branch address
        if (PC_OUT === 32'hAABBCCDD) begin
            $display("Branch successful. PC_OUT = 0x%h", PC_OUT);
        end else begin
            $display("Branch failed. Expected 0xAABBCCDD, Got 0x%h", PC_OUT);
        end
        
        // 4. Return to Normal Operation
        $display("\n--- Test 4: Back to Sequential Increment ---");
        branch_instr = 0;
        #T; // PC should increment from the branch address
        if (PC_OUT === 32'hAABBCCE1) begin
            $display("Sequential after branch successful. PC_OUT = 0x%h", PC_OUT);
        end else begin
            $display("Sequential after branch failed. Expected 0xAABBCCE1, Got 0x%h", PC_OUT);
        end

        $finish; // End the simulation
    end

endmodule