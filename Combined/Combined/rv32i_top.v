module rv32i_top(clk, reset, led);

input clk;
input reset;
output [7:0] led;

//IF
//INPUTS
wire PCsrc_mem; 
wire pc_stall;
wire [31:0] br_addr_mem;


//OUTPUTS
wire [31:0] PC_OUT_if;
wire [31:0] pcmux_out;
wire [31:0] pc4_if;
wire [31:0] instr_if;

wire [31:0] PC_OUT_id;
wire [31:0] pc4_id;
wire [31:0] instr_id;

wire if_id_stall;
wire if_id_flush;

//INSTANTIATE IF
programCounter PC_UNIT(
    .clk(clk),
    .reset(reset),
    .pc_stall(pc_stall),
    .PC_OUT(PC_OUT_if),
    .PC_IN(pcmux_out)
);
assign led = PC_OUT_if;

pcadder IFadder(
    .pc(PC_OUT_if),
    .pc4_out(pc4_if)
);

pcmux IFmux(
    .PCsrc(PCsrc_mem),
    .br_addr(bj_addr_out),
    .pc4(pc4_if),
    .pcmux_out(pcmux_out)
);

instruction_memory iMem(
    .address(PC_OUT_if),
    .instruction(instr_if)
);

if_id_reg IFIDREG(
    .clk(clk),
    .stall(if_id_stall),
    .flush(if_id_flush),
    .reset(reset),
    .pc_in(PC_OUT_if),
    .pc4_in(pc4_if),
    .instr_in(instr_if),
    .pc_out(PC_OUT_id),
    .pc4_out(pc4_id),
    .instr_out(instr_id)
);

//ID
//INPUTS

wire [4:0] rs1_id = instr_id[19:15];
wire [4:0] rs2_id = instr_id[24:20];
wire [6:0] opcode_id = instr_id[6:0];

//inputs from wb
wire [4:0] regdest_wb;
wire rw_wb;
wire [31:0] result_wb;

//from hazard
wire id_ex_flush;

//OUTPUTS
wire [31:0] rd1_id_out;
wire [31:0] rd2_id_out;

wire [1:0] ALUop_id, mtr_id;
wire ALUsrc_id, br_id, mr_id, mw_id, rw_id, j_id, jr_id; 

wire [31:0] imm_val_id;
wire [2:0] funct3_id = instr_id[14:12];
wire instr30_id = instr_id[30];
wire [4:0] regdest_id = instr_id[11:7]; 

//INSTANTIATE ID
//REG FILE
reg_file REG(
    .clk(clk),
    .we(rw_wb),
    .rr1(rs1_id),
    .rr2(rs2_id),
    .wr(regdest_wb),
    .wd(result_wb),
    .rd1(rd1_id_out),
    .rd2(rd2_id_out)
);
//control unit
//need to impement jump OR gate in mem stage
control CONTROL(
    .opcode(opcode_id),
    .ALUo(ALUop_id),
    .ALUs(ALUsrc_id),
    .br(br_id),
    .mr(mr_id),
    .mw(mw_id),
    .rw(rw_id),
    .mtr(mtr_id),
    .j(j_id),
    .jr(jr_id)
);
//ImmGen
ImmGen IMMGEN(
    .instr(instr_id),
    .immout(imm_val_id)
);

//ID EX REG
//OUTPUTS
wire [31:0] pc_ex, pc4_ex, rd1_ex, rd2_ex, imm_ex;
wire [4:0] regdest_ex, rs1_ex, rs2_ex;
wire [2:0] funct3_ex;
wire [1:0] ALUop_ex, mtr_ex;
wire ALUsrc_ex, br_ex, mr_ex, mw_ex, rw_ex, j_ex, instr30_ex, jr_ex;

