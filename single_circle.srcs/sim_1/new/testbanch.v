`timescale 1ns / 1ps

module testbanch();
    reg clk;
    reg rst;
    mips my_mips(clk, rst);
    
    initial begin
        // 载入指令
        $readmemh("/home/silvester/vivado_project/single_circle/testcode/addcode.txt", my_mips.U_IM.im);
        // 载入寄存器值, 测试 addiu 不需要初始寄存器
        // $readmemh("/home/silvester/vivado_project/single_circle/testcode/regfile.txt", my_mips.U_RF.gpr);
        rst = 1;
        clk = 0;
        #30 rst = 0; // rst = 0，复位结束，开始工作
        #40 $display("%h",my_mips.U_RF.gpr[10]); // rst 置0后的第一个上升沿后10ns,此时第一条指令执行完，显示 $10 结果
        #40 $display("%h",my_mips.U_RF.gpr[10]); // 第二条指令执行完毕，显示 $10 和 $11 结果
            $display("%h",my_mips.U_RF.gpr[11]);
        #40 $display("%h",my_mips.U_RF.gpr[10]); // 第三条指令执行完毕，显示 $10 和 $11 结果
            $display("%h",my_mips.U_RF.gpr[11]);
        #20 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule
