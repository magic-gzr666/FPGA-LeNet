`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 18:49:23
// Design Name: 
// Module Name: Softmax_layer_TB
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


module Softmax_layer_TB();

    parameter nums = 3;
    parameter DATA_WIDTH = 16;
    
    reg clk,reset;
    reg [0 : nums * DATA_WIDTH - 1] vector_x;
    wire [0 : nums * DATA_WIDTH - 1] vector_softmax_x;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        vector_x = 48'h3C00_3C00_3C00;
        
        
        # PERIOD;
        reset = 0;
        
        #(100*PERIOD);
	    $displayh(vector_softmax_x);
	    $stop;
    end 

    Softmax_layer #(.nums(nums), .DATA_WIDTH(DATA_WIDTH))
    softmax_layer_agent (.clk(clk), .reset(reset), .vector_x(vector_x), .vector_softmax_x(vector_softmax_x));

endmodule
