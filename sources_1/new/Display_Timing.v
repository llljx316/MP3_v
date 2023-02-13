`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/02 20:53:10
// Design Name: 
// Module Name: Display_Timing
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

//default: 800*600
module display_timings #(
    parameter H_RES=800,                      // horizontal resolution (pixels)
    parameter V_RES=600,                      // vertical resolution (lines)
    parameter H_FP=40,                        // horizontal front porch
    parameter H_SYNC=128,                      // horizontal sync
    parameter H_BP=88,                        // horizontal back porch
    parameter V_FP=1,                        // vertical front porch
    parameter V_SYNC=4,                       // vertical sync
    parameter V_BP=23,                        // vertical back porch
    parameter H_POL=1,                        // horizontal sync polarity (0:neg, 1:pos)
    parameter V_POL=1                         // vertical sync polarity (0:neg, 1:pos)
    )
    (
    input wire i_pix_clk,                //pixel clock
    input wire i_rst,
    output wire o_hs,
    output wire o_vs,
    output wire o_frame,
    output wire o_de,                    //display enable:high during active video
    output reg signed [15:0] o_sx,             //horizontal secreen position
    output reg signed [15:0] o_sy              //vertical screen position
    );
    
    //horizontal
    localparam signed H_STA = 0-H_FP-H_SYNC-H_BP;
    localparam signed HS_STA = H_STA+H_FP;
    localparam signed HS_END = HS_STA+H_SYNC;       //sync period
    localparam signed HA_STA = 0;                   //active start
    localparam signed HA_END = H_RES - 1;           //active end
    
    //vertical
    localparam signed V_STA = 0-V_FP-V_SYNC-V_BP;
    localparam signed VS_STA = V_STA+V_FP;
    localparam signed VS_END = VS_STA+V_SYNC;       //
    localparam signed VA_STA = 0;                   //active start
    localparam signed VA_END = V_RES - 1;           //active end

    //sync signal
    assign o_hs = H_POL?(o_sx>HS_STA && o_sx<=HS_END): ~(o_sx>HS_STA && o_sx<=HS_END);
    assign o_vs = V_POL?(o_sy>VS_STA && o_sy<=VS_END): ~(o_sy>VS_STA && o_sy<=VS_END);

    //display enable
    assign o_de = (o_sx>=0 && o_sy>=0);

    //o_frame: high for one tick at the start of each frame
    assign o_frame = (o_sy==V_STA && o_sx==H_STA);

    always @ (posedge i_pix_clk) begin
        if(i_rst) begin
            o_sx <= H_STA;
            o_sy <= V_STA;
        end

        else begin
            //judge row
            if(o_sx == HA_END) begin
                o_sx <= H_STA;
                //column judge
                if(o_sy == VA_END)
                    o_sy <= V_STA;
                else
                    o_sy <= o_sy + 16'h1;
            end
            else
                o_sx <= o_sx + 16'h1;
        end
    end
endmodule
