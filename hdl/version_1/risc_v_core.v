module risc_v_core(
    input           clk,
    input           rst_n,
    input   [31:0]  instr,
    input   [31:0]  readdata,
    output  [31:0]  pc,
    output  [31:0]  dataadr,
    output  [31:0]  writedata,
    output          memwrite
);
    wire            zero;
    wire            pcsrc;
    wire    [1:0]   resultsrc;
    wire    [2:0]   alucontrol;
    wire            alusrc;
    wire    [1:0]   immsrc;
    wire            regwrite;  
    //wire            regsrc;          


control control(
    .funct7(instr[30]),
    .funct3(instr[14:12]),
    .op(instr[6:0]),
    .zero(zero),
    .pcsrc(pcsrc),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .alucontrol(alucontrol),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite)
    //.regsrc(regsrc)
);

datapath datapath(
    .clk(clk),
    .rst_n(rst_n),
    .pcsrc(pcsrc),
    .resultsrc(resultsrc),
    .alucontrol(alucontrol),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite),
    //.regsrc(regsrc),
    .instr(instr),
    .readdata(readdata),
    .zero(zero),
    .pc(pc),
    .aluresult(dataadr),
    .writedata(writedata)
);

    
endmodule