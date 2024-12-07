`define lw 35
`define sw 43
`define r 0
`define addi 8
`define beq 4

`define RegDst 8
`define ALUSrc 7
`define MemToReg 6
`define RegWrite 5
`define MemRead 4
`define MemWrite 3
`define Branch 2
`define ALUop 1
`define Jump 0


module control(output reg [8:0] control_bus, input [31:26] op);

always @(op)
    case(op)
        `lw: control_bus = 9'b01111_0000;
        `sw: control_bus = 9'b0100_01000;
        `r: control_bus = 9'b1001_00010;
        `addi: control_bus = 9'b01010_0000;
        `beq: control_bus = 9'b0000_00101;
    endcase

endmodule