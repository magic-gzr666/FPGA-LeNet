`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 03:08:02
// Design Name: 
// Module Name: Linear
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


module Linear_layer(
    clk,
    reset,
    weights,
    bias,
    in_features,
    out_features
);

    //定义参数：输入数据的参数和输出数据的参数
    parameter in_features_dim = 5;
    parameter out_features_dim = 3;
    parameter DATA_WIDTH = 16;
    
    //定义接口类型
    input clk,reset;
    input weights;
    input bias;
    input in_features;
    output out_features;
    
    //定义输入输出的尺寸
    wire [0 : in_features_dim * out_features_dim * DATA_WIDTH - 1] weights;
    wire [0 : in_features_dim * DATA_WIDTH - 1] in_features;
    wire [DATA_WIDTH - 1 : 0] bias;
    reg [0 : out_features_dim * DATA_WIDTH - 1] out_features;
    
    //中间量
    reg [DATA_WIDTH - 1 : 0] in_features_element; //输入特征当前选取的元素
    wire [DATA_WIDTH - 1 : 0] out_features_element; //输出特征当前选取的元素
    reg [DATA_WIDTH - 1 : 0] weights_element; //权重当前选取的元素
    reg [DATA_WIDTH - 1 : 0] calc_element;  //加权求和的寄存器结果
    
    wire [DATA_WIDTH - 1 : 0] mul_element; //乘以权重后的结果
    wire [DATA_WIDTH - 1 : 0] add_tmp; //加权求和的输出结果
    
    //乘以权重
    FloatMult16 FM16(
        .floatA(in_features_element),
        .floatB(weights_element),
        .product(mul_element)
    );
    
    //对上一步的加权结果进行求和
    FloatAdd16 FA16_tmp(
        .floatA(mul_element),
        .floatB(calc_element),
        .sum(add_tmp));
    
    //加上偏置
    FloatAdd16 FA16_result(
        .floatA(add_tmp),
        .floatB(bias),
        .sum(out_features_element));
    
    //三个index记录当前计算的状态
    integer weight_index, in_features_index, out_features_index;
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            //重置输出结果的寄存器
            out_features = 0;
        
            //重置三个index
            weight_index = 0;
            in_features_index = 0;
            out_features_index = 0;
            
            //根据重置的index重置三个element
            in_features_element = in_features[in_features_index * DATA_WIDTH +: DATA_WIDTH];
            weights_element = weights[weight_index * DATA_WIDTH +: DATA_WIDTH];
            calc_element = 0;
        end else if(out_features_index < out_features_dim) begin
            //上一轮时钟上升沿结束后，将计算add_tmp，然后现在可以寄存在calc_element
            calc_element = add_tmp;
            
            //index的自然更新
            in_features_index = in_features_index + 1;
            weight_index = weight_index + 1;
            if(in_features_index >= in_features_dim) begin
                //保存当前输出元素的结果
                out_features[out_features_index * DATA_WIDTH +: DATA_WIDTH] = out_features_element;
                //进入下一个输出元素的位置
                in_features_element = 0;
                calc_element = 0;
                in_features_index = 0;
                out_features_index = out_features_index + 1;
            end
            
            //根据index的更新，重新计算两个elements以更新mul_element，从而更新add_tmp
            in_features_element = in_features[in_features_index * DATA_WIDTH +: DATA_WIDTH];
            weights_element = weights[weight_index * DATA_WIDTH +: DATA_WIDTH];
        end
    end
    

endmodule
