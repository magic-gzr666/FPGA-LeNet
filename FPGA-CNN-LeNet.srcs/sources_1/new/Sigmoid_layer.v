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
    //���������������Ԫ�ظ���
    parameter nums = 3;
    parameter DATA_WIDTH = 16;

    //����ӿ�����
    input clk,reset;
    input vector_x;
    output vector_sigmoid_x;
    
    //������������ĳߴ�
    wire [0 : nums * DATA_WIDTH - 1] vector_x;
    reg [0 : nums * DATA_WIDTH - 1] vector_sigmoid_x;
    
    //�м���
    reg [DATA_WIDTH - 1 : 0] x_element;
    wire [DATA_WIDTH - 1 : 0] sigmoid_x_element;
    
    integer i,counter;
    
    //���Ԫ�ؼ���Sigmoid�����
    Sigmoid #(.DATA_WIDTH(DATA_WIDTH))
    sigmoid_calc (
        .clk(clk),
        .reset(reset),
        .x(x_element),
        .sigmoid_x(sigmoid_x_element)
    );
    
    always @(posedge clk or posedge reset) begin
        //��ʼ��ֵ
        if(reset == 1) begin
            counter = 0;
            i = 0;
            x_element = vector_x[i * DATA_WIDTH +: DATA_WIDTH];
            vector_sigmoid_x = 0;
        
        //���Ԫ�ؼ���
        end else if(i < nums) begin
            counter = counter + 1;
            //������counter���ڵȴ�����Ԫ�ؼ���sigmoid�����
            if(counter > 10) begin
                counter = 0;
                i = i+1;
                x_element = vector_x[i * DATA_WIDTH +: DATA_WIDTH];
            end
            
            //����������
            vector_sigmoid_x[i * DATA_WIDTH +: DATA_WIDTH] = sigmoid_x_element;
        end
        
    end

endmodule