id_ex_reg IDEXREG(
.clk(clk), 
.reset(reset),
.flush(id_ex_flush),
.pc_in(PC_OUT_id),
.pc4_in(pc4_id),
.ALU_Op_in(ALUop_id),
.ALUSrc_in(ALUsrc_id),
.br_in(br_id),
.mr_in(mr_id),
.mw_in(mw_id),
.rw_in(rw_id),
.mtr_in(mtr_id),
.j_in(j_id),
.jr_in(jr_id),
.rd1_in(rd1_id_out),
.rd2_in(rd2_id_out),
.imm_in(imm_val_id),
.funct3_in(funct3_id),
.instr30_in(instr30_id),
.regdest_in(regdest_id),
.rs1_in(rs1_id),
.rs2_in(rs2_id),

.pc_out(pc_ex),
.pc4_out(pc4_ex),
.ALU_Op_out(ALUop_ex),
.ALUSrc_out(ALUsrc_ex),
.br_out(br_ex),
.mr_out(mr_ex),
.mw_out(mw_ex),
.rw_out(rw_ex),
.mtr_out(mtr_ex),
.j_out(j_ex),
.jr_out(jr_ex),
.rd1_out(rd1_ex),
.rd2_out(rd2_ex),
.imm_out(imm_ex),
.funct3_out(funct3_ex),
.instr30_out(instr30_ex),
.regdest_out(regdest_ex),
.rs1_out(rs1_ex),
.rs2_out(rs2_ex)
);

//EX
//INPUTS
wire [4:0] regdest_mem;
wire rw_mem;
wire [31:0] ALU_result_mem;
wire ex_mem_flush;
//OUTPUT
wire [1:0] fwdA, fwdB;
wire [31:0] output_A;
wire [31:0] output_B;
wire [31:0] imm_addr_ex;
wire [3:0] ALUctrl;
wire [31:0] srcmux_output_B;
wire [31:0] ALU_result_ex;
wire zero_flag_ex, neg_ex, carry_ex, overflow_ex;

//INSTANTIATE

//FORWARD
forward FORWARD(
    .rs1(rs1_ex),
    .rs2(rs2_ex),
    .rd_mem(regdest_mem),
    .rd_wb(regdest_wb),
    .rw_mem(rw_mem),
    .rw_wb(rw_wb),
    .fwdA(fwdA),
    .fwdB(fwdB)
);

//MUXA
muxA MUXA(
    .rd1(rd1_ex),
    .ALU_result_mem(ALU_result_mem),
    .result_wb(result_wb),
    .fwdA(fwdA),
    .output_A(output_A)
);
//MUXB
muxB MUXB(
    .rd2(rd2_ex),
    .ALU_result_mem(ALU_result_mem),
    .result_wb(result_wb),
    .fwdB(fwdB),
    .output_B(output_B)
);

//ALUSRC
ALUsrc ALUSRC(
    .imm(imm_ex),
    .rd2(output_B),
    .muxout(srcmux_output_B),
    .alusrc(ALUsrc_ex)
);

//IMMADDER
ADDER IMMADDER(
    .pc(pc_ex),
    .imm(imm_ex),
    .result(imm_addr_ex)
);
//ALUCONTROL
ALU_Control ALUCONTROL(
    .ALUop(ALUop_ex),
    .funct3(funct3_ex),
    .funct7_30(instr30_ex),
    .ALUctrl(ALUctrl)
);

//ALU
ALU ALUEX(
    .A(output_A),
    .B(srcmux_output_B),
    .ALUctrl(ALUctrl),
    .result(ALU_result_ex),
    .zero(zero_flag_ex),
    .neg(neg_ex),
    .carry(carry_ex),
    .overflow(overflow_ex)
);

//EXMEMREG

//OUTPUTS
wire [31:0] pc4_mem, rd2_mem, imm_mem, imm_addr_mem;
wire [2:0] funct3_mem;
wire [1:0] mtr_mem;
wire br_mem, mr_mem, mw_mem, overflow_mem, carry_mem, zero_mem, neg_mem, j_mem, jr_mem;

ex_mem_reg EXMEMREG(
    .clk(clk),
    .reset(reset),
    .flush(ex_mem_flush),

    .pc4_in(pc4_ex),
    .br_in(br_ex),
    .mr_in(mr_ex),
    .mw_in(mw_ex),
    .rw_in(rw_ex),
    .mtr_in(mtr_ex),
    .j_in(j_ex),
    .jr_in(jr_ex),
    .rd2_in(output_B),
    .imm_in(imm_ex),
    .funct3_in(funct3_ex),
    .regdest_in(regdest_ex),
    .adder_result_in(imm_addr_ex),
    .ALU_result_in(ALU_result_ex),
    .overflow_in(overflow_ex),
    .carry_in(carry_ex),
    .zero_in(zero_flag_ex),
    .neg_in(neg_ex),

    .pc4_out(pc4_mem),
    .br_out(br_mem),
    .mr_out(mr_mem),
    .mw_out(mw_mem),
    .rw_out(rw_mem),
    .mtr_out(mtr_mem),
    .j_out(j_mem),
    .jr_out(jr_mem),
    .rd2_out(rd2_mem),
    .imm_out(imm_mem),
    .funct3_out(funct3_mem),
    .regdest_out(regdest_mem),
    .adder_result_out(br_addr_mem),
    .ALU_result_out(ALU_result_mem),
    .overflow_out(overflow_mem),
    .carry_out(carry_mem),
    .zero_out(zero_mem),
    .neg_out(neg_mem)
);

//MEM
//INPUTS

//OUTPUTS
wire [31:0] read_data_out_mem;
wire [31:0] bj_addr_out;
//INSTANTIATE

//BRANCH_JUMP_UNIT
branch_unit BRANCH_JUMP_UNIT(
    .br(br_mem),
    .j(j_mem),
    .jr(jr_mem),
    .zero(zero_mem),
    .funct3(funct3_mem),
    .neg(neg_mem),
    .overflow(overflow_mem),
    .carry(carry_mem),
    .PCsrc(PCsrc_mem)
);

//JUMP BRANCH MUX
bjmux BJMUX(
    .adder_mux_result_mem(br_addr_mem),
    .jr(jr_mem),
    .ALU_result_mem(ALU_result_mem),
    .bj_addr_out(bj_addr_out)
);

//DATA_MEM
data_mem DATAMEM(
    .rd2(rd2_mem),
    .address(ALU_result_mem),
    .mw(mw_mem),
    .mr(mr_mem),
    .funct3(funct3_mem),
    .clk(clk),
    .rs2_out(read_data_out_mem)
);

//MEMWBREG

//OUTPUTS
wire [31:0] pc4_wb, read_data_wb, ALU_result_wb, imm_wb;
wire [1:0] mtr_wb;


mem_wb_reg MEMWBREG(
    .clk(clk),
    .reset(reset),

    .pc4_in(pc4_mem),
    .rw_in(rw_mem),
    .mtr_in(mtr_mem),
    .read_data_in(read_data_out_mem),
    .ALU_result_in(ALU_result_mem),
    .imm_in(imm_mem),
    .regdest_in(regdest_mem),

    .pc4_out(pc4_wb),
    .rw_out(rw_wb),
    .mtr_out(mtr_wb),
    .read_data_out(read_data_wb),
    .ALU_result_out(ALU_result_wb),
    .imm_out(imm_wb),
    .regdest_out(regdest_wb)
);

//WB
//INPUTS

//OUTPUTS

//INSTANTIATE

//WBMUX
wb_mux WBMUX(
    .ALU_result(ALU_result_wb),
    .data_mem(read_data_wb),
    .pc4(pc4_wb),
    .imm_in(imm_wb),
    .mtr(mtr_wb),
    .wb_out(result_wb)
);


//HAZARD UNIT
//INPUT

//OUTPUT

//INSTANTIATION
hazard_control HAZARDUNIT(
    .rs1_id(rs1_id),
    .rs2_id(rs2_id),
    .rd_ex(regdest_ex),
    .mr_ex(mr_ex),
    .PCsrc(PCsrc_mem),
    .pc_stall(pc_stall),
    .if_id_stall(if_id_stall),
    .if_id_flush(if_id_flush),
    .id_ex_flush(id_ex_flush),
    .ex_mem_flush(ex_mem_flush)
);


endmodule