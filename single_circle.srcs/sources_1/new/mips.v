/*mip 顶层*/
/*
(.clk(), .rst())
*/
`timescale 1ns / 1ps

module mips(
    input wire clk,      // 时钟
    input wire rst       // 复位
    );
    
    wire[31:0] PCin;     // pc输入，npc的输出
    wire[31:0] PCout;    // pc输出，npc的输入，实际pc输出
    wire[31:0] PC_add_4; // pc+4输出，下一个指令地址
    wire[1:0]  npc_sel;  // npc的选择线                     [+]控制信号
    wire[31:0] inst;     // 指令
    
    wire[5:0]  op;       // 操作码
    wire[4:0]  rs;       // rs寄存器地址
    wire[4:0]  rt;       // rt寄存器地址
    wire[4:0]  rd;       // rd寄存器地址
    wire[4:0]  sa;       // 移位指示
    wire[5:0]  func;     // 指令的func
    wire[15:0] imm_16;   // 16位立即数
    wire[25:0] imm_26;   // 26位立即数
    
    
    wire[31:0] RS1out;    // rf模块输出操作数rs1
    wire[31:0] RS2out;    // rf模块输出操作数rs2
    wire       RegW;      // 写入寄存器使能                 [+]控制信号
    wire[4:0]  mux4_5out; // 写入寄存器地址
    wire[31:0] mux4_32out;// 写入寄存器数据
    
    
    wire[31:0] mux2out;   // alu的第二个操作数
    wire[31:0] ALUout;    // alu运算结果
    wire[2:0]  ALUctrl;   // alu控制信号                   [+]控制信号
    
    
    wire[31:0] DMout;     // 数据存储器输出数据
    wire       DMwrite;   // 数据存储器写入使能              [+]控制信号
    
    wire[1:0]  mux4_32sel;// 写入寄存器数据选择信号          [+]控制信号
    wire[1:0]  mux4_5sel; // 写入寄存器地址选择信号          [+]控制信号
    wire       mux2sel;   // alu第二个运算数选择信号         [+]控制信号
    wire       zero;    
    wire       beqout;    // 有条件跳转的条件
    wire[1:0]  extop;     // 立即数扩展操作选择信号          [+]控制信号
    wire[31:0] extout;    // 立即数扩展结果
        
    
    assign op = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign sa = inst[10:6];
    assign func = inst[5:0];
    assign imm_16 = inst[15:0];
    assign imm_26 = inst[25:0];
    
    /*
    * 这三个模块合起来是一个inst fetch unit
    */
    // pc module
    pc U_PC(.rst(rst), .clk(clk), .npc(PCin), .pc(PCout));
    // npc module
    npc U_nPC(.imm_16(imm_16), .imm_26(imm_26), .pc(PCout), .npc_op(npc_sel), .npc(PCin), .pc_add_4(PC_add_4));
    // inst memory module
    im U_IM(.addr(PCout[11:2]), .dout(inst));
    
    
    //ctrl module
    ctrl U_CTRL(.clk(clk), .rst(rst), .beqout(beqout), .op(op), .funct(func), .ALUctrl(ALUctrl), .DMWrite(DMwrite), 
        .npc_sel(npc_sel), .RegWrite(RegW), .ExtOp(extop), .mux4_5sel(mux4_5sel), .mux4_32sel(mux4_32sel), .mux2sel(mux2sel));
    
    // Regfile module
    regfile U_RF(.clk(clk), .rs1_i(rs), .rs2_i(rt), .rd_i(mux4_5out), .reg_wr_i(RegW), .wdata_i(mux4_32out), .rs1_o(RS1out), .rs2_o(RS2out));
    
    // alu module
    alu U_ALU(.A(RS1out), .B(mux2out), .ctrl(ALUctrl), .C(ALUout), .zero(zero), .beqout(beqout));
    
    // dm module
    dm U_DM(.addr(ALUout[11:2]), .din(RS2out), .we(DMwrite), .clk(clk), .dout(DMout));
    
    // Mux_4_32 module
    // 获取将要写入寄存器的写入数据
    mux_4_32 U_mux4_32(.muxSel(mux4_32sel), .in1(ALUout), .in2(DMout), .in3(PC_add_4), .in4(extout), .mout(mux4_32out));
    
    // Mux_4_5 module
    // 获取将要写入寄存器的目的地址，以写入数据
    mux_4_5 U_mux4_5(.muxSel(mux4_5sel), .in1(rt), .in2(rd), .mout(mux4_5out));
    
    // Mux_2 module
    // 获取alu将要运算的第二个运算数
    mux_2 U_mux2(.muxSel(mux2sel), .in1(RS2out), .in2(extout), .mout(mux2out));
    
    // extender module
    // 扩展16位立即数
    sign_ext U_signext(.imm_16(imm_16), .EXTop(extop), .extout(extout));
    
endmodule
