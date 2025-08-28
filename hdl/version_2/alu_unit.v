module alu_unit(
    input       [31:0]  srca,
    input       [31:0]  writedata,
    input       [31:0]  instr,      
    input       [1:0]   immsrc,
    input               alusrc,
    input       [2:0]   alucontrol,
    output reg  [31:0]  immext,
    output      [31:0]  aluresult,
    output              zero
);
    reg [31:0] srcb;

    always @(instr or immsrc) begin
        casex (immsrc)
            2'b00: immext = {{20{instr[31]}}, instr[31:20]};
            2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            2'b10: immext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            2'b11: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default: immext = 32'b0;
        endcase
    end  

    //assign srcb = alusrc ? immext : writedata;
    always @(*) begin
        if(alusrc)  srcb = immext;
        else        srcb = writedata;
    end

    alu alu_inst(
        .a(srca),
        .b(srcb),
        .alucontrol(alucontrol),
        .result(aluresult),
        .zero(zero)
    );

endmodule