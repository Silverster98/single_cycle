# MIPS 32 单周期 部分指令实现
说明：每次提交的 commit 都是在验证一个指令正确之后提交的 commit，对于每个指令，使用的验证程序不同。

- single_circle.srcs 文件夹包含 源文件和仿真文件
- testcode 文件夹包含各个指令的测试二进制代码和寄存器初始值

代码当前实现指令如下：

### add 指令
测试的两条指令
```
add $12 $11 $0    00000001 01100000 01100000 00100000   0x01606020
add $10 $11 $12   00000001 01101100 01010000 00100000   0x016c5020
```
寄存器初始数据，只初始前12个就好了
```
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000000
0x00000003
```
testbench 测试程序
```
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
```
### addiu 指令
三条测试指令如下
```
addiu $10 $0 0x0001          00100100 00001010 00000000 00000001      0x240a0001
addiu $11 $10 0x0010         00100101 01001011 00000000 00010001      0x254b0010
addiu $10 $11 0x1111         00100101 01101010 11111111 11111111      0x256affff
```
寄存器不需要赋初始值

testbench 测试程序
```
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
```

### sub 指令
四条测试指令如下
```
addiu $10 $0 0x0009         00100100 00001010 00000000 00001001     0x240a0009
addiu $11 $0 0x0003         00100100 00001011 00000000 00000011     0x240b0003
sub $12 $10 $11             00000001 01001011 01100000 00100010     0x014b6022
sub $11 $12 $10             00000001 10001010 01011000 00100010     0x018a5822
```
testbench 测试程序
```
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
        #40 $display("%h",my_mips.U_RF.gpr[10]); // 第三条指令执行完毕，显示 $10 $12 $11 结果
            $display("%h",my_mips.U_RF.gpr[11]);
            $display("%h",my_mips.U_RF.gpr[12]);
        #40 $display("%h",my_mips.U_RF.gpr[10]); // 第四条指令执行完毕，显示 $10 $12 $11 结果
            $display("%h",my_mips.U_RF.gpr[11]);
            $display("%h",my_mips.U_RF.gpr[12]);
        #20 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule

```

emmmmmm 再说一个比较丢人的事，单周期是single_cycle,然后我在用vivado新建项目时写成了single_circle。。。然后找了半天，不知道怎么改项目名。。。所以文件夹名都是single_circle。哎，太菜了。
