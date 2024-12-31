`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 02:12:49
// Design Name: 
// Module Name: FloatExponent16_TB
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


module FloatExponent16_TB();

    parameter DATA_WIDTH = 16;
    
    reg clk,reset;
    reg [DATA_WIDTH - 1 : 0] x;
    wire [DATA_WIDTH - 1 : 0] exponent_x;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk; 
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        x = 16'h4000;
        
        
        # PERIOD;
        reset = 0;
        
        #(30*PERIOD);
	    $displayh(exponent_x);
	    $stop;
    end 
    
    FloatExponent16 #(.DATA_WIDTH(DATA_WIDTH))
    floatexponent16_calc (.clk(clk), .reset(reset), .x(x), .exponent_x(exponent_x));

endmodule
