/*pc 模块*/
/*
(.rst(), .clk(), .npc(), .pc())
*/
`timescale 1ns / 1ps

module pc(
    input wire       rst,
    input wire       clk,
    input wire[31:0] npc,
    // 输出地址
    output reg[31:0] pc
    );
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 'h00000000;
        end else begin
            pc <= npc;
        end
    end
endmodule
