`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 20:54:21
// Design Name: 
// Module Name: AveragePooling
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


module AveragePooling_layer(
    clk,
    reset,
    in_feature_maps_set,
    out_feature_map
);
    
    //定义参数：输入数据的参数和输出数据的参数
    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channels = 3;
    parameter DATA_WIDTH = 16;
    localparam result_width = map_width / 2;
    localparam result_height = map_height / 2;
    localparam result_channels = map_channels;
    
    //定义接口类型
    input clk;
    input reset;
    input in_feature_maps_set;
    output out_feature_map;
    
    //定义输入输出的尺寸
    wire [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    reg [0 : result_channels * result_width * result_height * DATA_WIDTH - 1] out_feature_map;
    reg [DATA_WIDTH - 1 : 0] add_element;
    reg [DATA_WIDTH - 1 : 0] result_element;
    
    //定义四分之一
    reg [DATA_WIDTH - 1 : 0] quarter = 16'b0011010000000000; 
    wire [DATA_WIDTH - 1 : 0] out_feature_map_addtmp;
    wire [DATA_WIDTH - 1 : 0] out_feature_map_multmp;
    
    //原图和池化结果的index
    integer result_channel_index, result_col_index, result_row_index, result_index;
    integer map_channel_index, map_col_index, map_row_index, map_index;
    integer counter;
    
    //池化窗口累加
    FloatAdd16 FA16 (
        .floatA(result_element),
        .floatB(add_element), 
        .sum(out_feature_map_addtmp)
    );
    
    //做平均
    FloatMult16 FM16 (
        .floatA(out_feature_map_addtmp),
        .floatB(quarter),
        .product(out_feature_map_multmp)
    );
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            //index复位
            result_channel_index = 0;
            result_col_index = 0;
            result_row_index = 0;
            result_index = 0;
            map_channel_index = 0;
            map_col_index = 0;
            map_row_index = 0;
            map_index = 0;
            
            //中间存储寄存器、输出寄存器的复位
            counter = 0;
            result_element = 0;
            add_element = in_feature_maps_set[(map_index + counter) * DATA_WIDTH +: DATA_WIDTH];
            out_feature_map = 0;
            
        end else if(result_channel_index < result_channels) begin
        
            //counter计数器自然更新
            counter = counter + 1;
            if(counter > 3) begin
                //result_element复位
                result_element = 0;
                
                out_feature_map[result_index * DATA_WIDTH +: DATA_WIDTH] = out_feature_map_multmp;
                counter = 0;
                result_row_index = result_row_index + 1;
                map_row_index = map_row_index + 2;
                
                //行结束
                if(result_row_index >= result_width) begin
                    result_row_index = 0;
                    result_col_index = result_col_index+1;
                    map_row_index = 0;
                    map_col_index = map_col_index+2;
                end
                
                //列结束即该通道结束
                if(result_col_index >= result_height) begin
                    result_row_index = 0;
                    result_col_index = 0;
                    result_channel_index = result_channel_index+1;
                    map_row_index = 0;
                    map_col_index = 0;
                    map_channel_index = map_channel_index+1;
                end
                
            end else begin
                //result_element自然更新
                result_element = out_feature_map_addtmp;
            end
            
            //result_index和map_index的更新，map_index是即时的，而result_index慢一拍，因为后面的out_feature_map的更新需要慢一拍
            result_index <= result_channel_index * (result_height * result_width) + result_col_index * result_width + result_row_index;
            map_index = map_channel_index * (map_height * map_width) + map_col_index * map_width + map_row_index;
            
            //根据result_index作为左上角，确定池化窗口，一次仅操作一个元素
            if(counter < 2) begin
                add_element = in_feature_maps_set[(map_index + counter) * DATA_WIDTH +: DATA_WIDTH];
            end else begin
                add_element = in_feature_maps_set[(map_index + map_width + counter - 2) * DATA_WIDTH +: DATA_WIDTH];
            end
            
            //输出out_feature_map的更新
            out_feature_map[result_index * DATA_WIDTH +: DATA_WIDTH] <= out_feature_map_multmp;
            
        end
    end

endmodule
