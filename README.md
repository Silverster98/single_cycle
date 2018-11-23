# MIPS 32 单周期 部分指令实现
说明：每次提交的 commit 都是在验证一个指令正确之后提交的 commit，对于每个指令，使用的验证程序不同。同时，测试指令的写法也并不是严格按照MIPS汇编来写的，仅仅根据每条指令的格式来写出他的16进制数，然后运行。

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

### lw 指令
需要初始化数据存储器，初始化的数据如下
```
0x00000001
0x0000000f
```
即第0字存0x00000001,第1字存0x0000000f

三条测试指令如下
```
lw $10,0($0)         10001100 00001010 00000000 00000000    0x8c0a0000
lw $11,3($10)        10001101 01001011 00000000 00000003    0x8d4b0003
add $12,$10,$11      00000001 01001011 01100000 00100000    0x014b6020
```
说明：首先先将 dm 中的0号存储字的数据加载到 $10,然后将1号存储字的数据加载到 $11,最后将 $10 和 $11 两数相加存在 $12。注意，第二条指令 ($10) + 3 的原因是数据是按字存储的，但是地址按字节编址，所以访问第二个字数据需要 ($10) + 3 = 1 + 3 = 4 这个地址,由此加载 dm\[4/4\] 即 dm\[1\]

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
        // 载入MEM
        $readmemh("/home/silvester/vivado_project/single_circle/testcode/memfile.txt", my_mips.U_DM.dm);
        rst = 1;
        clk = 0;
        #30 rst = 0; // rst = 0，复位结束，开始工作
        #40 $display("%h",my_mips.U_RF.gpr[10]);
        #40 $display("%h",my_mips.U_RF.gpr[11]);
        #40 $display("%h",my_mips.U_RF.gpr[12]);
        #20 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule

```

### sw 指令
三条测试指令如下
```
addiu $10,$0,0x0009   00100100 00001010 00000000 00001001    0x240a0009
sw $10,4($0)          10101100 00001010 00000000 00000100    0xac0a0004
sw $0,3($10)          10101101 01000000 00000000 00000011    0xad400003
```
说明：第一条就是计算结果9加载到 $10,然后将 $10 的结果加载至数据存储器1号字地址，最后一条就是将 $0 数据存在 (3+9)/4 = 3 号地址

testbench测试程序
```
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
        #40 $display("%h",my_mips.U_RF.gpr[10]);
        #100 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule

```
最后，在窗口处看dm的数据即可。

### lui 指令
测试的三条指令
```
lui $10,1          00111100 00001010 00000000 00000001    0x3c0a0001
lui $11,5          00111100 00001011 00000000 00000101    0x3c0b0005
add $12,$11,$10    00000001 01101010 01100000 00100000    0x016a6020
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
        rst = 1;
        clk = 0;
        #30 rst = 0; // rst = 0，复位结束，开始工作
        #40 $display("%h",my_mips.U_RF.gpr[10]);
        #40 $display("%h",my_mips.U_RF.gpr[11]);
        #40 $display("%h",my_mips.U_RF.gpr[12]);
        #20 $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule

```

### j 指令
测试的几条指令如下
```
j 0x4              00001000 00000000 00000000 00000101   0x08000004
addiu $10,$0,1     00101000 00001010 00000000 00000001   0x240a0001
addiu $10,$0,2     00101000 00001010 00000000 00000010   0x240a0002
addiu $10,$0,3     00101000 00001010 00000000 00000011   0x240a0003
addiu $10,$0,4     00101000 00001010 00000000 00000100   0x240a0004
addiu $11,$10,5    00101001 01001011 00000000 00000101   0x254b0005
```
说明：第一条指令即跳转，跳转至 addiu $10,$0,4 ，之后顺序执行
testbench测试程序
```
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
        #100 $display("%h",my_mips.U_RF.gpr[10]);
        #20 $display("%h",my_mips.U_RF.gpr[11]);
        $stop; // 停止
    end
    
    always
        #20 clk = ~clk; // 时钟
    
endmodule

```

# beq 指令
测试指令
```
addiu $10,$0,5    00101000 00001010 00000000 00000101   0x240a0005
addiu $11,$0,5    00101000 00001011 00000000 00000101   0x240b0005
beq $10,$11,1     00010001 01001011 00000000 00000001   0x114b0001
add $12,$10,$11   00000001 01001011 01100000 00100000   0x014b6020
sub $12,$10,$11   00000001 01001011 01100000 00100010   0x014b6022
```
说明，在第三条指令下， ($10)和($11)的值相等，则跳转至最后一条指令，最后($12)=0

testbench测试程序
```
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

```

emmmmmm 再说一个比较丢人的事，单周期是single_cycle,然后我在用vivado新建项目时写成了single_circle。。。然后找了半天，不知道怎么改项目名。。。所以文件夹名都是single_circle。哎，太菜了。
