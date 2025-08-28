module pc_logic(
    input           clk,
    input           rst_n,
    input           pcsrc,
    input   [31:0]  immext,
    output  [31:0]  pc,
    output  [31:0]  pcplus4
);
    reg [31:0] pcreg;

    wire [31:0] pctarget;
    reg  [31:0] pcnext;

    assign pcplus4 = pcreg + 4;
    assign pctarget = pcreg + immext;

    //assign pcnext = pcsrc ? pctarget : pcplus4;
    always @(*)begin
        if(pcsrc)   pcnext = pctarget;
        else        pcnext = pcplus4;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pcreg <= 32'b0;
        else
            pcreg <= pcnext;
    end

    assign pc = pcreg;

endmodule