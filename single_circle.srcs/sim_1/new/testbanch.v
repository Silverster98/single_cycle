`timescale 1ns / 1ps

module testbanch();
    reg clk;
    reg rst;
    mips my_mips(clk, rst);
    
    initial begin
        // 载入指令
        $readmemh("/home/silvester/vivado_project/single_circle/testcode/addcode.txt", my_mips.U_IM.im);
        rst = 1;
        clk = 0;
        #30 rst = 0; // rst = 0，复位结束，开始工作
        #120
        #40 $display("%h",my_mips.U_RF.gpr[12]);
        $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule
