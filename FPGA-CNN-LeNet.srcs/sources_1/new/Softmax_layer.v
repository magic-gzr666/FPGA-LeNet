`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 02:34:29
// Design Name: 
// Module Name: Softmax_layer
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


module Softmax_layer(
    clk,
    reset,
    vector_x,
    vector_softmax_x
);
    //定义参数：向量的元素个数
    parameter nums = 3;
    parameter DATA_WIDTH = 16;

    //定义接口类型
    input clk,reset;
    input vector_x;
    output vector_softmax_x;
    
    //定义输入输出的尺寸
    wire [0 : nums * DATA_WIDTH - 1] vector_x;
    reg [0 : nums * DATA_WIDTH - 1] vector_softmax_x;
    
    //中间量
    reg [DATA_WIDTH - 1 : 0] x_element;
    wire [DATA_WIDTH - 1 : 0] x_exponent_element;
    wire [DATA_WIDTH - 1 : 0] sum_element;
    reg [DATA_WIDTH - 1 : 0] sum_element_tmp;
    wire [DATA_WIDTH - 1 : 0] reciprocal_element;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    //求e指数
    FloatExponent16 FE16 (
        .clk(clk),
        .reset(reset),
        .x(x_element),
        .exponent_x(x_exponent_element)
    );
    
    //求e指数操作后的加和
    FloatAdd16 FA16 (
        .floatA(x_exponent_element),
        .floatB(sum_element_tmp),
        .sum(sum_element)
    );
    
    //求上一步的和的倒数
    FloatReciprocal16 FR16 (
        .clk(clk),
        .reset(reset),
        .number(sum_element),
        .output_rec(reciprocal_element)
    );
    
    //获得最终结果
    FloatMult16 FM16 (
        .floatA(reciprocal_element),
        .floatB(x_exponent_element),
        .product(result_element)
    );
    
    //分为两个阶段，求和阶段和计算阶段
    integer sum_counter, sum_index;
    integer result_counter, result_index;
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            //求和阶段相关值的初始化
            sum_counter = 0;
            sum_index = 0;
            sum_element_tmp = 0;
            x_element = vector_x[sum_index * DATA_WIDTH +: DATA_WIDTH];
            
            //计算阶段相关值的初始化
            result_counter = 0;
            result_index = 0;
            
            //最终结果的初始化
            vector_softmax_x = 0;
        end else begin
            //求和阶段
            if(sum_index < nums-1) begin
                sum_counter = sum_counter+1;
                if(sum_counter > 10) begin
                    sum_counter = 0;
                    sum_index = sum_index+1;
                    x_element = vector_x[sum_index * DATA_WIDTH +: DATA_WIDTH];
                    sum_element_tmp = sum_element;
                end
            //计算阶段
            end else begin
                result_counter = result_counter+1;
                if(result_counter > 10) begin
                    result_counter = 0;
                    result_index = result_index+1;
                    x_element = vector_x[result_index * DATA_WIDTH +: DATA_WIDTH];
                end
                vector_softmax_x[result_index * DATA_WIDTH+:DATA_WIDTH] = result_element;
            end
        end
    end
    
    

endmodule
