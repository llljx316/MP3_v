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

    output wire [1:0] o_led_song_select,
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

    wire [15:0] vol;
    wire [15:0] o_vol;
    wire [2:0] song_select;
    wire o_song_select;
    wire pause;
    
    wire next,pre;  //indicate change of song
    wire vol_plus,vol_dec;
    wire finish_song;
    wire [3:0] vol_level;

    bluetooth
    bluetooth_mp3 (
        .clk                     ( clk                   ),
        .rst_n                   ( rst_n                 ),
        .rx                      ( rx                    ),
        .i_finish_song           ( finish_song           ),

        .vol_level               ( vol_level             ),
        .o_vol                   ( vol          [15:0] ),
        .o_song_select           ( song_select         ),
        .o_pause                 ( pause               ),
        .o_next                  ( next                ),
        .o_pre                   ( pre                 ),
        .o_vol_plus              ( vol_plus            ),
        .o_vol_dec               ( vol_dec             )
    );

    //picmem
    wire clka,clkb;
    wire [14:0] addra,addrb;
    wire [15:0] dina,doutb;
    blk_mem_gen_buf_audio_pic 
    pic_ram(
        .clka(clk),
        .ena(1),
        .wea(1),
        .addra(addra),
        .dina(dina),
        .clkb(clk),
        .enb(1),
        .addrb(addrb),
        .doutb(doutb)
    );


    mp3#(
        .DELAY_TIME(2000),
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
        .o_vol                   (o_vol          [15:0]),
        .o_song_select           (o_led_song_select       ),
        .addra                   ( addra                  ),
        .dina                    ( dina                   ),
        .o_finish_song           ( finish_song            )
        //.clka                    ( clka                   )
    );

    assign o_next = next;// for test
    
    vga  display_vga (
        .CLK                     ( clk            ),
        .RST_BTN                 ( rst_n        ),
        .i_next                  ( next         ),
        .i_pre                   ( pre          ),
        .i_vol_plus              ( vol_plus     ),
        .i_vol_dec               ( vol_dec      ),
        .doutb                   ( doutb          ),
        .i_finish_song           ( finish_song           ),
        .vol_level               ( vol_level    ),

        .VGA_HS                  ( VGA_HS         ),
        .VGA_VS                  ( VGA_VS         ),
        .VGA_R                   ( VGA_R          ),
        .VGA_G                   ( VGA_G          ),
        .VGA_B                   ( VGA_B          ),
        .addrb                   ( addrb          )
    );

    wire [7:0] minute, second;
    wire [15:0] dtime;

    counter  u_counter (
        .clk                     ( clk           ),
        .rst_n                   ( rst_n         ),
        .next                    ( next          ),
        .pre                     ( pre           ),

        .minute                  ( minute  [7:0] ),
        .second                  ( second  [7:0] )

    );

    assign dtime = minute*100+second;
    
    display_num
    display_vol(
        .idata(dtime),

        .rst_n(rst_n),
        .clk(clk),
        .onum(onum),          
        .odigit(odigit)  
    );


endmodule
