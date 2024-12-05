module adder(output [31:0] out, input [31:0] a, b);
assign { out } = a + b;
endmodule