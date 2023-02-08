`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/04 11:10:45
// Deo_SIgn Name: 
// Module Name: mp3
// Project Name: 
// Target Devices: 
// Tool Vero_SIons: 
// Description: 
// 
// Dependencies: 
// 
// Revio_SIon:
// Revio_SIon 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`define test
module mp3
#(
    parameter CMD_NUM=2,
    parameter DELAY_TIME=500000
)
(
	input clk,
	//input mp3_clk,
	input i_DREQ,
	input rst_n, 
	//input [2:0] SONG_COL,
	//input NO_MUo_SIC,
	output reg o_XDCS, 
	output reg o_XCS,  
	output reg o_XRST, 
	output reg o_SI, 
	output reg o_SCK,
    output reg o_LED
);
	//mp3状态
	localparam CMD_PRE = 0;
	localparam WRITE_CMD = 1;
	localparam DATA_PRE = 2;
	localparam WRITE_DATA = 3;
	localparam DELAY = 4;
	reg [2: 0] state;
		
	//目前选择的歌曲
	reg[2: 0] cur=3'b00;
	
	// IP核
    reg[15:0] addr;
	wire [15: 0] Dout0,Dout1,Dout2,Dout3,Data;
    reg [15: 0] _Data;
    
    blk_mem_gen_0 music0(.clka(clk),.ena(1),.addra(addr),.douta(Dout0));
    // blk_mem_gen_1 muo_SIc1(.clka(clk),.ena(1),.addra(addr),.douta(Dout1));    
    // blk_mem_gen_2 muo_SIc2(.clka(clk),.ena(1),.addra(addr),.douta(Dout2));
    // blk_mem_gen_3 muo_SIc3(.clka(clk),.ena(1),.addra(addr),.douta(Dout3)); 
    assign Data=Dout0;
	
    //复位寄存器
    reg [63: 0] cmd = {32'h02000804, 32'h020B0000};
    reg [2: 0] cmd_cnt = 0;
        
    //计数
    integer delay_cnt = 0;
    integer cnt = 0;

    //mp3 clk
    wire mp3_clk;
`ifndef test
    clock_divider#(.Time(10))
    divider(
        .clkin(clk),
        .clkout(mp3_clk)
    );
`else
    assign mp3_clk = clk;
`endif
        
    always @ (posedge mp3_clk) begin
        if(!rst_n) begin
            o_XRST <= 0;
            o_SCK <= 0;
            o_XCS <= 1;
            o_XDCS <= 1;
            delay_cnt <= 0;
            state <= DELAY;
            cmd_cnt <= 0;
            addr <= 0;
            o_LED <= 0;
        end 
        else begin 
            o_LED<=1;
            case (state)
                CMD_PRE: begin 
                    o_SCK <= 0;
                    if(cmd_cnt == CMD_NUM) begin
                        state <= DATA_PRE;
                    end
                    else if(i_DREQ) begin 
                        state <= WRITE_CMD;
                        cnt <= 0;
                    end 
                end
                    
                WRITE_CMD: begin 
                    if(i_DREQ) begin
                        if(clk) begin 
                            if(cnt==32) begin
                                cmd_cnt <= cmd_cnt+1;
                                o_XCS <= 1;
                                state <= CMD_PRE;
                                cnt <= 0;
                            end 
                            else begin
                                o_XCS <= 0;
                                o_SI <= cmd[63];
                                cmd <= {cmd[62: 0], cmd[63]};
                                cnt <= cnt+1;
                            end 
                        end 
                        o_SCK <= ~o_SCK;
                    end 
                end
                
                DATA_PRE: begin
                    if(i_DREQ) begin 
                        o_SCK <= 0;
                        state <= WRITE_DATA;
                        _Data <= Data;
                        cnt <= 0;
                    end 
                end
                         
                WRITE_DATA: begin 
                    if(o_SCK) begin 
                        if(cnt == 16) begin 
                            o_XDCS <= 1;
                            addr <= addr+1;
                            state <= DATA_PRE;
                            end 
                        else begin 
                            o_XDCS <= 0;
                            o_SI <= _Data[15];
                            _Data <= {_Data[14:0], _Data[15]};
                            cnt <= cnt+1;
                        end 
                    end 
                    o_SCK = ~o_SCK;
                end
                 
                DELAY: begin 
                    if(delay_cnt == DELAY_TIME) begin 
			            delay_cnt <= 0;
                        state <= CMD_PRE;
                        o_XRST <= 1;
                    end 
                    else begin
						delay_cnt <= delay_cnt+1;
				    end
                end    
            endcase
        end
    end 
endmodule