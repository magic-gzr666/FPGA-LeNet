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
    //���������������Ԫ�ظ���
    parameter nums = 3;
    parameter DATA_WIDTH = 16;

    //����ӿ�����
    input clk,reset;
    input vector_x;
    output vector_softmax_x;
    
    //������������ĳߴ�
    wire [0 : nums * DATA_WIDTH - 1] vector_x;
    reg [0 : nums * DATA_WIDTH - 1] vector_softmax_x;
    
    //�м���
    reg [DATA_WIDTH - 1 : 0] x_element;
    wire [DATA_WIDTH - 1 : 0] x_exponent_element;
    wire [DATA_WIDTH - 1 : 0] sum_element;
    reg [DATA_WIDTH - 1 : 0] sum_element_tmp;
    wire [DATA_WIDTH - 1 : 0] reciprocal_element;
    wire [DATA_WIDTH - 1 : 0] result_element;
    
    //��eָ��
    FloatExponent16 FE16 (
        .clk(clk),
        .reset(reset),
        .x(x_element),
        .exponent_x(x_exponent_element)
    );
    
    //��eָ��������ļӺ�
    FloatAdd16 FA16 (
        .floatA(x_exponent_element),
        .floatB(sum_element_tmp),
        .sum(sum_element)
    );
    
    //����һ���ĺ͵ĵ���
    FloatReciprocal16 FR16 (
        .clk(clk),
        .reset(reset),
        .number(sum_element),
        .output_rec(reciprocal_element)
    );
    
    //������ս��
    FloatMult16 FM16 (
        .floatA(reciprocal_element),
        .floatB(x_exponent_element),
        .product(result_element)
    );
    
    //��Ϊ�����׶Σ���ͽ׶κͼ���׶�
    integer sum_counter, sum_index;
    integer result_counter, result_index;
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            //��ͽ׶����ֵ�ĳ�ʼ��
            sum_counter = 0;
            sum_index = 0;
            sum_element_tmp = 0;
            x_element = vector_x[sum_index * DATA_WIDTH +: DATA_WIDTH];
            
            //����׶����ֵ�ĳ�ʼ��
            result_counter = 0;
            result_index = 0;
            
            //���ս���ĳ�ʼ��
            vector_softmax_x = 0;
        end else begin
            //��ͽ׶�
            if(sum_index < nums-1) begin
                sum_counter = sum_counter+1;
                if(sum_counter > 10) begin
                    sum_counter = 0;
                    sum_index = sum_index+1;
                    x_element = vector_x[sum_index * DATA_WIDTH +: DATA_WIDTH];
                    sum_element_tmp = sum_element;
                end
            //����׶�
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
