module pc_mux (
    input       [31:0]  pctarget,
    input       [31:0]  pcplus4,
    input               pcsrc,
    output reg  [31:0]  pcnext
);

    //assign pcnext = pcsrc ? pcplus4 : pctarget;

    always @(pctarget or pcplus4 or pcsrc)begin
        if(pcsrc) pcnext = pctarget;
        else pcnext = pcplus4;
    end
    
endmodule