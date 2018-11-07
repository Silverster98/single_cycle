/*寄存器模块*/
/*
(.clk(), .rs1_i(), .rs2_i(), .rd_i(), .reg_wr_i(), .wdata_i(), .rs1_o(), .rs2_o())
*/
`timescale 1ns / 1ps

module regfile(
    input wire        clk,
    input wire[4:0]   rs1_i,    // rs1地址输入
    input wire[4:0]   rs2_i,    // rs2地址输入
    input wire[4:0]   rd_i,     // rd地址输入
    input wire        reg_wr_i, // reg写使能
    input wire[31:0]  wdata_i,  // 写入数据
    
    output wire[31:0] rs1_o,    // rs1输出数据
    output wire[31:0] rs2_o     // rs2输出数据
    );
    
    reg[31:0] gpr[31:0];
    
    assign rs1_o = (rs1_i == 0) ? 32'h00000000 : gpr[rs1_i];
    assign rs2_o = (rs2_i == 0) ? 32'h00000000 : gpr[rs2_i];
    
    always @ (posedge clk) begin
        if (reg_wr_i) begin
            gpr[rd_i] <= wdata_i;
        end
    end
    
endmodule
