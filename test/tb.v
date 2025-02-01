module tb;

    reg rst, clk;

    always #5 clk = ~clk;

    task toggle_rst;
        begin
            @(negedge clk);
            rst = 1;
            #1;
            rst = 0;
            #1;
            rst = 1;
        end
    endtask

    initial begin
        $dumpfile("test.fst");
        $dumpvars(0, tb);

        rst = 1;
        clk = 0;

        toggle_rst();

        $readmemh("test/irom.txt", imem.mem, 0, 15);
        $readmemh("test/dram.txt", dmem.mem, 0, 19);

        #5000;
        $finish;
    end

    wire [31:0] debug_data;
    wire [31:0] d_memory_data;
    wire [31:0] d_memory_write_data;
    wire d_memory_write;
    wire [31:0] d_memory_address;
    wire [31:0] i_memory_data;
    wire [31:0] i_memory_address;

    i_memory imem (
        .data(i_memory_data),
        .address(i_memory_address)
    );

    d_memory dmem (
        .data(d_memory_data),
        .debug_data(debug_data),
        .write_data(d_memory_write_data),
        .clk(clk),
        .write(d_memory_write),
        .address(d_memory_address),
        .debug_address(8)
    );

    mips_core dut (
        .i_memory_data(i_memory_data),
        .d_memory_data(d_memory_data),
        .i_memory_address(i_memory_address),
        .d_memory_address(d_memory_address),
        .d_memory_write_data(d_memory_write_data),
        .d_memory_write(d_memory_write),
        .rst(rst),
        .clk(clk)
    );

endmodule
