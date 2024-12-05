module lsl2(output [31:0] out, input [size:1] in);
parameter size = 16;

assign out = in << 2;

endmodule