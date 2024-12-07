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

    $readmemh("test/irom.txt", dut.mips_i_mem.mem, 0, 7);
    $readmemh("test/dram.txt", dut.mips_d_mem.mem, 0, 1);

    #500;
    $finish;
end

mips dut(rst, clk);

endmodule