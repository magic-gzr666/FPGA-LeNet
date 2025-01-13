`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 16:34:55
// Design Name: 
// Module Name: FloatReciprocal16_TB
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


module FloatReciprocal16_TB();
    
    parameter DATA_WIDTH=16;
    
    reg clk,reset;
    reg [DATA_WIDTH-1:0] number; //the number that we need to get the 1/number of 
    wire [DATA_WIDTH-1:0] output_rec; // = 1/number
    wire ack;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk; 
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        number = 16'h4200;
        
        
        # PERIOD;
        reset = 0;
        
        #(27*PERIOD);
	    $displayh(output_rec);
	    $stop;
    end 
    
    FloatReciprocal16 #(.DATA_WIDTH(DATA_WIDTH))
    floatreciprocal16_calc (.clk(clk), .reset(reset), .number(number), .output_rec(output_rec));
    
endmodule
