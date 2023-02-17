//~ `New testbench
`timescale  1ns / 1ps

module tb_mp3_display;

// mp3_display Parameters
parameter PERIOD  = 10;


// mp3_display Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [15:0]  i_x                          = 0 ;
reg   [15:0]  i_y                          = 0 ;
reg   i_next                               = 0 ;
reg   i_pre                                = 0 ;
reg   i_vol_plus                           = 0 ;
reg   i_vol_dec                            = 0 ;
reg   [15:0]  doutb                        = 0 ;
reg   i_vs                                 = 0 ;
reg   [3:0]  vol_level                     = 0 ;
reg   i_finish_song                        = 0 ;
reg   [7:0]  alc_x                         = 0 ;
reg   [7:0]  alc_y                         = 0 ;

// mp3_display Outputs
wire  [3:0]  o_red                         ;
wire  [3:0]  o_green                       ;
wire  [3:0]  o_blue                        ;
wire  [14:0]  addrb                        ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mp3_display 
 u_mp3_display (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .i_x                     ( i_x            [15:0] ),
    .i_y                     ( i_y            [15:0] ),
    .i_next                  ( i_next                ),
    .i_pre                   ( i_pre                 ),
    .i_vol_plus              ( i_vol_plus            ),
    .i_vol_dec               ( i_vol_dec             ),
    .doutb                   ( doutb          [15:0] ),
    .i_vs                    ( i_vs                  ),
    .vol_level               ( vol_level      [3:0]  ),
    .i_finish_song           ( i_finish_song         ),
    .alc_x                   ( alc_x          [7:0]  ),
    .alc_y                   ( alc_y          [7:0]  ),

    .o_red                   ( o_red          [3:0]  ),
    .o_green                 ( o_green        [3:0]  ),
    .o_blue                  ( o_blue         [3:0]  ),
    .addrb                   ( addrb          [14:0] )
);

initial
begin
    // #(PERIOD*6) i_next = 1;
    // #(PERIOD) i_next = 0;
    //#(PERIOD*80) i_pre = 1;
    //#(PERIOD) i_pre = 0;
    #(PERIOD*6) i_x = 80;
    i_y = 350;
    repeat(120)
    #(PERIOD) i_x = i_x + 1;
    #20 alc_x = 8'hfc;
    #20;
    $finish;
end



endmodule