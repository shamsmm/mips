module signextend (
    output [31:0] out,
    input  [15:0] in
);

    assign out = in[15] == 1 ? {{16{1'b1}}, in} : in;

endmodule
