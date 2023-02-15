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
//`define test_audio

module mp3#(
    parameter DELAY_TIME = 500000,
    parameter CMD_NUM = 2
)(
        input clk,
        input  rst_n,
        //input  i_SO,             //芯片的输出信??
        input  i_DREQ,           //执行信号
        input  i_song_select,
        input  i_pause,
        input  [15:0] i_vol,

        output reg o_XCS,        //选中
        output reg o_XDCS,       //数据选片
        output reg o_SCK,            //即时??
        output reg o_SI,
        output reg o_XRST,
        output reg o_LED,
        output reg o_FINISH,
        output wire [15:0] o_vol,
        output wire [2:0] o_song_select
    );



`ifndef test
    wire clk_mp3;

    // clock_divider#(.Time(10))
    // clk_10(
    //     .clkin(clk),
    //     .clkout(clk_mp3)
    // );

    clk_wiz_0

    clk_div(
    // Clock out ports
    .clk_out1(clk_mp3),
    // Status and control signals
    .resetn(1'b1),
    // Clock in ports
    .clk_in1(clk)
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
    localparam VOL_PRE = 5;
    localparam WRITE_VOL = 6;
    localparam VERIFY    = 7;

    reg [2:0] state;

    //commands
    //first command: new mode and soft reset
    //second command: biggest volume
    reg [63:0] cmd = {32'h02000804,32'h020B0000};
    //reg [31:0] vol_cmd ;
    reg [15:0] vol;

    //count
    integer delay_cnt = 0;
    integer cnt = 0;
    integer cmd_cnt = 0;
    //integer delay_cnt1 = 0;

    //core IP
    reg  [14:0] addr;
    wire [15:0] dout0,dout1,dout2,dout3;

    //storage relative
    wire [15:0] data;
    //reg [15:0] test_data = 16'hfefe;

    reg song_reg0, song_reg1, song_reg2, song_reg3;

    always@(posedge clk_mp3 or negedge rst_n) begin
		if(!rst_n) begin
			song_reg0 <= 1'b0;
			song_reg1 <= 1'b0;
			song_reg2 <= 1'b0;
			song_reg3 <= 1'b0;
		end

		else begin
			//move
			song_reg0 <= i_song_select;
			song_reg1 <= song_reg0;
			song_reg2 <= song_reg1;
			song_reg3 <= song_reg2;
		end
	end

    blk_mem_gen_0 music0(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout0)
    );

    blk_mem_gen_1 music1(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout1)
    );

    blk_mem_gen_2 music2(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout2)
    );

    blk_mem_gen_3 music3(
        .clka(clk),
        .ena(1'b1),
        .addra(addr),
        .douta(dout3)
    );

    //temporary data assign
    reg [2:0] song_select;
    assign data = i_pause==0?(song_select==0?dout0:(song_select == 1? dout1:(song_select==2? dout2: dout3))): 16'h0000;
    //assign data = test_data;
    assign o_vol = cmd[15:0];
    assign o_song_select = song_select;
    reg pause;
    

    reg [15:0] _Data;
    localparam VOL_CMD_TIMES = 2;
    //state machine
    always@(posedge clk_mp3) begin
        //reset
        if(!rst_n || song_reg2!=song_reg3 || i_pause!=pause) begin
            song_select <= i_song_select;
            o_XCS <= 1'b1;
            o_XDCS <= 1'b1;
            o_XRST <= 1'b0; 
            o_SCK <= 1'b0;
            
            //??????????????????????????????????????????????????????????????????????
            addr <= 0;//??????
            pause <= i_pause;
            //????????????????????????????????????????????????????????????????
           
            
            cmd_cnt <= 0;
            cnt <= 0;
            delay_cnt <= 0;
            state <= DELAY;
            o_LED <= 1'b0;
            o_FINISH <= 1'b1;//song切换后的信号
            //delay_cnt1 <= 0;
        end
        else begin
            o_LED <= 1'b1;
            o_FINISH <= 0;
            case (state)
                CMD_PRE: begin
                    o_SCK <= 0;
                    if(cmd_cnt == CMD_NUM) begin
                        state <= DATA_PRE;
                        cmd_cnt <= 0;
                    end
                    else if(i_DREQ) begin
                        state <= WRITE_CMD;
                        cnt <= 0;           //多加??
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
                    //critirial whether to change the state
                    if (i_vol!=cmd[15:0]) begin
                        state <= VOL_PRE;
                        cmd[15:0]  <= i_vol;
                        cmd_cnt <= 0;           //clear unpredictable status?
                    end

                    else if(i_DREQ) begin
                        o_SCK <= 1'b0;
                        cnt <= 0;
                        state <= WRITE_DATA;
                        //$display(addr);
                        _Data <= data;
                        //$display(_Data);
                    end
                    else ;
                end

                WRITE_DATA:begin
                    //if(i_DREQ)begin
                    //down_side
                    if(i_DREQ) begin
                        if(o_SCK) begin
                            if(cnt == 16) begin
                                if(~i_pause)
                                    addr <= addr + 1;//有延??
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
                    end
                    //end
                    //else;
                end

                VOL_PRE:begin
                    o_SCK <= 0;
                    if(cmd_cnt == VOL_CMD_TIMES) begin
                        state<=DATA_PRE;
                        cmd_cnt <= 0;
                    end
                    else if(i_DREQ) begin
                        state <= WRITE_VOL;
                        cnt <= 0;           //多加??
                    end
                    else ;
                end

                WRITE_VOL:begin
                    if(i_DREQ)begin
                        if(o_SCK) begin  //1
                            if(cnt == 32) begin
                                o_XCS <= 1'b1;
                                cnt <= 0;
                                cmd_cnt <= cmd_cnt + 1;
                                state <= VOL_PRE;//waiting for i_DREQ
                            end
                            else begin
                                o_XCS <= 1'b0;
                                cnt <= cnt + 1;
                                o_SI <= cmd[31];
                                cmd[31:0] <= {cmd[30:0],cmd[31]};//pos operation!
                            end
                        end
                        o_SCK <= ~o_SCK;//时钟信号刷新
                    end
                    else ;//empty
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
