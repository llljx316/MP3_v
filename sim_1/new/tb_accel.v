`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/17 16:01:08
// Design Name: 
// Module Name: tb_accel
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


`timescale 1ns/1ns

module tb_accel;

    reg         clock;
    reg         reset;

    reg         RXD;
    wire        TXD;
    wire        CTS;
    reg         RTS;

    reg  [9:0]  RXD_buf;

    wire        ACL_CSN;
    wire        ACL_MOSI;
    reg         ACL_MISO;
    wire        ACL_SCLK;

    reg  [15:0] ACL_MOSI_buf;

    initial begin
        clock = 1'b0;
        reset = 1'b0;
        
        RXD = 1'b1;
        RTS = 1'b1;
        RXD_buf = 8'h00;
        
        ACL_MISO = 1'b0;
        
        // Reset for 1us
        #100 
        reset = 1'b1;
        #1000
        reset = 1'b0;
        /*
        // Testing command 0x000A2057
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number A into uart
        RXD_buf = 10'b0100000101;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 2 into uart
        RXD_buf = 10'b0010011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 5 into uart
        RXD_buf = 10'b0101011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 7 into uart
        RXD_buf = 10'b0111011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        */
        // Testing command 0x010B2000, return 0xAA in SPI
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 1 into uart
        RXD_buf = 10'b0100011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number B into uart
        RXD_buf = 10'b0010000101;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 2 into uart
        RXD_buf = 10'b0010011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Send a number 0 into uart
        RXD_buf = 10'b0000011001;
        RTS = 1'b0;
        repeat(10) begin
            repeat(867) @(posedge clock);
            {RXD, RXD_buf} = {RXD_buf, 1'b1};
        end
        
        // Take 16 bits from MOSI, and send 8 bits to MISO
        repeat(16) begin
            @(posedge ACL_SCLK)
            ACL_MOSI_buf = {ACL_MOSI_buf[14:0], ACL_MOSI};
        end
        
        repeat(8) begin
            @(negedge ACL_SCLK)
            ACL_MISO = ~ACL_MISO;
        end
    end

    // Generate 100MHz clock signal
    always #5 clock <= ~clock;

    accel accel(
        .clk      (clock),
        .rst      (reset),
        
        // SPI port
        .ACL_CSN  (ACL_CSN),
        .ACL_MOSI (ACL_MOSI),
        .ACL_MISO (ACL_MISO),
        .ACL_SCLK (ACL_SCLK),
        
        // UART port
        .RXD      (RXD),
        .TXD      (TXD),
        .CTS      (CTS),
        .RTS      (RTS)
    );

endmodule

