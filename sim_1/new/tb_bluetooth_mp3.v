//~ `New testbench
`timescale  1ns / 1ps

module tb_mp3;

// mp3 Parameters
parameter PERIOD      = 0.1   ;
parameter DELAY_TIME  = 1;

// mp3 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   i_DREQ                               = 1 ;
reg   [15:0]  i_vol                        = 16'hffff ;
reg   i_next                               = 0 ;
reg   i_pre                                = 0 ;
reg   i_pause                              = 0 ;

// mp3 Outputs
wire  o_XCS                                ;
wire  o_XDCS                               ;
wire  o_SCK                                ;
wire  o_SI                                 ;
wire  o_XRST                               ;
wire  o_LED                                ;
wire  o_FINISH                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

always@(*) begin
    if(~o_XDCS) begin
        i_next = 1;
    end

    else if(o_FINISH)
        i_next = 0;
end

initial begin 
    $finish;
end

mp3 #(
    .DELAY_TIME ( DELAY_TIME ))
 u_mp3 (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .i_DREQ                  ( i_DREQ           ),
    .i_vol                   ( i_vol     [15:0] ),
    .i_next                  ( i_next           ),
    .i_pre                   ( i_pre            ),
    .i_pause                 ( i_pause          ),

    .o_XCS                   ( o_XCS            ),
    .o_XDCS                  ( o_XDCS           ),
    .o_SCK                   ( o_SCK            ),
    .o_SI                    ( o_SI             ),
    .o_XRST                  ( o_XRST           ),
    .o_LED                   ( o_LED            ),
    .o_FINISH                ( o_FINISH         )
);



endmodule