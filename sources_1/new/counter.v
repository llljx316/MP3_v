`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/16 20:59:53
// Design Name: 
// Module Name: counter
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


module counter(
    input wire clk,
    input wire rst_n,
    input next,
    input pre,

    output reg [7:0] minute,
    output reg [7:0] second
    //output reg o_finish_song
    );


    wire clk_second;
    clock_divider#(
        .Time(100000000)
    ) second_divider(
        .clkin(clk),
        .clkout(clk_second)
    );

    always@(posedge clk_second or negedge rst_n or posedge next or posedge pre) begin
        if(~rst_n | next | pre) begin
            minute <= 0;
            second <= 0;
            //o_finish_song <= 0;
        end
        else begin
            if(minute == 1 & second == 15)begin 
                //o_finish_song <= 1;
                minute <= 0;
                second <= 0;
            end
            else begin
                if(second == 59) begin
                    second<=0;
                    minute <= minute + 1;
                end

                else begin 
                    //o_finish_song <= 0;
                    second <= second + 1;
                end
            end
        end 

    end
endmodule
