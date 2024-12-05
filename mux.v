module mux(output out, input s, input a, input b);
    assign out = s ? a : b;
endmodule