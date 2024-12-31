`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 02:34:54
// Design Name: 
// Module Name: Sigmoid
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


module Sigmoid(
    clk,
    reset,
    x,
    sigmoid_x
);
    //定义参数：向量的元素个数
    parameter DATA_WIDTH = 16;

    //定义接口类型
    input clk, reset;
    input x;
    output sigmoid_x;
    
    //定义输入输出的尺寸
    wire [DATA_WIDTH - 1 : 0] x;
    wire [DATA_WIDTH - 1 : 0] sigmoid_x;
    
    //中间量
    wire [DATA_WIDTH - 1 : 0] exponent_x;
    wire [DATA_WIDTH - 1 : 0] exponent_x_add1;
    wire [DATA_WIDTH - 1 : 0] exponent_x_add1_reciprocal;
    
    //计算e指数
    FloatExponent16 FE16 (
        .clk(clk),
        .reset(reset),
        .x(x),
        .exponent_x(exponent_x)
    );
    
    //计算1+e^x
    FloatAdd16 FA16 (
        .floatA(exponent_x),
        .floatB(16'h3C00),
        .sum(exponent_x_add1)
    );
    
    //计算(1+e^x)的倒数
    FloatReciprocal16 FR16 (
        .clk(clk),
        .reset(reset),
        .number(exponent_x_add1),
        .output_rec(exponent_x_add1_reciprocal)
    );
    
    //计算 e^x / (1 + e^x)
    FloatMult16 FM16 (
        .floatA(exponent_x_add1_reciprocal),
        .floatB(exponent_x),
        .product(sigmoid_x)
    );
    
    integer counter;
    
    //下面这个counter功能待定，子过程消耗的时钟数还没有数
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            counter = 0;
        end else if(counter < 10) begin
            counter = counter + 1;
        end
    end
    
endmodule
