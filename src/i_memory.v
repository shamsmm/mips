module i_memory (
    output [31:0] data,
    input  [31:0] address
);
    parameter integer N = 4000;

    reg [31:0] mem[N];

    assign data = mem[address>>2];

endmodule
