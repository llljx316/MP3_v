`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/03 21:40:19
// Design Name: 
// Module Name: display7_int
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


module display7_8digit
    (
    input [3:0] hex0,
    input [3:0] hex1,
    input [3:0] hex2,
    input [3:0] hex3,
    input [3:0] hex4,
    input [3:0] hex5,
    input [3:0] hex6,
    input [3:0] hex7,
    input [7:0] dp_in,              //小数点
    input [7:0] idigit,
    input clk,
    input rst_n,
    
    output wire[7:0] onum,          //7位代表一个整数, 最高位是小数点
    output reg [7:0] odigit         //亮的数码管
    );

    localparam N = 19;
    reg [N-1:0] cnt;
    reg [3:0] hex_in;
    reg dp;
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            cnt<=0;
        end
        else
            cnt<=cnt+1;
    end

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            odigit<=8'b11111111;
        else begin
            case(cnt[N-1:N-3])
            3'b000:begin
                odigit= idigit & 8'b11111110;//选中第一个
                hex_in=hex0;
                dp=dp_in[0];
            end
            3'b001:begin
                odigit= idigit & 8'b11111101;
                hex_in=hex1;
                dp=dp_in[1];
            end
            3'b010:begin
                odigit= idigit & 8'b11111011;
                hex_in=hex2;
                dp=dp_in[2];
            end
            3'b011:begin
                odigit= idigit & 8'b11110111;
                hex_in=hex3;
                dp=dp_in[3];
            end
            3'b100:begin
                odigit= idigit & 8'b11101111;//选中第一个
                hex_in=hex4;
                dp=dp_in[4];
            end
            3'b101:begin
                odigit= idigit & 8'b11011111;
                hex_in=hex5;
                dp=dp_in[5];
            end
            3'b110:begin
                odigit= idigit & 8'b10111111;
                hex_in=hex6;
                dp=dp_in[6];
            end
            3'b111:begin
                odigit= idigit & 8'b01111111;
                hex_in=hex7;
                dp=dp_in[7];
            end
            endcase
        end
    end

    display7
    display7_inst(
        .iData(hex_in),
        .oData(onum)
    );


endmodule
