`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/11 10:53:57
// Design Name: 
// Module Name: mp3_display
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


module mp3_display #(
    parameter H_RES=640,
    parameter V_RES=480
    ) (
        input wire clk,
        input wire rst_n,
        input wire signed [15:0] i_x,
        input wire signed [15:0] i_y,
        input wire i_next,
        input wire i_pre,
        input wire i_vol_plus,
        input wire i_vol_dec,
        input wire [15:0] doutb,
        input wire i_vs,
        

        output reg [7:0] o_red,
        output reg [7:0] o_green,
        output reg [7:0] o_blue,
        output reg [14:0] addrb
    );

    localparam HR = H_RES;              // horizontal resolution (pixels)
    localparam VR = V_RES;              // vertical resolution (lines)
    localparam BW = 16;                 // border width
    localparam SQ = VR >> 6;            // square unit
    localparam SX = (HR >> 1);   // middle of the picture
    localparam SY = ((VR >> 1) + (VR >> 2));   // square start vertical
    localparam SX_NEXT = (HR>>1)+(SQ<<4);
    localparam SX_PRE  = (HR>>1)-(SQ<<4);   //next begin
    localparam SX_VOLPLUS = (HR>>1)+(SQ<<5);
    localparam SX_VOLDEC = (HR>>1)-(SQ<<5);

    localparam LS = 2;                  // line spacing
    wire [7:0] color_square [0:2];

    assign color_square[0] = 8'hff;
    assign color_square[1] = 8'hff;
    assign color_square[2] = 8'h00;

    // Borders
    // wire top = (i_x >=     0) & (i_y >=     0) & (i_x < HR) & (i_y < BW);
    // wire btm = (i_x >=     0) & (i_y >= VR-BW) & (i_x < HR) & (i_y < VR);
    // wire lft = (i_x >=     0) & (i_y >=     0) & (i_x < BW) & (i_y < VR);
    // wire rgt = (i_x >= HR-BW) & (i_y >=     0) & (i_x < HR) & (i_y < VR);

    //picture vol
    reg [14:0]addr;
    wire dout_dec;
    wire dout_plus;
    vol_dec_mem
    pic_vol_dec(
        .clka(clk),
        .ena(1),
        .wea(),
        .addra(addr),
        .dina(),
        .douta(dout_dec)
    );
    //plus mem
    vol_plus_mem
    pic_vol_plus(
        .clka(clk),
        .ena(1),
        .wea(),
        .addra(addr),
        .dina(),
        .douta(dout_plus)
    );

    //choose
    //wire dout = (vol_dec? dout_dec: dout_plus);
    //wire dout = dout_dec;

    // triangle
    wire play1 = (i_x >= SX)        & (i_y >= SY       ) & (i_x < (i_y>SY + 2*SQ? SX+ SY + 4*SQ - i_y: i_y-SY+SX)            ) & (i_y < SY + 4*SQ);
    wire next1 = (i_x >= SX_NEXT)   & (i_y >= SY       ) & (i_x < (i_y>SY + 2*SQ? SX_NEXT+ SY + 4*SQ - i_y: i_y-SY+SX_NEXT)  ) & (i_y < SY + 4*SQ);
    wire next1_rt = (i_x >= SX_NEXT - 2*SQ) & (i_y >= SY) & (i_x < SX_NEXT - SQ) & (i_y < SY + 4*SQ);
    wire pre1 =  (i_x >= (i_y>SY + 2*SQ? (SX_PRE + i_y - SY - 2*SQ):(SX_PRE + SY + 2*SQ - i_y)))   & (i_y >= SY       ) & (i_x < SX_PRE + 2*SQ) & (i_y < SY + 4*SQ);
    wire pre1_rt = (i_x >= SX_PRE + 2*SQ + SQ) & (i_y >= SY) & (i_x < SX_PRE+4*SQ) &(i_y < SY+4*SQ);

    wire square1 = (i_x >= SX-3)    & (i_y >= SY - 3   ) & (i_x < SX + 2*SQ + 3                          ) & (i_y < SY + 4*SQ + 3);
    wire next_square  = (i_x >= SX_NEXT - 2*SQ-3)    & (i_y >= SY - 3   ) & (i_x < SX_NEXT + 2*SQ + 3           ) & (i_y < SY + 4*SQ + 3);
    wire pre_square  = (i_x >= SX_PRE-3)    & (i_y >= SY - 3   ) & (i_x < SX_PRE + 4*SQ + 3                          ) & (i_y < SY + 4*SQ + 3);

    //picture
    wire vol_plus = (i_x>SX_VOLPLUS) & (i_x < SX_VOLPLUS+ 30) & (i_y > SY) & (i_y <SY+30);
    wire vol_dec = (i_x>SX_VOLDEC) & (i_x < SX_VOLDEC+ 30) & (i_y >= SY) & (i_y < SY+30);

    //mem_pic
    wire music_pic = (i_x>=SX-100)&(i_x<SX+100) & (i_y >= SY - 250) & (i_y <SY - 50);

    

    // wire sq_b = (i_x >= SX + 2*SQ) & (i_y >= SY + 2*SQ) & (i_x < SX +  6*SQ) & (i_y < SY +  6*SQ);
    // wire sq_c = (i_x >= SX + 4*SQ) & (i_y >= SY + 4*SQ) & (i_x < SX +  8*SQ) & (i_y < SY +  8*SQ);
    // wire sq_d = (i_x >= SX + 6*SQ) & (i_y >= SY + 6*SQ) & (i_x < SX + 10*SQ) & (i_y < SY + 10*SQ);
    // wire sq_e = (i_x >= SX)        & (i_y >= SY + 8*SQ) & (i_x < SX +  2*SQ) & (i_y < SY + 10*SQ);

    // // Lines
    // wire lns_1 = (i_x >= SX + 8*SQ) & (i_x <= SX + 10*SQ) & ((i_y == SY + 0*LS       ) | (i_y == SY +  2*SQ - 0*LS));
    // wire lns_2 = (i_x >= SX + 8*SQ) & (i_x <= SX + 10*SQ) & ((i_y == SY + 1*LS       ) | (i_y == SY +  2*SQ - 1*LS));
    // wire lns_3 = (i_x >= SX + 8*SQ) & (i_x <= SX + 10*SQ) & ((i_y == SY + 2*LS       ) | (i_y == SY +  2*SQ - 2*LS));
    // wire lns_4 = (i_x >= SX + 8*SQ) & (i_x <= SX + 10*SQ) & ((i_y == SY + 3*LS       ) | (i_y == SY +  2*SQ - 3*LS));
    // wire lns_5 = (i_y >=        SY) & (i_y <= SY +  2*SQ) & ((i_x == SX + 8*SQ + 0*LS) | (i_x == SX + 10*SQ - 0*LS));
    // wire lns_6 = (i_y >=        SY) & (i_y <= SY +  2*SQ) & ((i_x == SX + 8*SQ + 1*LS) | (i_x == SX + 10*SQ - 1*LS));
    // wire lns_7 = (i_y >=        SY) & (i_y <= SY +  2*SQ) & ((i_x == SX + 8*SQ + 2*LS) | (i_x == SX + 10*SQ - 2*LS));
    // wire lns_8 = (i_y >=        SY) & (i_y <= SY +  2*SQ) & ((i_x == SX + 8*SQ + 3*LS) | (i_x == SX + 10*SQ - 3*LS));

    integer cnt = 0;
    reg[31:0] display_cnt;
    localparam DELAY_TIME = 50;//test
    localparam BEG = 0;
    localparam DELAY = 1;
    reg [1:0] state = 0;
    reg next,pre;
    //wire vol_sx = (vol_dec?SX_VOLDEC:SX_VOLPLUS);
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            state <= 0;
            cnt<=0;
            //display_cnt <= 0;
           
        end
        else begin
            case(state)
            BEG: begin
                if(i_next) begin
                    next <= 1;
                    state <= DELAY;
                end
                
                else if(i_pre) begin
                    pre <= 1;
                    state <= DELAY;
                end
                
                else begin
                    next <= 0;
                    pre <= 0;
                end
            end
            
            DELAY:begin
                if(cnt==DELAY_TIME) begin
                    state<=BEG;
                    cnt <= 0;
                end
                else 
                    cnt <= cnt+1;
            end

            

            default:;
            endcase
        end
    
    end

    //每一次增加
    integer display_delay_cnt =0 ;
    always@(negedge clk or negedge rst_n) begin
        if(~rst_n | next | pre) begin display_cnt <= 0; display_delay_cnt <=0 ;end
        else if(display_delay_cnt == 1000000)  begin 
            display_cnt <= display_cnt + 16'h1;
            display_delay_cnt <= 0;
        end
        else display_delay_cnt <= display_delay_cnt + 1;
    end

    // Colour Output
    // find the specified color
    always@(negedge clk) begin
        if(play1 | next1 | pre1 | next1_rt | pre1_rt) begin
            o_red <= 8'hff;
            o_green <= 8'hff;
            o_blue <= 8'hff;
        end
        else if((next & next_square ) | (pre & pre_square)) begin
            o_red <= color_square[0];
            o_green <= color_square[1];
            o_blue <= color_square[2];
        end
        else if(vol_dec) begin
            addr <= (i_y-SY) * (32) + i_x - SX_VOLDEC ;

            if(dout_dec == 0) begin
                o_red <= 8'hff;
                o_blue <= 8'hff;
                o_green <= 8'hff;
            end
            else begin
                if(i_vol_dec)begin
                    o_red <= color_square[0];
                    o_green <= color_square[1];
                    o_blue <= color_square[2];
                end
                else begin
                    o_red <= 8'h00;
                    o_green <= 8'h00;
                    o_blue <= 8'h00;
                end
            end
        end
        
        else if(vol_plus) begin
            
            addr <= (i_y-SY) * (32) +( i_x - SX_VOLPLUS );
            if(dout_plus == 0) begin
                o_red <= 8'hff;
                o_blue <= 8'hff;
                o_green <= 8'hff;
            end
            else begin
                if(i_vol_plus)begin
                    o_red <= color_square[0];
                    o_green <= color_square[1];
                    o_blue <= color_square[2];
                end
                else begin
                    o_red <= 8'h00;
                    o_green <= 8'h00;
                    o_blue <= 8'h00;
                end
            end
        end

        else if(music_pic) begin
            addrb <= ((i_x -(SX-100)) >> 2) + ((i_y -(SY-250)) >> 2)* 50;
            if(addrb <= display_cnt[19:5]) begin
                o_red <= {doutb[3:0],4'h0};
                o_green <= {doutb[7:4],4'h0};
                o_blue <= {doutb[11:8],4'h0};
            end
            else begin
                o_red <= 8'h00;
                o_green <= 8'h00;
                o_blue <= 8'h00;
            end
        end

        else begin
            o_red <= 8'h00;
            o_green <= 8'h00;
            o_blue <= 8'h00;
        end
    end
endmodule
