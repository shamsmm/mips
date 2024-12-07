module rf(
    output [31:0] reg1_data, reg2_data,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [31:0] write_data,
    input write, rst, clk
);

reg [31:0] data [4:0];

assign reg1_data = data[read_reg1];
assign reg2_data = data[read_reg2];

integer i;

always @(posedge clk or negedge rst)
    if (!rst)
        for (i = 0; i < 8; i = i + 1)
          data[i] <= 0;
    else if (write)
        data[write_reg] <= write_data;

endmodule