`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 19:27:05
// Design Name: 
// Module Name: Conv_single_kernel
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


module Conv_single_kernel(
    clk,
    reset,
    in_feature_maps_set,
    single_kernel,
    out_feature_map,
    feature_map,
    kernel_single_channel,
    result_element,
    result,
    counter,
    i
);

    //��������
    parameter map_width = 6;
    parameter map_height = 6;
    parameter map_channels = 3;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    parameter kernel_channels = map_channels;
    parameter DATA_WIDTH = 16;
    //�����������ĳߴ�
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    //Ϊ�ȶ��������Ҫ�ȴ���ʱ��
    localparam delta_counter = 8;
    
    //����ӿ�����
    input clk,reset;
    input in_feature_maps_set;
    input single_kernel;
    output out_feature_map; 
    // ������debugʱ�õ�
    output feature_map; 
    output kernel_single_channel; 
    output result; 
    output i; 
    output counter; 
    output result_element; 
    
    //������������ĳߴ�
    wire [0 : map_channels * map_width * map_height * DATA_WIDTH - 1] in_feature_maps_set;
    wire [0 : kernel_channels * kernel_width * kernel_height * DATA_WIDTH - 1] single_kernel;
    reg [0 : result_width * result_height * DATA_WIDTH - 1] out_feature_map;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] out_feature_map_temp;
    
    reg [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    reg [0 : kernel_width * kernel_height * DATA_WIDTH - 1] kernel_single_channel;
    wire [0 : result_width * result_height * DATA_WIDTH - 1] result;
    
    reg [5:0] i;
    reg [127:0] counter;
    
    //���㵥�������ͨ��-����ͼͨ�����ľ����������result�Ƕ�ά����ͼ
    kernel_single_channel_calc #(.map_width(map_width), .map_height(map_height), .kernel_width(kernel_width), .kernel_height(kernel_height), .DATA_WIDTH(DATA_WIDTH))
    kernel_single_channel_calc_agent (
        .clk(clk), 
        .reset(reset), 
        .feature_map(feature_map), 
        .kernel_single_channel(kernel_single_channel),
        .result_element(result_element),
        .result(result)
    );
    
    //��result�ۼӵõ��������˵Ķ�ά�������ͼ
    FloatVectorAdd16 #(.vectorA_length(result_width * result_height), .vectorB_length(result_width * result_height), .DATA_WIDTH(DATA_WIDTH))
    FVA16 (.clk(clk), .reset(reset), .vectorA(result), .vectorB(out_feature_map), .vectorResult(out_feature_map_temp));
    
    //counter���ڵȴ��Ӳ�������ɣ�i���ƶ������š����ͨ��-����ͼͨ������Ե��ƶ�
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            i <= 0;
            counter = 0;
            out_feature_map = 0;
        end else if(i < map_channels) begin
            if(counter > (kernel_width * kernel_height) * (result_width * result_height) * 1.1) begin
                counter = 0;
                out_feature_map = out_feature_map_temp;
                i = i+1;
            end
            counter = counter + 1;
        end
        
        feature_map = in_feature_maps_set[i * map_width * map_height * DATA_WIDTH +: map_width * map_height * DATA_WIDTH];
        kernel_single_channel = single_kernel[i * kernel_width * kernel_height * DATA_WIDTH +: kernel_width * kernel_height * DATA_WIDTH];
        
    end
    

endmodule
