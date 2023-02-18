`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/08 16:23:30
// Design Name: 
// Module Name: bluetooth
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bluetooth#(
    parameter SONG_NUM = 4
)(
    input clk,
    input rst_n,
    input rx,
    input i_finish_song,


    output wire [15:0] o_vol,
    output reg [3:0] vol_level,
    output reg [2:0] o_song_select,
    output reg o_next,
    output reg o_pre,
    output reg o_pause,
    output reg o_vol_plus,
    output reg o_vol_dec,
    output reg [15:0] o_effect
    );

    //---------------state-------------------//
    localparam CMD_PRE  = 0;
    localparam PAUSE    = 1;
    localparam NEXT     = 2;
    localparam PRE      = 3;
    localparam VOL_PLUS = 4;
    localparam VOL_DEC  = 5;
    localparam EFFECT0   = 8'h40;
    localparam EFFECT1   = 8'h41;
    localparam EFFECT2   = 8'h42;
    localparam DELAY    = 6;

    localparam VOL_CHANGE = 14;

    reg [7:0] state;
    wire [7:0] rx_data;
    wire rx_done;

    uart_rx
    uart_recieve(
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),


        .o_rx_done(rx_done),
        .o_data(rx_data)
    );

    localparam DELAY_SIGNAL = 50000000;
    integer cnt = 0;

    wire [7:0] vol1 = (vol_level==8)?8'hfc:(8'd14*vol_level);
    assign o_vol = {vol1,vol1};

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            vol_level <= 0;
            o_pause <= 1;
            o_song_select <= 0;
            o_pre <= 0;
            o_next <= 0;
            o_vol_dec <= 0;
            o_vol_plus <= 0;
	        state  <= CMD_PRE;
            cnt <= 0;
        end

        //------------------state machine---------------------//
        else begin
            case (state)
                CMD_PRE: begin
                    o_next <= 0;
                    o_pre <= 0;// for display
                    o_vol_plus <= 0;
                    o_vol_dec <= 0;
                    if(rx_done) begin
                        state <= rx_data;
                    end

                    else if(i_finish_song) begin
                        state<=NEXT;
                    end
                end

                PAUSE: begin
                    o_pause <= ~o_pause;
                    state <= CMD_PRE;
                end

                NEXT:begin
                    o_song_select <= o_song_select<SONG_NUM-1?o_song_select+1:0;
                    state <= DELAY;
                    if(~i_finish_song)
                        o_next <= 1;
                end

                PRE:begin
                    o_song_select <= o_song_select>0?o_song_select-1:SONG_NUM-1;
                    state <= DELAY;
                    o_pre <= 1;
                end

                VOL_PLUS:begin
                    vol_level <= (vol_level==0?0:vol_level - 1);
                    o_vol_plus <= 1;
                    state <= DELAY;
                end

                VOL_DEC: begin
                    vol_level <= (vol_level==8?8:vol_level + 1);
                    state <= DELAY;
                    o_vol_dec <= 1;
                end

                EFFECT0:begin
                    o_effect <= 16'h0000;
                    state <= CMD_PRE;
                end

                EFFECT1: begin
                    o_effect <= 16'h7000;
                    state <= CMD_PRE;
                end

                EFFECT2: begin
                    o_effect <= 16'h00f0;
                    state <= CMD_PRE;
                end

                DELAY: begin
                    if(cnt==DELAY_SIGNAL) begin
                        state<=CMD_PRE;
                        cnt <= 0;
                    end
                    else 
                        cnt <= cnt +1;
                end


                default: ;
            endcase

        end
    end
endmodule
