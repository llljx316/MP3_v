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


module bluetooth(
    input clk,
    input rst_n,
    input rx,
    input i_FINISH,


    output reg [15:0] o_vol,
    output reg o_song_select,
    output reg o_pause
    );

    //---------------state-------------------//
    localparam CMD_PRE  = 0;
    localparam PAUSE    = 1;
    localparam NEXT     = 2;
    localparam PRE      = 3;
    localparam VOL_PLUS = 4;
    localparam VOL_DEC  = 5;
    localparam MUSIC0   = 8'h41;
    localparam MUSIC1   = 8'h41;

    localparam VOL_CHANGE = 4079;

    reg [3:0] state;
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

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            o_vol <= 16'hffff;
            o_pause <= 0;
            o_song_select <= 0;
        end

        //------------------state machine---------------------//
        else begin
            case (state)
                CMD_PRE: begin
                    if(i_FINISH)begin
                        o_vol <= 16'hffff;
                        o_pause <= 0;
                    end
                    else if(rx_done) begin
                        state <= rx_data;
                    end
                end

                PAUSE: begin
                    o_pause <= 1;
                    state <= CMD_PRE;
                end

                NEXT:begin
                    o_song_select <= o_song_select+1;
                    state <= CMD_PRE;
                end

                PRE:begin
                    o_song_select <= o_song_select-1;
                    state <= CMD_PRE;
                end

                VOL_PLUS:begin
                    o_vol <= (o_vol< (16'hfefe)? o_vol+VOL_CHANGE: o_vol);
                    state <= CMD_PRE;
                end

                VOL_DEC: begin
                    o_vol <= (o_vol>0? o_vol-VOL_CHANGE: o_vol);
                    state <= CMD_PRE;
                end

                default: ;
            endcase

        end
    end
endmodule
