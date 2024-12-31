`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 20:43:50
// Design Name: 
// Module Name: FloatVectorAdd16_TB
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


module FloatVectorAdd16_TB();

    parameter DATA_WIDTH = 16;
    parameter vectorA_length = 36;
    parameter vectorB_length = 36;
    
    reg clk,reset;
    
    reg [0 : vectorA_length * DATA_WIDTH - 1] vectorA;
    reg [0 : vectorB_length * DATA_WIDTH - 1] vectorB;
    wire [0 : vectorA_length * DATA_WIDTH - 1] vectorResult;
    
    localparam PERIOD = 100;
    always
        #(PERIOD / 2) clk = ~clk;   
        
    initial begin
        # 0;
        clk = 1'b0;
        reset = 1;
        vectorA = 576'h3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080;
        vectorB = 576'h3C00_4000_4200_4400_4500_4600_4700_4800_4880_4900_4980_4A00_4A80_4B00_4B80_4C00_4C40_4C80_4CC0_4D00_4D40_4D80_4DC0_4E00_4E40_4E80_4EC0_4F00_4F40_4F80_4FC0_5000_5020_5040_5060_5080;
        
        # PERIOD;
        reset = 0;
        
        #(30*PERIOD);
	    $display(vectorResult);
	    $stop;
    end 
    
    FloatVectorAdd16 #(.DATA_WIDTH(DATA_WIDTH), .vectorA_length(vectorA_length), .vectorB_length(vectorB_length))
    floatvectoradd16_checker (.clk(clk), .reset(reset), .vectorA(vectorA), .vectorB(vectorB), .vectorResult(vectorResult));

endmodule
