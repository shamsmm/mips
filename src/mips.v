module mips (
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
    wire [31:0] lsl2_imm;


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

    i_memory mips_i_mem (
        .data(i_mem_out),
        .address(pc_out)
    );

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

    d_memory mips_d_mem (
        .data(d_mem_out),
        .write_data(rf_read_reg1_data),
        .clk(clk),
        .write(control_bus[`MemWrite]),
        .address(alu_out)
    );

    mux #(5) mips_write_reg_mux (
        .out(rf_write_reg),
        .s  (control_bus[`RegDst]),
        .a  (i_mem_out[20:16]),
        .b  (i_mem_out[15:11])
    );

    mux #(32) mips_alu_read_reg_mux (
        .out(alu_rf_read_reg),
        .s  (control_bus[`ALUSrc]),
        .a  (rf_read_reg2_data),
        .b  (sign_extended_imm)
    );

    mux #(32) mips_rf_write_data_mux (
        .out(rf_write_data),
        .s  (control_bus[`MemToReg]),
        .a  (alu_out),
        .b  (d_mem_out)
    );

    mux #(32) mips_pc_in_mux (
        .out(pc_in),
        .s  (control_bus[`Jump]),
        .a  (pc_in0),
        .b  (lsl2_imm)
    );

    mux #(32) mips_pc_in_mux0 (
        .out(pc_in0),
        .s  (pc_in_mux0_src),
        .a  (pc_next),
        .b  (pc_relative_alu_out)
    );

    and mips_pc_in_mux0_src (pc_in_mux0_src, control_bus[`Branch], alu_out_zero);

    signextend mips_sign_extended_imm (
        .out(sign_extended_imm),
        .in (i_mem_out[15:0])
    );

    lsl2 #(26) mips_lsl2_imm (
        .out(lsl2_imm),
        .in (i_mem_out[25:0])
    );

    lsl2 #(32) mips_lsl2_sign_extended_imm (
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
