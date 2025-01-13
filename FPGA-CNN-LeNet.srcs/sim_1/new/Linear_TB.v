`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 12:28:15
// Design Name: 
// Module Name: Linear_TB
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


module Linear_layer_TB();

    parameter in_features_dim = 5;
    parameter out_features_dim = 3;
    parameter DATA_WIDTH = 16;
    
    reg clk,reset;
    reg [0 : in_features_dim * out_features_dim * DATA_WIDTH - 1] weights;
    reg [0 : in_features_dim * DATA_WIDTH - 1] in_features;
    reg [DATA_WIDTH - 1 : 0] bias;
    wire [0 : out_features_dim * DATA_WIDTH - 1] out_features;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;   
    
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        in_features = 80'h3c00_3c00_3c00_3c00_3c00;
        weights = 240'h3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00;
        bias = 16'h3c00;
        
        
        # PERIOD;
        reset = 0;
        
        #(100*PERIOD);
	    $displayh(out_features);
	    $stop;
    end 
    
    Linear_layer #(.in_features_dim(in_features_dim), .out_features_dim(out_features_dim), .DATA_WIDTH(DATA_WIDTH))
    linear_layer_agent (.clk(clk), .reset(reset), .in_features(in_features), .weights(weights), .bias(bias), .out_features(out_features));
    
endmodule
