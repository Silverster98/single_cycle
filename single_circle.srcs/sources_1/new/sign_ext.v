/*
(.imm_16(), .EXTop(), .extout())
*/

/*立即数扩展*/

module sign_ext(
    input wire[15:0] imm_16,
    input wire[1:0] EXTop,
    output wire[31:0] extout
    );
    
    assign extout = (EXTop == 2'b00) ? {imm_16, 16'b0} :
                    (EXTop == 2'b01) ? {16'b0, imm_16} :
                    (EXTop == 2'b10) ? {{16{imm_16[15]}}, imm_16} :
                    32'b0001001000110100;
endmodule
