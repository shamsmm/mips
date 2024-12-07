module tb;

reg rst, clk;

always #5 clk = ~clk;

initial begin
    $dumpfile("test.fst");
    $dumpvars(0, tb);

    dut.mips_i_mem.mem[0] = 111;
    $readmemh(dut.mips_i_mem.mem, "ddd");

    clk = 0;
    rst = 0;


    #500;
    $finish;
end

mips dut(rst, clk);

endmodule