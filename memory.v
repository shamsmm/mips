module memory(output [31:0] data, input [31:0] address);

reg [31:0] mem [1000:0];

assign data = mem[address];

endmodule