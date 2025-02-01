module top (
    input sys_clk,
    input sys_rst_n,
    output reg [5:0] led
);

localparam LED_OUT_ADDRESS = 8;

wire [31:0] debug_data;
wire [31:0] d_memory_data;
wire [31:0] d_memory_write_data;
wire d_memory_write;
wire [31:0] d_memory_address;
wire [31:0] i_memory_data;
wire [31:0] i_memory_address;

// Output on LED
always @(posedge clk or negedge sys_rst_n)
    if (~sys_rst_n)
        led <= 0;
    else
        //if (d_memory_write && d_memory_address == LED_OUT_ADDRESS)  
            led <= ~(i_memory_data[5:0]);

// Clock divider chain to bring down 27MHz to roughly 1.6Hz
Gowin_CLKDIV div1(clk8, sys_clk, sys_rst_n);
Gowin_CLKDIV div2(clk64, clk8, sys_rst_n);
Gowin_CLKDIV div3(clk512, clk64, sys_rst_n);
Gowin_CLKDIV div4(clk4096, clk512, sys_rst_n);
Gowin_CLKDIV div5(clk32786, clk4096, sys_rst_n);
Gowin_CLKDIV div6(clk262144, clk32786, sys_rst_n);
Gowin_CLKDIV div7(clk2097152, clk262144, sys_rst_n);
Gowin_CLKDIV div8(clk, clk2097152, sys_rst_n);

`unconnected_drive pull0

// SRAM Block
Gowin_SP d_memory(
        .dout(d_memory_data), //output [31:0] dout
        .clk(clk), //input clk
        .ce(1'b1), //input ce
        .oce(1'b0),
        .reset(~sys_rst_n), //input reset
        .wre(d_memory_write), //input wre
        .ad(d_memory_address >> 2), //input [7:0] ad
        .din(d_memory_write_data) //input [31:0] din
    );

// Read-Only SRAM Block
Gowin_pROM i_memory(
        .dout(i_memory_data), //output [31:0] dout
        .clk(clk), //input clk
        .ce(1'b1), //input ce
        .oce(1'b0),
        .reset(~sys_rst_n), //input reset
        .ad(i_memory_address >> 2) //input [7:0] ad
    );

// MIPS core
mips_core mips(
        .i_memory_data(i_memory_data),
        .d_memory_data(d_memory_data),
        .i_memory_address(i_memory_address),
        .d_memory_address(d_memory_address),
        .d_memory_write_data(d_memory_write_data),
        .d_memory_write(d_memory_write),
        .rst(sys_rst_n),
        .clk(clk)
    );

endmodule