module alu (
    output reg [31:0] out,
    output zero,
    input [31:0] a,
    input [31:0] b,
    input [1:0] control_bus,
    input [5:0] funct,
    input [4:0] shamt
);

    assign zero = out == 0;

    always @(control_bus, a, b, funct, shamt)
        case (control_bus)
            2'b00: out = a + b;
            2'b01: out = a - b;
            2'b10:
            case (funct)
                32: out = a + b;
                34: out = a - b;
                36: out = a & b;
                39: out = a | ~b;
                37: out = a | b;
                0: out = a << shamt;
                default: out = 0;
            endcase
            default: out = 0;
        endcase
endmodule
