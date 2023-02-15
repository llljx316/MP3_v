`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/02 18:10:03
// Design Name: 
// Module Name: vga
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
`default_nettype none

module vga(
    input  wire CLK,                // board clock: 100 MHz on Arty/Basys3/Nexyss
    input  wire RST_BTN,            // reset button
    input  wire i_next,
    input  wire i_pre,
    
    output wire VGA_HS,             // horizontal sync output
    output wire VGA_VS,             // vertical sync output
    output wire [3:0] VGA_R,        // 4-bit VGA red output
    output wire [3:0] VGA_G,        // 4-bit VGA green output
    output wire [3:0] VGA_B         // 4-bit VGA blue output
    );
    
     // Display Clocks
    wire pix_clk;                   // pixel clock
    wire clk_lock;                  // clock locked?
    
    
    display_clocks #(               // 640x480  800x600 1280x720 1920x1080
       .MULT_MASTER(31.5),         //    31.5     10.0   37.125    37.125
       .DIV_MASTER(5),             //       5        1        5         5
       .DIV_5X(5.0),               //     5.0      5.0      2.0       1.0
       .DIV_1X(25),                //      25       25       10         5
       .IN_PERIOD(10.0)            // 100 MHz = 10 ns
    )
    display_clocks_inst
    (
      .i_clk(CLK),
      .i_rst(~RST_BTN),            // reset is active low on Arty & Nexys Video
      .o_clk_1x(pix_clk),
      .o_clk_5x(),                 // 5x clock not needed for VGA
      .o_locked(clk_lock)
    );
 
    /*
    Divider#(
        .FREQ(25)
    )
    Divider_inst(
        .I_CLK(CLK),
        .rst(RST_BTN),
        .O_CLK(pix_clk)
    );

        */
    //timing
    wire hs;
    wire vs;
    wire frame;
    wire de;
    wire signed [15:0] sx;
    wire signed [15:0] sy;
    display_timings #(              // 640x480  800x600 1280x720 1920x1080
        .H_RES(640),                //     640      800     1280      1920
        .V_RES(480),                //     480      600      720      1080
        .H_FP(16),                  //      16       40      110        88
        .H_SYNC(96),                //      96      128       40        44
        .H_BP(48),                  //      48       88      220       148
        .V_FP(10),                  //      10        1        5         4
        .V_SYNC(2),                 //       2        4        5         5
        .V_BP(33),                  //      33       23       20        36
        .H_POL(0),                  //       0        1        1         1
        .V_POL(0)                   //       0        1        1         1
    )
    display_timing_600p(
        .i_pix_clk(pix_clk),
        .i_rst(~RST_BTN),
        .o_hs(hs),
        .o_vs(vs),
        .o_frame(frame),
        .o_de(de),
        .o_sx(sx),
        .o_sy(sy)
    );

    //simple test
    assign VGA_HS=hs;
    assign VGA_VS=vs;

    wire [7:0]red;
    wire [7:0] green;
    wire [7:0] blue;
/*
    test_card_simple(
        .i_x(sx),
        .o_red(red),
        .o_green(green),
        .o_blue(blue)
    );
*/
    // Test Card: Squares - ENABLE ONE TEST CARD INSTANCE ONLY
    mp3_display #(
        .H_RES(640),    // horizontal resolution
        .V_RES(480)     // vertical resolution
    )
    mp3_show_vga (
        .clk(CLK),
        .rst_n(RST_BTN),
        .i_x(sx),
        .i_y(sy),
        .i_next(i_next),
        .i_pre(i_pre),
        .i_vol_plus(),
        .i_vol_dec(),

        .o_red(red),
        .o_green(green),
        .o_blue(blue)

    );
    // always @(sy)
    //     if(sy == 300)
    //     $finish;

    assign VGA_R    = de ? red[7:4] : 4'b0;
    assign VGA_G    = de ? green[7:4] : 4'b0;
    assign VGA_B    = de ? blue[7:4] : 4'b0;

    // assign VGA_R    = de ? 4'b1111 : 4'b0;
    // assign VGA_G    = de ? 4'b0 : 4'b0;
    // assign VGA_B    = de ? 4'b0 : 4'b0;

    //some square or something that you want to display on the screen
endmodule
