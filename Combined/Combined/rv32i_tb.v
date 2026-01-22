`timescale 1ns / 1ps
module rv32i_tb;

reg clk;
reg reset;

rv32i_top RV32I(
    .clk(clk),
    .reset(reset)
);

initial begin
    // Force all registers to 0 at time 0
    for (integer j = 0; j < 32; j = j + 1) begin
        RV32I.REG.reg_mem[j] = 32'b0;
    end
end

initial begin
    clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz)
    end
    
initial begin
        reset = 1;
        #10 
        reset = 0;

        #700; // Wait for program to finish

        $display("\n--- FINAL REGISTER DUMP ---");
        dump_registers();
        $display("---------------------------\n");
        $finish;
    end
    
task dump_registers;
        integer i;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                // This path must match your hierarchy: InstanceName.SubModuleName.ArrayName
                $display("Register x%02d: %h", i, RV32I.REG.reg_mem[i]);
            end
        end
    endtask

initial begin
    //$monitor("Time: %t | PC: %h | x5: %d | x8: %d | x9: %d | x10: %d | x11: %d | br_ex: %b | zero_ex: %d | Input A: %d | Input B: %d | br_mem: %b | zero_mem: %d | PCsrc_mem: %b | jump: %b |", 
    //         $time, RV32I.PC_OUT_if, RV32I.REG.reg_mem[5], RV32I.REG.reg_mem[8], RV32I.REG.reg_mem[9], RV32I.REG.reg_mem[10], RV32I.REG.reg_mem[11], RV32I.EXMEMREG.br_in, RV32I.EXMEMREG.zero_in, RV32I.ALUEX.B, RV32I.ALUEX.A, RV32I.EXMEMREG.br_out, RV32I.EXMEMREG.zero_out, RV32I.BRANCH_JUMP_UNIT.PCsrc, RV32I.EXMEMREG.j_out);

    $monitor("Time: %t | PC: %h | x5: %d | br_ex: %b | zero_ex: %d | Input A: %d | Input B: %d | br_mem: %b | zero_mem: %d | PCsrc_mem: %b | jump: %b |",
            $time, RV32I.PC_OUT_if, RV32I.REG.reg_mem[5], RV32I.EXMEMREG.br_in, RV32I.EXMEMREG.zero_in, RV32I.ALUEX.B, RV32I.ALUEX.A, RV32I.EXMEMREG.br_out, RV32I.EXMEMREG.zero_out, RV32I.BRANCH_JUMP_UNIT.PCsrc, RV32I.EXMEMREG.j_out);
end
    initial begin
    $dumpfile("rv32i_sim.vcd"); // Creates the waveform file
    $dumpvars(0, rv32i_tb);    // Dumps all signals in the TB and below
end



endmodule