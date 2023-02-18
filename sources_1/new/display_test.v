`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/03 23:21:52
// Design Name: 
// Module Name: display_test
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


module display_num(

    input wire [15:0] idata,
    input wire rst_n,
    input wire clk,
    input wire [7:0] dp_in,
    input wire [7:0] idigit,

    output wire [6:0] onum,          
    output wire [7:0] odigit         
    );

 
    reg [31:0] out;
    //reg [15:0] t_idata = 15'h1234;
    always@(posedge clk) begin
        out[3:0] <= idata%10;
        out[7:4] <= (idata/10)%10;
        out[11:8] <= (idata/100)%10;
        out[15:12] <= (idata/1000)%10;
        out[19:16] <= (idata/10000)%10;
        out[23:20] <= (idata/100000)%10;
        out[27:24] <= (idata/1000000)%10;
        out[31:28] <= (idata/10000000)%10;

    end



    display7_8digit
    display7_low_inst(
        .hex0(out[3:0]),
        .hex1(out[7:4]),
        .hex2(out[11:8]),
        .hex3(out[15:12]),
        .hex4(out[19:16]),
        .hex5(out[23:20]),
        .hex6(out[27:24]),
        .hex7(out[31:28]),
        .dp_in(dp_in),
        .idigit(idigit),

        .clk(clk),
        .rst_n(rst_n),
        .onum(onum),
        .odigit(odigit)
    );
    

endmodule
