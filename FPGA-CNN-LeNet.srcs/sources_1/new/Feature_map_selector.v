`timescale 100ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 02:37:43
// Design Name: 
// Module Name: Feature_map_selector
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


module Feature_map_selector(
    clk,
    reset,
    feature_maps_set,
    feature_map
);

    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channel = 3;
    parameter DATA_WIDTH = 16;

    input clk;
    input reset;
    input feature_maps_set;
    output feature_map;
    
    wire [0 : map_width * map_height * map_channel * DATA_WIDTH - 1] feature_maps_set;
    reg [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    
    integer i;
    
    always @(i) begin
        feature_map = feature_maps_set[i * map_width * map_height * DATA_WIDTH +: map_width * map_height * DATA_WIDTH];
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            i = 0;
        end else if (i < map_channel) begin
            i = i+1;
        end
    end

endmodule
