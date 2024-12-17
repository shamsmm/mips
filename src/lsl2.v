module lsl2 (
    output [31:0] out,
    input  [ N:1] in
);
    parameter integer N = 16;

    assign out = in << 2;

endmodule
