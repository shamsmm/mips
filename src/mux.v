module mux(output [size:1] out, input s, input [size:1] a, b);
    parameter size = 1;
    assign out = ~s ? a : b;
endmodule