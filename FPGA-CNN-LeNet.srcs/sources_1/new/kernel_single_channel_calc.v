`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 16:19:10
// Design Name: 
// Module Name: kernel_single_channel_calc
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


module kernel_single_channel_calc(
    clk,
    reset,
    feature_map,
    kernel_single_channel,
    feature_map_window,
    result_element,
    result
);
    //�����������
    parameter map_width = 6;
    parameter map_height = 6;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    parameter DATA_WIDTH = 16;
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    localparam delta_counter = 3;
    
    //����ӿ�����
    input clk,reset;
    input feature_map;
    input kernel_single_channel;
    output result_element;
    output feature_map_window;
    output result;
    
    //����ӿڳߴ�
    wire [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] kernel_single_channel;
    reg [0 : result_width * result_height * DATA_WIDTH - 1] result_temp;
    reg [0 : result_width * result_height * DATA_WIDTH - 1] result;
    
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] feature_map_window;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    //���ִ���
    Window_partition #(.map_width(map_width), .map_height(map_height), .DATA_WIDTH(DATA_WIDTH), .window_width(kernel_width), .window_height(kernel_height))
    window_partition_agent (
        .clk(clk),
        .reset(reset),
        .feature_map(feature_map),
        .feature_map_window(feature_map_window)
    );
    
    //��ÿ�����ڽ��л�������㣨������㣩
    Conv_calc #(.window_width(kernel_width), .window_height(kernel_height), .DATA_WIDTH(DATA_WIDTH))
    conv_calc_agent (
        .clk(clk),
        .reset(reset),
        .feature_map_window(feature_map_window),
        .filter(kernel_single_channel),
        .result(result_element)
    );
    
    integer i,counter;
    
    //�����ʱ���̼�¼
    always @ (result_element) begin
        if (result_element) begin
            result_temp[i*DATA_WIDTH +: DATA_WIDTH] = result_element[DATA_WIDTH - 1 : 0];
        end
    end
    
    //���ڱ仯ʱҪ��ʱ�ƶ�i����¼�����������һ��Ԫ��λ�ã����⵱ǰλ�ñ����󸲸�
    always @ (feature_map_window) begin
        if (feature_map_window) begin
            i = i+1;
        end
    end
    
    //counter��������ʱ�����ڵȴ��Ӳ�������ɣ���i�ƶ������еĴ���ʱ����result_tempȡ�����������������
    always @ (posedge clk or posedge reset) begin
        if(reset == 1) begin
            result = 0;
            result_temp = 0;
            counter = 0;
            i = -1;
        end else if(counter >  kernel_width * kernel_height * 1.1 && i < result_width * result_height - 1) begin
            counter = 0;
        end else begin
            counter = counter + 1;
        end
        
//        if(i >= result_width * result_height - 1) begin
//            result = result_temp;
//        end
        result = result_temp;
        
    end

endmodule
