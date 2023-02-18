`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/16 18:32:10
// Design Name: 
// Module Name: accelerometer
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

`default_nettype wire
//读三轴传感器的
module accelerometer#(
    parameter DELAY_TIME = 50000
)(
        input clk,
        input  rst_n,
        input  SO,             //芯片的输出信??

        output reg CS,        //选中
        output reg SCLK,            //即时??
        output reg SI,
        //relative data about position
        output reg [7:0] x_data     //test for x
    );


    wire clk_alm;//2hz
    wire clk_temp;//8hz
    parameter CMD_NUM=1;
    // clock_divider#(.Time(10))
    // clk_10(
    //     .clkin(clk),
    //     .clkout(clk_mp3)
    // );
    clock_divider#(.Time(10000)) divider(
        .clkin(clk),
        .clkout(clk_alm)
    );

    //states
    localparam CMD_PRE = 0;
    localparam WRITE_CMD = 1;
    localparam DATA_PRE = 2;
    localparam READ_DATA = 3;
    //localparam DELAY = 4;
    

    reg [2:0] state;

    //commands
    //first command: new mode and soft reset
    //second command: biggest volume
    reg [15:0] cmd;
    //reg [31:0] vol_cmd ;
    reg [15:0] vol;

    //count
    integer delay_cnt = 0;
    integer cnt = 0;
    integer cmd_cnt = 0;
    //integer delay_cnt1 = 0;

    //core IP

    //state machine
    always@(posedge clk_alm) begin
        //reset
        if(!rst_n) begin
            CS <= 1'b1;
            SCLK <= 1'b0;
            cmd <=  {16'h0b08};
            cmd_cnt <= 0;
            cnt <= 0;
            delay_cnt <= 0;
            state <= CMD_PRE;
        end
        else begin
            case (state)
                CMD_PRE: begin
                    SCLK <= 0;
                    if(cmd_cnt == CMD_NUM) begin
                        state <= DATA_PRE;
                        cmd_cnt <= 0;
                    end
                    else begin
                        state <= WRITE_CMD;
                        cnt <= 0;           //多加??
                    end
                end

                //cnt计数，cmd_cnt记命令数
                WRITE_CMD:begin
                
                    if(SCLK) begin  //1
                        if(cnt == 16) begin
                            CS <= 1'b1;
                            cmd_cnt <= cmd_cnt + 1;
                            cnt <= 0;
                            state <= CMD_PRE;//waiting for i_DREQ
                        end
                        else begin
                            CS <= 1'b0;
                            cnt <= cnt + 1;
                            SI <= cmd[15];
                            cmd <= {cmd[14:0],cmd[15]};
                        end
                    end
                    SCLK <= ~SCLK;//时钟信号刷新
                end

                DATA_PRE:begin
                    SCLK <= 1'b0;
                    cnt <= 0;
                    state <= READ_DATA;
                    //$display(addr);
                    //$display(_Data);
                    //else ;
                end

                READ_DATA:begin
                    //if(i_DREQ)begin
                    //down_side
                    if(SCLK) begin
                        if(cnt == 8) begin
                            CS <= 1'b1;
                            state <= CMD_PRE;
                        end
                        
                    end
                    else begin
                        //refresh data
                        //down side operation
                        //use both upper side and down side
                        CS <= 0;
                        x_data <= {x_data[0],x_data[7:1]};
                        x_data[7]<=SI;
                        cnt <= cnt + 1;
                        //$display(cnt);
                    end
                    //transmit data
                        
                    SCLK <= ~SCLK;
                    //end
                    //else;
                end



                default:;


            endcase
            
            //
        end
    end

    

endmodule
