`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/05 15:44:45
// Design Name: 
// Module Name: tb_blk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_blk(

    );

    // mp3 Parameters
    parameter PERIOD      = 2    ;


    // mp3 Inputs
    reg   CLK                                  = 0 ;
    reg   [11:0] addr                          = 0 ;
    
    wire  [15:0] dout0                             ;

    initial
    begin
        forever #(PERIOD/2)  CLK=~CLK;
    end



    initial
    begin
        forever #(PERIOD*8)  addr=addr+1;
    end

    blk_mem_gen_0 tank(
        .clka(CLK),
        .ena(1),
        .addra(addr),
        .douta(dout0)
    );

endmodule
