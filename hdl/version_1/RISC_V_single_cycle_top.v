module RISC_V_single_cycle(
    input           clk,
    input           rst_n,
    output  [31:0]  writedata, dataadr,
    output          memwrite
);
    wire [31:0] pc, instr, readdata;

    risc_v_core risc_v_core(
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .readdata(readdata),
        .pc(pc),
        .dataadr(dataadr),
        .writedata(writedata),
        .memwrite(memwrite)
    );

    inmem inmem_inst(
        .a(pc),
        .rd(instr)
    );

    datamem datamem_inst(
        .clk(clk),
        .a(dataadr),
        .wd(writedata),
        .we(memwrite),
        .rd(readdata)
    );
    
endmodule