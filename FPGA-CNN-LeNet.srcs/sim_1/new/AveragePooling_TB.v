`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 22:10:11
// Design Name: 
// Module Name: AveragePooling_TB
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


module AveragePooling_layer_TB();

    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channels = 3;
    parameter DATA_WIDTH = 16;
    localparam result_width = map_width / 2;
    localparam result_height = map_height / 2;
    localparam result_channels = map_channels;
    
    reg clk,reset;
    reg [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    wire [0 : result_channels * result_width * result_height * DATA_WIDTH - 1] out_feature_map;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;  
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        in_feature_maps_set = 1728'h3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080_3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080_3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080;
        
        # PERIOD;
        reset = 0;
        
        #(1000*PERIOD);
	    $display(out_feature_map);
	    $stop;
    end 
    
    AveragePooling_layer #(.map_width(map_width), .map_height(map_height), .map_channels(map_channels), .DATA_WIDTH(DATA_WIDTH))
    averagepooling_layer_agent (.clk(clk), .reset(reset), .in_feature_maps_set(in_feature_maps_set), .out_feature_map(out_feature_map));

endmodule
