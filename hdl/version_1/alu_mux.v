module alu_mux (
    input       [31:0]  writedata,
    input       [31:0]  immext,
    input               alusrc,
    output reg  [31:0]  srcb
);

    //assign srcb = alusrc ? immext : writedata;
    always @(writedata or immext or alusrc) begin
        if(alusrc) srcb = immext;
        else srcb = writedata;
    end

endmodule