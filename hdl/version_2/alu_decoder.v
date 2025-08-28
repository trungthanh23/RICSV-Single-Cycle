module alu_decoder(
    input       [2:0]   funct3,
    input               funct7,
    input               op5,
    input       [1:0]   aluop,
    output  reg [2:0]   alucontrol
);
    wire aludec;
    assign aludec = op5 & funct7;

    always @(aludec or funct3 or aluop) begin
        case (aluop)
            2'b00:  alucontrol = 3'b000;
            2'b01:  alucontrol = 3'b001; 
            2'b10: begin
              case (funct3)
                3'b000: begin
                  if (aludec) alucontrol = 3'b001;
                  else alucontrol = 3'b000;
                end 
                3'b010:   alucontrol = 3'b101;
                3'b110:   alucontrol = 3'b011;
                3'b111:   alucontrol = 3'b010;
                default:  alucontrol = 3'bxxx;
              endcase
            end
            default: alucontrol = 3'bxxx;
        endcase
    end

endmodule