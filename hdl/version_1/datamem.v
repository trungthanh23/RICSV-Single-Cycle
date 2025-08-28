module datamem(
    input           clk,
    input           we,
    input   [31:0]  a,
    input   [31:0]  wd,
    output  [31:0]  rd
);

    /*verilator public*/ reg [31:0] mem [63:0];

    assign rd = mem[a[31:2]];

    always @(posedge clk) begin
        if (we) begin
            mem[a[31:2]] <= wd;
        end else begin
        end
    end

endmodule