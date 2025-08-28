// File: datapath.v (đã được tái cấu trúc)
module datapath(
    input           clk, 
    input           rst_n, 
    input           pcsrc, 
    input           alusrc, 
    input           regwrite,
    input   [1:0]   resultsrc,
    input   [2:0]   alucontrol,
    input   [1:0]   immsrc,
    input   [31:0]  instr,
    input   [31:0]  readdata,
    output          zero,
    output  [31:0]  pc,
    output  [31:0]  aluresult,
    output  [31:0]  writedata       
);

    wire [31:0] result;
    wire [31:0] srca;
    wire [31:0] immext; 
    wire [31:0] pcplus4;

    // PC Logic 
    pc_logic pc_logic_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pcsrc(pcsrc),
        .immext(immext), 
        .pc(pc),
        .pcplus4(pcplus4)
    );

    // Register File
    register_file register_file_inst(
        .clk(clk),
        .we3(regwrite),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(result),
        .rd1(srca),
        .rd2(writedata) 
    );

    //ALU Logic
    alu_unit alu_unit_inst(
        .srca(srca),
        .writedata(writedata), 
        .instr(instr),
        .immsrc(immsrc),
        .alusrc(alusrc),
        .alucontrol(alucontrol),
        .aluresult(aluresult),
        .zero(zero),
        .immext(immext) 
    );
    
    // Mux Result
    result_mux result_mux_inst(
        .readdata(readdata),
        .aluresult(aluresult),
        .pcplus4(pcplus4),
        .resultsrc(resultsrc),
        .result(result)
    );

endmodule