`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 18:09:22
// Design Name: 
// Module Name: Window_partition_TB
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


module Window_partition_TB();

    parameter map_width = 6;
    parameter map_height = 6;
    parameter DATA_WIDTH = 16;
    parameter window_width = 3;
    parameter window_height = 3;
    
    reg clk,reset;
    reg [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    wire [0 : window_width * window_height * DATA_WIDTH - 1] feature_map_window;
    
    //øÿ÷∆ ±÷”
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;   
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        feature_map = 576'h000100020003000400050006000700080009000a000b000c000d000e000f0010001100120013001400150016001700180019001a001b001c001d001e001f00200021002200230024;
        
        
        # PERIOD;
        reset = 0;
        
        #(27*PERIOD);
	    $displayh(feature_map_window);
	    $stop;
    end 
    
    Window_partition #(.map_width(map_width), .map_height(map_height), .DATA_WIDTH(DATA_WIDTH), .window_width(window_width), .window_height(window_height))
    window_partition_prepare (.clk(clk), .reset(reset), .feature_map(feature_map), .feature_map_window(feature_map_window));

endmodule
