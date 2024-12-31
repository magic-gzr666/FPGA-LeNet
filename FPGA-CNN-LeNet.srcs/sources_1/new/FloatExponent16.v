`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 01:10:42
// Design Name: 
// Module Name: FloatExponent16
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


module FloatExponent16(
    clk,
    reset,
    x,
    exponent_x
);
    //定义参数
    parameter DATA_WIDTH = 16;
    
    //定义接口类型
    input clk,reset;
    input x;
    output exponent_x;
    
    //定义输入输出的尺寸
    wire [DATA_WIDTH - 1 : 0] x;
    reg [DATA_WIDTH - 1 : 0] exponent_x;
    
    //定义中间量：采用泰勒展开逼近e指数计算的方式
    reg [0 : 7 * DATA_WIDTH - 1] mul_factors_set;
    reg [DATA_WIDTH - 1 : 0] mul_factor;
    reg [DATA_WIDTH - 1 : 0] mul_element;
    wire [DATA_WIDTH - 1 : 0] mul_element_tmp;
    wire [DATA_WIDTH - 1 : 0] add_element;
    wire [DATA_WIDTH - 1 : 0] exponent_x_tmp;
    
    integer counter;
    
    //乘以这一项的因子
    FloatMult16 FM16_factor (
        .floatA(mul_element),
        .floatB(mul_factor),
        .product(add_element)
    );
    
    //将项累加
    FloatAdd16 FA16 (
        .floatA(add_element),
        .floatB(exponent_x),
        .sum(exponent_x_tmp)
        );
    
    //更新x的幂
    FloatMult16 FM16_update (
        .floatA(mul_element),
        .floatB(x),
        .product(mul_element_tmp)
    );
    
    always @(posedge clk or posedge reset) begin
        //初始化值
        if(reset == 1) begin
            counter = 0;
            mul_element = 16'h3C00;
            //初始化泰勒展开的系数
            mul_factors_set = 112'h3C00_3C00_3800_3155_2955_2044_15b0;
            mul_factor = mul_factors_set[counter * DATA_WIDTH +: DATA_WIDTH];
            exponent_x = 0;
            
        //精确到泰勒公式的前7项
        end else if(counter < 7) begin
            counter = counter + 1;
            mul_factor = mul_factors_set[counter * DATA_WIDTH +: DATA_WIDTH];
            mul_element = mul_element_tmp;
            exponent_x = exponent_x_tmp;
        end
    
    end

endmodule
