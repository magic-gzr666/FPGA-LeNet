`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 11:27:47
// Design Name: 
// Module Name: Conv_layer
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


module Conv_layer(
    clk,
    reset,
    in_feature_maps_set,
    kernels_set,
    out_feature_maps_set
);

    //参数定义
    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channels = 3;
    parameter kernel_nums = 3;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    parameter kernel_channels = map_channels;
    parameter DATA_WIDTH = 16;
    //计算输出结果的尺寸
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    localparam result_channels = kernel_nums;
    localparam result_single_channel_size = result_width * result_height;
    localparam kernel_size = kernel_channels * kernel_width * kernel_height;

    //定义接口类型
    input clk,reset;
    input in_feature_maps_set;
    input kernels_set;
    output out_feature_maps_set;
    
    //定义输入输出的尺寸
    wire [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    wire [0 : kernel_nums * kernel_channels * kernel_width * kernel_height * DATA_WIDTH - 1] kernels_set;
    reg [0 : result_channels * result_width * result_height * DATA_WIDTH - 1] out_feature_maps_set;
    
    //中间结果
    reg local_reset;
    reg [0 : kernel_channels * kernel_width * kernel_height * DATA_WIDTH - 1] kernel;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] out_feature_map;
    
    //将提取出的单个卷积核，分别计算out_feature_map
    Conv_single_kernel #(.map_width(map_width), .map_height(map_height), .map_channels(map_channels), .kernel_width(kernel_width), .kernel_height(kernel_height), .kernel_channels(kernel_channels), .DATA_WIDTH(DATA_WIDTH))
    conv_single_kernel_agent (
        .clk(clk),
        .reset(reset || local_reset),
        .in_feature_maps_set(in_feature_maps_set),
        .single_kernel(kernel),
        .out_feature_map(out_feature_map)
    );
    
    //卷积核的index，用于选取卷积层中的不同卷积核
    integer kernel_index;
    //计数器，用于等待一个Conv_single_kernel操作的完成
    integer counter;
    
    always @(posedge clk or posedge reset) begin
    
        if(reset == 1) begin
            //重置
            local_reset = 0;
            kernel_index = 0;
            out_feature_maps_set = 0;
            kernel = kernels_set[kernel_index * kernel_size * DATA_WIDTH +: kernel_size * DATA_WIDTH];
            counter = 0;
        end else if(kernel_index < kernel_nums)begin
            //计数器counter的自然更新
            local_reset = 0;
            counter = counter+1;
            //单卷积核操作的等待时间结束
            if(counter > map_channels * (kernel_width * kernel_height) * result_width * result_height * 1.2) begin
                //合并out_feature_map至out_feature_maps_set
                out_feature_maps_set[kernel_index * result_single_channel_size * DATA_WIDTH +: result_single_channel_size * DATA_WIDTH] = out_feature_map;
                //更新至下一卷积
                kernel_index = kernel_index + 1;
                kernel = kernels_set[kernel_index * kernel_size * DATA_WIDTH +: kernel_size * DATA_WIDTH];
                local_reset = 1;
                counter = 0;
            end
        end
    
    end
        
    

endmodule
