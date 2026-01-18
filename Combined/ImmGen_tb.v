`timescale 1ns/1ns

module ImmGen_tb;
reg [31:0] instr;
wire [31:0] immout;

ImmGen dut(
    .instr(instr),
    .immout(immout));

// Test stimulus
    initial begin

        instr = 32'h00000000;

        $dumpfile("ImmGen_test.vcd");
        $dumpvars(0, ImmGen_tb);

        // Display initial state and monitor key signals
        $display("-------------------------------------------");
        $display("Initial State: All inputs are reset.");
        $display("-------------------------------------------");
        $monitor("Time=%0t | instr=%b | immout=%b |", $time, instr, immout);

        #20;
        // 1. Write a value to register x10
        $display("\n--- Test Case 1: IRTYPE ---");

        instr = 32'b10101010101010101000100110010011;

        #20;
        
        $display("\n--- Test Case 2: JTYPE ---");

        instr = 32'b11111111111111111111111111101111;

        #20;
        
        $display("\n--- Test Case 3: RTYPE ---");

        instr = 32'b11111111111111111111111110110011;

        #20
        
        $display("\n--- Simulation Complete ---");
        $finish; // End the simulation

    end

endmodule