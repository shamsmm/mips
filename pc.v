module pc (output reg [31:0] pc_out, input rst, clk, input [31:0] pc_in);

always @(posedge clk or negedge rst)
    if (!rst)
        pc_out <= 0;
    else
        pc_out <= pc_in;


endmodule