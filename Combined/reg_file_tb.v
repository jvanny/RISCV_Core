    // Testbench signals
`timescale 1ns/1ns

module registerFile_tb;
reg clk, we;
reg [4:0] rr1;
reg [4:0] rr2;
reg [4:0] wr;
reg [31:0] wd;

wire [31:0] rd1, rd2;

registerFile dut(
    .clk(clk),
    .we(we),
    .rr1(rr1),
    .rr2(rr2),
    .wr(wr),
    .wd(wd),
    .rd1(rd1),
    .rd2(rd2));

// Generate a clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100 MHz)
    end

// Test stimulus
    initial begin

        we = 0;
        rr1 = 5'd0;
        rr2 = 5'd0;
        wr = 5'd0;
        wd = 32'd0;

        $dumpfile("regFile_test.vcd");
        $dumpvars(0, registerFile_tb);

        // Display initial state and monitor key signals
        $display("-------------------------------------------");
        $display("Initial State: All inputs are reset.");
        $display("-------------------------------------------");
        $monitor("Time=%0t | clk=%b | we=%b | wd=%h | wr=%d | rr1=%d (rd1=%h) | rr2=%d (rd2=%h)", $time, clk, we, wd, wr, rr1, rd1, rr2, rd2);

        #20;

        // 1. Write a value to register x10
        $display("\n--- Test Case 1: Write to x10 ---");
        wr = 5'd10;      // Set write address to register x10
        wd = 32'hdeadbeef; // Set data to be written
        we = 1;          // Enable write
        #10;             // Wait for a full clock cycle to ensure the write occurs
        we = 0;          // Disable write

        // 2. Read from register x10 and x11 (which should be 0)
        $display("\n--- Test Case 2: Read from x10 and x11 ---");
        rr1 = 5'd10;     // Read from x10
        rr2 = 5'd11;     // Read from x11 (should be 0)
        #10;

        // 3. Read from the hardwired zero register (x0)
        $display("\n--- Test Case 3: Read from x0 ---");
        rr1 = 5'd0;      // Read from x0
        rr2 = 5'd10;     // Read from x10 again for comparison
        #10;

        // 4. Attempt to write to x0, which should be ignored
        $display("\n--- Test Case 4: Attempt to write to x0 ---");
        wr = 5'd0;      // Set write address to x0
        wd = 32'h12345678; // Set data to be written
        we = 1;          // Enable write
        #10;
        we = 0;
        
        // Confirm that x0 is still 0
        rr1 = 5'd0;
        #10;

        // 5. Write to a different register and verify the read
        $display("\n--- Test Case 5: Write to x20 and read from it ---");
        wr = 5'd20;      // Set write address to x20
        wd = 32'hfacecafe; // New data to be written
        we = 1;          // Enable write
        #10;
        we = 0;
        
        // Read from x20
        rr1 = 5'd20;
        #10;
        
        $display("\n--- Simulation Complete ---");
        $finish; // End the simulation
    end

endmodule