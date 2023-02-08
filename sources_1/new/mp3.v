`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/04 13:54:27
// Design Name: 
// Module Name: mp3
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
//`define test

module mp3#(
    parameter DELAY_TIME = 5000,
    parameter CMD_NUM = 2
)(
        input clk,
        input  rst_n,
        //input  i_SO,             //芯片的输出信号
        input  i_DREQ,           //执行信号

        output reg o_XCS,        //选中
        output reg o_XDCS,       //数据选片
        output reg o_SCK,            //即时钟
        output reg o_SI,
        output reg o_XRST,
        output reg o_LED
    );

   


`ifndef test
    wire clk_mp3;

    clock_divider#(.Time(10))
    clk_10(
        .clkin(clk),
        .clkout(clk_mp3)
    );
`else
    integer div_cnt = 0;
    reg clk_mp3 = 0;
    always @(posedge clk) begin
        clk_mp3 <= ~clk_mp3;
    end
`endif

    //states
    localparam CMD_PRE = 0;
    localparam WRITE_CMD = 1;
    localparam DATA_PRE = 2;
    localparam WRITE_DATA = 3;
    localparam DELAY = 4;
    localparam PAUSE = 5;
    localparam DELAY1 = 6;

    reg [2:0] state;

    //commands
    //first command: new mode and soft reset
    //second command: biggest volume
    reg [63:0] cmd = {32'h02000804,32'h020B0000};

    //count
    integer delay_cnt = 0;
    integer cnt = 0;
    integer cmd_cnt = 0;
    //integer delay_cnt1 = 0;

    //core IP
    reg  [14:0] addr;
    wire [15:0] dout0;

    //storage relative
    wire [15:0] data;
    //reg [15:0] test_data = 16'hfefe;

    blk_mem_gen_1 test(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout0)
    );
    //temporary data assign
    assign data = dout0;
    //assign data = test_data;

    reg [15:0] _Data;
    //state machine
    always@(posedge clk_mp3) begin
        //reset
        if(!rst_n) begin
            o_XCS <= 1'b1;
            o_XDCS <= 1'b1;
            o_XRST <= 1'b0;
            o_SCK <= 1'b0;
            addr <= 0;
            cmd_cnt <= 0;
            cnt <= 0;
            delay_cnt <= 0;
            state <= DELAY;
            o_LED <= 1'b0;
            //delay_cnt1 <= 0;
        end
        else begin
            o_LED <= 1'b1;
            case (state)
                CMD_PRE: begin
                    o_SCK <= 0;
                    if(cmd_cnt == CMD_NUM) begin
                        state <= DATA_PRE;
                        cmd_cnt <= 0;
                    end
                    else if(i_DREQ) begin
                        state <= WRITE_CMD;
                        cnt <= 0;           //多加的
                    end
                    else ;
                end

                //cnt计数，cmd_cnt记命令数
                WRITE_CMD:begin
                    if(i_DREQ)begin
                        if(o_SCK) begin  //1
                            if(cnt == 32) begin
                                o_XCS <= 1'b1;
                                cmd_cnt <= cmd_cnt + 1;
                                cnt <= 0;
                                state <= CMD_PRE;//waiting for i_DREQ
                            end
                            else begin
                                o_XCS <= 1'b0;
                                cnt <= cnt + 1;
                                o_SI <= cmd[63];
                                cmd <= {cmd[62:0],cmd[63]};
                            end
                        end
                        o_SCK <= ~o_SCK;//时钟信号刷新
                    end
                    else ;//empty
                end

                DATA_PRE:begin
                    if(i_DREQ) begin
                        o_SCK <= 1'b0;
                        cnt <= 0;
                        state <= WRITE_DATA;
                        $display(addr);
                        _Data <= data;
                        $display(_Data);
                    end
                    else ;
                end

                WRITE_DATA:begin
                    //if(i_DREQ)begin
                    //down_side
                    if(o_SCK) begin
                        if(cnt == 32) begin
                            addr <= addr + 1;//有延迟
                            o_XDCS <= 1'b1;
                            state <= DATA_PRE;
                        end
                        else begin
                            //refresh data
                            //down side operation
                            //use both upper side and down side
                            o_XDCS <= 0;
                            o_SI <= _Data[15];//shift register
                            _Data <= {_Data[14:0],_Data[15]};
                            cnt <= cnt + 1;
                            //$display(cnt);
                        end
                    end
                    //transmit data
                    
                    o_SCK <= ~o_SCK;
                    //end
                    //else;
                end

                DELAY:begin
                    if(delay_cnt == DELAY_TIME) begin
                        state <= CMD_PRE;
                        delay_cnt <= 0;
                        o_XRST <= 1'b1;
                    end
                    else begin
                        delay_cnt <= delay_cnt + 1;
                    end
                end


                default:;


            endcase
            
            //
        end
    end

endmodule
