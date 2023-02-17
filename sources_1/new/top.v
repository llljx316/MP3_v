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
    output wire o_next,
    output wire [7:0]o_vol_led,

    //accelerometer
    input       ACL_MISO,
    input       ACL_INT1,
    input       ACL_INT2,
    output wire ACL_CSN,
    output wire ACL_SCLK,
    output wire ACL_MOSI

    
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


    mp3 u_mp3 (
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

    wire signed [7:0] x_data, y_data;//x y Æ«ÒÆÊý¾Ý
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
        .alc_x                   ( x_data       ),
        .alc_y                   ( y_data       ),

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
        .second                  ( second  [7:0] ),
        .i_finish_song           ( finish_song           )

    );

    assign dtime = minute*100+second;
    
    display_num display_time(
        .idata(dtime),
        .dp_in(8'b00000100),
        .idigit(8'b00001111),

        .rst_n(rst_n),
        .clk(clk),
        .onum(onum),          
        .odigit(odigit)  
    );

    //vol_led
    // wire [4:0]vol_led_level = 8-vol_level; 
    // always@(vol_led_level) begin
    //     case(vol_led_level)
    //         0: o_vol_led <= 8'b0;
    //         1: o_vol_led <= 8'b1;
    //         2: o_vol_led <= 8'b11;
    //         3: o_vol_led <= 8'b111;
    //         4: o_vol_led <= 8'b1111;
    //         5: o_vol_led <= 8'b11111;
    //         6: o_vol_led <= 8'b111111;
    //         7: o_vol_led <= 8'b1111111;
    //         default: o_vol_led <= 8'b11111111;
    //     endcase
    // end
    led_display leds(
        .vol_level(vol_level),
        .o_vol_led(o_vol_led)
    );

    //accelerometer
    get_acl_data u_get_acl_data (
        .rst                     ( ~rst_n          ),
        .clk                     ( clk             ),
        .MISO                    ( ACL_MISO            ),
        .INT1                    ( ACL_INT1            ),
        .INT2                    ( ACL_INT2            ),

        .x_data                  ( x_data    [7:0] ),
        .y_data                  ( y_data    [7:0] ),
        .LED_INT1                (         ),
        .LED_INT2                (         ),
        .CSN                     ( ACL_CSN             ),
        .SCLK                    ( ACL_SCLK            ),
        .MOSI                    ( ACL_MOSI            )
    );

endmodule
