module rf #(
    parameter int SP_INITIAL = 24
) (
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
        if (!rst) begin
            for (i = 1; i < 29; i = i + 1) data[i] <= 0;
            data[29] <= SP_INITIAL;
            data[30] <= 0;
            data[31] <= 0;
        end else if (write) data[write_reg] <= write_data;
endmodule
