`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 16:42:32
// Design Name: 
// Module Name: Kernel_single_channel_calc_TB
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


module Kernel_single_channel_calc_TB();

    parameter map_width = 6;
    parameter map_height = 6;
    parameter DATA_WIDTH = 16;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    
    reg clk,reset;
    
    reg [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    reg [0 : kernel_width * kernel_height * DATA_WIDTH - 1] kernel_single_channel;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] result;
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] feature_map_window;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    //øÿ÷∆ ±÷”
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;   
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        feature_map = 576'h3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080;
        kernel_single_channel = 144'h3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00;
        
        # PERIOD;
        reset = 0;
        
        #(1000*PERIOD);
	    $display(result);
	    $display(result_element);
	    $display(feature_map_window);
	    $stop;
    end 
    
    kernel_single_channel_calc #(.map_width(map_width), .map_height(map_height), .DATA_WIDTH(DATA_WIDTH), .kernel_width(kernel_width), .kernel_height(kernel_height))
    kernel_single_channel_calc_agent (.clk(clk), .reset(reset), .feature_map(feature_map), .kernel_single_channel(kernel_single_channel), .result(result), .result_element(result_element), .feature_map_window(feature_map_window));

endmodule
