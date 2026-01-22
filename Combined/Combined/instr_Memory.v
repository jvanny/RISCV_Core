module instruction_memory (
    //input clk,
    input wire [31:0] address,
    output wire [31:0] instruction
);

    // 8192 words * 4B/word = 32768B = 32KiB
    reg [31:0] mem [0:8191];

    initial begin
        // This file acts as the overall instruction memory, to implement a cache a smaller mem file that sits in between this and the core is needed
        $readmemh("instructions.mem", mem);
    end

    // When clock input changes the output changes
    assign instruction = mem[address[14:2]];
    

endmodule