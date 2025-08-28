module alu (
    input       [31:0]  a,
    input       [31:0]  b,
    input       [2:0]   alucontrol,
    output  reg [31:0]  result,
    output              zero
);

  wire          overflow;
  wire  [31:0]  result_tmp;
  wire  [31:0]  b_tmp;

  assign b_tmp = (alucontrol[0]) ? (~b) : b;

  assign result_tmp = a + b_tmp + alucontrol[0];
  assign overflow = (a[31] == b_tmp[31]) && (result_tmp[31] != a[31]);

  always @(a or b or alucontrol) begin
    case (alucontrol)
      3'b000  : result = result_tmp;
      3'b001  : result = result_tmp;
      3'b010  : result = a & b;
      3'b011  : result = a | b;
      3'b101  : result = {31'b0, overflow ^ result_tmp[31]};
      default: result = 32'b0;
    endcase
  end

  assign zero = (result == 32'b0);

endmodule