`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 17:17:10
// Design Name: 
// Module Name: Sigmoid_layer
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


module Sigmoid_layer(
    clk,
    reset,
    vector_x,
    vector_sigmoid_x
);
    //定义参数：向量的元素个数
    parameter nums = 3;
    parameter DATA_WIDTH = 16;

    //定义接口类型
    input clk,reset;
    input vector_x;
    output vector_sigmoid_x;
    
    //定义输入输出的尺寸
    wire [0 : nums * DATA_WIDTH - 1] vector_x;
    reg [0 : nums * DATA_WIDTH - 1] vector_sigmoid_x;
    
    //中间量
    reg [DATA_WIDTH - 1 : 0] x_element;
    wire [DATA_WIDTH - 1 : 0] sigmoid_x_element;
    
    integer i,counter;
    
    //逐个元素计算Sigmoid激活函数
    Sigmoid #(.DATA_WIDTH(DATA_WIDTH))
    sigmoid_calc (
        .clk(clk),
        .reset(reset),
        .x(x_element),
        .sigmoid_x(sigmoid_x_element)
    );
    
    always @(posedge clk or posedge reset) begin
        //初始化值
        if(reset == 1) begin
            counter = 0;
            i = 0;
            x_element = vector_x[i * DATA_WIDTH +: DATA_WIDTH];
            vector_sigmoid_x = 0;
        
        //逐个元素计算
        end else if(i < nums) begin
            counter = counter + 1;
            //计数器counter用于等待单个元素计算sigmoid的完成
            if(counter > 10) begin
                counter = 0;
                i = i+1;
                x_element = vector_x[i * DATA_WIDTH +: DATA_WIDTH];
            end
            
            //更新输出结果
            vector_sigmoid_x[i * DATA_WIDTH +: DATA_WIDTH] = sigmoid_x_element;
        end
        
    end

endmodule
