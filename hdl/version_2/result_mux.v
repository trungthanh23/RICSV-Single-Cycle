module result_mux (
    input       [1:0]   resultsrc,
    input       [31:0]  readdata,
    input       [31:0]  aluresult,
    input       [31:0]  pcplus4,
    output reg  [31:0]  result
);

    always @(resultsrc or readdata or aluresult or pcplus4) begin
        if (resultsrc[0]) result = readdata;
        else if (resultsrc[1]) result = pcplus4;
        else result = aluresult;
    end

endmodule