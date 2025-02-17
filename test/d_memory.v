module d_memory (
    output [31:0] data,
    output [31:0] debug_data,
    input [31:0] write_data,
    input clk,
    input write,
    input [31:0] address,
    input [31:0] debug_address
);
    parameter integer N = 10000;

    reg [31:0] mem[N];

    assign data = mem[address>>2];
    assign debug_data = mem[debug_address>>2];

    // Write
    always @(posedge clk) if (write) mem[address>>2] <= write_data;

endmodule
