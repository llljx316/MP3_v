
`timescale  1ns / 1ps
//`define test
//--------------- uart data receiver for 9600bps  ----------------
//------------------------- author : ljx ------------------------
`default_nettype wire
module uart_rx#(
	//parameter BPS = 9600,
	parameter DATA_BITS = 8
)(
	input	clk,
	input   rst_n,
	input	rx,			//get signal


	output	reg  o_rx_done,
	output  reg  [DATA_BITS-1:0] o_data
);
`ifndef test
	parameter C_BPS_DIV = 10417;//100mhz
`else
	parameter C_BPS_DIV = 3;//test
`endif

	reg rx_reg0, rx_reg1, rx_reg2, rx_reg3;

	reg[3:0] R_state;


	//消除亚稳??
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rx_reg0 <= 1'b1;
			rx_reg1 <= 1'b1;
			rx_reg2 <= 1'b1;
			rx_reg3 <= 1'b1;
		end

		else begin
			//move
			rx_reg0 <= rx;
			rx_reg1 <= rx_reg0;
			rx_reg2 <= rx_reg1;
			rx_reg3 <= rx_reg2;
		end
	end
	
	//产生下降沿信号标志位
	wire rx_neg;
	assign rx_neg = (~rx_reg2 & rx_reg3);//begin

	/***********产生波特率signal**********/
`ifndef test
	wire rx_clk;
`endif
	reg [14:0] bps_cnt;
	reg bps_en;
	//分频
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			bps_cnt <= 0;
		end
		else if(bps_en) begin
			if(bps_cnt == C_BPS_DIV - 1)
				bps_cnt <= 15'd0;
			else 
				bps_cnt <= bps_cnt + 1;
				
		end
		else
			bps_cnt <= 0;
		//$display(bps_cnt);
	end

	assign rx_clk = (bps_cnt == C_BPS_DIV >> 1?1'b1:1'b0);//脉冲信号，中间

	/************产生接收信号*************/
	reg R_recieving;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)begin
			R_recieving <= 1'b0;
		end
		else if(rx_neg) begin
			R_recieving <= 1'b1;
		end
		else if(o_rx_done) begin
			R_recieving <= 1'b0;
		end
		else ;

	end

	/***************state machine接受数据***************/
	//reg temp_data;
	reg [7:0] t_odata;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			R_state <= 0;
			bps_en <= 0;
			t_odata <= 0;
			o_rx_done <= 0;
		end
		else if(R_recieving) begin
			//打开波特率时钟signal
			bps_en <= 1; 
			if(rx_clk) begin
				case(R_state)
					4'd0: begin
						t_odata <= 0;
						o_rx_done <= 0;
						R_state <= R_state + 1;
					end

					4'd9: begin
						o_data <= t_odata;
						o_rx_done <= 1;
						R_state <= R_state + 1;
					end

					4'd10: begin
						R_state <= 0;
						o_rx_done <= 0;
					end

					default: begin
						t_odata[R_state-1] <= rx;
						o_rx_done <= 0;
						R_state <= R_state + 1;
					end

				endcase
				
				$display(R_state);
			end
		end
		else begin
			R_state <= 0;
			o_rx_done <= 0;
			t_odata <= 0;
			bps_en <= 0;
		end//关闭相应的signal
	end

	
endmodule