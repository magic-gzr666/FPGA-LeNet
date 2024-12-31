`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 20:28:19
// Design Name: 
// Module Name: FloatVectorAdd16
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


module FloatVectorAdd16(
    clk,
    reset,
    vectorA,
    vectorB,
    vectorResult
);
    //定义参数
    parameter DATA_WIDTH = 16;
    parameter vectorA_length = 36;
    parameter vectorB_length = 36;
    
    //定义接口类型
    input clk,reset;
    input vectorA;
    input vectorB;
    output vectorResult;
    
    //定义接口尺寸
    wire [0 : vectorA_length * DATA_WIDTH - 1] vectorA;
    wire [0 : vectorB_length * DATA_WIDTH - 1] vectorB;
    reg [0 : vectorA_length * DATA_WIDTH - 1] vectorResult;
    
    reg [DATA_WIDTH - 1 : 0] vectorA_element;
    reg [DATA_WIDTH - 1 : 0] vectorB_element;
    wire [DATA_WIDTH - 1 : 0] vectorResult_element;
    
    FloatAdd16 FA16_vector(vectorA_element, vectorB_element, vectorResult_element);
    
    integer i;
    
    //输入改变则立刻重新计算
    always @(vectorA or vectorB) begin
        i = 0;
        vectorA_element <= vectorA[i * DATA_WIDTH +: DATA_WIDTH];
        vectorB_element <= vectorB[i * DATA_WIDTH +: DATA_WIDTH];
        vectorResult[i * DATA_WIDTH +: DATA_WIDTH] <= vectorResult_element;
    end
    
    //更新输出结果向量vectorResult，这个向量仅在足够时钟周期后是正确的运算结果
    always @(vectorResult_element) begin
        vectorResult[i * DATA_WIDTH +: DATA_WIDTH] = vectorResult_element;
    end
    
    //更新两个输入向量中指向的元素的位置
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            vectorResult = 0;
            i <= 0;
        end else begin
            i = i + 1;
        end
        vectorA_element <= vectorA[i * DATA_WIDTH +: DATA_WIDTH];
        vectorB_element <= vectorB[i * DATA_WIDTH +: DATA_WIDTH];
    end

endmodule
