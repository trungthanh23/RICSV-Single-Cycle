module extend (
    input   [31:0]  instr,
    input   [1:0]   immsrc,
    output  [31:0]  immext
);

    reg [31:0] immextreg;

    always @(*) begin
        case (immsrc)
            2'b00: immextreg = {{20{instr[31]}}, instr[31:20]}; 
            2'b01: immextreg = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            2'b10: immextreg = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            2'b11: immextreg = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0} ; 
            default: immextreg = 32'd0;
        endcase
    end

    assign immext = immextreg;
endmodule