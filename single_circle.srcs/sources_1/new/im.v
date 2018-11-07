/*指令存储器*/

/*
(.addr(), .dout())
*/
module im(
    input wire[11:2] addr,
    
    output wire[31:0] dout
    );
    
    reg[31:0] im[1023:0];
    assign dout = im[addr];
endmodule
