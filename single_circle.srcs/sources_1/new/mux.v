/*多路复用器*/

/*
(.muxSel(), .in1(), .in2(), .in3(), .in4(), .mout())
*/
module mux_4_32(
    input wire[1:0]  muxSel,
    input wire[31:0] in1, in2, in3, in4,
    
    output reg[31:0] mout
    );
    
    always @ (muxSel or in1 or in2 or in3 or in4) begin
        case(muxSel)
            2'b00: mout <= in1;
            2'b01: mout <= in2;
            3'b10: mout <= in3;
            4'b11: mout <= in4;
        endcase
    end
endmodule

/*
(.muxSel(), .in1(), .in2(), .mout())
*/
module mux_4_5(
    input wire[1:0] muxSel,
    input wire[4:0] in1,in2,
    output reg[4:0] mout
    );
    
    always @ (muxSel or in1 or in2) begin
        case(muxSel)
            2'b00: mout <= in1;
            2'b01: mout <= in2;
            2'b10: mout <= 'h1f;
        endcase
    end
endmodule

/*
(.muxSel(), .in1(), .in2(), .mout())
*/
module mux_2(
    input wire       muxSel,
    input wire[31:0] in1,in2,
    output reg[31:0] mout
    );
    
    always @ (muxSel or in1 or in2) begin
        case(muxSel)
            1'b0: mout <= in1;
            1'b1: mout <= in2;
        endcase
    end
endmodule