`timescale 100ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 15:26:53
// Design Name: 
// Module Name: Conv_calc_TB
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


module Conv_calc_TB();

    parameter map_width = 6;
    parameter map_height = 6;
    parameter DATA_WIDTH = 16;
    parameter window_width = 3;
    parameter window_height = 3;

    reg clk, reset;
    reg [0 : window_height * window_width * DATA_WIDTH - 1] feature_map_window;
    reg [0 : window_height * window_width * DATA_WIDTH - 1] filter;
    wire [DATA_WIDTH - 1 : 0] result;
    wire [DATA_WIDTH - 1 : 0] product;
    wire [DATA_WIDTH - 1 : 0] feature_map_element;
    wire [DATA_WIDTH - 1 : 0] filter_element;
    
    localparam PERIOD = 100;
    
    always
        #(PERIOD / 2) clk = ~clk;
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        feature_map_window = 144'h3c00_4000_4200_4400_4500_4600_4700_4800_4880;
        filter = 144'h3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00_3c00;
//      feature_map_window =  400'h4400440044004400440044004400440044004400440044004400440044004400440044004400440044004400440044004400;
//	    filter = 400'h4400440044004400440044004400440044004400440044004400440044004400440044004400440044004400440044004400;
        
        # PERIOD;
        reset = 0;
        
        #(27*PERIOD)
	    $displayh(result);
	    $displayh(product);
	    $displayh(feature_map_element);
	    $displayh(filter_element);
	    $stop;
    end

    Conv_calc #(.window_width(window_width), .window_height(window_height), .DATA_WIDTH(DATA_WIDTH)) 
    convolution_calc (.clk(clk), .reset(reset), .feature_map_window(feature_map_window), .filter(filter), .product(product), .feature_map_element(feature_map_element), .result(result), .filter_element(filter_element));

endmodule
