`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 21:26:03
// Design Name: 
// Module Name: Conv_single_kernel_TB
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


module Conv_single_kernel_TB();
    
    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channels = 3;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    parameter kernel_channels = map_channels;
    parameter DATA_WIDTH = 16;
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    localparam delta_counter = 3;
    
    reg clk,reset;
    reg [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    reg [0 : kernel_channels * kernel_width * kernel_height * DATA_WIDTH - 1] single_kernel;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] out_feature_map;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] result;
    wire [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] kernel_single_channel;
    wire [5:0] i;
    wire [127:0] counter;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;  
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        in_feature_maps_set = 1728'h3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080_3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080_3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080;
        single_kernel = 432'h3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00;
        
        # PERIOD;
        reset = 0;
        
        #(1000*PERIOD);
	    $display(out_feature_map);
	    $stop;
    end 
    
    Conv_single_kernel #(.map_width(map_width), .map_height(map_height), .map_channels(map_channels), .kernel_width(kernel_width), .kernel_height(kernel_height), .DATA_WIDTH(DATA_WIDTH))
    conv_single_kernel_agent(
        .clk(clk), 
        .reset(reset), 
        .in_feature_maps_set(in_feature_maps_set),
        .single_kernel(single_kernel),
        .out_feature_map(out_feature_map),
        .result(result),
        .feature_map(feature_map),
        .kernel_single_channel(kernel_single_channel),
        .i(i),
        .counter(counter),
        .result_element(result_element)
    );
    
endmodule
