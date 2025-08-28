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

   //PC Logic  
    wire [31:0] pcnext, pcplus4, pctarget;
    wire [31:0] immext;
    wire [31:0] srca, srcb;
    wire [31:0] result;

    pc pc_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .pcnext(pcnext),
        .pc(pc)
    );

    pc_plus_4 pc_plus_4_inst(
        .pc(pc),
        .pcplus4(pcplus4)
    );


    extend extend_inst(
        .instr(instr), 
        .immsrc(immsrc),
        .immext(immext)
    );

    pc_target pc_target_inst(
        .pc(pc),
        .immext(immext),
        .pctarget(pctarget)
    );

    pc_mux pc_mux_inst(
        .pctarget(pctarget),
        .pcplus4(pcplus4),
        .pcsrc(pcsrc),
        .pcnext(pcnext)
    );

    //Register file
    register_file register_file_inst(
        .clk(clk),
        .a1(instr[19:15]),          
        .a2(instr[24:20]),         
        .a3(instr[11:7]),         
        .wd3(result),  
        .we3(regwrite),         
        .rd1(srca),                
        .rd2(writedata)            
    );

    //ALU logic
    alu_mux alu_mux_inst(
        .writedata(writedata), 
        .immext(immext),            
        .alusrc(alusrc),           
        .srcb(srcb)                 
    );

    alu alu_inst(
        .a(srca),
        .b(srcb),
        .alucontrol(alucontrol),
        .result(aluresult),
        .zero(zero)
    );

    //Result
    result_mux result_mux_inst(
        .resultsrc(resultsrc),
        .readdata(readdata),        
        .aluresult(aluresult),      
        .pcplus4(pcplus4),         
        .result(result) 
    );

endmodule