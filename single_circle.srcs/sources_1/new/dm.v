/*数据存储器*/
/*
(.addr(), .din(), .we(), .clk(), .dout())
*/
`timescale 1ns / 1ps

module dm(
    input wire[11:2] addr,
    input wire[31:0] din,
    input wire we,
    input wire clk,
    
    output wire[31:0] dout
    );
    
    reg[31:0] dm[1023:0];
    assign dout = dm[addr];
    
    always @ (posedge clk) begin
        if (we) begin
            dm[addr] <= din;
        end
    end
endmodule
