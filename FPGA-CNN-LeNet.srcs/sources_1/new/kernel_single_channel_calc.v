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
    //定义参数类型
    parameter map_width = 6;
    parameter map_height = 6;
    parameter kernel_width = 3;
    parameter kernel_height = 3;
    parameter DATA_WIDTH = 16;
    localparam result_width = map_width - (kernel_width - 1);
    localparam result_height = map_height - (kernel_height - 1);
    localparam delta_counter = 3;
    
    //定义接口类型
    input clk,reset;
    input feature_map;
    input kernel_single_channel;
    output result_element;
    output feature_map_window;
    output result;
    
    //定义接口尺寸
    wire [0 : map_width * map_height * DATA_WIDTH - 1] feature_map;
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] kernel_single_channel;
    reg [0 : result_width * result_height * DATA_WIDTH - 1] result_temp;
    reg [0 : result_width * result_height * DATA_WIDTH - 1] result;
    
    wire [0 : kernel_width * kernel_height * DATA_WIDTH - 1] feature_map_window;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    //划分窗口
    Window_partition #(.map_width(map_width), .map_height(map_height), .DATA_WIDTH(DATA_WIDTH), .window_width(kernel_width), .window_height(kernel_height))
    window_partition_agent (
        .clk(clk),
        .reset(reset),
        .feature_map(feature_map),
        .feature_map_window(feature_map_window)
    );
    
    //对每个窗口进行互相关运算（卷积运算）
    Conv_calc #(.window_width(kernel_width), .window_height(kernel_height), .DATA_WIDTH(DATA_WIDTH))
    conv_calc_agent (
        .clk(clk),
        .reset(reset),
        .feature_map_window(feature_map_window),
        .filter(kernel_single_channel),
        .result(result_element)
    );
    
    integer i,counter;
    
    //有输出时立刻记录
    always @ (result_element) begin
        if (result_element) begin
            result_temp[i*DATA_WIDTH +: DATA_WIDTH] = result_element[DATA_WIDTH - 1 : 0];
        end
    end
    
    //窗口变化时要即时移动i到记录输出向量的下一个元素位置，避免当前位置被错误覆盖
    always @ (feature_map_window) begin
        if (feature_map_window) begin
            i = i+1;
        end
    end
    
    //counter用于留出时钟周期等待子操作的完成，当i移动完所有的窗口时，从result_temp取出卷积的最终输出结果
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
