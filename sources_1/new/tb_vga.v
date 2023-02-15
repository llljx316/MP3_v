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

// vga Outputs
wire  VGA_HS                               ;
wire  VGA_VS                               ;
wire  [3:0]  VGA_R                         ;
wire  [3:0]  VGA_G                         ;
wire  [3:0]  VGA_B                         ;


initial
begin
    forever #(PERIOD/2)  CLK=~CLK;
end

initial
begin
    #(PERIOD*2) RST_BTN  =  1;
end

vga  u_vga (
    .CLK                     ( CLK            ),
    .RST_BTN                 ( RST_BTN        ),
    .i_next                  ( i_next         ),
    .i_pre                   ( i_pre          ),

    .VGA_HS                  ( VGA_HS         ),
    .VGA_VS                  ( VGA_VS         ),
    .VGA_R                   ( VGA_R    [3:0] ),
    .VGA_G                   ( VGA_G    [3:0] ),
    .VGA_B                   ( VGA_B    [3:0] )
);

initial
begin
    $finish;
end

endmodule