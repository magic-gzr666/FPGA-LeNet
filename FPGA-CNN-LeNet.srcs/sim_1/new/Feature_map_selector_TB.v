`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 02:49:22
// Design Name: 
// Module Name: Feature_map_selector_TB
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


module Feature_map_selector_TB();

    parameter map_width = 3;
    parameter map_height = 3;
    parameter map_channel = 4;
    parameter DATA_WIDTH = 16;
    
    reg clk,reset;
    reg [0 : map_width * map_height * map_channel * DATA_WIDTH - 1] feature_maps_set;
    wire [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        feature_maps_set = 576'h000100020003000400050006000700080009000a000b000c000d000e000f0010001100120013001400150016001700180019001a001b001c001d001e001f00200021002200230024;
        
        
        # PERIOD;
        reset = 0;
        
        #(27*PERIOD);
	    $displayh(feature_map);
	    $stop;
    end 
    
    Feature_map_selector #(.map_width(map_width), .map_height(map_height), .map_channel(map_channel), .DATA_WIDTH(DATA_WIDTH))
    feature_map_selector_instance (.clk(clk), .reset(reset), .feature_maps_set(feature_maps_set), .feature_map(feature_map));

endmodule
