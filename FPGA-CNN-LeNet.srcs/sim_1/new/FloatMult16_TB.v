`timescale 100 ns / 10 ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 19:18:03
// Design Name: 
// Module Name: FloatMult16_TB
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


module FloatMult16_TB();

    reg [15:0] floatA;
    reg [15:0] floatB;
    wire [15:0] product;
    
    initial begin
        # 0;
        floatA = 16'b0100000000110011;
        floatB = 16'b0000000000000000;
        
        # 10;
        floatA = 16'b0011110000000000;
        floatB = 16'b0100001010011010;
        
        # 10;
        floatA = 16'b0100000000110011;
        floatB = 16'b0100001010011010;
        
        # 10;
        $stop;
        
    
    end
    
   
    FloatMult16 floatmult16(
        .floatA(floatA),
        .floatB(floatB),
        .product(product)
    );

endmodule
