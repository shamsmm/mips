module lsl2 (
    output [M:1] out,
    input  [N:1] in
);
    parameter integer N = 16, M = 18;

    assign out = in << 2;

endmodule
