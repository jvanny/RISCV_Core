module instruction_memory_tb;

    // Testbench signals
    reg [7:0] tb_address;
    wire [31:0] tb_instruction;

    // Instantiate the Instruction Memory module
    instruction_memory uut (
        .address(tb_address),
        .instruction(tb_instruction)
    );

    initial begin

        $dumpfile("test.vcd");
        $dumpvars(0, instruction_memory_tb);
        
        // Initialize inputs
        tb_address = 8'h00;

        // Display a header
        $display("------------------------------------");
        $display("Testing Instruction Memory");
        $display("------------------------------------");
        $display("Time | Address | Instruction");
        $display("------------------------------------");

        // Test Addresses
        #10;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);

        #10;
        tb_address = 8'h04;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);

        #10;
        tb_address = 8'h08;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);

        // Add more tests as needed
        #10;
        tb_address = 8'h12;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);
        #10;
        tb_address = 8'h16;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);
        #10;
        tb_address = 8'h20;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);
        #10;
        tb_address = 8'h24;
        $display("%0t | 0x%h    | 0x%h", $time, tb_address, tb_instruction);
        $finish; // End the simulation
    end

endmodule