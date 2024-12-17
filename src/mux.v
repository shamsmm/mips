module mux (
    output [N:1] out,
    input s,
    input [N:1] a,
    input [N:1] b
);
    parameter integer N = 1;
    assign out = ~s ? a : b;
endmodule
