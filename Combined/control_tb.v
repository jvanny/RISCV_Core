module control_tb;

reg [31:0] instr;

wire [1:0] ALUo;
wire ALUs;
wire br;
wire mr;
wire mw;
wire rw;
wire mtr;

control dut(
    .instr(instr),
    .ALUo(ALUo),
    .ALUs(ALUs),
    .br(br),
    .mr(mr),
    .mw(mw),
    .rw(rw),
    .mtr(mtr));

    // Test stimulus
    initial begin

        instr = 32'h00000000;

        $dumpfile("control_test.vcd");
        $dumpvars(0, control_tb);

        // Display initial state and monitor key signals
        $display("-------------------------------------------");
        $display("Initial State: All inputs are reset.");
        $display("-------------------------------------------");
        $monitor("Time=%0t | instr=%b | ALUo=%b | ALUs=%b | br=%b | mr=%b | mw=%b | rw=%b | mtr=%b |", $time, instr, ALUo, ALUs, br, mr, mw, rw, mtr);

        #20;
        // 1. Write a value to register x10
        $display("\n--- Test Case 1: STYPE ---");

        instr = 32'b10101010101010101000100110100011;

        #20;

        $display("\n--- Test Case 2: BTYPE ---");

        instr = 32'b11111111111111111111111111100011;

        #20;
        
        $display("\n--- Test Case 3: RTYPE ---");

        instr = 32'b11111111111111111111111110110011;

        #20;

        $display("\n--- Test Case 3: I-Load-RTYPE ---");

        instr = 32'b11111111111111111111111110000011;

        #20;

        $display("\n--- Simulation Complete ---");
        $finish; // End the simulation
    
    end

endmodule