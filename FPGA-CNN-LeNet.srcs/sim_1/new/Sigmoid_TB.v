`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 02:56:57
// Design Name: 
// Module Name: Sigmoid_TB
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


module Sigmoid_TB();

    parameter DATA_WIDTH = 16;
    
    reg clk,reset;
    reg [DATA_WIDTH - 1 : 0] x;
    wire [DATA_WIDTH - 1 : 0] sigmoid_x;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk; 
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        x = 16'h3C00;
        
        
        # PERIOD;
        reset = 0;
        
        #(27*PERIOD);
	    $displayh(sigmoid_x);
	    $stop;
    end 

    Sigmoid #(.DATA_WIDTH(DATA_WIDTH))
    sigmoid_calc (.clk(clk), .reset(reset), .x(x), .sigmoid_x(sigmoid_x));

endmodule
