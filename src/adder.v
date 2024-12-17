module adder (
    output [31:0] out,
    input  [31:0] a,
    input  [31:0] b
);
    assign {out} = a + b;
endmodule
