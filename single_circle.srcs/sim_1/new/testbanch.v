`timescale 1ns / 1ps

module testbanch();
    reg clk;
    reg rst;
    mips my_mips(clk, rst);
    
    initial begin
        // 载入指令
        $readmemh("/home/silvester/vivado_project/single_circle/testcode/addcode.txt", my_mips.U_IM.im);
        // 载入寄存器值
        $readmemh("/home/silvester/vivado_project/single_circle/testcode/regfile.txt", my_mips.U_RF.gpr);
        rst = 1;
        clk = 0;
        #30 rst = 0; // rst = 0，复位结束，开始工作
        $display("%h",my_mips.U_RF.gpr[11]); // 显示 $11 值
        #80 $display("%h",my_mips.U_RF.gpr[10]); // 此时运行110s,两条指令执行完毕，显示存在￥10的结果
        #20 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule
