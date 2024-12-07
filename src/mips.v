module mips(
    input rst, clk
);

wire [31:0] pc_out, pc_next;

wire [4:0] rf_write_reg;
wire [31:0] rf_write_data, rf_read_reg1_data, rf_read_reg2_data;
wire [4:0] rf_read_reg1, rf_read_reg2;

wire [31:0] i_mem_out;
wire [31:0] pc_in, pc_in0, pc_relative_alu_out;

wire [1:0] alu_control_bus;

wire alu_out_zero;
wire [31:0] alu_out, d_mem_out;
wire [31:0] alu_rf_read_reg;

wire pc_in_mux0_src;
wire [31:0] sign_extended_imm, lsl2_sign_extended_imm;
wire [31:0] lsl2_imm;


// RegDst(8) Jump(7) Branch(6) MemRead(5) MemtoReg(4) ALUop(3) MemWrite(2) ALUsrc(1) RegWrite(0)
wire [9:0] control_bus;

assign rf_read_reg1 = i_mem_out[25:21];
assign rf_read_reg2 = i_mem_out[20:16];

assign alu_control_bus = {control_bus[`ALUop1], control_bus[`ALUop0]};

pc mips_pc(pc_out, rst, clk, pc_in);
i_memory mips_i_mem(i_mem_out, pc_out);
rf mips_rf(rf_read_reg1_data, rf_read_reg2_data, rf_read_reg1, rf_read_reg2, rf_write_reg, rf_write_data, control_bus[`RegWrite], rst, clk);
control mips_control(control_bus, i_mem_out[31:26]);
alu mips_alu(alu_out, alu_out_zero, rf_read_reg1_data, alu_rf_read_reg, alu_control_bus, i_mem_out[5:0], i_mem_out[10:6]);
d_memory mips_d_mem(d_mem_out, rf_read_reg1_data, clk, control_bus[`MemWrite], alu_out);

mux #(5) mips_write_reg_mux(rf_write_reg, control_bus[`RegDst], i_mem_out[20:16], i_mem_out[15:11]);
mux #(32) mips_alu_read_reg_mux(alu_rf_read_reg, control_bus[`ALUSrc], rf_read_reg2_data, sign_extended_imm);
mux #(32) mips_rf_write_data_mux(rf_write_data, control_bus[`MemToReg], alu_out, d_mem_out);

mux #(32) mips_pc_in_mux(pc_in, control_bus[`Jump], pc_in0, lsl2_imm);
mux #(32) mips_pc_in_mux0(pc_in0, pc_in_mux0_src, pc_next, pc_relative_alu_out);
and mips_pc_in_mux0_src(pc_in_mux0_src, control_bus[`Branch], alu_out_zero);

signextend mips_sign_extended_imm(sign_extended_imm, i_mem_out[15:0]);
lsl2 #(26) mips_lsl2_imm(lsl2_imm, i_mem_out[25:0]);
lsl2 #(32) mips_lsl2_sign_extended_imm(lsl2_sign_extended_imm, sign_extended_imm);

adder mips_pc_next_adder(pc_next, pc_out, 4);
adder mips_pc_relative_adder(pc_relative_alu_out, pc_next, lsl2_sign_extended_imm);

endmodule