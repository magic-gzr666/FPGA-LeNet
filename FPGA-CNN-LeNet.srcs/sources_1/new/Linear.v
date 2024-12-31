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

    //����������������ݵĲ�����������ݵĲ���
    parameter in_features_dim = 5;
    parameter out_features_dim = 3;
    parameter DATA_WIDTH = 16;
    
    //����ӿ�����
    input clk,reset;
    input weights;
    input bias;
    input in_features;
    output out_features;
    
    //������������ĳߴ�
    wire [0 : in_features_dim * out_features_dim * DATA_WIDTH - 1] weights;
    wire [0 : in_features_dim * DATA_WIDTH - 1] in_features;
    wire [DATA_WIDTH - 1 : 0] bias;
    reg [0 : out_features_dim * DATA_WIDTH - 1] out_features;
    
    //�м���
    reg [DATA_WIDTH - 1 : 0] in_features_element; //����������ǰѡȡ��Ԫ��
    wire [DATA_WIDTH - 1 : 0] out_features_element; //���������ǰѡȡ��Ԫ��
    reg [DATA_WIDTH - 1 : 0] weights_element; //Ȩ�ص�ǰѡȡ��Ԫ��
    reg [DATA_WIDTH - 1 : 0] calc_element;  //��Ȩ��͵ļĴ������
    
    wire [DATA_WIDTH - 1 : 0] mul_element; //����Ȩ�غ�Ľ��
    wire [DATA_WIDTH - 1 : 0] add_tmp; //��Ȩ��͵�������
    
    //����Ȩ��
    FloatMult16 FM16(
        .floatA(in_features_element),
        .floatB(weights_element),
        .product(mul_element)
    );
    
    //����һ���ļ�Ȩ����������
    FloatAdd16 FA16_tmp(
        .floatA(mul_element),
        .floatB(calc_element),
        .sum(add_tmp));
    
    //����ƫ��
    FloatAdd16 FA16_result(
        .floatA(add_tmp),
        .floatB(bias),
        .sum(out_features_element));
    
    //����index��¼��ǰ�����״̬
    integer weight_index, in_features_index, out_features_index;
    
    always @(posedge clk or posedge reset) begin
        if(reset == 1) begin
            //�����������ļĴ���
            out_features = 0;
        
            //��������index
            weight_index = 0;
            in_features_index = 0;
            out_features_index = 0;
            
            //�������õ�index��������element
            in_features_element = in_features[in_features_index * DATA_WIDTH +: DATA_WIDTH];
            weights_element = weights[weight_index * DATA_WIDTH +: DATA_WIDTH];
            calc_element = 0;
        end else if(out_features_index < out_features_dim) begin
            //��һ��ʱ�������ؽ����󣬽�����add_tmp��Ȼ�����ڿ��ԼĴ���calc_element
            calc_element = add_tmp;
            
            //index����Ȼ����
            in_features_index = in_features_index + 1;
            weight_index = weight_index + 1;
            if(in_features_index >= in_features_dim) begin
                //���浱ǰ���Ԫ�صĽ��
                out_features[out_features_index * DATA_WIDTH +: DATA_WIDTH] = out_features_element;
                //������һ�����Ԫ�ص�λ��
                in_features_element = 0;
                calc_element = 0;
                in_features_index = 0;
                out_features_index = out_features_index + 1;
            end
            
            //����index�ĸ��£����¼�������elements�Ը���mul_element���Ӷ�����add_tmp
            in_features_element = in_features[in_features_index * DATA_WIDTH +: DATA_WIDTH];
            weights_element = weights[weight_index * DATA_WIDTH +: DATA_WIDTH];
        end
    end
    

endmodule
