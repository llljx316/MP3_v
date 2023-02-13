//~ `New testbench
`timescale  1ns / 1ps

module tb_bluetooth;

// bluetooth Parameters
parameter PERIOD    = 10;
parameter SONG_NUM  = 2;

// bluetooth Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rx                                   = 0 ;
reg   i_FINISH                             = 0 ;

// bluetooth Outputs
wire  [15:0]  o_vol                        ;
wire  [4:0]  o_song_select                 ;
wire  o_next                               ;
wire  o_pre                                ;
wire  o_pause                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

bluetooth #(
    .SONG_NUM ( SONG_NUM ))
 u_bluetooth (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .rx                      ( rx                    ),
    .i_FINISH                ( i_FINISH              ),

    .o_vol                   ( o_vol          [15:0] ),
    .o_song_select           ( o_song_select  [4:0]  ),
    .o_next                  ( o_next                ),
    .o_pre                   ( o_pre                 ),
    .o_pause                 ( o_pause               )
);

initial
begin

    $finish;
end

endmodule