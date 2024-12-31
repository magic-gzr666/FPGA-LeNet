`timescale 1ns / 1ps

module Conv_calc(
    clk,
    reset,
    feature_map_window,
    filter,
    product,
    feature_map_element,
    filter_element,
    result
);

    //互相关计算参数
    parameter window_width = 3;
    parameter window_height = 3;
    parameter DATA_WIDTH = 16;

    //接口定义
    input clk,reset;
    input feature_map_window;
    input filter;
    output result;
    output product;
    output feature_map_element;
    output filter_element;
    
    wire [0 : window_width * window_height * DATA_WIDTH - 1] feature_map_window;
    wire [0 : window_width * window_height * DATA_WIDTH - 1] filter;
    reg [DATA_WIDTH - 1 : 0] result;
    
    //中间量
    wire [DATA_WIDTH - 1 : 0] product;
    wire [DATA_WIDTH - 1 : 0] result_temp;
    reg [DATA_WIDTH - 1 : 0] feature_map_element;
    reg [DATA_WIDTH - 1 : 0] filter_element;
    wire flag;
    integer i;
    
    //互相关运算单个元素（组合逻辑）
    FloatMult16 FM16 (feature_map_element, filter_element, product, flag);
    FloatAdd16 FA16 (product, result, result_temp);
    
    always @(feature_map_window) begin
        i = 0;
        feature_map_element = 0;
        filter_element = 0;
        result = 0;
    end
    
    //互相关计算过程（时序逻辑）
    always @ (posedge clk or posedge reset) begin
        if(reset == 1'b1) begin
            i = 0;
            feature_map_element = 0;
            filter_element = 0;
            result = 0;
        end else begin
            result = result_temp;
            feature_map_element = feature_map_window[i * DATA_WIDTH+:DATA_WIDTH];
            filter_element = filter[i * DATA_WIDTH+:DATA_WIDTH];
            
            i = i + 1;
            if(i > window_width * window_height) begin
                feature_map_element = 0;
                filter_element = 0;
            end
        end
    end
    
    
endmodule