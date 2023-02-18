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
        input wire [3:0] vol_level,
        input wire i_finish_song,
        input wire signed [7:0] alc_x,
        input wire signed [7:0] alc_y,
        input wire i_pause,
        input wire mp3rstn,

        output reg [3:0] o_red,
        output reg [3:0] o_green,
        output reg [3:0] o_blue,
        output reg [14:0] addrb
    );

    wire signed [15:0] alc_x16 = {alc_x[7]?8'hff:8'h00,alc_x};
    wire signed [15:0] alc_y16 = {alc_y[7]?8'hff:8'h00,alc_y};

    parameter [15:0]    HR = H_RES,              // horizontal resolution (pixels)
                        VR = V_RES,              // vertical resolution (lines)
                        BW = 16,                 // border width
                        SQ = VR >> 6;            // square unit

    localparam SX_DEF = (HR >> 1);
    localparam SY_DEF = ((VR >> 1) + (VR >> 2));
    reg [15:0] SX_REG, SY_REG;
    reg [15:0] SX = (HR >> 1),   // middle of the picture
               SY = ((VR >> 1) + (VR >> 2)),   // square start vertical
               SX_NEXT = (HR>>1)+(SQ<<4),
               SX_PRE  = (HR>>1)-(SQ<<4),   //next begin
               SX_VOLPLUS = (HR>>1)+(SQ<<5),
               SX_VOLDEC = (HR>>1)-(SQ<<5),
               SX_VOL_DISPLAY = (HR>>1)+(SQ<<5) + (SQ<<2),
               SY_VOL_DISPLAY_BOTTOM = ((VR >> 1) + (VR >> 2)) - SQ;

    localparam state_change = 0;
    localparam state_move = 1;
    localparam state_delay = 2;

    reg [2:0] STATE1;

    //change for SX SY
    always @(posedge clk) begin
        if(~rst_n) begin
            SX <= (HR >> 1);   // middle of the picture
            SY <= ((VR >> 1) + (VR >> 2));   // square start vertical
            SX_REG <= SX;
            SY_REG <= SY;
        end
        else begin
            case(STATE1)
                state_change:begin
                    SX_REG <= SX_DEF - alc_y16;
                    SY_REG <= SY_DEF + alc_x16;
                    STATE1 <= state_move;
                end

                state_move:begin
                    if(SX!=SX_REG) begin
                        SX <= SX + (SX<SX_REG?1:-1);
                    end

                    if(SY!=SY_REG) begin
                        SY <= SY + (SY<SY_REG?1:-1);
                    end

                    if(SY==SY_REG && SX == SX_REG) begin
                        STATE1 <= state_change;
                    end
                end

            endcase
            SX <= SX_DEF - alc_y16;
            SY <= SY_DEF + alc_x16;
        end

        SX_NEXT <= SX + (SQ<<4);
        SX_PRE <= SX - (SQ<<4); //next begin
        SX_VOLPLUS <= SX+(SQ<<5);
        SX_VOLDEC <= SX-(SQ<<5);
        SX_VOL_DISPLAY <= SX_VOLPLUS + (SQ<<2);
        SY_VOL_DISPLAY_BOTTOM <= SY - SQ;
    end 

    localparam LS = 2;                  // line spacing
    wire [3:0] color_square [0:2];
    wire [3:0] color_vol    [0:2];
    reg  [3:0] color_round  [0:2];        

    assign color_square[0] = 4'hf;
    assign color_square[1] = 4'hf;
    assign color_square[2] = 4'h0;

    assign color_vol[0]    = 4'hf;
    assign color_vol[1]    = 4'hf;
    assign color_vol[2]    = 4'hf;


    wire [4:0]vol_display_level = 8-vol_level;                                                                                                                                                                     

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

    wire pause1 = (i_x >= SX)        & (i_y >= SY       ) & (i_x < SX + SQ            ) & (i_y < SY + 4*SQ);
    wire pause2 = (i_x >= SX + 2*SQ)        & (i_y >= SY       ) & (i_x < SX + 3*SQ            ) & (i_y < SY + 4*SQ);
    wire play_pause_square = (i_x >= SX-3)        & (i_y >= SY-3       ) & (i_x < SX + 3*SQ +3         ) & (i_y < SY + 4*SQ + 3);

    wire square1 = (i_x >= SX-3)    & (i_y >= SY - 3   ) & (i_x < SX + 2*SQ + 3                          ) & (i_y < SY + 4*SQ + 3);
    wire next_square  = (i_x >= SX_NEXT - 2*SQ-3)    & (i_y >= SY - 3   ) & (i_x < SX_NEXT + 2*SQ + 3           ) & (i_y < SY + 4*SQ + 3);
    wire pre_square  = (i_x >= SX_PRE-3)    & (i_y >= SY - 3   ) & (i_x < SX_PRE + 4*SQ + 3                          ) & (i_y < SY + 4*SQ + 3);

    //picture
    wire vol_plus = (i_x>SX_VOLPLUS+3) & (i_x < SX_VOLPLUS+ 30) & (i_y > SY) & (i_y <SY+30);
    wire vol_dec = (i_x>SX_VOLDEC+3) & (i_x < SX_VOLDEC+ 30) & (i_y >= SY) & (i_y < SY+30);

    //mem_pic
    wire music_pic = (i_x>=SX-100)&(i_x<SX+100) & (i_y >= SY - 250) & (i_y <SY - 100);

    //vol_sqaure
    reg [7:0] vol_sqaure;
    always@(*) begin
        case(vol_display_level)
            0: vol_sqaure <= 8'b0;
            1: vol_sqaure <= 8'b1;
            2: vol_sqaure <= 8'b11;
            3: vol_sqaure <= 8'b111;
            4: vol_sqaure <= 8'b1111;
            5: vol_sqaure <= 8'b11111;
            6: vol_sqaure <= 8'b111111;
            7: vol_sqaure <= 8'b1111111;
            default: vol_sqaure <= 8'b11111111;
        endcase
    end

    wire vol1_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ    ) & (i_y < SY_VOL_DISPLAY_BOTTOM            );
    wire vol2_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*3  ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*2     );
    wire vol3_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*5  ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*4     );
    wire vol4_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*7  ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*6     );
    wire vol5_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*9  ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*8     );
    wire vol6_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*11 ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*10    );
    wire vol7_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*13 ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*12    );
    wire vol8_display = (i_x>=SX_VOL_DISPLAY    ) & (i_x<SX_VOL_DISPLAY + SQ*2  ) & (i_y >= SY_VOL_DISPLAY_BOTTOM - SQ*15 ) & (i_y < SY_VOL_DISPLAY_BOTTOM - SQ*14    );

    wire square_top = (i_y>0)&(i_y<15);
    wire square_left = (i_x>0)&(i_x<15);
    wire square_right = (i_x>HR-15)&(i_x<HR);
    wire square_bottom = (i_y > VR - 15) & (i_y < VR );



    

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
            state <= BEG;
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
        if(~rst_n | next | pre | i_finish_song | i_pause | ~mp3rstn) begin 
            display_cnt <= 0; 
            display_delay_cnt <=0 ;
        end
        else if(display_delay_cnt == 4500000)  begin 
            display_cnt <= display_cnt + 16'h1;
            display_delay_cnt <= 0;
        end
        else display_delay_cnt <= display_delay_cnt + 1;
    end

    // Colour Output
    // find the specified color
    //  buf
    reg [3:0] red_buf,green_buf,blue_buf;
    reg [4:0] get_color_delay_cnt = 0;
    reg i_pause_reg;
    //integer color_cnt = 0;//用于图像转文字
    always@(negedge clk or negedge rst_n) begin
        //rst
        if(~rst_n) begin
            o_red <= 0;
            o_green <= 0;
            o_blue <= 0;
            i_pause_reg <= i_pause;
        end
        else begin
            if((play1&i_pause==1) | ((pause1 | pause2) & i_pause == 0) | next1 | pre1 | next1_rt | pre1_rt) begin
                o_red <= 4'hf;
                o_green <= 4'hf;
                o_blue <= 4'hf;
                get_color_delay_cnt <= 0;

            end

            //next pre
            else if((next & next_square ) | (pre & pre_square)) begin
                o_red <= color_square[0];
                o_green <= color_square[1];
                o_blue <= color_square[2];
            end

            //pause play
            else if(i_pause != i_pause_reg && play_pause_square) begin
                i_pause_reg <= i_pause;
                o_red <= color_square[0];
                o_green <= color_square[1];
                o_blue <= color_square[2];
            end

            //voldec pic
            else if(vol_dec) begin
                addr <= (i_y-SY) * (32) + i_x - SX_VOLDEC ;

                if(dout_dec == 0) begin
                    o_red <= 4'hf;
                    o_blue <= 4'hf;
                    o_green <= 4'hf;
                end
                else begin
                    if(i_vol_dec)begin
                        o_red <= color_square[0];
                        o_green <= color_square[1];
                        o_blue <= color_square[2];
                    end
                    else begin
                        o_red <= 4'h0;
                        o_green <= 4'h0;
                        o_blue <= 4'h0;
                    end
                end
            end
            
            else if(vol_plus) begin
                
                addr <= (i_y-SY) * (32) +( i_x - SX_VOLPLUS );
                if(dout_plus == 0) begin
                    o_red <= 4'hf;
                    o_blue <= 4'hf;
                    o_green <= 4'hf;
                end
                else begin
                    if(i_vol_plus)begin
                        o_red <= color_square[0];
                        o_green <= color_square[1];
                        o_blue <= color_square[2];
                    end
                    else begin
                        o_red <= 4'h0;
                        o_green <= 4'h0;
                        o_blue <= 4'h0;
                    end
                end
            end

            else if(music_pic&&~i_pause) begin
                addrb <= ((i_x -(SX-100)) >> 2) + ((i_y -(SY-250)) >> 2)* 50;
                if(addrb < display_cnt) begin
                    o_red <= {doutb[3:0]};
                    o_green <= {doutb[7:4]};
                    o_blue <= {doutb[11:8]};
                end
                else if(addrb == display_cnt) begin
                    if(get_color_delay_cnt == 0) begin
                        color_round[0] <=  {doutb[3:0]};
                        color_round[1] <=  {doutb[7:4]};
                        color_round[2] <=  {doutb[11:8]};//happy mode模式
                    end
                    get_color_delay_cnt <= get_color_delay_cnt + 1;

                end
                else begin
                    o_red <= 4'h0;
                    o_green <= 4'h0;
                    o_blue <= 4'h0;
                end
            end

            

            else if((square_top|square_bottom|square_left|square_right)&&~i_pause) begin
                o_red <= color_round[0];
                o_green <= color_round[1];
                o_blue <= color_round[2];
            end

            //vol_display
            else if((i_vol_dec| i_vol_plus) &&((vol_sqaure[0]&&vol1_display) || (vol_sqaure[1]&&vol2_display) || (vol_sqaure[2]&&vol3_display)
            || (vol_sqaure[3]&&vol4_display) || (vol_sqaure[4]&&vol5_display) || (vol_sqaure[5]&&vol6_display) 
            || (vol_sqaure[6]&&vol7_display) || (vol_sqaure[7]&&vol8_display)) ) begin                    
                o_red   <= color_vol[0];
                o_green <= color_vol[1];
                o_blue  <= color_vol[2];
            end


            else begin
                o_red <= 4'h0;
                o_green <= 4'h0;
                o_blue <= 4'h0;
            end
        end
    end
endmodule
