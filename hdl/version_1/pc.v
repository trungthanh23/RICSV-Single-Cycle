module pc(
    input           clk,
    input           rst_n,
    input   [31:0]  pcnext,
    output  [31:0]  pc
);

    reg [31:0]  pcreg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pcreg <= 32'b0;
        else pcreg <= pcnext;
    end
    
    assign pc = pcreg; 
endmodule