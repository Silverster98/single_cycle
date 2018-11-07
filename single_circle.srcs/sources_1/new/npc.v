/*npc模块*/

/*
(.imm_26(), .imm_16(), .pc(), .npc_op(), .npc(), .pc_add_4())
*/
module npc(
    input wire[25:0] imm_26, // 输入26位立即数
    input wire[15:0] imm_16, // 输入16位立即数
    input wire[31:0] pc,     // 输入上个pc
    input wire[1:0] npc_op,  // 输入选择信号
    
    output wire[31:0] npc,   // 输出的pc
    output wire[31:0] pc_add_4 // 输出pc+4信号至$31,$31($ra)是返回地址
    );
    
    assign pc_add_4 = pc + 'h4;
    
    assign npc = (npc_op == 2'b00) ? pc_add_4 : // 顺序加4
                 (npc_op == 2'b01) ? {pc[31:28], imm_26, 2'b00} : // 跳转到26位立即数指示的地址
                 (npc_op == 2'b10) ? (pc + {{14{imm_16[15]}}, imm_16, 2'b00}) : // pc+imm_16
                 (npc_op == 2'b11) ? (pc_add_4 + {{14{imm_16[15]}}, imm_16, 2'b00}) : // pc+4+imm_16
                 32'h00000000; // 都没有输出0，这个应该是有bug的情况
endmodule
