//~ `New testbench
`timescale  1ns / 1ps

module tb_top;

// top Parameters
parameter PERIOD  = 10;


// top Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rx                                   = 0 ;
reg   i_DREQ                               = 1 ;

// top Outputs
wire  o_LED                                ;
wire  o_SI                                 ;
wire  o_SCK                                ;
wire  o_XDCS                               ;
wire  o_XCS                                ;
wire  o_XRST                               ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

top  u_top (
    .clk                     ( clk      ),
    .rst_n                   ( rst_n    ),
    .rx                      ( rx       ),
    .i_DREQ                  ( i_DREQ   ),

    .o_LED                   ( o_LED    ),
    .o_SI                    ( o_SI     ),
    .o_SCK                   ( o_SCK    ),
    .o_XDCS                  ( o_XDCS   ),
    .o_XCS                   ( o_XCS    ),
    .o_XRST                  ( o_XRST   )
);

// initial
// begin

//     $finish;
// end

endmodule