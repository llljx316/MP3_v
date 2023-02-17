//~ `New testbench
`timescale  1ns / 1ps

module tb_vga;

// vga Parameters
parameter PERIOD  = 10;


// vga Inputs
reg   CLK                                  = 0 ;
reg   RST_BTN                              = 0 ;
reg   i_next                               = 0 ;
reg   i_pre                                = 0 ;
reg   i_vol_plus                           = 0 ;
reg   i_vol_dec                            = 0 ;
reg   [15:0]  doutb                        = 0 ;
reg   [3:0]  vol_level                     = 0 ;
reg   i_finish_song                        = 0 ;
reg   [7:0]  alc_x                         = 0 ;
reg   [7:0]  alc_y                         = 0 ;

// vga Outputs
wire  VGA_HS                               ;
wire  VGA_VS                               ;
wire  [3:0]  VGA_R                         ;
wire  [3:0]  VGA_G                         ;
wire  [3:0]  VGA_B                         ;
wire  [14:0]  addrb                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

vga  u_vga (
    .CLK                     ( CLK                   ),
    .RST_BTN                 ( RST_BTN               ),
    .i_next                  ( i_next                ),
    .i_pre                   ( i_pre                 ),
    .i_vol_plus              ( i_vol_plus            ),
    .i_vol_dec               ( i_vol_dec             ),
    .doutb                   ( doutb          [15:0] ),
    .vol_level               ( vol_level      [3:0]  ),
    .i_finish_song           ( i_finish_song         ),
    .alc_x                   ( alc_x          [7:0]  ),
    .alc_y                   ( alc_y          [7:0]  ),

    .VGA_HS                  ( VGA_HS                ),
    .VGA_VS                  ( VGA_VS                ),
    .VGA_R                   ( VGA_R          [3:0]  ),
    .VGA_G                   ( VGA_G          [3:0]  ),
    .VGA_B                   ( VGA_B          [3:0]  ),
    .addrb                   ( addrb          [14:0] )
);

initial
begin

    $finish;
end

endmodule