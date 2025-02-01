module mips_core #(
    int SP_INITIAL = 24
) (
    output [31:0] i_memory_address,
    output [31:0] d_memory_address,
    output [31:0] d_memory_write_data,
    output d_memory_write,
    input [31:0] i_memory_data,
    input [31:0] d_memory_data,
    input rst,
    input clk
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
    wire [27:0] lsl2_imm;


    // RegDst(8) Jump(7) Branch(6) MemRead(5) MemtoReg(4) ALUop(3) MemWrite(2) ALUsrc(1) RegWrite(0)
    wire [ 9:0] control_bus;

    assign rf_read_reg1 = i_mem_out[25:21];
    assign rf_read_reg2 = i_mem_out[20:16];

    assign alu_control_bus = {control_bus[`ALUop1], control_bus[`ALUop0]};

    pc mips_pc (
        .pc_out(pc_out),
        .rst(rst),
        .clk(clk),
        .pc_in(pc_in)
    );

    assign i_mem_out = i_memory_data;
    assign i_memory_address = pc_out;

    rf mips_rf (
        .reg1_data(rf_read_reg1_data),
        .reg2_data(rf_read_reg2_data),
        .read_reg1(rf_read_reg1),
        .read_reg2(rf_read_reg2),
        .write_reg(rf_write_reg),
        .write_data(rf_write_data),
        .write(control_bus[`RegWrite]),
        .rst(rst),
        .clk(clk)
    );

    control mips_control (
        .control_bus(control_bus),
        .op(i_mem_out[31:26])
    );

    alu mips_alu (
        .out(alu_out),
        .zero(alu_out_zero),
        .a(rf_read_reg1_data),
        .b(alu_rf_read_reg),
        .control_bus(alu_control_bus),
        .funct(i_mem_out[5:0]),
        .shamt(i_mem_out[10:6])
    );

    assign d_mem_out = d_memory_data;
    assign d_memory_address = alu_out;
    assign d_memory_write_data = rf_read_reg2_data;
    assign d_memory_write = control_bus[`MemWrite];

    assign rf_write_reg = control_bus[`RegDst] ? i_mem_out[15:11] : i_mem_out[20:16];
    assign alu_rf_read_reg = control_bus[`ALUSrc] ? sign_extended_imm : rf_read_reg2_data;
    assign rf_write_data = control_bus[`MemToReg] ? d_mem_out : alu_out;
    assign pc_in = control_bus[`Jump] ? {pc_next[31:28], lsl2_imm} : pc_in0;
    assign pc_in0 = pc_in_mux0_src ? pc_relative_alu_out : pc_next;
    assign pc_in_mux0_src = control_bus[`Branch] & alu_out_zero;

    signextend mips_sign_extended_imm (
        .out(sign_extended_imm),
        .in (i_mem_out[15:0])
    );

    lsl2 #(
        .N(26),
        .M(28)
    ) mips_lsl2_imm (
        .out(lsl2_imm),
        .in (i_mem_out[25:0])
    );

    lsl2 #(
        .N(32),
        .M(32)
    ) mips_lsl2_sign_extended_imm (
        .out(lsl2_sign_extended_imm),
        .in (sign_extended_imm)
    );

    adder mips_pc_next_adder (
        .out(pc_next),
        .a  (pc_out),
        .b  (4)
    );

    adder mips_pc_relative_adder (
        .out(pc_relative_alu_out),
        .a  (pc_next),
        .b  (lsl2_sign_extended_imm)
    );

endmodule
