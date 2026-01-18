`timescale 1ns / 1ps
module rv32i_tb;

reg clk;
reg reset;

rv32i_top RV32I(
    .clk(clk),
    .reset(reset)
);

initial begin
    clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz)
    end
    
initial begin
        reset = 1;
        #20 reset = 0;

        #5000; // Wait for program to finish

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
    $monitor("Time: %t | PC: %h | Instr: %h | ALU_Out: %h | WB_Reg: %d | WB_Data: %h | br: %b | PCsrc: ", 
             $time, RV32I.PC_OUT_if, RV32I.instr_if, RV32I.ALU_result_ex, RV32I.regdest_wb, RV32I.result_wb, RV32I.br_mem, RV32I.PCsrc_mem);
end
    initial begin
    $dumpfile("rv32i_sim.vcd"); // Creates the waveform file
    $dumpvars(0, rv32i_tb);    // Dumps all signals in the TB and below
end

endmodule