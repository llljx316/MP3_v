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

// mp3_display Outputs
wire  [7:0]  o_red                         ;
wire  [7:0]  o_green                       ;
wire  [7:0]  o_blue                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mp3_display  u_mp3_display (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .i_x                     ( i_x      [15:0] ),
    .i_y                     ( i_y      [15:0] ),
    .i_next                  ( i_next          ),
    .i_pre                   ( i_pre           ),

    .o_red                   ( o_red    [7:0]  ),
    .o_green                 ( o_green  [7:0]  ),
    .o_blue                  ( o_blue   [7:0]  )
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
    $finish;
end



endmodule