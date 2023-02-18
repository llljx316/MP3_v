`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/17 15:38:10
// Design Name: 
// Module Name: led_display
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


module led_display(
    input wire clk,
    input wire [4:0] vol_level,
    input wire rst_n,
    output reg [7:0] o_vol_led
    );

    wire [4:0]vol_led_level = 8-vol_level; 
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            o_vol_led <= 8'b0;
        end
        else begin
            case(vol_led_level)
                0: o_vol_led <= 8'b0;
                1: o_vol_led <= 8'b1;
                2: o_vol_led <= 8'b11;
                3: o_vol_led <= 8'b111;
                4: o_vol_led <= 8'b1111;
                5: o_vol_led <= 8'b11111;
                6: o_vol_led <= 8'b111111;
                7: o_vol_led <= 8'b1111111;
                default: o_vol_led <= 8'b11111111;
            endcase
        end
    end
endmodule
