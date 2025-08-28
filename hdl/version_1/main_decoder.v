module main_decoder(
    input   [6:0]   op,
    output          branch,
    output          jump,
    output          memwrite,
    output          alusrc,
    output          regwrite,
    output  [1:0]   aluop,
    output  [1:0]   immsrc,
    output  [1:0]   resultsrc
);

    reg [10:0] decode;

    assign {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = decode;

    always @(op) begin
        case (op)
            7'b0110011: decode = 11'b1XX00000100; // R-type
            7'b0010011: decode = 11'b10010000100; // I_type
            7'b1100011: decode = 11'b01000XX1010; // B-type
            7'b0000011: decode = 11'b10010010000; // lw
            7'b0100011: decode = 11'b00111XX0000; // sw
            7'b1101111: decode = 11'b111X0100XX1; // jal
            default: decode = 11'bXXXXXXXXXXX;
        endcase
    end


endmodule