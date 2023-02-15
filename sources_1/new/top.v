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
`default_nettype wire

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
    output wire o_XRST,

    output wire o_led_song_select,
    output wire [6:0] onum,          
    output wire [7:0] odigit,
    
    //vga
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [3:0]VGA_R,
    output wire [3:0]VGA_G,
    output wire [3:0]VGA_B,
    output wire o_next
    
    );

    wire FINISH;
    wire [15:0] vol;
    wire [15:0] o_vol;
    wire [2:0] song_select;
    wire o_song_select;
    wire pause;
    
    wire next,pre;  //indicate change of song
    wire vol_plus,vol_dec;

    bluetooth
    bluetooth_mp3 (
        .clk                     ( clk                   ),
        .rst_n                   ( rst_n                 ),
        .rx                      ( rx                    ),
        .i_FINISH                ( FINISH                ),

        .o_vol                   ( vol          [15:0] ),
        .o_song_select           ( song_select         ),
        .o_pause                 ( pause               ),
        .o_next                  ( next                ),
        .o_pre                   ( pre                 ),
        .o_vol_plus              ( vol_plus            ),
        .o_vol_dec               ( vol_dec             )
    );

    mp3#(
        .DELAY_TIME(50000),
        .CMD_NUM(2)
    )
    u_mp3 (
        .clk                     ( clk                    ),
        .rst_n                   ( rst_n                  ),
        .i_DREQ                  ( i_DREQ                 ),
        .i_vol                   ( vol           [15:0]   ),
        .i_song_select           ( song_select            ),
        .i_pause                 ( pause                  ),

        .o_XCS                   ( o_XCS                  ),
        .o_XDCS                  ( o_XDCS                 ),
        .o_SCK                   ( o_SCK                  ),
        .o_SI                    ( o_SI                   ),
        .o_XRST                  ( o_XRST                 ),
        .o_LED                   ( o_LED                  ),
        .o_FINISH                ( finish                 ),
        .o_vol                   (o_vol          [15:0]),
        .o_song_select           (o_led_song_select)
    );

    assign o_next = next;// for test
    
    vga  display_vga (
    .CLK                     ( clk            ),
    .RST_BTN                 ( rst_n        ),
    .i_next                  ( next         ),
    .i_pre                   ( pre          ),
    .i_vol_plus              ( vol_plus     ),
    .i_vol_dec               ( vol_dec      ),

    .VGA_HS                  ( VGA_HS         ),
    .VGA_VS                  ( VGA_VS         ),
    .VGA_R                   ( VGA_R          ),
    .VGA_G                   ( VGA_G          ),
    .VGA_B                   ( VGA_B          )
);
    
    
    display_num
    display_vol(
        .idata(o_vol),

        .rst_n(rst_n),
        .clk(clk),
        .onum(onum),          
        .odigit(odigit)   
    );
    
endmodule
