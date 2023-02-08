`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/08 16:21:08
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst_n,
    input rx,
    //mp3
    input i_DREQ,

    output wire o_LED,
    output wire o_SI,
    output wire o_SCK,
    output wire o_XDCS,
    output wire o_XCS,
    output wire o_XRST

    );

    wire FINISH;
    wire [15:0] vol;
    wire song_select;
    wire pause;

    bluetooth
    bluetooth_mp3 (
        .clk                     ( clk                   ),
        .rst_n                   ( rst_n                 ),
        .rx                      ( rx                    ),
        .i_FINISH                ( FINISH                ),

        .o_vol                   ( vol          [15:0] ),
        .o_song_select           ( song_select         ),
        .o_pause                 ( pause               )
    );

    mp3 
    u_mp3 (
        .clk                     ( clk                    ),
        .rst_n                   ( rst_n                  ),
        .i_DREQ                  ( i_DREQ                 ),
        // .i_vol                   ( vol           [15:0]   ),
        // .i_music_select          ( song_select            ),
        // .i_pause                 ( pause                  ),

        .o_XCS                   ( o_XCS                  ),
        .o_XDCS                  ( o_XDCS                 ),
        .o_SCK                   ( o_SCK                  ),
        .o_SI                    ( o_SI                   ),
        .o_XRST                  ( o_XRST                 ),
        .o_LED                   ( o_LED                  )//,
        // .o_FINISH                ( finish                 )
    );
endmodule
