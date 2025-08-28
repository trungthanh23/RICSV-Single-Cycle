module register_file (
    input           clk,
    input   [4:0]   a1,
    input   [4:0]   a2,
    input   [4:0]   a3,
    input   [31:0]  wd3,
    input           we3,
    output  [31:0]  rd1,
    output  [31:0]  rd2
);

    reg [31:0] mem [31:0];

    always @(posedge clk) begin
        if ((we3 != 1'b0) && (a3 != 5'b0)) mem[a3] <= wd3;
        else mem[a3] <= mem[a3];
    end

    assign rd1 = (a1==0) ? 32'b0 : mem[a1];
    assign rd2 = (a2==0) ? 32'b0 : mem[a2]; 
endmodule