module control(
    input           funct7,
    input   [2:0]   funct3,
    input   [6:0]   op,
    input           zero,
    output          pcsrc,
    output  [1:0]   resultsrc,
    output          memwrite,
    output  [2:0]   alucontrol,
    output          alusrc,
    output  [1:0]   immsrc,
    output          regwrite
    //output          regsrc
);

    wire            branch;
    wire            jump;
    wire    [1:0]   aluop;

    main_decoder main_decoder(
        .op(op),
        .branch(branch),
        .jump(jump),
        .resultsrc(resultsrc),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .immsrc(immsrc),
        .regwrite(regwrite),
        .aluop(aluop)
    );

    alu_decoder alu_decoder(
        .funct3(funct3),
        .funct7(funct7),
        .aluop(aluop),
        .op5(op[5]),
        .alucontrol(alucontrol)
    );

    assign pcsrc = (zero & branch) | jump;

endmodule