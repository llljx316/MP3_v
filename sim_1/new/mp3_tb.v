//~ `New testbench
`timescale  1ns / 1ps

module tb_mp3;

// mp3 Parameters
parameter PERIOD      = 2    ;
parameter CMD_NUM     = 2     ;
parameter DELAY_TIME  = 1;

// mp3 Inputs
reg   clk                                  = 0 ;
reg   i_DREQ                               = 1 ;
reg   rst_n                                = 0 ;

// mp3 Outputs
wire  o_XDCS                               ;
wire  o_XCS                                ;
wire  o_XRST                               ;
wire  o_SI                                 ;
wire  o_SCK                                ;
wire  o_LED                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mp3 #(
    .CMD_NUM    ( CMD_NUM    ),
    .DELAY_TIME ( DELAY_TIME ))
 u_mp3 (
    .clk                     ( clk      ),
    .i_DREQ                  ( i_DREQ   ),
    .rst_n                   ( rst_n    ),

    .o_XDCS                  ( o_XDCS   ),
    .o_XCS                   ( o_XCS    ),
    .o_XRST                  ( o_XRST   ),
    .o_SI                    ( o_SI     ),
    .o_SCK                   ( o_SCK    ),
    .o_LED                   ( o_LED    )
);

// initial
// begin

//     $finish;
// end

endmodule