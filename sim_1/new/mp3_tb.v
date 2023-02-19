//~ `New testbench
`timescale  1ns / 1ps

module tb_mp3;

// mp3 Parameters
parameter PERIOD      = 0.01   ;
parameter DELAY_TIME  = 5;
parameter CMD_NUM     = 3     ;

// mp3 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   i_DREQ                               = 1 ;
reg   i_song_select                        = 0 ;
reg   i_pause                              = 0 ;
reg   [15:0]  i_vol                        = 0 ;
reg   [15:0] i_effect                      = 0 ;


// mp3 Outputs
wire  o_XCS                                ;
wire  o_XDCS                               ;
wire  o_SCK                                ;
wire  o_SI                                 ;
wire  o_XRST                               ;
wire  o_LED                                ;
wire  [15:0]  o_vol                        ;
wire  o_song_select                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

integer cnt = 0;

initial begin
    #(PERIOD*150)  i_pause = 1;
    #(PERIOD* 10) $finish;
end


always@(negedge o_XDCS) begin
    if(cnt == 15)
        i_song_select = i_song_select + 1;
    else if(cnt == 5) begin
        //i_vol = 16'hfcfc;
	i_pause = 1;
    end
    else if(cnt==10)begin
	i_pause=0;
	$finish;
    end
    if(cnt == 25)
        $finish;
    cnt <= cnt + 1;

end

mp3 #(
    .DELAY_TIME ( DELAY_TIME ),
    .CMD_NUM    ( CMD_NUM    ))
 u_mp3 (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .i_DREQ                  ( i_DREQ                ),
    .i_song_select           ( i_song_select         ),
    .i_pause                 ( i_pause               ),
    .i_vol                   ( i_vol          [15:0] ),
    .i_effect                ( i_effect              ),

    .o_XCS                   ( o_XCS                 ),
    .o_XDCS                  ( o_XDCS                ),
    .o_SCK                   ( o_SCK                 ),
    .o_SI                    ( o_SI                  ),
    .o_XRST                  ( o_XRST                ),
    .o_LED                   ( o_LED                 ),
    .o_vol                   ( o_vol          [15:0] ),
    .o_song_select           ( o_song_select         )
);


endmodule