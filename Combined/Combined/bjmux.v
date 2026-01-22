module bjmux(adder_mux_result_mem, jr, ALU_result_mem, bj_addr_out);

input [31:0] adder_mux_result_mem, ALU_result_mem;
input jr;

output reg [31:0] bj_addr_out;

always @(*) begin

case(jr)

1'b0:bj_addr_out = adder_mux_result_mem;
1'b1: bj_addr_out = {ALU_result_mem[31:1], 1'b0};
default: bj_addr_out = 1'b0;

endcase

end

endmodule