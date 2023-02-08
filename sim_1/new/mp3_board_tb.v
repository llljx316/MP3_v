//~ `New testbench
`timescale  1ns / 1ps

module tb_mp3_board;

// mp3_board Parameters
parameter PERIOD  = 10;


// mp3_board Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [7:0]  i_ADDRESS                     = 8'h0d ;
reg   i_SO                                 = 0 ;//板子输入无法控制，此处就不用
reg   i_WRITE_EN                           = 1 ;

// mp3_board Outputs
wire  o_XCS                                ;
wire  o_SCK                                ;
wire  o_SI                                 ;
wire  o_XRST                               ;
wire  o_DREQ                               ;

// mp3_board Bidirs
wire  [15:0]  data               ;

assign data = 16'hf0      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mp3_board  u_mp3_board (
    .clk                     ( clk                ),
    .rst_n                   ( rst_n              ),
    .i_ADDRESS               ( i_ADDRESS   [7:0]  ),
    .i_SO                    ( i_SO               ),
    .i_WRITE_EN              ( i_WRITE_EN         ),

    .o_XCS                   ( o_XCS              ),
    .o_SCK                   ( o_SCK              ),
    .o_SI                    ( o_SI               ),
    .o_XRST                  ( o_XRST             ),
    .o_DREQ                  ( o_DREQ             ),

    .data                    ( data        [15:0] )
);

// initial
// begin

//     $finish;
// end

endmodule