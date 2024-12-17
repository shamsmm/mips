`define lw 35
`define sw 43
`define r 0
`define addi 8
`define beq 4
`define j 2

`define RegDst 9
`define ALUSrc 8
`define MemToReg 7
`define RegWrite 6
`define MemRead 5
`define MemWrite 4
`define Branch 3
`define ALUop1 2
`define ALUop0 1
`define Jump 0


module control (
    output reg [9:0] control_bus,
    input [31:26] op
);

    // RegDst(9) ALUSrc(8) MemToReg(7) RegWrite(6) MemRead(5) MemWrite(4) Branch(3) ALUop1(2) ALUop0(1) Jump(0)
    always @(op)
        case (op)
            `lw:     control_bus = 10'b01111_00000;
            `sw:     control_bus = 10'b01000_10000;
            `r:      control_bus = 10'b10010_00100;
            `addi:   control_bus = 10'b01010_00000;
            `beq:    control_bus = 10'b00000_01010;
            `j:      control_bus = 10'b00000_00001;
            default: control_bus = 10'b00000_00000;
        endcase

endmodule
