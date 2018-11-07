/*alu 模块*/
/*
(.A(), .B(), .ctrl(), .C(), .zero(), .beqout())
*/
`timescale 1ns / 1ps

module alu(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire[2:0]  ctrl,
    
    output wire[31:0] C,
    output wire zero,
    output wire beqout // zero的作用跟beqout相同，可以删去zero，并没有使用到
    );
    
    reg[32:0] tmp_arith;
    
    assign C = tmp_arith[31:0];
    assign zero = (tmp_arith[31:0] == 0) ? 1 : 0;
    assign beqout = (tmp_arith[31:0] == 0) ? 1 : 0;
    
    always @ (*) begin
        case (ctrl)
            3'b001 : tmp_arith <= {A[31], A} + {B[31], B}; // add
            3'b010 : tmp_arith <= {A[31], A} - {B[31], B}; // sub
            
            default : tmp_arith <= B;
        endcase
    end
endmodule
