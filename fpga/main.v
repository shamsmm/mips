module main (
    input sys_clk,
    input sys_rst_n,
    output reg [5:0] led
);

mips computer(led, 8, sys_clk, sys_rst_n);

endmodule