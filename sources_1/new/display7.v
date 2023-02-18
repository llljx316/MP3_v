`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/12 18:21:17
// Design Name: 
// Module Name: display7
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


module display7(
    iData,oData,oPoint
    );
    input [3:0] iData;
    output[6:0] oData;
    output oPoint;

    wire [3:0]iData;
    reg [6:0] oData;
    wire oPoint;
    
    assign oPoint = 1'b1;

    always @(*) begin
        //一个数字一个数字来
        if(iData == 0)
            oData=7'b1000000;
        else if(iData == 1)
            oData=7'b1111001;
        else if(iData == 2)
            oData=7'b0100100;
        else if(iData == 3)
            oData=7'b0110000;
        else if(iData == 4)
            oData=7'b0011001;
        else if(iData == 5)
            oData=7'b0010010;
        else if(iData == 6)
            oData=7'b0000010;
        else if(iData == 7)
            oData=7'b1111000;
        else if(iData == 8)
            oData=7'b0000000;
        else
            oData=7'b0010000;
    end
endmodule
