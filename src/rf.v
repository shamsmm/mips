module rf (
    output [31:0] reg1_data,
    output [31:0] reg2_data,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input write,
    input rst,
    input clk
);

    reg [31:0] data[1:31];

    assign reg1_data = read_reg1 == 0 ? 0 : data[read_reg1];
    assign reg2_data = read_reg2 == 0 ? 0 : data[read_reg2];

    integer i;

    always @(posedge clk or negedge rst)
        if (!rst) for (i = 0; i < 32; i = i + 1) data[i] <= 0;
        else if (write) data[write_reg] <= write_data;

endmodule
