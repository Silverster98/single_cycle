/* 
(.clk(), .rst(), .beqout(), .op(), .funct(), .ALUctrl(), .DMWrite(), 
    .npc_sel(), .RegWrite(), .ExtOp(), .mux4_sel(), .mux4_32sel(), .mux2sel())
*/

/*
add    GPR[rd] <- GPR[rs] + GPR[rt]
addiu  GPR[rt] <- GPR[rs] + immediate
beq    (1)target_offset <- sign_extend(offset << 2) (2)if GPR[rs] == GPR[rt] then pc <- pc + target_offset
j      
lw     GPR[rt] <- MEM[GPR[rs] + offset]
sw     MEM[GPR[rs] + offset] <- GPR[rt]
sub    GPR[rd] <- GPR[rs] - GPR[rt]
lui    GPR[rt] <- imm << 16
*/

`timescale 1ns / 1ps

/*输出控制信号*/

module ctrl(
    input wire        clk,
    input wire        rst,
    input wire        beqout,
    input wire[5:0]   op,
    input wire[5:0]   funct,
    
    output wire[2:0]  ALUctrl,
    output wire       DMWrite,
    output wire[1:0]  npc_sel,
    output wire       RegWrite,
    output wire[1:0]  ExtOp,
    
    output wire[1:0]  mux4_5sel,
    output wire[1:0]  mux4_32sel,
    output wire       mux2sel
    );
    
    wire Rtype, add, sub, addiu, lw, sw, j, beq, lui;
    
    assign Rtype = (op == 6'b000000) ? 1 : 0;
    assign add   = (Rtype && funct == 6'b100000) ? 1 : 0;
    assign sub   = (Rtype && funct == 6'b100010) ? 1 : 0; // 未使用
    assign lw    = (op == 6'b100011) ? 1 : 0;
    assign sw    = (op == 6'b101011) ? 1 : 0;
    assign beq   = (op == 6'b000100) ? 1 : 0;
    assign lui   = (op == 6'b001111) ? 1 : 0;
    assign addiu = (op == 6'b001001) ? 1 : 0;
    assign j     = (op == 6'b000010) ? 1 : 0;
    
    
    assign ALUctrl = (add || addiu || lw || sw) ? 3'b001 :
                     (beq) ? 3'b010:
                     3'b000;
                     
    assign DMWrite = (sw) ? 1'b1 : 1'b0;
    assign npc_sel = (j) ? 2'b01 : (beq && beqout) ? 2'b11 : 2'b00;
    assign RegWrite = (add || addiu || lw || lui) ? 1'b1 : 1'b0;
    assign ExtOp = (lui) ? 2'b00 : (lw || sw) ? 2'b10 : 2'b10; //???
    assign mux4_5sel = (addiu || lui || lw) ? 2'b00 : 2'b01;
    assign mux2sel = (lw || sw || addiu) ? 1'b1 : 1'b0;
    assign mux4_32sel = (lui) ? 2'b11 : (add || addiu) ? 2'b00 : (lw) ? 2'b01 : 2'b10;
    
endmodule
