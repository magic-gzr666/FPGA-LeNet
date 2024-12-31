`timescale 100 ns / 10 ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 19:17:23
// Design Name: 
// Module Name: FloatAdd16_TB
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


module FloatAdd16_TB();

    reg [15:0] floatA;
    reg [15:0] floatB;
    wire [15:0] sum;
    
    initial begin
        # 0;
        floatA = 16'b0100000000110011;
        floatB = 16'b0;
        
        # 10;
        floatA = 16'b0;
        floatB = 16'b0100001010011010;
        
        # 10;
        floatA = 16'b0100000000110011;
        floatB = 16'b0100001010011010;
        
        # 10;
        $stop;
        
    
    end
    
   
    FloatAdd16 floatadd16(
        .floatA(floatA),
        .floatB(floatB),
        .sum(sum)
    );

endmodule
