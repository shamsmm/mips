`define lw 35
`define sw 43
`define r 0
`define addi 8
`define beq 4

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


module control(output reg [9:0] control_bus, input [31:26] op);

always @(op)
    case(op)
        `lw: control_bus = 10'b01111_00000;
        `sw: control_bus = 10'b0100_010000;
        `r: control_bus = 10'b1001_000100;
        `addi: control_bus = 10'b01010_00000;
        `beq: control_bus = 10'b0000_001001;
    endcase

endmodule