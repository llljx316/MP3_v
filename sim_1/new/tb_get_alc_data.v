//~ `New testbench
`timescale  1ns / 1ps

module tb_get_acl_data;

// get_acl_data Parameters
parameter PERIOD            = 10      ;
parameter state_type_idle   = 3'd0    ;
parameter data_type_y_axis  = 2'd1    ;
parameter POWER_CTL         = 16'h2D08;
parameter BW_RATE           = 16'h2C08;
parameter DATA_FORMAT       = 16'h3100;
parameter yAxis0            = 16'hB400;
parameter yAxis1            = 16'hB500;
parameter INST_WRITE        = 8'h0A   ;

// get_acl_data Inputs
reg   rst_n                                  = 0 ;
reg   clk                                  = 0 ;
reg   MISO                                 = 0 ;

// get_acl_data Outputs
wire  [7:0]  z_data                        ;
wire  LED_INT1                             ;
wire  LED_INT2                             ;
wire  CSN                                  ;
wire  SCLK                                 ;
wire  MOSI                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

get_acl_data #(
    .state_type_idle  ( state_type_idle  ),
    .data_type_y_axis ( data_type_y_axis ),
    .POWER_CTL        ( POWER_CTL        ),
    .BW_RATE          ( BW_RATE          ),
    .DATA_FORMAT      ( DATA_FORMAT      ),
    .yAxis0           ( yAxis0           ),
    .yAxis1           ( yAxis1           ),
    .INST_WRITE       ( INST_WRITE       ))
 u_get_acl_data (
    .rst                     ( ~rst_n             ),
    .clk                     ( clk             ),
    .MISO                    ( MISO            ),

    .z_data                  ( z_data    [7:0] ),
    .LED_INT1                ( LED_INT1        ),
    .LED_INT2                ( LED_INT2        ),
    .CSN                     ( CSN             ),
    .SCLK                    ( SCLK            ),
    .MOSI                    ( MOSI            )
);



endmodule