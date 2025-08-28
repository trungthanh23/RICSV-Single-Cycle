module pc_target(
    input   [31:0]  pc,
    input   [31:0]  immext,
    output   [31:0]  pctarget
);

    assign pctarget = pc + immext;
endmodule